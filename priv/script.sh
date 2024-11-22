#!/bin/sh

set -eu

elixir_version=1.17.3-otp-27
erlang_version=27.1.2
phoenix_version=1.7.14
postgres_version=15.1

OS="$(uname -s)"
case "$OS" in
Linux*) os_type=Linux ;;
Darwin*) os_type=macOS ;;
*)
  printf >&2 "Unsupported OS: %s\n" "$OS"
  exit 1
  ;;
esac

has() {
  command -V "${1:?}" >/dev/null 2>/dev/null
}

mise_has() {
  mise which "${1:?}" >/dev/null 2>/dev/null
}

mise_has_version() {
  has mise &&
    mise_has "${1:?}" &&
    [ "$(mise which --version "${1:?}")" = "${2:?}" ]
}

# Make sure important variables exist if not already defined
#
# $USER is defined by login(1) which is not always executed (e.g. containers)
# POSIX: https://pubs.opengroup.org/onlinepubs/009695299/utilities/id.html
USER=${USER:-$(id -u -n)}

# $HOME is defined at the time of login, but it could be unset. If it is unset,
# a tilde by itself (~) will not be expanded to the current user's home directory.
# POSIX: https://pubs.opengroup.org/onlinepubs/009696899/basedefs/xbd_chap08.html#tag_08_03
if [ -z "$HOME" ]; then
  set +e
  if [ "$os_type" = Linux ]; then
    HOME="$(getent passwd "$USER" 2>/dev/null | cut -d: -f6)"
  elif [ "$os_type" = macOS ]; then
    HOME="$(dscl . -read /Users/"$USER" NFSHomeDirectory)"
  fi

  # If neither of the above commands works, fall back to `~$USER`.
  HOME="${HOME:-$(eval echo ~"$USER")}"
  set -e
fi

elixir_version=1.18.1-otp-27
erlang_version=27.2
phoenix_version=1.7.18
postgres_version=15.1
# Disable colour output if NO_COLOR is set to any value at all.
# https://no-color.org
if [ -n "${NO_COLOR:-}" ] || [ -z "${TERM:-}" ] || [ "$TERM" = dumb ]; then
  bold=''
  normal=''
  bblue=''
  cyan=''
elif has tput; then
  # Prefer using `tput` for highlighting over manual ANSI colour codes. This
  # would allow xterm 256 colour as well.
  bold="$(tput bold)"
  normal="$(tput sgr0)"
  bblue="$(tput setaf 11)"
  cyan="$(tput setaf 6)"
else
  bold='\033[1m'
  normal='\033[0m'
  bblue='\033[1;34m'
  cyan='\033[0;36m'
fi

phx_tools_path="$HOME"/.config/phx_tools
phx_tools_sh_path="$phx_tools_path"/phx_tools.sh
phx_tools_fish_path="$phx_tools_path"/phx_tools.fish
homebrew_path=

if [ -n "${SHELL:-}" ]; then
  case "$(basename "${SHELL}")" in
  bash | fish | zsh) : ;;
  *)
    printf >&2 "Unsupported shell: %s\n" "$SHELL"
    exit 1
    ;;
  esac
else
  printf >&2 "Cannot discover shell, \$SHELL is unset.\n"
  exit 1
fi

case "${SHELL:-}" in
esac

get_package_manager() {
  if has apt-get; then
    echo apt
  elif has dnf; then
    echo dnf
  elif has pacman; then
    echo pacman
  elif has apk; then
    echo apk
  else
    printf >&2 "Unsupported package manager.\n"
    printf >&2 "This script requires apt, dnf, pacman, or apk.\n"
    exit 1
  fi
}

if [ "$os_type" = macOS ]; then
  package_manager=homebrew

  if [ "$(uname -m)" = arm64 ]; then
    homebrew_path=/opt/homebrew/bin
  else
    homebrew_path=/usr/local/bin
  fi
else
  package_manager="$(get_package_manager)"
fi

already_installed() {
  case "$1" in
  Elixir) mise_has_version elixir "$elixir_version" ;;
  Erlang) mise_has_version erl "$erlang_version" ;;
  git) has git ;;
  Homebrew) has brew ;;
  mise) has mise ;;
  Phoenix) has mix && mix phx.new --version >/dev/null 2>&1 ;;
  PostgreSQL) mise_has initdb ;;
  "Xcode Command Line Tools") has xcode-select ;;
  *)
    printf >&2 "Unknown tool provided for install check: %s\n" "$1"
    exit 1
    ;;
  esac
}

install_deps() {
  case "$1" in
  Elixir)
    case "$package_manager" in
    apt)
      sudo apt-get update
      sudo apt-get install -y unzip
      ;;
    dnf) sudo dnf install -y unzip ;;
    pacman) sudo pacman -Sy --noconfirm unzip ;;
    apk) sudo apk add --no-cache unzip ;;
    esac
    ;;
  Erlang)
    case "$package_manager" in
    homebrew)
      brew install autoconf openssl@3 wxwidgets libxslt fop

      if [ ! -f "$HOME"/.kerlrc ]; then
        printf "KERL_CONFIGURE_OPTIONS=\"--with-ssl=%s --without-javac\"\n" \
          "'$(brew --prefix openssl@3)'" >"$HOME"/.kerlrc
      fi

      # shellcheck disable=SC3045
      ulimit -n 1024
      ;;
    apt)
      sudo apt-get update
      sudo apt-get install -y build-essential automake autoconf libssl-dev \
        libncurses5-dev
      ;;
    dnf)
      sudo dnf groupinstall -y "Development Tools"
      sudo dnf install -y openssl-devel ncurses-devel
      ;;
    pacman)
      sudo pacman -Sy --noconfirm base-devel openssl ncurses
      ;;
    apk)
      sudo apk add --no-cache build-base autoconf openssl-dev ncurses-dev
      ;;
    esac

    if [ "$os_type" = Linux ] && [ ! -f "$HOME"/kerlrc ]; then
      printf "KERL_CONFIGURE_OPTIONS=\"--without-javac\"\n" >"$HOME"/.kerlrc
    fi
    ;;
  PostgreSQL)
    case "$package_manager" in
    homebrew) brew install gcc readline zlib curl ossp-uuid ;;
    apt)
      sudo apt-get update
      sudo apt-get install -y linux-headers-generic build-essential \
        libssl-dev libreadline-dev zlib1g-dev libcurl4-openssl-dev uuid-dev \
        icu-devtools
      ;;
    dnf)
      sudo dnf groupinstall -y "Development Tools"
      sudo dnf install -y kernel-headers openssl-devel readline-devel \
        zlib-devel libcurl-devel libuuid-devel libicu-devel
      ;;
    pacman)
      sudo pacman -Sy --noconfirm linux-headers base-devel openssl readline \
        zlib curl util-linux icu
      ;;
    apk)
      sudo apk add --no-cache linux-headers build-base openssl-dev \
        readline-dev zlib-dev curl-dev util-linux-dev icu-dev
      ;;
    esac
    ;;
  esac
}

install() {
  if [ -n "${DRY_RUN:-}" ]; then
    return
  fi

  install_deps "$1"

  case "$1" in
  Elixir) mise use -g -y elixir@$elixir_version ;;
  Erlang) mise use -g -y erlang@$erlang_version ;;
  git)
    case "$package_manager" in
    "apt")
      sudo apt-get update
      sudo apt-get install -y git
      ;;
    "dnf")
      sudo dnf install -y git
      ;;
    "pacman")
      sudo pacman -Sy --noconfirm git
      ;;
    "apk")
      sudo apk add --no-cache git
      ;;
    esac
    ;;
  Homebrew)
    NONINTERACTIVE=1 /bin/bash -c \
      "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    eval "$("$homebrew_path"/brew shellenv sh)"
    ;;
  mise)
    curl https://mise.run | sh

    export PATH="$HOME/.local/bin:$PATH"
    ;;
  Phoenix)
    mise exec -- mix local.hex --force
    mise exec -- mix local.rebar --force
    mise exec -- mix archive.install --force hex phx_new $phoenix_version
    ;;
  PostgreSQL)
    mise use -g -y postgres@$postgres_version
    ;;
  "Xcode Command Line Tools")
    xcode-select --install
    ;;
  *)
    printf >&2 "Unknown tool provided for install: %s\n" "$1"
    exit 1
    ;;
  esac
}

maybe_install() {
  if already_installed "$1"; then
    printf "%s is already installed. Skipping...\n" "$1"
  else
    case "$1" in
    Homebrew | Erlang)
      printf "Installing %s... (this might take a while)\n" "$1"
      ;;
    *)
      printf "Installing %s...\n" "$1"
      ;;
    esac

    install "$1"
  fi
}

install_shell_scripts() {
  mkdir -p "$phx_tools_path"

  local_bin=\"\$HOME\"/.local/bin

  cat >"$phx_tools_sh_path" <<SH
#!/bin/sh

# This file is managed by phx.tools and should not be edited by hand.
SH

  if [ -n "$homebrew_path" ]; then
    cat >>"$phx_tools_sh_path" <<SH

eval "\$("$homebrew_path"/brew shellenv)"
SH
  fi

  cat >>"$phx_tools_sh_path" <<SH

if ! command -v mise >/dev/null 2>/dev/null && [ -x $local_bin/mise ]; then
  export PATH="$local_bin:\$PATH"
fi

eval "\$(mise activate "\$(basename \$SHELL)")"
SH

  cat >"$phx_tools_fish_path" <<FISH
# This file is managed by phx.tools and should not be edited by hand.
FISH

  if [ -n "$homebrew_path" ]; then
    cat >>"$phx_tools_fish_path" <<FISH

$homebrew_path/brew shellenv | source
FISH
  fi

  cat >>"$phx_tools_fish_path" <<FISH

if ! command -sq mise && test -x $local_bin/mise
  fish_add_path --global --path --move $local_bin
end

if ! functions -q __mise_env_eval && status is-interactive
  mise activate fish | source
end
FISH

  sh_source_line="source '$phx_tools_sh_path'"

  if has bash && [ -f "$HOME"/.bashrc ]; then
    if ! grep -q "$sh_source_line" "$HOME"/.bashrc; then
      printf "bash: updating %s/.bashrc to source %s\n" "$HOME" \
        "$phx_tools_sh_path"
      printf "\n%s\n" "$sh_source_line" >>"$HOME"/.bashrc
    fi
  fi

  if has zsh && [ -f "$HOME"/.zshrc ]; then
    if ! grep -q "$sh_source_line" "$HOME"/.zshrc; then
      printf "zsh: updating %s/.zshrc to source %s\n" "$HOME" \
        "$phx_tools_sh_path"
      printf "\n%s\n" "$sh_source_line" >>"$HOME"/.zshrc
    fi
  fi

  if has fish; then
    fish_confd="$HOME/.config/fish/conf.d"
    mkdir -p "$fish_confd"

    fish_confd="$fish_confd/$(basename "$phx_tools_fish_path")"

    printf "fish: linking %s to %s\n" "$phx_tools_fish_path" "$fish_confd"
    ln -sf "$phx_tools_fish_path" "$fish_confd"
  fi
}

add_env() {
  # Ask for sudo password upfront
  cat <<SUDO
phx.tools may need to install build dependencies with your platform package
manager. We are requesting 'sudo' permission before starting for a smoother
install.

SUDO
  sudo -v

  # Keep sudo alive
  while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
  done 2>/dev/null &

  if [ "$os_type" = macOS ]; then
    maybe_install "Xcode Command Line Tools"
    maybe_install Homebrew
  else
    maybe_install git
  fi

  maybe_install "mise"
  maybe_install "Erlang"
  maybe_install "Elixir"
  maybe_install "Phoenix"
  maybe_install "PostgreSQL"

  install_shell_scripts

  printf "\n%sphx.tools setup is complete!\n\n" "$normal$cyan$bold"
  printf "%sPlease restart the terminal and type in the following command:\n" \
    "$cyan$bold"
  printf "%s    mix phx.new\n%s\n" "$cyan$bold" "$normal"
}

banner='
        ██████╗░██╗░░██╗██╗░░██╗  ████████╗░█████╗░░█████╗░██╗░░░░░░██████╗ 
        ██╔══██╗██║░░██║╚██╗██╔╝  ╚══██╔══╝██╔══██╗██╔══██╗██║░░░░░██╔════╝ 
        ██████╔╝███████║░╚███╔╝░  ░░░██║░░░██║░░██║██║░░██║██║░░░░░╚█████╗░ 
        ██╔═══╝░██╔══██║░██╔██╗░  ░░░██║░░░██║░░██║██║░░██║██║░░░░░░╚═══██╗ 
        ██║░░░░░██║░░██║██╔╝╚██╗  ░░░██║░░░╚█████╔╝╚█████╔╝███████╗██████╔╝ 
        ╚═╝░░░░░╚═╝░░╚═╝╚═╝░░╚═╝  ░░░╚═╝░░░░╚════╝░░╚════╝░╚══════╝╚═════╝░ 

                            ██████╗░██╗░░░██╗
                            ██╔══██╗╚██╗░██╔╝
                            ██████╦╝░╚████╔╝░
                            ██╔══██╗░░╚██╔╝░░
                            ██████╦╝░░░██║░░░
                            ╚═════╝░░░░╚═╝░░░

    ░█████╗░██████╗░████████╗██╗███╗░░░███╗██╗░░░██╗███╗░░░███╗██████╗░██╗░░██╗
    ██╔══██╗██╔══██╗╚══██╔══╝██║████╗░████║██║░░░██║████╗░████║██╔══██╗██║░░██║
    ██║░░██║██████╔╝░░░██║░░░██║██╔████╔██║██║░░░██║██╔████╔██║██████╦╝███████║
    ██║░░██║██╔═══╝░░░░██║░░░██║██║╚██╔╝██║██║░░░██║██║╚██╔╝██║██╔══██╗██╔══██║
    ╚█████╔╝██║░░░░░░░░██║░░░██║██║░╚═╝░██║╚██████╔╝██║░╚═╝░██║██████╦╝██║░░██║
    ░╚════╝░╚═╝░░░░░░░░╚═╝░░░╚═╝╚═╝░░░░░╚═╝░╚═════╝░╚═╝░░░░░╚═╝╚═════╝░╚═╝░░╚═╝
'

printf "%s\n" "$bblue$banner"

printf "\n%sWelcome to the phx.tools shell script for %s.\n" \
  "$bblue$bold" "$os_type"

printf "\n%sThe following will be installed if not available already:\n" \
  "$bblue$bold"

printf "%s\n" "$cyan$bold"

if [ "$os_type" = macOS ]; then
  printf "1) Build dependencies\n"
  printf "2) Homebrew\n"
  printf "3) mise\n"
  printf "4) Erlang\n"
  printf "5) Elixir\n"
  printf "6) Phoenix\n"
  printf "7) PostgreSQL\n"
else
  printf "1) Build dependencies\n"
  printf "2) mise\n"
  printf "3) Erlang\n"
  printf "4) Elixir\n"
  printf "5) Phoenix\n"
  printf "6) PostgreSQL\n"
fi

is_yn() {
  case "$1" in
  [yY] | [yY][eE][sS])
    true
    ;;
  [nN] | [nN][oO])
    true
    ;;
  *)
    false
    ;;
  esac
}

printf "\n"

answer=''

while ! is_yn "$answer"; do
  printf "%sDo you want to continue? (y/n) %s" "$normal$bold" "$normal"
  read -r answer

  case "$answer" in
  [yY] | [yY][eE][sS])
    break
    ;;
  [nN] | [nN][oO])
    printf "Thank you for your time\n\n"
    exit 0
    ;;
  *)
    printf >&2 "Please enter y or n\n\n"
    continue
    ;;
  esac
done

printf "\n"
add_env
