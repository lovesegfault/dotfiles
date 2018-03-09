#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# __file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
# __base="$(basename ${__file} .sh)"
# __root="$(cd "$(dirname "${__dir}")" && pwd)"

sudo pacman -Syyu --needed --noconfirm ccache
# Set up tools
sudo pacman -S --needed --noconfirm base-devel exa htop sudo git nvim python clang llvm

mkdir -p "${HOME}/.config/alacritty"
mkdir -p "${HOME}/.config/i3"
mkdir -p "${HOME}/.config/i3status"

sudo gpasswd -a "${USER}" sys
sudo gpasswd -a "${USER}" disk
sudo gpasswd -a "${USER}" wheel
sudo gpasswd -a "${USER}" uucp
sudo gpasswd -a "${USER}" lock
sudo gpasswd -a "${USER}" storage

# Setup makepkg
sudo cp "${__dir}/makepkg.conf" "${HOME}/.config/pacman/makepkg.conf"

# Set up fonts
workdir=$(mktemp -d)
git clone --depth=1 https://aur.archlinux.org/nerd-fonts-complete.git "${workdir}"
cd "${workdir}"
makepkg -csi --noconfirm
cd "${__dir}"
rm -rf "${workdir}"
unset workdir
workdir=$(mktemp -d)
git clone --depth=1 https://aur.archlinux.org/powerline-console-fonts.git "${workdir}"
cd "${workdir}"
makepkg -csi --noconfirm
cd "${__dir}"
rm -rf "${workdir}"
unset workdir
sudo cp "${__dir}/vconsole.conf" "/etc/vconsole.conf"

# Set up vim using amix/vimrc
sudo pacman -S --needed --noconfirm git vim
git clone --depth=1 https://github.com/amix/vimrc.git "${HOME}"/.vim_runtime
sh "${HOME}"/.vim_runtime/install_awesome_vimrc.sh

# Set up Rust
sudo pacman -S --needed --noconfirm rustup
rustup toolchain install stable
rustup default stable
export PATH="${PATH}:${HOME}/.cargo/bin" # Rust

# Set up alacritty
workdir=$(mktemp -d)
git clone --depth=1 https://aur.archlinux.org/alacritty-git.git "${workdir}"
cd "${workdir}"
makepkg -csi --noconfirm
cd "${__dir}"
rm -rf "${workdir}"
unset workdir
mkdir -p "${HOME}/.config/alacritty/"
cp "${__dir}/alacritty.yml" "${HOME}/.config/alacritty/alacritty.yml"

# Set up i3
sudo pacman -S --needed --noconfirm i3-wm i3blocks i3lock i3status
mkdir -p "${HOME}/.config/i3/"
cp "${__dir}/i3.config" "${HOME}/.config/i3/config"

# Set up i3 status
mkdir -p "${HOME}/.config/i3status/"
cp "${__dir}/i3status.config" "${HOME}/.config/i3status/config"

# Set up tmux
sudo pacman -S --needed --noconfirm tmux
cp "${__dir}/tmux.conf" "${HOME}/.tmux.conf"

# Set up zsh
sudo pacman -S --needed --noconfirm zsh ruby
cp "${__dir}/zshrc" "${HOME}/.zshrc"
workdir=$(mktemp -d)
git clone --depth=1 https://aur.archlinux.org/antigen-git.git "${workdir}"
cd "${workdir}"
makepkg -csi --noconfirm
cd "${__dir}"
rm -rf "${workdir}"
unset workdir

# Set up folders
mkdir -p "${HOME}/src"
mkdir -p "${HOME}/bin"
mkdir -p "${HOME}/mnt"

# Set up binaries
cp -r "${__dir}/bin" "${HOME}/"

