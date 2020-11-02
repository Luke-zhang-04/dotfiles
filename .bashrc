#! /bin/bash
# ~/.bashrc
#

[[ $- != *i* ]] && return

alias cp="cp -iv"                         # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias np='nano -w PKGBUILD'
alias more=less

complete -cf sudo
source /usr/share/doc/pkgfile/command-not-found.bash
shopt -s autocd
source /etc/profile.d/autojump.bash
shopt -s checkwinsize

shopt -s expand_aliases

shopt -s histappend

export LESS=-R
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

#
# # ex - archive extractor
# # usage: ex <file>
ex () {
    if [ -f "$1" ] ; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"   ;;
            *.tar.gz)    tar xzf "$1"   ;;
            *.bz2)       bunzip2 "$1"   ;;
            *.rar)       unrar x "$1"   ;;
            *.gz)        gunzip "$1"    ;;
            *.tar)       tar xf "$1"    ;;
            *.tbz2)      tar xjf "$1"   ;;
            *.tgz)       tar xzf "$1"   ;;
            *.zip)       unzip "$1"     ;;
            *.Z)         uncompress "$1";;
            *.7z)        7z x "$1"      ;;
            *)           echo "'$1' cannot be extracted via ex()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}


# BASH OPTIONS
shopt -s cdspell
shopt -s checkwinsize
shopt -s histappend
shopt -s cmdhist
shopt -s extglob
shopt -s no_empty_cmd_completion

# COMPLETION
complete -cf sudo
if [[ -f /etc/bash_completion ]]; then
. /etc/bash_completion
fi


# EDITOR
export EDITOR="vim"

# BASH HISTORY
export HISTSIZE=100000
export HISTFILESIZE=${HISTSIZE}
export HISTCONTROL=ignoreboth
export HISTIGNORE='&:ls:ll:la:cd:exit:clear:history:neofetch:cls:startx:startgdm'

# COLORED MAN PAGES
if [[ "$_isxrunning" ]]; then
    export PAGER=less
    export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
    export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
    export LESS_TERMCAP_me=$'\E[0m'           # end mode
    export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
    export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
    export LESS_TERMCAP_ue=$'\E[0m'           # end underline
    export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline
fi

# ENTER AND LIST DIRECTORY
function cd() {
    builtin cd "$@" && { [ "$PS1" = "" ] || ls -hrt --color; }
}

if which systemctl &>/dev/null; then
    start() {
        sudo systemctl start "$1".service
    }
    restart() {
        sudo systemctl restart "$1".service
    }
    stop() {
        sudo systemctl stop "$1".service
    }
    enable() {
        sudo systemctl enable "$1".service
    }
    status() {
        sudo systemctl status "$1".service
    }
    disable() {
        sudo systemctl disable "$1".service
    }
fi

# ALIAS
alias freemem='sudo /sbin/sysctl -w vm.drop_caches=3'
alias enter_matrix='echo -e "\e[32m"; while :; do for i in {1..16}; do r="$(($RANDOM % 2))"; if [[ $(($RANDOM % 5)) == 1 ]]; then if [[ $(($RANDOM % 4)) == 1 ]]; then v+="\e[1m $r   "; else v+="\e[2m $r   "; fi; else v+="     "; fi; done; echo -e "$v"; v=""; done'

# GIT_OR_HUB
if which hub &>/dev/null; then
    alias git=hub
fi

# AUTOCOLOR
alias ls='ls --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# MODIFIED COMMANDS
alias ..='cd ..'
alias df='df -h'
alias diff='colordiff'              # requires colordiff package
alias du='du -c -h'
alias free='free -m'                # show sizes in MB
alias grep='grep --color=auto'
alias grep='grep --color=tty -d skip -n'
alias mkdir='mkdir -p -v'
alias more='less'
alias nano='nano -w'
alias ping='ping -c 5'
alias cls='clear; neofetch'
alias pacman='sudo pacman'
alias howdoi='howdoi -c'
alias pls='sudo $(fc -ln -1)'
alias neofetch="neofetch --colors 6 6 6 6 6 6"
alias vi="vim"
alias diskspace="du -S | sort -n -r | less"
alias folders="find . -maxdepth 1 -type d -print | xargs du -sk | sort -rn"
alias rmlck="sudo rm -rv /var/lib/pacman/db.lck"
alias htop="htop -t"

# PRIVILEGED ACCESS
if ! $_isroot; then
    alias sudo='sudo '
    alias scat='sudo cat'
    alias svim='sudo vim'
    alias root='sudo su'
    alias reboot='sudo reboot'
    alias halt='sudo halt'
fi

# PACMAN ALIASES
# we're on ARCH
if $_isarch; then
    # we're not root
    if ! $_isroot; then
        alias pacman='sudo pacman'
    fi
    alias pacupg='pacman -Syu'            # Synchronize with repositories and then upgrade packages that are out of date on the local system.
    alias pacupd='pacman -Sy'             # Refresh of all package lists after updating /etc/pacman.d/mirrorlist
    alias pacin='pacman -S'               # Install specific package(s) from the repositories
    alias pacinu='pacman -U'              # Install specific local package(s)
    alias pacre='pacman -R'               # Remove the specified package(s), retaining its configuration(s) and required dependencies
    alias pacun='pacman -Rcsn'            # Remove the specified package(s), its configuration(s) and unneeded dependencies
    alias pacinfo='pacman -Si'            # Display information about a given package in the repositories
    alias pacse='pacman -Ss'              # Search for package(s) in the repositories

    alias pacupa='pacman -Sy && sudo abs' # Update and refresh the local package and ABS databases against repositories
    alias pacind='pacman -S --asdeps'     # Install given package(s) as dependencies of another package
    alias pacclean="pacman -Sc"           # Delete all not currently installed package files
    alias pacmake="makepkg -fcsi"         # Make package from PKGBUILD file in current directory
fi

# MULTIMEDIA
if which get_flash_videos &>/dev/null; then
    alias gfv='get_flash_videos -r 720p --subtitles'
fi

# LS
alias ls='ls -hF --color=auto'
alias lr='ls -R'                    # recursive ls
alias ll='ls -alh'
alias la='ll -A'
alias lm='la | less'

# STARTUP
if [ "$TERM" = "linux" ]; then
    _SEDCMD='s/.*\*color\([0-9]\{1,\}\).*#\([0-9a-fA-F]\{6\}\).*/\1 \2/p'
    for i in $(sed -n "$_SEDCMD" ~/.Xresources | awk '$1 < 16 {printf "\\e]P%X%s", $1, $2}'); do
        echo -en "$i"
    done
fi

alias pacman=yay
alias docker="sudo docker"

PATH=/usr/local/bin:$PATH
PATH=$PATH:~/node_modules/.bin
PATH=$PATH:~/bin
PATH=$PATH:/bin
PATH=$PATH:~/.local/bin

loadnvm() {
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
}

source ~/.ombrc

if [[ -d "$PWD/.git" ]]; then
    onefetch
else
    neofetch
fi

loadnvm &
