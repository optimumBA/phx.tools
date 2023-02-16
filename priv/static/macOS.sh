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
        "xcode")
            which xcode-select > /dev/null
            ;;  

        "oh-my-zsh")
            [ -d ~/.oh-my-zsh ]
            ;;
        "homebrew")
            which brew >/dev/null 2>&1
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
            mix phx.new --version >/dev/null 2>&1
            ;;
        "nodejs")
            which node >/dev/null 2>&1
            ;;
        "postgresql")
            which psql >/dev/null 2>&1
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
        "xcode")
            xcode-select --install
            ;;  
        "oh-my-zsh")
            sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
            ;;
        "homebrew")
             /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            ;;
        "asdf")
            # Deps for asdf
            brew install coreutils curl git

            brew install asdf && echo -e "\n. $(brew --prefix asdf)/libexec/asdf.sh" >> ${ZDOTDIR:-~}/.zshrc
            ;;
        "erlang")
            # Deps for erlang
            brew install autoconf openssl@1.1 wxwidgets libxslt fop

            export KERL_CONFIGURE_OPTIONS="--without-javac --with-ssl=$(brew --prefix openssl@1.1)"
            asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git
            asdf install erlang 25.2.2 && asdf global erlang 25.2.2
            ;;
        "elixir")
            # Deps for elixir
            brew install unzip

            asdf plugin add elixir https://github.com/asdf-vm/asdf-elixir.git
            asdf install elixir 1.14.2-otp-25
            asdf global elixir 1.14.2-otp-25
            asdf reshim elixir 1.14.2-otp-25
            ;;
        "phoenix")
            source ~/.bashrc >/dev/null 2>&1
            source ~/.zshrc >/dev/null 2>&1
            mix local.hex --force
            echo "y" | mix archive.install hex phx_new 1.7.0-rc.2
            ;;
        "nodejs")
            asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
            asdf install nodejs 16.17.0
            asdf global nodejs 16.17.0
            asdf reshim nodejs 16.17.0
            ;;
        "postgresql")
            # Dependencies for PSQL
            brew install gcc readline zlib curl ossp-uuid

            asdf plugin add postgres https://github.com/smashedtoatoms/asdf-postgres.git
            asdf install postgres 15.1
            asdf global postgres 15.1
            ;;
        "chrome")
            brew install google-chrome
            ;;
        "chromedriver")
            # Dependencies for chromedriver
            brew install zip
            
            asdf plugin add chromedriver
            asdf install chromedriver latest
            asdf global chromedriver latest
            ;;
        "docker")
            brew install docker
            ;;
        *)
            echo "Invalid name argument on install"
        ;;
    esac
}

function maybe_install() {
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
    maybe_install "xcode"

    echo -e "${white}"
    sleep 2 
    maybe_install "oh-my-zsh"

    echo -e "${white}"
    sleep 2
    maybe_install "homebrew"

    echo -e "${white}"
    sleep 3
    maybe_install "asdf"

    echo -e "${white}"
    sleep 1.5
    maybe_install "erlang"

    echo -e "${white}"
    sleep 1.5
    maybe_install "elixir"

    echo -e "${white}"
    sleep 1.5
    maybe_install "phoenix"
    
    echo -e "${white}"
    sleep 1.5
    maybe_install "postgresql"

    if [[ "$1" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        echo -e "${white}"  
        sleep 3
        maybe_install "chrome" 
        echo -e "${white}"  

        sleep 1.5
        maybe_install "nodejs"
        echo -e "${white}"  

        sleep 2
        maybe_install "chromedriver"
        echo -e "${white}"  

        maybe_install "docker"
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

echo "1) Command Line Developer Tools(xcode-select)"
echo "2) OhmyZSH"
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

while ! is_yn "$answer";do
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

            chsh -s /usr/local/bin/zsh
            
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