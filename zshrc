#!usr/bin/zsh

# Standard
source /home/bemeurer/src/Standard/General/.profile

export PATH=$PATH:$HOME/.node_modules/bin

export PATH=$PATH:/opt/Xilinx/Vivado/2017.4/bin/ # Vivado/FPGA

export PATH=$HOME/bin:/usr/local/bin:$PATH # Self-compiled

export PATH=$PATH:$HOME/.cargo/bin # Rust

gempath=$(ruby -rrubygems -e "puts Gem.user_dir")/bin
export PATH=$PATH:$gempath # Ruby Gems

export GOPATH=$HOME/.go
export PATH=$PATH:$GOPATH/bin

export SSH_KEY_PATH="$HOME/.ssh/id_rsa"
export GPG_TTY=$(tty)

export TERM=tmux-256color

export LOCATION_QUERY=1

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_RUNTIME_DIR="/run/user/$UID"
export DBUS_SESSION_BUS_ADDRESS="unix:path=${XDG_RUNTIME_DIR}/bus"

export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000

# Uses nano for SSH sessions to avoid bugs with Vim colors.
if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='nano'
 else
   export EDITOR='nvim'
fi

export UNCRUSTIFY_CONFIG="$HOME"/.uncrustify.cfg

# zplug
source /usr/share/zsh/scripts/zplug/init.zsh
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
# Load theme file
zplug 'agnoster/agnoster-zsh-theme', as:theme
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
bindkey "^[[1;5D" backward-word

# Some useful aliases
alias l="exa -bhlF"
alias ls="exa -bhlF"
alias la="exa -bhlFa"
alias reflect="sudo reflector --verbose --latest 200 --sort rate --save /etc/pacman.d/mirrorlist"
alias -g toclip="| xclip -selection c"
alias sync="sync & watch -n 1 rg -e Dirty: /proc/meminfo"
alias chkbd="/home/bemeurer/bin/chkbd.bash"
alias clippy="cargo +nightly clippy"
alias modules="cargo +nightly modules"
alias screenshot="maim -m 10 -u ~/pictures/screenshots/$(date +%s).png"
alias aurup="aur vercmp-devel | cut -d: -f1 | aur sync --no-ver-shallow -"
alias wg="sudo wg"
alias vim=nvim
alias vi=nvim
