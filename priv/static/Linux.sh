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
*/bash)
    current_shell="bash"
    config_file="$HOME/.bashrc"
    ;;
*/zsh)
    current_shell="zsh"
    config_file="$HOME/.zshrc"
    ;;
*)
    printf "Unsupported shell: $SHELL\n"
    exit 1
    ;;
esac

already_installed() {
    case "$1" in
    "Elixir")
        which elixir >/dev/null 2>&1
        ;;
    "Erlang")
        which erl >/dev/null 2>&1
        ;;
    "mise")
        which mise >/dev/null 2>&1
        ;;
    "Phoenix")
        mix phx.new --version >/dev/null 2>&1
        ;;
    "PostgreSQL")
        which initdb >/dev/null 2>&1
        ;;
    *)
        printf "Invalid name argument on checking: $1\n"
        exit 1
        ;;
    esac
}

install() {
    case "$1" in
    "Elixir")
        mise use -g elixir@$elixir_version
        ;;
    "Erlang")
        if [ ! -f ~/.kerlrc ]; then
            printf "KERL_CONFIGURE_OPTIONS=\"--without-javac\"\n" >~/.kerlrc
        fi
        mise use -g erlang@$erlang_version
        ;;
    "mise")
        arch=$(uname -m)
        if [ "$arch" = "x86_64" ]; then
            mise_arch="x86_64"
        elif [ "$arch" = "aarch64" ]; then
            mise_arch="arm64"
        else
            printf "Unsupported architecture: %s\n" "$arch"
            exit 1
        fi
        mkdir -p "$HOME/.local/bin"
        curl -L "https://github.com/jdxcode/mise/releases/latest/download/mise-linux-$mise_arch" -o "$HOME/.local/bin/mise"
        chmod +x "$HOME/.local/bin/mise"
        printf 'eval "$(%s activate %s)"\n' "$HOME/.local/bin/mise" "$current_shell" >>"$config_file"
        eval "$("$HOME/.local/bin/mise" activate "$current_shell")"
        # Verify that 'mise' is installed correctly
        "$HOME/.local/bin/mise" --version || {
            printf "Failed to execute mise. Exiting.\n"
            exit 1
        }
        ;;
    "Phoenix")
        mise exec -- mix local.hex --force
        mise exec -- mix local.rebar --force
        mise exec -- mix archive.install --force hex phx_new $phoenix_version
        ;;
    "PostgreSQL")
        sudo apt-get update
        sudo apt-get -y install linux-headers-generic build-essential libssl-dev libreadline-dev zlib1g-dev libcurl4-openssl-dev uuid-dev icu-devtools
        mise use -g postgres@$postgres_version
        ;;
    *)
        printf "Invalid name argument on install: %s\n" "$1"
        exit 1
        ;;
    esac
}

maybe_install() {
    if already_installed "$1"; then
        printf "$1 is already installed. Skipping...\n"
    else
        printf "Installing $1...\n"
        if [ "$1" = "Erlang" ]; then
            printf "This might take a while.\n"
        fi
        printf "\n"
        install "$1"
    fi
}

add_env() {
    printf "\n"

    printf "${white}\n"
    sleep 1.5
    maybe_install "mise"

    # printf "${white}\n"
    # sleep 1.5
    # maybe_install "Erlang"

    printf "${white}\n"
    sleep 1.5
    maybe_install "Elixir"

    # printf "${white}\n"
    # sleep 1.5
    # maybe_install "Phoenix"

    # printf "${white}\n"
    # sleep 1.5
    # maybe_install "PostgreSQL"

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

printf "${bblue}${bold}Welcome to the phx.tools shell script for Linux-based OS.\n"

sleep 3

printf "\n"

printf "${bblue}${bold}The following will be installed if not available already:\n"

printf "${cyan}${bold}\n"

printf "1) Build dependencies\n"
printf "2) mise\n"
printf "3) Erlang\n"
printf "4) Elixir\n"
printf "5) Phoenix\n"
printf "6) PostgreSQL\n"

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

printf "Setup complete. Please restart your terminal or run 'source $config_file' to apply changes.\n"
