#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__base="$(basename ${__file} .sh)"
__root="$(cd "$(dirname "${__dir}")" && pwd)"


# Set up vim using amix/vimrc
sudo pacman -S --needed --noconfirm git vim
git clone --depth=1 https://github.com/amix/vimrc.git "${HOME}"/.vim_runtime
sh "${HOME}"/.vim_runtime/install_awesome_vimrc.sh

# Setup makepkg
sudo cp "${__dir}/makepkg.conf" /etc/makepkg.conf

# Set up Rust
sudo pacman -S --needed --noconfirm rustup
rustup default stable
export PATH="${PATH}:${HOME}/.cargo/bin" # Rust

# Set up alacritty
workdir=$(mktemp -d)
git clone --depth=1 https://aur.archlinux.org/alacritty-git.git "${workdir}"
cd "${workdir}"
makepkg -csi
cd "${__dir}"
rm -r "${workdir}"
unset workdir
mkdir -p "${HOME}/.config/alacritty/"
cp "${__dir}/alacritty.yml" "${HOME}/.config/alacritty/alacritty.yml"

# Set up i3
sudo pacman -S --needed --noconfirm i3-wm i3blocks i3lock i3status
workdir=$(mktemp -d)
git clone --depth=1 https://aur.archlinux.org/i3pystatus.git "${workdir}"
cd "${workdir}"
makepkg -csi
cd "${__dir}"
rm -r "${workdir}"
unset workdir
mkdir -p "${HOME}/.config/i3/"
cp "${__dir}/i3-config" "${HOME}/.config/i3/config"
cp "${__dir}/i3pystatus.conf.py" "${HOME}/.config/i3pystatus.conf.py"

# Set up tmux
sudo pacman -S --needed --noconfirm tmux
cp "${__dir}/tmux.conf" "${HOME}/.tmux.conf"

# Set up zsh
sudo pacman -S --needed --noconfirm zsh ruby
cp "{__dir}/zshrc" "${HOME}/.zshrc"

# Set up tools
sudo pacman -S --needed --noconfirm base-devel python clang llvm
