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

elixir_version=1.17.2-otp-27
erlang_version=27.0.1
phoenix_version=1.7.14
postgres_version=15.1

current_shell=$(echo $SHELL | awk -F '/' '{print $NF}')

case "$current_shell" in
"bash" | "rbash")
    config_file="$HOME/.bashrc"
    ;;
"dash" | "sh")
    config_file="$HOME/.profile"
    ;;
"elvish")
    config_file="$HOME/.config/elvish/rc.elv"
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

echo "Current shell: $current_shell"
echo "Config file: $config_file"

function already_installed() {
    case $1 in
    "Git")
        which git >/dev/null 2>&1
        ;;
    "wget")
        dpkg -l | grep -q wget
        ;;
    "asdf")
        which asdf >/dev/null 2>&1
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
    "wget")
        sudo apt-get install -y wget
        ;;
    "asdf")
        git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.1

        case $current_shell in
        "bash" | "rbash")
            echo '. "$HOME/.asdf/asdf.sh"' >>"$config_file"
            echo '. "$HOME/.asdf/completions/asdf.bash"' >>"$config_file"
            ;;
        "elvish")
            echo ". $HOME/.asdf/asdf.elv" >>~/.config/elvish/rc.elv
            ;;
        "fish")
            echo ". $HOME/.asdf/asdf.fish" >>~/.config/fish/config.fish
            mkdir -p ~/.config/fish/completions
            ln -s ~/.asdf/completions/asdf.fish ~/.config/fish/completions
            ;;
        *)
            echo "Unsupported shell: $current_shell"
            exit 1
            ;;
        esac
        ;;
    "Erlang")
        sudo apt-get update
        sudo apt-get -y install build-essential autoconf m4 libncurses5-dev libwxgtk3.0-gtk3-dev libwxgtk-webview3.0-gtk3-dev libgl1-mesa-dev libglu1-mesa-dev libpng-dev libssh-dev unixodbc-dev xsltproc fop libxml2-utils libncurses-dev openjdk-11-jdk
        asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git
        asdf install erlang $erlang_version
        asdf global erlang $erlang_version
        asdf reshim erlang $erlang_version
        ;;
    "Elixir")
        asdf plugin add elixir https://github.com/asdf-vm/asdf-elixir.git
        asdf install elixir $elixir_version
        asdf global elixir $elixir_version
        asdf reshim elixir $elixir_version
        ;;
    "Phoenix")
        source $config_file >/dev/null 2>&1
        mix local.hex --force
        mix archive.install --force hex phx_new $phoenix_version
        ;;
    "PostgreSQL")
        sudo apt-get update
        sudo apt-get -y install linux-headers-generic build-essential libssl-dev libreadline-dev zlib1g-dev libcurl4-openssl-dev uuid-dev icu-devtools

        asdf plugin add postgres https://github.com/smashedtoatoms/asdf-postgres.git
        asdf install postgres $postgres_version
        asdf global postgres $postgres_version
        asdf reshim postgres

        echo 'export PATH="$HOME/.asdf/installs/postgres/$postgres_version/bin:$PATH"' >>$config_file
        echo 'export PATH="$HOME/.asdf/shims:$PATH"' >>$config_file
        echo 'export PGDATA="$HOME/pgdata"' >>$config_file
        echo 'pg_ctl() { "$HOME/.asdf/shims/pg_ctl" "$@"; }' >>$config_file
        source $config_file >/dev/null 2>&1

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
        if [[ $1 == "Erlang" ]]; then
            echo "This might take a while."
        fi
        echo ""
        install $1
    fi
}

function add_env() {
    # echo ""
    # echo -e "${white}"
    # sleep 2
    # maybe_install "Git"

    # echo -e "${white}"
    # sleep 2
    # maybe_install "wget"

    echo -e "${white}"
    # sleep 3
    maybe_install "asdf"

    # echo -e "${white}"
    # sleep 1.5
    # maybe_install "Erlang"

    # echo -e "${white}"
    # sleep 1.5
    # maybe_install "Elixir"

    # echo -e "${white}"
    # sleep 1.5
    # maybe_install "Phoenix"

    # echo -e "${white}"
    # sleep 1.5
    # maybe_install "PostgreSQL"

    echo "echo 'This is executed'" >>~/.bashrc
    echo $HOME
    echo "Sourcing $config_file"
    source $config_file
    echo "Final PATH: $PATH"
    echo "Which asdf: $(which asdf)"
    echo "asdf --version: $(asdf --version)"

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

# sleep 3

echo ""

echo -e "${bblue}${bold}Welcome to the phx.tools shell script for Linux-based OS."

# sleep 3

echo ""

echo -e "${bblue}${bold}The following will be installed if not available already:"

echo -e "${cyan}${bold}"

echo "1) Build dependencies"
echo "2) asdf"
echo "3) Erlang"
echo "4) Elixir"
echo "5) Phoenix"
echo "6) PostgreSQL"

echo ""
echo -e "${white} ${bold}"

# sleep 1

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

        # sleep 3

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
