#! /bin/bash

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

if [[ $current_shell == "bash" ]]; then
    config_file="/Users/$USER/.bashrc"
else
    current_shell="zsh"
    config_file="/Users/$USER/.zshrc"
fi

function already_installed() {
    case $1 in
    "Git")
        which git >/dev/null 2>&1
        ;;
    "Zsh")
        dpkg -l | grep -q zsh
        ;;
    "oh-my-zsh")
        [ -d ~/.oh-my-zsh ]
        ;;
    "Homebrew")
        which brew >/dev/null 2>&1
        ;;
    "asdf")
        brew list | grep -q asdf
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
    "Git")
        sudo apt-get install -y git
        ;;
    "Zsh")
        sudo apt-get install -y zsh
        ;;
    "oh-my-zsh")
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        ;;
    "Homebrew")
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        echo '# set PATH, MANPATH, etc., for Homebrew' >>~/.zshrc
        (
            echo
            echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"'
        ) >>~/.zshrc
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        ;;
    "asdf")
        brew install asdf
        (
            echo
            echo 'source $(brew --prefix asdf)/libexec/asdf.sh'
        ) >>~/.zshrc
        source ~/.zshrc >/dev/null 2>&1
        ;;
    "Erlang")
        sudo apt-get update
        sudo apt-get -y install build-essential autoconf m4 libncurses5-dev libwxgtk3.0-gtk3-dev libwxgtk-webview3.0-gtk3-dev libgl1-mesa-dev libglu1-mesa-dev libpng-dev libssh-dev unixodbc-dev xsltproc fop libxml2-utils libncurses-dev openjdk-11-jdk
        asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git
        asdf install erlang 27.0.1
        asdf global erlang 27.0.1
        asdf reshim erlang 27.0.1
        ;;
    "Elixir")
        asdf plugin add elixir https://github.com/asdf-vm/asdf-elixir.git
        asdf install elixir 1.17.2-otp-27
        asdf global elixir 1.17.2-otp-27
        asdf reshim elixir 1.17.2-otp-27
        ;;
    "Phoenix")
        source ~/.zshrc >/dev/null 2>&1
        mix local.hex --force
        mix archive.install --force hex phx_new 1.7.14
        ;;
    "PostgreSQL")
        sudo apt-get update
        sudo apt-get -y install linux-headers-generic build-essential libssl-dev libreadline-dev zlib1g-dev libcurl4-openssl-dev uuid-dev icu-devtools

        asdf plugin add postgres https://github.com/smashedtoatoms/asdf-postgres.git
        asdf install postgres 16
        asdf global postgres 16
        asdf reshim postgres

        echo 'pg_ctl() { "$HOME/.asdf/shims/pg_ctl" "$@"; }' >>~/.profile
        source ~/.zshrc >/dev/null 2>&1
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
    sleep 2
    maybe_install "Git"

    echo ""
    echo -e "${white}"
    sleep 2
    maybe_install "Zsh"

    echo -e "${white}"
    sleep 2
    maybe_install "oh-my-zsh"

    echo -e "${white}"
    sleep 2
    maybe_install "Homebrew"

    echo -e "${white}"
    sleep 3
    maybe_install "asdf"

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

echo -e "${bblue}${bold}Welcome to the phx.tools shell script for Linux-based OS."

sleep 3

echo ""

echo -e "${bblue}${bold}The following will be installed if not available already:"

echo -e "${cyan}${bold}"

echo "1) Build dependencies"
echo "2) oh-my-zsh"
echo "3) Homebrew"
echo "4) asdf"
echo "5) Erlang"
echo "6) Elixir"
echo "7) Phoenix"
echo "8) PostgreSQL"

echo ""
echo -e "${white} ${bold}"

sleep 1

# only true if user answer y/n
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

        echo -e "${bblue}${bold}We're going to switch your default shell to Zsh even if it's not available yet, so you might see the following:"

        echo -e "${bblue}${bold}chsh: Warning: /bin/zsh does not exist"

        echo -e "${bblue}${bold}But don't worry. The installation will proceed as regular."

        sleep 3

        sudo -S chsh -s '/bin/zsh' "${USER}"

        add_env "$optional"
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
