# If not running interactively, don't do anything
[[ $- != *i* ]] && return

## Set prompt (eg https://i.l1v.in/misc/neofetch.png)
export PS1='\[\033[34m\]\W\[\033[00m\] ❯ '

## Set aliases
if [ -f ~/.aliases ]; then
    . ~/.aliases
fi

## Set locale, editor, commands, and misc exports
source ~/.profile
source ~/.env
source ~/.bashcmds

## Export paths from ~/.paths
while read path; do
    export PATH="$(eval echo -e "$path"):$PATH"
done </"$HOME/.paths"

## Echo login shell (set in .profile)
if [ "$LOGIN_MSG" == "true" ]; then
    echo "Logged in at $(date +"%H:%M:%S on %d/%m/%Y")"
    echo ""
fi

## Single setup things when starting X
if [ "$(tty)" == "/dev/tty1" ]; then
    sudo systemctl start systemd-timesyncd.service &>/dev/null &
    exec exec nohup /usr/lib/notify-osd/notify-osd &>/dev/null &
    "$HOME/.cargo/bin/cmus-discord-rpc" &>/dev/null &
    exec startx
fi
