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

function is_package_exists() {
    case $1 in
    "Zsh")
        dpkg -l | grep -q zsh
        ;;
    "oh-my-zsh")
        [ -d ~/.oh-my-zsh ]
        ;;
    "wget")
        dpkg -l | grep -q wget
        ;;
    "Homebrew")
        which brew >/dev/null 2>&1
        ;;
    "Asdf")
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
        which psql >/dev/null 2>&1
        ;;
    "Vim")
        dpkg -l | grep -q vim
        ;;
    "Chrome")
        dpkg -l | grep -q google-chrome-stable
        ;;
    "Chromedriver")
        npm list -g | grep -q chromedriver
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
    "Zsh")
        sudo apt-get install -y zsh
        ;;
    "oh-my-zsh")
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        ;;
    "wget")
        sudo apt-get install -y wget
        ;;
    "Homebrew")
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        echo '# Set PATH, MANPATH, etc., for Homebrew.' >>/home/"$(whoami)"/.zprofile
        echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >>/home/"$(whoami)"/.zprofile
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

        # recommendation after install homebrew
        brew install gcc
        ;;
    "Asdf")
        brew install asdf && echo -e "\n. $(brew --prefix asdf)/libexec/asdf.sh" >>${ZDOTDIR:-~}/.zshrc
        ;;
    "Erlang")
        sudo apt-get update
        sudo apt-get -y install build-essential autoconf m4 libncurses5-dev libwxgtk3.0-gtk3-dev libwxgtk-webview3.0-gtk3-dev libgl1-mesa-dev libglu1-mesa-dev libpng-dev libssh-dev unixodbc-dev xsltproc fop libxml2-utils libncurses-dev openjdk-11-jdk
        asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git
        asdf install erlang 25.1.2
        asdf global erlang 25.1.2
        asdf reshim erlang 25.1.2
        ;;
    "Elixir")
        asdf plugin add elixir https://github.com/asdf-vm/asdf-elixir.git
        asdf install elixir 1.14.2-otp-25
        asdf global elixir 1.14.2-otp-25
        asdf reshim elixir 1.14.2-otp-25
        ;;
    "Phoenix")
        source ~/.bashrc >/dev/null 2>&1
        source ~/.zshrc >/dev/null 2>&1
        mix local.hex --force
        echo "y" | mix archive.install hex phx_new 1.7.0-rc.2
        ;;
    "Node.js")
        asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
        asdf install nodejs 16.17.0
        asdf global nodejs 16.17.0
        asdf reshim nodejs 16.17.0
        ;;
    "PostgreSQL")
        sudo apt-get update
        sudo apt-get -y install linux-headers-generic build-essential libssl-dev libreadline-dev zlib1g-dev libcurl4-openssl-dev uuid-dev icu-devtools
        asdf plugin add postgres https://github.com/smashedtoatoms/asdf-postgres.git
        asdf install postgres 15.1
        asdf global postgres 15.1
        asdf reshim postgres 15.1
        ;;
    "Vim")
        sudo apt-get install -y vim
        ;;
    "Chrome")
        sudo wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
        sudo apt install -y ./google-chrome-stable_current_amd64.deb
        ;;
    "Chromedriver")
        source ~/.bashrc >/dev/null 2>&1
        source ~/.zshrc >/dev/null 2>&1
        npm install -g chromedriver
        ;;
    "Docker")
        sudo apt-get update
        sudo apt-get install -y \
            ca-certificates \
            curl \
            gnupg \
            lsb-release
        sudo mkdir -p /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
        echo \
            "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
            $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
        sudo apt-get update
        sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
        ;;
    *)
        echo "Invalid name argument on install"
        ;;
    esac
}

function get() {
    if is_package_exists $1; then
        echo "$1 is already installed. Skipping..."
    else
        echo "Installing $1..."
        if [[ $1 == "homebrew" || $1 == "erlang" ]]; then
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
    get "Zsh"

    echo -e "${white}"
    sleep 2
    get "oh-my-zsh"

    echo -e "${white}"
    sleep 2
    get "wget"

    echo -e "${white}"
    sleep 2
    get "Homebrew"

    echo -e "${white}"
    sleep 3
    get "Asdf"

    echo -e "${white}"
    sleep 1.5
    get "Erlang"

    echo -e "${white}"
    sleep 1.5
    get "Elixir"

    echo -e "${white}"
    sleep 1.5
    get "Phoenix"

    echo -e "${white}"
    sleep 1.5
    get "PostgreSQL"

    echo -e "${white}"
    get "Vim"

    if [[ "$1" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        echo -e "${white}"
        sleep 3
        get "Chrome"
        echo -e "${white}"

        sleep 1.5
        get "Node.js"
        echo -e "${white}"

        sleep 2
        get "Chromedriver"
        echo -e "${white}"

        get "Docker"
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

echo -e "${bblue}${bold}Welcome to the phx.tools shell script for Linux-based OS."

sleep 3

echo ""

echo -e "${bblue}${bold}The following will be installed if not available already:"

echo -e "${cyan}${bold}"

echo "1) Zsh"
echo "2) Homebrew"
echo "3) Asdf"
echo "4) Erlang"
echo "5) Elixir"
echo "6) Phoenix"
echo "7) PostgreSQL"
echo "8) Vim"

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
        echo "3) Chromedriver"
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
