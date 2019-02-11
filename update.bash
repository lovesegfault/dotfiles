#!/usr/bin/env bash

set -o nounset
set -o pipefail

rsync -Pav ~/.config/alacritty/alacritty.yml ./alacritty.yml
rsync -Pav /etc/fstab ./fstab
rsync -Pav /etc/default/grub ./grub

rsync -Pav ~/.config/i3/config ./i3.config
rsync -Pav ~/.config/i3status-rs.toml ./i3status-rs.toml

rsync -Pav ~/.config/nvim/init.vim ./init.vim
rsync -Pav ~/.tmux.conf ./tmux.conf
rsync -Pav /etc/vconsole.conf ./vconsole.conf
rsync -Pav ~/.xinitrc ./xinitrc
rsync -Pav ~/.Xresources ./Xresources
rsync -Pav ~/.zshrc ./zshrc
rsync -Pav --no-links ~/bin ./

rsync -Pav /etc/dracut.conf ./dracut.conf
rsync -Pav /etc/genkernel.conf ./genkernel.conf
rsync -Pav /etc/portage/make.conf ./make.conf
rsync -Pav /usr/src/linux/.config ./kernel.config
rsync -Pav ~/pictures/walls ./

