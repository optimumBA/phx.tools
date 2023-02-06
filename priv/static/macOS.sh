#! /bin/bash

bold=$(tput bold)
normal=$(tput sgr0)
red='\033[0;31m'
blue='\033[0;34m'  
bblue='\033[1;34m'  
white='\033[0;37m'
green='\033[0;32m'
cyan='\033[0;36m'
reset='\033[0m'

function install_xcode() {
  if which xcode-select > /dev/null; then
    echo -e "${white} "
    echo -e "${green}${bold}xcode-select is already installed, skipping installation"
    echo -e "${white} "
  else
    echo -e "${cyan}${bold}Installing Command Line Developer Tools..."
    echo -e "${white} "

    xcode-select --install
  fi

  sleep 0.4
}

function install_homebrew() {
  if which brew > /dev/null; then
    echo -e "${white} "
    echo -e "${green}${bold}Homebrew is already installed, skipping installation"
    echo -e "${white} "
  else
    echo -e "${white} "
    echo -e "${cyan}${bold}Installing Homebrew..."
    echo -e "${white} "

    sleep 0.4
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  sleep 0.4
}

function install_asdf() {
  if brew list | grep "asdf" > /dev/null; then
    echo -e "${white} "
    echo -e "${green}${bold}asdf is already installed, skipping installation"
    echo -e "${white} "
  else
    echo -e "${white} "
    echo -e "${cyan}${bold}Installing dependencies for asdf..."
    echo -e "${white} "

    sleep 0.4

    # Deps for asdf
    brew install coreutils curl git

    echo -e "${white} "
    echo -e "${cyan}${bold}Installing asdf..."
    echo -e "${reset} "

    brew install asdf && echo -e "\n. $(brew --prefix asdf)/libexec/asdf.sh" >> ~/.zshrc 
  fi
}

function install_erlang() {
  # I don't understand how the below command "command" works
  if command -v erl >/dev/null 2>&1; then
    echo -e "${white} "
    echo -e "${green}${bold}Erlang is already installed, skipping installation"
    echo -e "${white} "
  else
    sleep 2
    
    echo -e "${reset}${bold}Installing dependencies for Erlang..."
    echo -e "${white}"
    # dependencies for Erlang plugin
    brew install autoconf openssl@1.1 wxwidgets libxslt fop

    echo -e "${white} "
    echo -e "${cyan}${bold}Installing Erlang..."
    echo -e "${reset}"
    export KERL_CONFIGURE_OPTIONS="--without-javac --with-ssl=$(brew --prefix openssl@1.1)"
    asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git && asdf install erlang 25.2.2 && asdf global erlang 25.2.2
  fi
}

function install_elixir() {
    if which elixir > /dev/null 2>&1; then
    echo -e "${white} "
    echo -e "${green}${bold}Elixir is already installed, skipping installation"
    echo -e "${white} "
  else
    echo -e "${white} "
    echo -e "${cyan}${bold}Installing Elixir..."

    sleep 2

    brew install unzip
    asdf plugin add elixir https://github.com/asdf-vm/asdf-elixir.git && asdf install elixir 1.14.3-otp-25 && asdf global elixir 1.14.3-otp-25
  fi
}

function install_psql() {
  if which psql >/dev/null 2>&1; then
    echo -e "${white} "
    echo -e "${green}${bold}PostgreSQL is already installed, skipping installation"
    echo -e "${white} "
  else
    echo -e "${cyan}${bold}Installing dependencies for PostgreSQL..."
    echo -e "${reset} "
    # Dependencies for PSQL
    brew install gcc readline zlib curl ossp-uuid

    # Installing psql
    asdf plugin-add postgres && asdf install postgres 15.1 && asdf global postgres 15.1

    echo -e "${cyan}${bold}Starting the postgres server... ${reset}"
    pg_ctl start

    echo -e "${cyan}${bold}Creating default database and user for Phoenix to interact with ${reset}"
    createdb ${whoami} # Create default database
    psql -c "CREATE USER postgres WITH PASSWORD 'postgres' CREATEDB;" # User for phoenix to be able to create databases
  fi
}

function install_phoenix_installer() {
  if mix phx.new --version; then
    echo -e "${white} "
    echo -e "${green}${bold}Phoenix installer is already installed, skipping installation"
    echo -e "${white} "
  else
    echo -e "${white} "
    echo -e "${cyan}${bold}Installing Phoenix installer..."
    sleep 0.4

    mix archive.install hex phx_new 1.7.0-rc.2m
  fi 
}

function install_mandatory_tools() {
  install_xcode
  install_homebrew
  install_asdf
  install_erlang
  install_elixir
  install_psql
  install_phoenix_installer
}

function install_nodejs() {
  read -p "Are you sure you want to install NodeJS? (y/n) " sure_install_nodejs

  case $sure_install_nodejs in
    [yY])
      if which node > /dev/null 2>&1; then
        echo -e "${white} "
        echo -e "${green}${bold}NodeJS is already installed, skipping installation"
        echo -e "${white} "
      else
        echo -e "${white} "
        echo -e "${cyan}${bold}Installing NodeJS..."

        sleep 2

        asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git && asdf install nodejs lts && asdf global nodejs lts
      fi
      ;;
      
    [nN])
      echo "skipping installation of NodeJS"
      echo ""
      ;;

    *)
      echo -e "${red}${bold}Invalid response. Please enter either y or n"
      echo -e "${cyan}"
  esac
}

function install_chromedriver() {
  read -p "Are you sure you want to install Chromedriver? (y/n) " sure_install_chromedriver

  case $sure_install_chromedriver in
    [yY])
      if which chromedriver > /dev/null 2>&1; then
        echo -e "${white} "
        echo -e "${green}${bold}Chromedriver is already installed, skipping installation"
        echo -e "${white} "
      else
        echo -e "${white} "
        echo -e "${cyan}${bold}Installing Chromedriver..."

        sleep 2
        
        asdf plugin add chromedriver && asdf install chromedriver latest && asdf install chromedriver latest
      fi
      ;;
      
    [nN])
      echo "skipping installation of Chromedriver"
      echo ""
      ;;

    *)
      echo -e "${red}${bold}Invalid response. Please enter either y or n"
      echo -e "${cyan}"
  esac
}

function install_ohmyzsh() {
  read -p "Are you sure you want to install ohmyzsh? (y/n) " sure_install_ohmyzsh

  case $sure_install_chromedriver in
    [yY])
      echo ""
      echo -e "Installing ohmyzsh"
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

      sleep 1

      echo -e "Installed ohmyzsh"
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
      ;;
      
    [nN])
      echo "skipping installation of ohmyzsh"
      echo ""
      ;;

    *)
      echo -e "${red}${bold}Invalid response. Please enter either y or n"
      echo -e "${cyan}"
  esac
}

function install_optional_tools() {
  install_nodejs
  install_chromedriver
  install_ohmyzsh
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

echo "$phx_tools"

echo "$by"

echo "$optimum"

sleep 2

echo ""

echo -e "${bblue}${bold}Welcome to our Phx.tools script for macOS"

sleep 2

echo ""

echo -e "${bblue}${bold}The following tools and dependencies will be installed if you don't have them already installed:"

echo -e "${cyan}${bold}"

echo -e "1) Command Line Developer Tools(xcode-select)"
echo -e "2) Homebrew"
echo -e "3) asdf"
echo -e "4) Erlang"
echo -e "5) Elixir"
echo -e "6) PostgreSQL"
echo -e "7) Phoenix Installer"

echo ""

sleep 2

is_yn() {
  case $1 in
    [yY])
      
      true
      ;;

    [nN])
      true
      ;;
      
    *)
      false
      ;;
  esac
}

while ! is_yn $answer
do
  read -p "Do you want to continue? (y/n) " answer
  case $answer in
    [yY])
      install_mandatory_tools

      echo ""
      echo -e "${green}${bold}All the mandatory tools that are required to create a phoenix application are installed!!!"

      sleep 2

      echo ""
      echo ""
      echo -e "${cyan}${bold}You can install a few more optional tools if you want:"
      echo -e "1) NodeJS"
      echo -e "2) Chromedriver"
      echo -e "3) ohmyzsh"
      
      while ! is_yn $optional
      do
        read -p "Do you want to continue? (y/n) " optional

        case $optional in
          [yY])
            install_optional_tools

            echo 
            ;;

          [nN])
            echo "Thank you for your time... exiting tool..."
            echo ""
            exit 1
            ;;
            
          *)
            echo -e "${red}${bold}Invalid response. Please enter either y or n"
            echo -e "${cyan}"
        esac

      done

      ;;
      
    [nN])
      echo "Thank you for your time... exiting tool..."
      echo ""
      exit 1
      ;;

    *)
      echo -e "${red}${bold}Invalid response. Please enter either y or n"
      echo -e "${cyan}"
  esac
done