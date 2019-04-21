#!usr/bin/zsh

if [ -z $IN_NIX_SHELL ];then
    PATH=$PATH:/sbin:/usr/sbin
    PATH=$HOME/bin:$PATH # Self-compiled
    PATH=$PATH:$HOME/.cargo/bin # Rust
    PATH=$PATH:$HOME/.local/bin  # Pip
    export PATH
fi

if [ -z $LIBCLANG_PATH ]; then
    LIBCLANG_PATH="/usr/lib/llvm/7/lib64"
    export LIBCLANG_PATH
fi

SSH_KEY_PATH="$HOME/.ssh/id_rsa"
GPG_TTY=$(tty)
export SSH_KEY_PATH
export GPG_TTY

XDG_CONFIG_HOME="$HOME/.config"
export XDG_CONFIG_HOME

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
export HISTFILE
export HISTSIZE
export SAVEHIST

EDITOR='nvim'
PAGER='vimpager'
export EDITOR
export PAGER


CCACHE_DIR="/gentoo/ccache"
export CCACHE_DIR

SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_PROMPT_SEPARATE_LINE=false

# zplug
ZPLUG_HOME=$HOME/.zplug
export ZPLUG_HOME
source $ZPLUG_HOME/init.zsh
zplug 'zplug/zplug', hook-build:'zplug --self-manage'
zplug "zdharma/fast-syntax-highlighting", defer:2
zplug "voronkovich/gitignore.plugin.zsh"
zplug "skywind3000/z.lua"
zplug 'sei40kr/zsh-tmux-rename'
zplug "zdharma/history-search-multi-word", defer:2
zplug "zsh-users/zsh-history-substring-search", defer:2
zplug "zsh-users/zsh-completions", defer:2
zplug "zsh-users/zsh-autosuggestions", defer:2
zplug "hlissner/zsh-autopair", defer:2
zplug "zpm-zsh/colors"
zplug "hcgraf/zsh-sudo"
zplug "plugins/colored-man-pages", from:oh-my-zsh
zplug "plugins/cargo", from:oh-my-zsh
zplug "plugins/rust", from:oh-my-zsh
zplug "chisui/zsh-nix-shell"
zplug "spwhitt/nix-zsh-completions", defer:2
# Load theme file
# zplug 'agnoster/agnoster-zsh-theme', as:theme
#zplug "chisui/0d12bd51a5fd8e6bb52e6e6a43d31d5e", from:gist, as:theme, use:agnoster-nix.zsh-theme
zplug "denysdovhan/spaceship-prompt", use:spaceship.zsh, as:theme
zplug load

# keybinds
bindkey "${terminfo[khome]}" beginning-of-line
bindkey "${terminfo[kend]}" end-of-line
bindkey "${terminfo[kdch1]}" delete-char
bindkey "^[[A" history-substring-search-up
bindkey "^[[B" history-substring-search-down
bindkey "^[[1;5C" forward-word
bindkey "^[[1;3C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^[[1;3D" backward-word
bindkey -s "^O" 'nvim $(sk -m)^M'

# Some useful aliases
## Use bat instead of cat
alias cat="bat"
alias b="bat"
## Use exa instead of ls proper
alias l="exa -bhlF"
alias ls="exa -bhlF"
alias la="exa -bhlFa"
## Neat trick to monitor sync
alias sync="sync & watch -n 1 rg -e Dirty: /proc/meminfo"
## Wireguard
alias wg="sudo wg"
## Some utility aliases
alias pip="pip3"
alias vim="nvim"
alias vi="nvim"
alias pass="gopass"
## Git
alias ga="git add"
alias gaa="git add -A"
alias gap="git add --patch"
alias gaap="git add -A --patch"
alias gc="git commit"
alias gd="git difftool"
alias gf="git fetch --prune"
alias gl="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all"
alias gs="git status --find-renames --show-stash"
alias gm="git merge"
alias gp="git push"
alias gpl="git pull --rebase"
alias gr="git rebase"
## Cargo
alias cb="cargo build"
alias cc="cargo check"
alias cdoc="cargo doc"
alias cr="cargo run"
alias ct="cargo test"
alias cbr="cargo build --release"
alias ccr="cargo check --release"
alias cdocr="cargo doc --release"
alias crr="cargo run --release"
alias ctr="cargo test --release"
## Portage
alias cls="sudo emerge -av --depclean"
alias upd="sudo emerge --sync"
alias upg="sudo emerge -uDU --keep-going --with-bdeps=y @world"
## z.lua
alias zc='z -c'      # restrict matches to subdirs of $PWD
alias zz='z -i'      # cd with interactive selection
alias zf='z -I'      # use fzf to select in multiple matches
alias zb='z -b'      # quickly cd to the parent directory

# added by travis gem
[ -f /home/bemeurer/.travis/travis.sh ] && source /home/bemeurer/.travis/travis.sh
