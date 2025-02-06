#!/bin/bash

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
PS1='[\u@\h \W]\$ '

# Aliases
alias blui='bluetoothctl'
alias c="clear"
alias ld='sudo lazydocker'
alias ls='ls --color=auto -a'
alias gi='gitui'
alias 'gitc'='git add . && git commit -S'

# Path
export PATH=~/.local/bin:$PATH
export PATH=~/.local/share/cargo/bin:$PATH

# Default Programs
export VISUAL=hx
export EDITOR=hx
export BROWSER=brave

# XDG https://wiki.archlinux.org/title/XDG_Base_Directory
export XDG_CONFIG_HOME=~/.config
export XDG_DATA_HOME=~/.local/share
export XDG_CACHE_HOME=~/.cache

# Cleanup
export STARSHIP_CONFIG=~/.config/starship/starship.toml
export CARGO_HOME=~/.local/share/cargo
export RUSTUP_HOME=~/.local/share/rustup
export NUGET_PACKAGES=~/.local/share/Nuget
export GOPATH=~/.local/share/go
#export LS_COLORS='*.md=34:'
export LF_COLORS="\
~/.cache=90:\
~/.config=90:\
~/.dotnet=90:\
~/.java=90:\
~/.local=90:\
~/.nuget=90:\
~/.pki=90:\
~/.templateengine=90:\
~/.vscode=90:\
.cargo/=90:\
.git/=90:\
.github/=90:\
.idea/=90:\
bin/=90:\
obj/=90:\
target/=90:\
.git*=90:\
*.gitignore=90:\
"

# Functions
function gsync(){
  git add .
  git commit -m update
  git push
}

function ya() {
    tmp="$(mktemp -t "yazi-cwd.XXXXX")"
    yazi --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}
