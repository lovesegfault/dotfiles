#!usr/bin/zsh

gempath=$(ruby -rubygems -e "puts Gem.user_dir")/bin

export PATH=$HOME/bin:/usr/local/bin:$PATH # Self-compiled
export PATH=$PATH:$gempath # Ruby Gems
export PATH=$PATH:$HOME/.node_modules/bin
#export PATH=$PATH:/opt/cuda/bin # Cuda
#export PATH=$PATH:/opt/Xilinx/Vivado/2016.4/bin/ # Vivado/FPGA
export PATH=$PATH:$HOME/.cargo/bin # Rust

export TERM="xterm-256color" # MOAR COLOURS

export SSH_KEY_PATH="$HOME/.ssh/id_rsa"
export GPG_TTY=$(tty)

export XDG_CONFIG_HOME="$HOME/.config"

#export SWAYSOCK=$(ls /run/user/*/sway-ipc.*.sock | head -n 1)

# Uses nano for SSH sessions to avoid bugs with Vim colors.
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='nano'
else
    export EDITOR='vim'
fi

export UNCRUSTIFY_CONFIG="$HOME"/.uncrustify.cfg

export npm_config_prefix=$HOME/.node_modules

fpath+=~/.zfunc

source /usr/share/zsh/share/antigen.zsh

antigen use oh-my-zsh

antigen bundle colored-man-pages #Adds color to man
antigen bundle archlinux #Arch Linux shortcuts
antigen bundle common-aliases #A set of common, useful aliases
antigen bundle gem #Completions for gem
antigen bundle git #Completions for git
antigen bundle gitfast #Faster completions
antigen bundle git-extras #A collection of git aliases
antigen bundle github #Completions for github's gem
antigen bundle nyan #Nyan cat
antigen bundle pip #pip completions
antigen bundle python #Python interpreter completions
antigen bundle web-search #In-term websearch

antigen bundle zsh-users/zsh-syntax-highlighting #Fish-like highlighting
antigen bundle zsh-users/zsh-history-substring-search #Fish-like history search
antigen bundle zsh-users/zsh-completions #Extra completions
antigen bundle zsh-users/zsh-autosuggestions #Fish-like autosiggestions

antigen bundle fcambus/ansiweather #Weather command
antigen bundle arzzen/calc.plugin.zsh #In-zsh calculator
antigen bundle voronkovich/gitignore.plugin.zsh #gitignore generator
antigen bundle hcgraf/zsh-sudo #ESCESC sudo adding
antigen bundle chrissicool/zsh-bash #Better bash compatibility
antigen bundle thewtex/tmux-mem-cpu-load

antigen theme agnoster

antigen apply

zmodload zsh/terminfo

# These map up/down arrows into history search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Pacman stuff
# pacaur, yaourt, makepkg: use powerpill instead of pacman
export PACMAN=/usr/bin/powerpill
# pacmatic: use pacaur instead of pacman# s/pacaur/yaourt/g if desired
export pacman_program=/usr/bin/pacaur
# pacaur must not be run as root, but pacdiff must be
alias pacaur='pacdiff_program="sudo pacdiff" pacmatic'

# Some useful aliases
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias weather="ansiweather"
alias reflect="sudo reflector --verbose --latest 200 --country US --sort rate --save /etc/pacman.d/mirrorlist"
alias plex="/usr/bin/bash -c \"source /etc/conf.d/plexmediaserver && export LD_LIBRARY_PATH=/opt/plexmediaserver && /opt/plexmediaserver/Plex\ Media\ Server\""
alias startvpn="sudo systemctl start openvpn-client@mullvad"
alias stopvpn="sudo systemctl stop openvpn-client@mullvad"
alias gpuon="sudo /bin/sh -c 'tee /proc/acpi/bbswitch <<< ON'"
alias gpuoff="sudo rmmod nvidia_uvm && sudo rmmod nvidia && sudo /bin/sh -c 'tee /proc/acpi/bbswitch <<< OFF'"
alias sway="XKB_DEFAULT_LAYOUT=gb sway"
alias ls="exa -bhl"
alias -g toclip="| xclip -selection c"
alias sync="sync & watch -n 1 grep -e Dirty: /proc/meminfo"

# added by travis gem
[ -f /home/bemeurer/.travis/travis.sh ] && source /home/bemeurer/.travis/travis.sh
