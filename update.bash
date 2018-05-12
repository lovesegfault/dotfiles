#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

cp ~/.config/alacritty/alacritty.yml ./alacritty.yml
cp /etc/fstab ./
cp /etc/default/grub ./grub

cp ~/.config/i3status/config ./i3status.config
cp ~/.config/i3/config ./i3.config
cp ~/.config/i3/i3status-rs.toml ./i3status-rs.toml

cp ~/.config/nvim/init.vim ./init.vim
cp ~/.config/pacman/makepkg.conf ./makepkg.conf
cp ~/.tmux.conf ./tmux.conf
cp /etc/vconsole.conf ./vconsole.conf
cp ~/.xinitrc ./xinitrc
cp ~/.zprofile ./zprofile
cp ~/.zshrc ./zshrc
