#!/bin/fish

set PATH ~/node_modules/.bin $PATH
set PATH /bin $PATH
set PATH ~/bin $PATH
set PATH ~/.local/bin $PATH

alias docker="sudo docker"

if test -d "$PWD/.git"
    onefetch
else
    neofetch
end
