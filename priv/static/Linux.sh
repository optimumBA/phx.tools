#! /bin/bash

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
        "curl")
            dpkg -l | grep -q curl
            ;;
        "zsh")
            dpkg -l | grep -q zsh
            ;;
        "oh-my-zsh")
            [ -d ~/.oh-my-zsh ]
            ;;
        "wget")
            dpkg -l | grep -q wget
            ;;
        "homebrew")
            which brew > /dev/null
            ;;
        "asdf")
            brew list | grep -q asdf
            ;;
        "erlang")
            command -v erl >/dev/null 2>&1
            ;;
        "elixir")
            which elixir >/dev/null 2>&1
            ;;
        "phoenix")
            mix phx.new --version
            ;;
        "nodejs")
            which node >/dev/null 2>&1
            ;;
        "postgresql")
            which psql >/dev/null 2>&1
            ;;
        "vim")
            dpkg -l | grep -q vim
            ;;
        "chrome")
            dpkg -l | grep -q google-chrome-stable
            ;;
        "chromedriver")
            npm list -g | grep -q chromedriver
            ;;
        "docker")
            which docker >/dev/null 2>&1
            ;;
        *)
            echo "Invalid name argument on checking"
        ;;
    esac
}

function install() {
    case $1 in
        "curl")
            sudo apt-get install -y build-essential procps curl file git
            ;;
        "zsh")
            sudo apt-get install -y zsh
            ;;
        "oh-my-zsh")
            sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
            ;;
        "wget")
            sudo apt-get install -y wget
            ;;
        "homebrew")
            NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            echo '# Set PATH, MANPATH, etc., for Homebrew.' >> /home/"$(whoami)"/.zprofile
            echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/"$(whoami)"/.zprofile
            eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

            # recommendation after install homebrew
            brew install gcc
            ;;
        "asdf")
            brew install asdf && echo -e "\n. $(brew --prefix asdf)/libexec/asdf.sh" >> ${ZDOTDIR:-~}/.zshrc
            ;;
        "erlang")
            sudo apt-get -y install -y build-essential autoconf m4 libncurses5-dev libwxgtk3.0-gtk3-dev libwxgtk-webview3.0-gtk3-dev libgl1-mesa-dev libglu1-mesa-dev libpng-dev libssh-dev unixodbc-dev xsltproc fop libxml2-utils libncurses-dev openjdk-11-jdk
            asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git
            asdf install erlang 25.2.2 && asdf global erlang 25.2.2
            ;;
        "elixir")
            asdf plugin add elixir https://github.com/asdf-vm/asdf-elixir.git
            asdf install elixir 1.14.3-otp-25
            asdf global elixir 1.14.3-otp-25
            ;;
        "phoenix")
            mix archive.install hex phx_new 1.7.0-rc.2
            ;;
        "nodejs")
            asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
            asdf install nodejs 16.17.0
            asdf global nodejs 16.17.0
            ;;
        "postgresql")
            sudo apt-get install -y linux-headers-$(uname -r) build-essential libssl-dev libreadline-dev zlib1g-dev libcurl4-openssl-dev uuid-dev
            asdf plugin add postgres https://github.com/smashedtoatoms/asdf-postgres.git
            asdf install postgres 15.1
            asdf global postgres 15.1

            echo -e "${cyan}${bold}Starting the postgres server... ${reset}"
            ;;
        "vim")
            sudo apt-get install -y vim
            ;;
        "chrome")
            wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
            sudo apt install -y ./google-chrome-stable_current_amd64.deb
            ;;
        "chromedriver")
            npm install -g chromedriver
            ;;
        "docker")
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
            $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
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
        echo "Installing $1"
        if [[ $1 == "homebrew" || $1 == "erlang" ]]; then
            echo "This might take a while."
        fi
        echo ""
        install $1
    fi
}

function add_env() {
    echo ""
    echo ""
    echo -e "${cyan}${bold}First we install curl"
    echo -e "${white}"
    sleep 1
    get "curl"
    echo ""

    echo -e "${cyan}${bold}Now we are going to install zsh (it's a shell variant, required for oh-my-zsh)"
    sleep 2
    echo -e "${white}"
    get "zsh"
    echo ""

    echo -e "${cyan}${bold}After that we need to add oh-my-zsh terminal helpers"
    echo -e "${white}"
    sleep 2 
    get "oh-my-zsh"
    echo ""

    echo -e "${cyan}${bold}Now we need wget (command-line tool that makes it possible to download files)"
    echo -e "${white}"
    sleep 2
    get "wget"
    echo ""

    echo -e "${cyan}${bold}Now we are gonna add Homebrew"
    echo -e "${white}"
    sleep 2
    get "homebrew"
    echo ""

    echo -e "${cyan}${bold}Also we need to install asdf 
    (preferred way of installing development tools because it enables us to set versions per project)"
    echo -e "${white}"
    sleep 3
    get "asdf"
    echo ""

    echo -e "${cyan}${bold}Finally we came to part where we install technologies that 
    we are gonna use in our elixir/phoenix development jurney"
    echo ""
    sleep 3
    echo -e "${cyan}${bold}1) Erlang"
    echo -e "${white}"
    sleep 1.5
    get "erlang"
    echo ""

    echo -e "${cyan}${bold}2) Elixir"
    echo -e "${white}"
    sleep 1.5
    get "elixir"
    echo ""

    echo -e "${cyan}${bold}3) Phoenix 1.7.0-rc.2"
    echo -e "${white}"
    sleep 1.5
    get "phoenix"
    echo ""
    
    echo -e "${cyan}${bold}4) PostgreSQL"
    echo -e "${white}"
    sleep 1.5
    get "postgresql"
    echo ""
    echo -e "${cyan}${bold}start the DB using pg_ctl start and stop with pg_ctl stop"
    sleep 1.5
    echo ""
    
    echo -e "${cyan}${bold}5) Vim"
    echo -e "${white}"  
    get "vim"
    echo ""

    if [[ "$1" =~ ^([nN][oO]|[nN])$ ]]; then
        echo -e "${cyan}${bold}Skipping the optional installation
        (Chrome, Chromedriver, Docker)"

        echo ""
        echo "Skipping Chrome"
        echo ""
        echo "Skipping Node.js"
        echo ""
        echo "Skipping chromedriver"
        echo ""
        echo "Skipping Docker"
        echo ""
    else
        echo -e "${cyan}${bold}Hang on tight. We will do the optional installation
        (Chrome, Chromedriver, Docker)"
        echo ""

        echo -e "${cyan}${bold}1) Chrome
        (Next step is to add Chrome, Firefox is pre-installed on Ubuntu, but we need Chrome to run automated tests)"
        echo -e "${white}"
        sleep 3
        get "chrome" 
        echo ""

        echo -e "${cyan}${bold}2) Node.js"
        echo -e "${white}"
        sleep 1.5
        get "nodejs"
        echo ""

        echo -e "${cyan}${bold}3) chromedriver
        (Now we are gonna add chromedriver that we also need for tests)"
        echo -e "${white}"
        sleep 2
        get "chromedriver"
        echo ""

        echo -e "${cyan}${bold}4) Docker"
        echo -e "${white}"
        get "docker"
        echo ""
    fi

    echo ""
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

echo -e "${bblue}${bold}Welcome to our Phx.tools script for linux based OS"

sleep 3

echo ""

echo -e "${bblue}${bold}The following tools and dependencies will be installed if you don't have them
already installed:"

echo -e "${cyan}${bold}"

echo "1) Curl"
echo "2) Zsh"
echo "3) Chrome"
echo "4) Homebrew"
echo "5) Chromedriver"
echo "6) asdf"
echo "7) Erlang"
echo "8) Elixir"
echo "9) Phoenix"
echo "10) Node.js"
echo "11) PostgreSQL"
echo "12) Vim"
echo "13) Docker"

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

while ! is_yn "$answer";do
    read -p "Do you want to continue? (y/n) " answer
    echo ""
    case "$answer" in
        [yY] | [yY][eE][sS])
            echo -e "${bblue}${bold}Do you want to perform the optional installation?"

            echo -e "${cyan}${bold}"

            echo "1) Chrome" 
            echo "2) Node.js" 
            echo "3) Chromedriver" 
            echo "4) Docker"

            echo ""

            echo -e "${white} ${bold}"

            optional=""

            while ! is_yn "$optional"; do
                read -p "(y/n) " optional

                case "$optional" in
                    [yY] | [yY][eE][sS])
                        echo "The optional packages will be installed"
                        ;;
                    [nN] | [nN][oO])
                        echo "The optional packages will not be installed"
                        ;;
                    *)
                        echo "Please enter y or n"
                        echo ""
                        ;;
                esac
            done

            echo ""

            read -sp 'What is your password?' sudo_password

            sudo -S chsh -s '/bin/zsh' "${USER}" <<< "${sudo_password}"
            
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