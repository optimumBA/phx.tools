#!/bin/bash

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

bold=$(tput bold)
normal=$(tput sgr0)
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

current_shell=$(basename "$SHELL")

case $current_shell in
"bash" | "rbash")
    config_file="$HOME/.bashrc"
    ;;
"fish")
    config_file="$HOME/.config/fish/config.fish"
    ;;
"zsh")
    config_file="$HOME/.zshrc"
    ;;
*)
    echo "Unsupported shell: $current_shell"
    exit 1
    ;;
esac

function already_installed() {
    case $1 in
    "Xcode Command Line Tools")
        which xcode-select >/dev/null
        ;;
    "Homebrew")
        which brew >/dev/null 2>&1
        ;;
    "mise")
        which mise >/dev/null 2>&1
        ;;
    "Erlang")
        command -v erl >/dev/null 2>&1
        ;;
    "Elixir")
        which elixir >/dev/null 2>&1
        ;;
    "Phoenix")
        mix phx.new --version >/dev/null 2>&1
        ;;
    "PostgreSQL")
        which pg_ctl >/dev/null 2>&1
        ;;
    *)
        echo "Invalid name argument on checking"
        ;;
    esac
}

function install() {
    case $1 in
    "Xcode Command Line Tools")
        xcode-select --install
        ;;
    "Homebrew")
        $current_shell -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
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
        mise activate $current_shell
        ;;
    "Erlang")
        brew install autoconf openssl@1.1 wxwidgets libxslt fop
        echo 'KERL_CONFIGURE_OPTIONS="--without-javac" --with-ssl=$(brew --prefix openssl@1.1)"' >>~/.kerlrc
        mise install erlang@$erlang_version
        mise use -g erlang@$erlang_version
        ;;
    "Elixir")
        mise install elixir@$elixir_version
        mise use -g elixir@$elixir_version
        ;;
    "Phoenix")
        mix local.hex --force
        mix archive.install --force hex phx_new $phoenix_version
        ;;
    "PostgreSQL")
        brew install gcc readline zlib curl ossp-uuid
        mise install postgres@$postgres_version
        mise use -g postgres@$postgres_version
        postgres_bin_path="$HOME/.local/share/mise/installs/postgres/$postgres_version/bin"
        export PATH="$postgres_bin_path:$PATH"
        echo "export PATH=\"$postgres_bin_path:\$PATH\"" >>$config_file
        ;;
    *)
        echo "Invalid name argument on install"
        ;;
    esac
}

function maybe_install() {
    if already_installed $1; then
        echo "$1 is already installed. Skipping..."
    else
        echo "Installing $1..."
        if [[ $1 == "Homebrew" || $1 == "Erlang" ]]; then
            echo "This might take a while."
        fi
        echo ""
        install $1
    fi
}

function add_env() {
    echo ""
    echo -e "${white}"
    sleep 1.5
    maybe_install "Xcode Command Line Tools"

    echo -e "${white}"
    sleep 1.5
    maybe_install "Homebrew"

    echo -e "${white}"
    sleep 1.5
    maybe_install "mise"

    echo -e "${white}"
    sleep 1.5
    maybe_install "Erlang"

    echo -e "${white}"
    sleep 1.5
    maybe_install "Elixir"

    echo -e "${white}"
    sleep 1.5
    maybe_install "Phoenix"

    echo -e "${white}"
    sleep 1.5
    maybe_install "PostgreSQL"

    echo -e "${white}"
    echo -e "${cyan}${bold}phx.tools setup is complete!"
    echo -e "${cyan}${bold}Please restart the terminal and type in the following command:"
    echo -e "${cyan}${bold}mix phx.new"
    echo -e "${white}"
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

echo -e "$phx_tools"

echo -e "$by"

echo -e "$optimum"

sleep 3

echo ""

echo -e "${bblue}${bold}Welcome to the phx.tools shell script for macOS."

sleep 3

echo ""

echo -e "${bblue}${bold}The following will be installed if not available already:"

echo -e "${cyan}${bold}"

echo "1) Build dependencies"
echo "2) Homebrew"
echo "3) mise"
echo "4) Erlang"
echo "5) Elixir"
echo "6) Phoenix"
echo "7) PostgreSQL"

echo ""
echo -e "${white} ${bold}"

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
    read -p "Do you want to continue? (y/n) " answer
    echo ""
    case "$answer" in
    [yY] | [yY][eE][sS])

        echo ""

        sleep 3

        add_env
        ;;
    [nN] | [nN][oO])
        echo "Thank you for your time"
        echo ""
        ;;
    *)
        echo "Please enter y or n"
        echo ""
        ;;
    esac
done
