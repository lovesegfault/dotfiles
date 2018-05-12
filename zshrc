#!usr/bin/zsh

gempath=$(ruby -rrubygems -e "puts Gem.user_dir")/bin

export GOPATH=$HOME/.go

export PATH=$HOME/bin:/usr/local/bin:$PATH # Self-compiled
export PATH=$PATH:$gempath # Ruby Gems
export PATH=$PATH:$HOME/.node_modules/bin
#export PATH=$PATH:/opt/cuda/bin # Cuda 
export PATH=$PATH:/opt/Xilinx/Vivado/2017.4/bin/ # Vivado/FPGA
export PATH=$PATH:$HOME/.cargo/bin # Rust
export PATH=$PATH:$GOPATH/bin

export ANDROID_HOME=/opt/android-sdk # Android -- I hate my life

export TERM="tmux-256color" # MOAR COLOURS

export SSH_KEY_PATH="$HOME/.ssh/id_rsa"
export GPG_TTY=$(tty)

export TASKDDATA=/var/lib/taskd

export LOCATION_QUERY=1

export XDG_CONFIG_HOME="$HOME/.config"

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
antigen bundle git #Completions for git
antigen bundle gitfast #Faster completions
antigen bundle git-extras #A collection of git aliases
antigen bundle github #Completions for github's gem
antigen bundle pip #pip completions
antigen bundle python #Python interpreter completions
antigen bundle web-search #In-term websearch

antigen bundle zsh-users/zsh-syntax-highlighting #Fish-like highlighting
antigen bundle zsh-users/zsh-history-substring-search #Fish-like history search
antigen bundle zsh-users/zsh-completions #Extra completions
antigen bundle zsh-users/zsh-autosuggestions #Fish-like autosiggestions

antigen bundle voronkovich/gitignore.plugin.zsh #gitignore generator
antigen bundle hcgraf/zsh-sudo #ESCESC sudo adding
antigen bundle chrissicool/zsh-bash #Better bash compatibility

antigen theme agnoster

antigen apply

zmodload zsh/terminfo

# These map up/down arrows into history search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Some useful aliases
alias ls="exa -bhlF"
alias la="exa -bhlFa"
alias reflect="sudo reflector --verbose --latest 200 --sort rate --save /etc/pacman.d/mirrorlist"
alias -g toclip="| xclip -selection c"
alias sync="sync & watch -n 1 rg -e Dirty: /proc/meminfo"
alias chkbd="/home/bemeurer/bin/chkbd.bash"
alias clippy="cargo +nightly clippy"
alias modules="cargo +nightly modules"
alias screenshot="maim -m 10 -u ~/pictures/screenshots/$(date +%s).png"
alias aur='repose -vf aur -r /var/cache/pacman/aur'
alias wg="sudo wg"
alias pacman="powerpill"
alias vim=nvim
alias vi=nvim
