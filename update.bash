#!/usr/bin/env bash

set -o nounset
set -o pipefail

cp -f ~/.config/alacritty/alacritty.yml ./alacritty.yml
cp -f /etc/fstab ./
cp -f /etc/default/grub ./grub

cp -f ~/.config/i3/config ./i3.config
cp -f ~/.config/i3status-rs.toml ./i3status-rs.toml

cp -f ~/.config/nvim/init.vim ./init.vim
cp -f ~/.tmux.conf ./tmux.conf
cp -f /etc/vconsole.conf ./vconsole.conf
cp -f ~/.xinitrc ./xinitrc
cp -f ~/.Xresources ./Xresources
cp -f ~/.zshrc ./zshrc
cp -r ~/bin ./

cp -f /etc/genkernel.conf ./genkernel.conf
cp -f /etc/portage/make.conf ./make.conf
cp -f /usr/src/linux/.config ./kernel.config
cp -r ~/pictures/walls ./

