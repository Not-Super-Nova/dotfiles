#!/bin/bash

# USAGE:
# ./install.sh   (interactive)
# ./install.sh y (automatic)
#

log () {
    # Following SC2059 breaks the newlines
    # shellcheck disable=SC2059
    printf "[$(date +"%H:%M:%S")] $1\n"
}

rm_log () {
    echo "RM: $1"
    rm -rf "$1"
}

remove_all () {
    rm_log "$HOME/.aliases"
    rm_log "$HOME/.bashcmds"
    rm_log "$HOME/.bash_profile"
    rm_log "$HOME/.bashrc"
    rm_log "$HOME/.config/rofi/"
    rm_log "$HOME/.paths"
    rm_log "$HOME/.profile"
    rm_log "$HOME/.hidden"
    rm_log "$HOME/.fonts/NotoSansJP-Black.otf"
    rm_log "$HOME/.fonts/NotoSansJP-Bold.otf"
    rm_log "$HOME/.fonts/NotoSansJP-Light.otf"
    rm_log "$HOME/.fonts/NotoSansJP-Medium.otf"
    rm_log "$HOME/.fonts/NotoSansJP-Regular.otf"
    rm_log "$HOME/.fonts/NotoSansJP-Thin.otf"
    rm_log "$HOME/.gitconfig"
    rm_log "$HOME/.local/share/konsole/Pastels 2.colorscheme"
    rm_log "$HOME/.local/share/konsole/Pastels 2.profile"
    rm_log "$HOME/.local/share/konsole/Profile 1.profile"
    rm_log "$HOME/.vimrc"
    rm_log "$HOME/.xinitrc"
    rm_log "$HOME/.xprofile"
    echo ""
}

mkdir_log () {
    echo "MK: $1"
    mkdir -p "$1"
}

mkdir_all () { 
    mkdir_log ~/.fonts 
    mkdir_log ~/.local/share/konsole 
    mkdir_log ~/.config/rofi
    echo ""
}

link_all () {
    stow -vSt ~ bash git vim x11 dolphin
    stow -vSt ~/.fonts fonts
    stow -vSt ~/.local/share/konsole/ konsole/
    stow -vSt ~/.config/rofi rofi
}

# Check if stow is installed
if [[ -z "$(which stow)" ]]; then
    log "stow not found in path, make sure you have it installed!"
    exit 1
fi

# Set directory to stow, inside where install.sh is
cd "$(dirname "$0")/stow" || {
    log "Failed to cd to stow directory, make sure you are running the script from where you git cloned it."
    exit 1
}

# If the first argument is provided, check if it's some variation of "yes"
if [[ -z "$1" ]]; then
    arr=("Removing default configurations:\n  "
    "bash:\n    ~/.aliases\n    ~/.bashcmds\n    ~/.bash_profile\n    ~/.bashrc\n    ~/.paths\n    ~/.profile\n  "
    "rofi:\n    ~/.config/rofi/  \n  "
    "dolphin:\n    ~/.hidden\n  "
    "fonts:\n    ~/.fonts/NotoSansJP-Black.otf\n    ~/.fonts/NotoSansJP-Bold.otf\n    ~/.fonts/NotoSansJP-Light.otf\n    ~/.fonts/NotoSansJP-Medium.otf\n    ~/.fonts/NotoSansJP-Regular.otf\n    ~/.fonts/NotoSansJP-Thin.otf\n  "
    "git:\n    ~/.gitconfig\n  "
    "konsole:\n    ~/.local/share/konsole/Profile 1.profile\n    ~/.local/share/konsole/Pastels 2.profile\n    ~/.local/share/konsole/Pastels 2.colorscheme\n  "
    "vim:\n    ~/.vimrc\n  "
    "x11:\n    ~/.xinitrc\n    ~/.xprofile"
    "\n")
    log "${arr[*]}"
    read -r -p "Is this okay? (y/N): " confirm
    echo ""
else
    confirm="$1"
fi

# Confirm if the user wants to remove all default configurations
if [[ "$confirm" =~ [Yy] ]]; then
    log "Removing default configurations..."
else
    log "User selected no, exiting."
    exit 1
fi

remove_all || {
    log "Failed to remove all default configurations, check your permissions."
}

log "Creating required directories..."

mkdir_all

log "Automatically linking new configurations via stow..."

link_all || {
    log "Failed to link all new configurations, check your permissions."
}
