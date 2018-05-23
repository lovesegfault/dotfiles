#!/usr/bin/env bash

set -o nounset
set -o pipefail

cp -f ~/.config/alacritty/alacritty.yml ./alacritty.yml
cp -f /etc/fstab ./
cp -f /etc/default/grub ./grub

cp -f ~/.config/i3status/config ./i3status.config
cp -f ~/.config/i3/config ./i3.config
cp -f ~/.config/i3/i3status-rs.toml ./i3status-rs.toml

cp -f ~/.config/nvim/init.vim ./init.vim
cp -f ~/.config/pacman/makepkg.conf ./makepkg.conf
cp -f ~/.tmux.conf ./tmux.conf
cp -f /etc/vconsole.conf ./vconsole.conf
cp -f ~/.xinitrc ./xinitrc
cp -f ~/.zprofile ./zprofile
cp -f ~/.zshrc ./zshrc
