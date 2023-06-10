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

function already_installed() {
    case $1 in
    "Xcode Command Line Tools")
        which xcode-select >/dev/null
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
    "Node.js")
        which node >/dev/null 2>&1
        ;;
    "PostgreSQL")
        which pg_ctl >/dev/null 2>&1
        ;;
    "Chrome")
        brew list | grep -q google-chrome
        ;;
    "ChromeDriver")
        brew list | grep -q chromedriver
        ;;
    "Docker")
        which docker >/dev/null 2>&1
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
    "oh-my-zsh")
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        ;;
    "Homebrew")
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        ;;
    "asdf")
        # Deps for asdf
        brew install coreutils curl git

        brew install asdf && echo -e "\n. $(brew --prefix asdf)/libexec/asdf.sh" >>${ZDOTDIR:-~}/.zshrc
        ;;
    "Erlang")
        # Deps for erlang
        brew install autoconf openssl@1.1 wxwidgets libxslt fop

        export KERL_CONFIGURE_OPTIONS="--without-javac --with-ssl=$(brew --prefix openssl@1.1)"
        asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git
        asdf install erlang 25.1.2
        asdf global erlang 25.1.2
        asdf reshim erlang 25.1.2
        ;;
    "Elixir")
        # Deps for elixir
        brew install unzip

        asdf plugin add elixir https://github.com/asdf-vm/asdf-elixir.git
        asdf install elixir 1.14.2-otp-25
        asdf global elixir 1.14.2-otp-25
        asdf reshim elixir 1.14.2-otp-25
        ;;
    "Phoenix")
        source ~/.zshrc >/dev/null 2>&1
        mix local.hex --force
        mix archive.install --force hex phx_new 1.7.0-rc.3
        ;;
    "Node.js")
        asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
        asdf install nodejs 16.17.0
        asdf global nodejs 16.17.0
        asdf reshim nodejs 16.17.0
        ;;
    "PostgreSQL")
        # Dependencies for PSQL
        brew install gcc readline zlib curl ossp-uuid

        asdf plugin add postgres https://github.com/smashedtoatoms/asdf-postgres.git
        asdf install postgres 15.1
        asdf global postgres 15.1
        asdf reshim postgres

        echo 'pg_ctl() { "$HOME/.asdf/shims/pg_ctl" "$@"; }' >>~/.profile
        source ~/.zshrc >/dev/null 2>&1
        ;;
    "Chrome")
        brew install google-chrome
        ;;
    "ChromeDriver")
        # Dependencies for chromedriver
        brew install zip

        asdf plugin add chromedriver
        asdf install chromedriver latest
        asdf global chromedriver latest
        asdf reshim chromedriver latest
        ;;
    "Docker")
        brew install --cask docker
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
    maybe_install "xcode"

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

    if [[ "$1" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        echo -e "${white}"
        sleep 3
        maybe_install "Chrome"
        echo -e "${white}"

        sleep 1.5
        maybe_install "Node.js"
        echo -e "${white}"

        sleep 2
        maybe_install "ChromeDriver"
        echo -e "${white}"

        maybe_install "Docker"
        echo -e "${white}"
    fi

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
        echo -e "${bblue}${bold}We can also install some optional tools:"

        echo -e "${cyan}${bold}"

        echo "1) Chrome"
        echo "2) Node.js"
        echo "3) ChromeDriver"
        echo "4) Docker"

        echo -e "${white}"
        echo -e "${white} ${bold}"

        optional=""

        while ! is_yn "$optional"; do
            read -p "Do you want us to install those as well? (y/n) " optional

            if ! [[ "$optional" =~ ^([yY][eE][sS]|[yY]|[nN]|[nN][oO])$ ]]; then
                echo "Please enter y or n"
                echo ""
            fi
        done

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
