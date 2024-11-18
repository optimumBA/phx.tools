#!/bin/sh

set -eu

# Make sure important variables exist if not already defined
#
# $USER is defined by login(1) which is not always executed (e.g. containers)
# POSIX: https://pubs.opengroup.org/onlinepubs/009695299/utilities/id.html
USER=${USER:-$(id -u -n)}
# $HOME is defined at the time of login, but it could be unset. If it is unset,
# a tilde by itself (~) will not be expanded to the current user's home directory.
# POSIX: https://pubs.opengroup.org/onlinepubs/009696899/basedefs/xbd_chap08.html#tag_08_03
HOME="${HOME:-$(getent passwd $USER 2>/dev/null | cut -d: -f6)}"
# macOS does not have getent, but this works even if $HOME is unset
HOME="${HOME:-$(eval echo ~$USER)}"

bold='\033[1m'
normal='\033[0m'
red='\033[0;31m'
blue='\033[0;34m'
bblue='\033[1;34m'
white='\033[0;37m'
green='\033[0;32m'
cyan='\033[0;36m'

elixir_version=1.17.2-otp-27
erlang_version=27.0.1
phoenix_version=1.7.14
postgres_version=15.1

case "${SHELL:-}" in
*bash)
    current_shell="bash"
    config_file="$HOME/.bashrc"
    ;;
*fish)
    current_shell="fish"
    config_file="$HOME/.config/fish/config.fish"
    mkdir -p "$(dirname "$config_file")"
    ;;
*zsh)
    current_shell="zsh"
    config_file="$HOME/.zshrc"
    ;;
*)
    printf "Unsupported shell: %s\n" "$SHELL"
    exit 1
    ;;
esac

# Add OS detection
OS="$(uname -s)"

case "${OS}" in
Linux*) os_type=Linux ;;
Darwin*) os_type=macOS ;;
*)
    printf "Unsupported OS: %s\n" "${OS}"
    exit 1
    ;;
esac

already_installed() {
    case "$1" in
    "Elixir")
        mise which elixir >/dev/null 2>&1
        ;;
    "Erlang")
        mise which erl >/dev/null 2>&1
        ;;
    "git")
        which git >/dev/null 2>&1
        ;;
    "Homebrew")
        which brew >/dev/null 2>&1
        ;;
    "mise")
        which mise >/dev/null 2>&1
        ;;
    "Phoenix")
        mix phx.new --version >/dev/null 2>&1
        ;;
    "PostgreSQL")
        mise which initdb >/dev/null 2>&1
        ;;
    "Xcode Command Line Tools")
        which xcode-select >/dev/null 2>&1
        ;;
    *)
        printf "Invalid name argument on checking: %s\n" "$1"
        exit 1
        ;;
    esac
}

install() {
    case "$1" in
    "Elixir")
        if [ "$os_type" = "Linux" ]; then
            sudo apt-get update
            sudo apt-get install -y unzip
        fi

        mise use -g -y elixir@$elixir_version
        ;;
    "Erlang")
        if [ "$os_type" = "macOS" ]; then
            brew install autoconf openssl@1.1 wxwidgets libxslt fop

            if [ ! -f ~/.kerlrc ]; then
                printf "KERL_CONFIGURE_OPTIONS=\"--with-ssl=$(brew --prefix openssl@1.1) --without-javac\"\n" >~/.kerlrc
            fi

            ulimit -n 1024
        else
            sudo apt-get update
            sudo apt-get install -y build-essential automake autoconf libssl-dev libncurses5-dev

            if [ ! -f ~/.kerlrc ]; then
                printf "KERL_CONFIGURE_OPTIONS=\"--without-javac\"\n" >~/.kerlrc
            fi
        fi
        mise use -g -y erlang@$erlang_version
        ;;
    "git")
        sudo apt-get update
        sudo apt-get -y install git
        ;;
    "Homebrew")
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        UNAME_MACHINE="$(/usr/bin/uname -m)"

        if [[ "${UNAME_MACHINE}" == "arm64" ]]; then
            if [ "$current_shell" = "fish" ]; then
                fish_add_path /opt/homebrew/bin
            else
                (
                    echo
                    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"'
                ) >>$config_file
            fi
            eval "$(/opt/homebrew/bin/brew shellenv)"
        else
            if [ "$current_shell" = "fish" ]; then
                fish_add_path /usr/local/bin
            else
                (
                    echo
                    echo 'eval "$(/usr/local/bin/brew shellenv)"'
                ) >>$config_file
            fi
            eval "$(/usr/local/bin/brew shellenv)"
        fi
        ;;
    "mise")
        curl https://mise.run | sh

        case $current_shell in
        "bash")
            echo 'eval "$(~/.local/bin/mise activate bash)"' >>$config_file
            ;;
        "fish")
            echo '~/.local/bin/mise activate fish | source' >>$config_file
            ;;
        "zsh")
            echo 'eval "$(~/.local/bin/mise activate zsh)"' >>$config_file
            ;;
        esac

        export PATH="$HOME/.local/bin:$PATH"
        ;;
    "Phoenix")
        mise exec -- mix local.hex --force
        mise exec -- mix local.rebar --force
        mise exec -- mix archive.install --force hex phx_new $phoenix_version
        ;;
    "PostgreSQL")
        if [ "$os_type" = "macOS" ]; then
            brew install gcc readline zlib curl ossp-uuid
        else
            sudo apt-get update
            sudo apt-get -y install linux-headers-generic build-essential libssl-dev libreadline-dev zlib1g-dev libcurl4-openssl-dev uuid-dev icu-devtools
        fi

        mise use -g -y postgres@$postgres_version
        ;;
    "Xcode Command Line Tools")
        xcode-select --install
        ;;
    *)
        printf "Invalid name argument on install: %s\n" "$1"
        exit 1
        ;;
    esac
}

maybe_install() {
    if already_installed "$1"; then
        printf "%s is already installed. Skipping...\n" "$1"
    else
        printf "Installing %s...\n" "$1"

        if [ "$1" = "Homebrew" ] || [ "$1" = "Erlang" ]; then
            printf "This might take a while.\n"
        fi

        printf "\n"
        install "$1"
    fi
}

add_env() {
    printf "\n"

    # Ask for sudo password upfront
    sudo -v

    # Keep sudo alive
    while true; do
        sudo -n true
        sleep 60
        kill -0 "$$" || exit
    done 2>/dev/null &

    if [ "$os_type" = "macOS" ]; then
        printf "${white}\n"
        sleep 1.5
        maybe_install "Xcode Command Line Tools"

        printf "${white}\n"
        sleep 1.5
        maybe_install "Homebrew"
    else
        printf "${white}\n"
        sleep 1.5
        maybe_install "git"
    fi

    printf "${white}\n"
    sleep 1.5
    maybe_install "mise"

    printf "${white}\n"
    sleep 1.5
    maybe_install "Erlang"

    printf "${white}\n"
    sleep 1.5
    maybe_install "Elixir"

    printf "${white}\n"
    sleep 1.5
    maybe_install "Phoenix"

    printf "${white}\n"
    sleep 1.5
    maybe_install "PostgreSQL"

    printf "${white}\n"
    printf "${cyan}${bold}phx.tools setup is complete!\n"
    printf "${cyan}${bold}Please restart the terminal and type in the following command:\n"
    printf "${cyan}${bold}mix phx.new\n"
    printf "${white}\n"
}

phx_tools="
        ██████╗░██╗░░██╗██╗░░██╗  ████████╗░█████╗░░█████╗░██╗░░░░░░██████╗ 
        ██╔══██╗██║░░██║╚██╗██╔╝  ╚══██╔══╝██╔══██╗██╔══██╗██║░░░░░██╔════╝ 
        ██████╔╝███████║░╚███╔╝░  ░░░██║░░░██║░░██║██║░░██║██║░░░░░╚█████╗░ 
        ██╔═══╝░██╔══██║░██╔██╗░  ░░░██║░░░██║░░██║██║░░██║██║░░░░░░╚═══██╗ 
        ██║░░░░░██║░░██║██╔╝╚██╗  ░░░██║░░░╚█████╔╝╚█████╔╝███████╗██████╔╝ 
        ╚═╝░░░░░╚═╝░░╚═╝╚═╝░░╚═╝  ░░░╚═╝░░░░╚════╝░░╚════╝░╚══════╝╚═════╝░ 
"
by="
                            ██████╗░██╗░░░██╗
                            ██╔══██╗╚██╗░██╔╝
                            ██████╦╝░╚████╔╝░
                            ██╔══██╗░░╚██╔╝░░
                            ██████╦╝░░░██║░░░
                            ╚═════╝░░░░╚═╝░░░
"
optimum="
    ░█████╗░██████╗░████████╗██╗███╗░░░███╗██╗░░░██╗███╗░░░███╗██████╗░██╗░░██╗
    ██╔══██╗██╔══██╗╚══██╔══╝██║████╗░████║██║░░░██║████╗░████║██╔══██╗██║░░██║
    ██║░░██║██████╔╝░░░██║░░░██║██╔████╔██║██║░░░██║██╔████╔██║██████╦╝███████║
    ██║░░██║██╔═══╝░░░░██║░░░██║██║╚██╔╝██║██║░░░██║██║╚██╔╝██║██╔══██╗██╔══██║
    ╚█████╔╝██║░░░░░░░░██║░░░██║██║░╚═╝░██║╚██████╔╝██║░╚═╝░██║██████╦╝██║░░██║
    ░╚════╝░╚═╝░░░░░░░░╚═╝░░░╚═╝╚═╝░░░░░╚═╝░╚═════╝░╚═╝░░░░░╚═╝╚═════╝░╚═╝░░╚═╝
"

printf "%s\n" "$phx_tools"
printf "%s\n" "$by"
printf "%s\n" "$optimum"

sleep 3

printf "\n"

printf "${bblue}${bold}Welcome to the phx.tools shell script for ${os_type}.\n"

sleep 3

printf "\n"

printf "${bblue}${bold}The following will be installed if not available already:\n"

printf "${cyan}${bold}\n"

if [ "$os_type" = "macOS" ]; then
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

printf "\n"
printf "${white}${bold}\n"

sleep 1

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

answer=''

while ! is_yn "$answer"; do
    printf "Do you want to continue? (y/n) "
    read -r answer
    printf "\n"
    case "$answer" in
    [yY] | [yY][eE][sS])
        printf "\n"
        sleep 3
        add_env
        ;;
    [nN] | [nN][oO])
        printf "Thank you for your time\n"
        printf "\n"
        ;;
    *)
        printf "Please enter y or n\n"
        printf "\n"
        ;;
    esac
done
