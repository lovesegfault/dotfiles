#!usr/bin/zsh

PATH=$PATH:/opt/intel/bin/
PATH=$PATH:/opt/Xilinx/Vivado/2017.4/bin/ # Vivado/FPGA
PATH=$HOME/bin:/usr/local/bin:$PATH # Self-compiled
PATH="$HOME/.cargo/bin:$PATH" # Rust
export PATH

SSH_KEY_PATH="$HOME/.ssh/id_rsa"
GPG_TTY=$(tty)
export SSH_KEY_PATH
export GPG_TTY

TERM=tmux-256color
export TERM

TMUX_PLUGIN_MANAGER_PATH="/Users/bemeurer/.tmux/plugins/"
export TMUX_PLUGIN_MANAGER_PATH

XDG_CONFIG_HOME="$HOME/.config"
XDG_RUNTIME_DIR="/run/user/$UID"
DBUS_SESSION_BUS_ADDRESS="unix:path=${XDG_RUNTIME_DIR}/bus"
export XDG_CONFIG_HOME
export XDG_RUNTIME_DIR
export DBUS_SESSION_BUS_ADDRESS

FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
export FZF_DEFAULT_COMMAND


HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
export HISTFILE
export HISTSIZE
export SAVEHIST

EDITOR='nvim'
export EDITOR

# zplug
ZPLUG_HOME=/usr/share/zsh/scripts/zplug
fpath+=$HOME/.zfunc
export ZPLUG_HOME
source $ZPLUG_HOME/init.zsh
zplug 'zplug/zplug', hook-build:'zplug --self-manage'
zplug "zdharma/fast-syntax-highlighting", defer:2
zplug "voronkovich/gitignore.plugin.zsh"
zplug 'sei40kr/zsh-tmux-rename'
zplug "zdharma/history-search-multi-word", defer:2
zplug "zsh-users/zsh-history-substring-search", defer:2
zplug "zsh-users/zsh-completions", defer:2
zplug "zsh-users/zsh-autosuggestions", defer:2
zplug "hlissner/zsh-autopair", defer:2
zplug "zpm-zsh/colors"
zplug "hcgraf/zsh-sudo"
zplug "plugins/colored-man-pages", from:oh-my-zsh
zplug "plugins/archlinux", from:oh-my-zsh
zplug "valentinocossar/sublime"
zplug "srijanshetty/zsh-pip-completion"
zplug "chisui/zsh-nix-shell"
zplug "spwhitt/nix-zsh-completions", defer:2
# Load theme file
#zplug 'agnoster/agnoster-zsh-theme', as:theme
zplug "chisui/0d12bd51a5fd8e6bb52e6e6a43d31d5e", from:gist, as:theme, use:agnoster-nix.zsh-theme
zplug load

# keybinds
bindkey "${terminfo[khome]}" beginning-of-line
bindkey "${terminfo[kend]}" end-of-line
bindkey "${terminfo[kdch1]}" delete-char
#bindkey "${terminfo[kcuu1]}" history-substring-search-up
#bindkey "${terminfo[kcud1]}" history-substring-search-down
bindkey "^[[A" history-substring-search-up
bindkey "^[[B" history-substring-search-down
bindkey "^[[1;5C" forward-word
bindkey "^[[1;3C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^[[1;3D" backward-word
bindkey -s "^O" 'nvim $(fzf)^M'

# Some useful aliases
alias l="exa -bhlF"
alias ls="exa -bhlF"
alias la="exa -bhlFa"
alias reflect="sudo reflector --verbose --latest 200 --sort rate --save /etc/pacman.d/mirrorlist"
alias -g toclip="| xclip -selection c"
alias ..="cd .."
alias ...="cd ..."
alias sync="sync & watch -n 1 rg -e Dirty: /proc/meminfo"
alias chkbd="/home/bemeurer/bin/chkbd.bash"
alias screenshot="maim -m 10 -u ~/pictures/screenshots/$(date +%s).png"
alias aurup="aur vercmp-devel | cut -d: -f1 | aur sync --chroot --upgrades --no-ver-shallow -"
alias clippy="cargo clippy"
alias wg="sudo wg"
alias vim=nvim
alias vi=nvim
alias ga="git add"
alias gaa="git add -A"
alias gap="git add --patch"
alias gaap="git add -A --patch"
alias gc="git commit"
alias gd="git difftool"
alias gf="git fetch --prune"
alias gl="git log"
alias gs="git status"
alias gm="git merge"
alias gp="git push"
alias gpl="git pull"
alias gr="git rebase"
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
