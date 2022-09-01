#!/bin/fish

set PATH ~/node_modules/.bin $PATH
set PATH /bin $PATH
set PATH ~/bin $PATH
set PATH ~/.local/bin $PATH
set PATH ~/.npm-global/bin $PATH

alias docker="sudo docker"
alias plz="sudo"
alias pls="sudo"
alias please="sudo"

# eval (ssh-agent -c) | :

if test -d "$PWD/.git"
    onefetch --show-logo auto
else
    neofetch
end

# tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/fish/__tabtab.fish ]; and . ~/.config/tabtab/fish/__tabtab.fish; or true
