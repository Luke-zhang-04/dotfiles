#! /bin/bash
# ~/.bashrc
#

[[ $- != *i* ]] && return

battery_percentage() {
    upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -E "percentage" | awk '{print substr($2, 1, length($2)-1)}'
}

colors() {
    local fgc bgc vals seq0

    printf "Color escapes are %s\n" '\e[${value};...;${value}m'
    printf "Values 30..37 are \e[33mforeground colors\e[m\n"
    printf "Values 40..47 are \e[43mbackground colors\e[m\n"
    printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

    # foreground colors
    for fgc in {30..37}; do
        # background colors
        for bgc in {40..47}; do
            fgc=${fgc#37} # white
            bgc=${bgc#40} # black

            vals="${fgc:+$fgc;}${bgc}"
            vals=${vals%%;}

            seq0="${vals:+\e[${vals}m}"
            printf "  %-9s" "${seq0:-(default)}"
            printf " ${seq0}TEXT\e[m"
            printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
        done
        echo; echo
    done
}

[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# Change the window title of X terminals
case ${TERM} in
    xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*)
        PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"';;
    screen*)
        PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"';;
esac

use_color=true

safe_term=${TERM//[^[:alnum:]]/?}
match_lhs=""

[[ -f ~/.dir_colors   ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs}    ]] \
    && type -P dircolors >/dev/null \
    && match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

if ${use_color}; then
    if type -P dircolors >/dev/null; then
        if [[ -f ~/.dir_colors ]]; then
            eval "$(dircolors -b ~/.dir_colors)"
        elif [[ -f /etc/DIR_COLORS ]]; then
            eval "$(dircolors -b /etc/DIR_COLORS)"
        fi
    fi

    if [[ ${EUID} == 0 ]]; then
        PS1='\[$(tput setaf 6)$(tput bold)\][\u@\h\[\033[01;37m\] \W\[$(tput setaf 6)$(tput bold)\]]\$\[\033[00m\] '
    else
        PS1='\[$(tput setaf 6)$(tput bold)\][\u@\h\[\033[01;37m\] \W\[$(tput setaf 6)$(tput bold)\]]\$\[\033[00m\] '
    fi

    alias ls='ls --color=auto'
    alias grep='grep --colour=auto'
    alias egrep='egrep --colour=auto'
    alias fgrep='fgrep --colour=auto'
else
    if [[ ${EUID} == 0 ]]; then
        PS1='\u@\h \W \$ '
    else
        PS1='\u@\h \w \$ '
    fi
fi

unset use_color safe_term match_lhs sh

alias cp="cp -iv"                         # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias np='nano -w PKGBUILD'
alias more=less

xhost +local:root > /dev/null 2>&1

complete -cf sudo
source /usr/share/doc/pkgfile/command-not-found.bash
shopt -s autocd
source /etc/profile.d/autojump.bash
shopt -s checkwinsize

shopt -s expand_aliases

# Export QT_SELECT=4

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

# CONFIG
export PATH=/usr/local/bin:$PATH
if [[ -d "$HOME/bin" ]] ; then
    PATH="$HOME/bin:$PATH"
fi

# EDITOR
export EDITOR="vim"

# BASH HISTORY
export HISTSIZE=100000
export HISTFILESIZE=${HISTSIZE}
export HISTCONTROL=ignoreboth
export HISTIGNORE='&:ls:ll:la:cd:exit:clear:history:neofetch:cls:startx:startgdm'

# COLORED MAN PAGES
if "$_isxrunning"; then
    export PAGER=less
    export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
    export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
    export LESS_TERMCAP_me=$'\E[0m'           # end mode
    export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
    export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
    export LESS_TERMCAP_ue=$'\E[0m'           # end underline
    export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline
fi

# TOP 10 COMMANDS
# copyright 2007 - 2010 Christopher Bratusek
top10() { history | awk '{a[$2]++ } END{for(i in a){print a[i] " " i}}' | sort -rn | head; }

# Goes up many dirs as the number passed as argument, if none goes up by 1 by default
up() {
    local d=""
    limit=$1

    for ((i=1 ; i <= limit ; i++)); do
        d=$d/..
    done

    d=$(echo $d | sed 's/^\///')

    if [[ -z "$d" ]]; then
        d=..
    fi

    cd $d
}

extract() {
    clrstart="\033[1;34m"  # Color codes
    clrend="\033[0m"

    if [[ "$#" -lt 1 ]]; then
        echo -e "${clrstart}Pass a filename. Optionally a destination folder. You can also append a v for verbose output.${clrend}"
        exit 1 # Not enough args
    fi

    if [[ ! -e "$1" ]]; then
        echo -e "${clrstart}File does not exist!${clrend}"
        exit 2 # File not found
    fi

    if [[ -z "$2" ]]; then
        DESTDIR="." #set destdir to current dir
    elif [[ ! -d "$2" ]]; then
        echo -e -n "${clrstart}Destination folder doesn't exist or isnt a directory. Create? (y/n): ${clrend}"
        read response

        if [[ $response == y || $response == Y ]]; then
        mkdir -p "$2"
        if [ $? -eq 0 ]; then
            DESTDIR="$2"
        else
            exit 6 # Write perms error
        fi
        else
        echo -e "${clrstart}Closing.${clrend}"; exit 3 # no/wrong response
        fi
    else
        DESTDIR="$2"
    fi

    if [[ ! -z "$3" ]]; then
        if [[ "$3" != "v" ]]; then
        echo -e "${clrstart}Wrong argument $3 !${clrend}"
        exit 4 # Wrong arg 3
        fi
    fi

    filename=`basename "$1"`

    case "${filename##*.}" in
        tar)
            echo -e "${clrstart}Extracting $1 to $DESTDIR: (uncompressed tar)${clrend}"
            tar x"${3}"f "$1" -C "$DESTDIR"
        ;;
        gz)
            echo -e "${clrstart}Extracting $1 to $DESTDIR: (gip compressed tar)${clrend}"
            tar x"${3}"fz "$1" -C "$DESTDIR"
        ;;
        tgz)
            echo -e "${clrstart}Extracting $1 to $DESTDIR: (gip compressed tar)${clrend}"
            tar x${3}fz "$1" -C "$DESTDIR"
        ;;
        xz)
            echo -e "${clrstart}Extracting  $1 to $DESTDIR: (gip compressed tar)${clrend}"
            tar x"${3}"f -J "$1" -C "$DESTDIR"
        ;;
        bz2)
            echo -e "${clrstart}Extracting $1 to $DESTDIR: (bzip compressed tar)${clrend}"
            tar x"${3}"fj "$1" -C "$DESTDIR"
        ;;
        zip)
            echo -e "${clrstart}Extracting $1 to $DESTDIR: (zipp compressed file)${clrend}"
            unzip "$1" -d "$DESTDIR"
        ;;
        rar)
            echo -e "${clrstart}Extracting $1 to $DESTDIR: (rar compressed file)${clrend}"
            unrar x "$1" "$DESTDIR"
        ;;
        7z)
            echo -e  "${clrstart}Extracting $1 to $DESTDIR: (7zip compressed file)${clrend}"
            7za e "$1" -o"$DESTDIR"
        ;;
        *)
            echo -e "${clrstart}Unknown archieve format!"
            exit 5
        ;;
    esac
}

compress() {
    if [[ -n "$1" ]]; then
        FILE=$1
        case $FILE in
            *.tar ) shift && tar cf $FILE $* ;;
            *.tar.bz2 ) shift && tar cjf $FILE $* ;;
            *.tar.gz ) shift && tar czf $FILE $* ;;
            *.tgz ) shift && tar czf $FILE $* ;;
            *.zip ) shift && zip $FILE $* ;;
            *.rar ) shift && rar $FILE $* ;;
        esac
    else
        echo "usage: compress <foo.tar.gz> ./foo ./bar"
    fi
}

to_iso () {
    if [[ $# == 0 || $1 == "--help" || $1 == "-h" ]]; then
        echo -e "Converts raw, bin, cue, ccd, img, mdf, nrg cd/dvd image files to ISO image file.\nUsage: to_iso file1 file2..."
    fi

    for i in $*; do
        if [[ ! -f "$i" ]]; then
        echo "'$i' is not a valid file; jumping it"
        else
        echo -n "converting $i..."
        OUT=`echo $i | cut -d '.' -f 1`
        case $i in
                *.raw ) bchunk -v $i $OUT.iso;; #raw=bin #*.cue #*.bin
        *.bin|*.cue ) bin2iso $i $OUT.iso;;
        *.ccd|*.img ) ccd2iso $i $OUT.iso;; #Clone CD images
                *.mdf ) mdf2iso $i $OUT.iso;; #Alcohol images
                *.nrg ) nrg2iso $i $OUT.iso;; #nero images
                    * ) echo "to_iso don't know de extension of '$i'";;
        esac
        if [[ $? != 0 ]]; then
            echo -e "${R}ERROR!${W}"
        else
            echo -e "${G}done!${W}"
        fi
        fi
    done
}
# REMIND ME, ITS IMPORTANT!
# usage: remindme <time> <text>
# e.g.: remindme 10m "omg, the pizza"
remindme() { sleep $1 && zenity --info --text "$2" & }

# SIMPLE CALCULATOR
# usage: calc <equation>
calc() {
    if which bc &>/dev/null; then
        echo "scale=3; $*" | bc -l
    else
        awk "BEGIN { print $* }"
    fi
}

# FILE & STRINGS RELATED FUNCTIONS
## FIND A FILE WITH A PATTERN IN NAME
ff() { find . -type f -iname '*'$*'*' -ls ; }
## FIND A FILE WITH PATTERN $1 IN NAME AND EXECUTE $2 ON IT
fe() { find . -type f -iname '*'$1'*' -exec "${2:-file}" {} \;  ; }

## MOVE FILENAMES TO LOWERCASE
lowercase() {
    for file ; do
        filename=${file##*/}
        case "$filename" in
            */* ) dirname=${file%/*} ;;
            * ) dirname=.;;
        esac

        nf=$(echo $filename | tr A-Z a-z)
        newname="${dirname}/${nf}"

        if [[ "$nf" != "$filename" ]]; then
            mv "$file" "$newname"
            echo "lowercase: $file --> $newname"
        else
            echo "lowercase: $file not changed."
        fi
    done
}

## SWAP 2 FILENAMES AROUND, IF THEY EXIST
#(from Uzi's bashrc).
swap() {
    local TMPFILE=tmp.$$

    [[ $# -ne 2 ]] && echo "swap: 2 arguments needed" && return 1
    [[ ! -e $1 ]] && echo "swap: $1 does not exist" && return 1
    [[ ! -e $2 ]] && echo "swap: $2 does not exist" && return 1

    mv "$1" $TMPFILE
    mv "$2" "$1"
    mv $TMPFILE "$2"
}

## FINDS DIRECTORY SIZES AND LISTS THEM FOR THE CURRENT DIRECTORY
dirsize () {
    du -shx * .[a-zA-Z0-9_]* 2> /dev/null | egrep '^ *[0-9.]*[MG]' | sort -n > /tmp/list
    egrep '^ *[0-9.]*M' /tmp/list
    egrep '^ *[0-9.]*G' /tmp/list
    rm -rf /tmp/list
}

## FIND AND REMOVED EMPTY DIRECTORIES
fared() {
    read -p "Delete all empty folders recursively [y/N]: " OPT
    [[ $OPT == y ]] && find . -type d -empty -exec rm -fr {} \; &> /dev/null
}

## FIND AND REMOVED ALL DOTFILES
farad () {
    read -p "Delete all dotfiles recursively [y/N]: " OPT
    [[ $OPT == y ]] && find . -name '.*' -type f -exec rm -rf {} \;
}

# ENTER AND LIST DIRECTORY
function cd() { builtin cd -- "$@" && { [ "$PS1" = "" ] || ls -hrt --color; }; }

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


if [[ "$COLORTERM" == "truecolor" ]]; then
    powerline-daemon -q
    POWERLINE_BASH_CONTINUATION=1
    POWERLINE_BASH_SELECT=1
    . /usr/share/powerline/bindings/bash/powerline.sh
fi

alias pacman=yay
alias docker="sudo docker"

PATH=$PATH:~/node_modules/.bin
PATH=$PATH:~/bin
PATH=$PATH:/bin
PATH=$PATH:~/.local/bin

source ~/.ombrc

if [[ "$(ls "$PWD"/.git)" ]]; then
    onefetch
else
    neofetch
fi
