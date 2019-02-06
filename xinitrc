if [ -x /usr/bin/gpg-agent ]; then
 eval "$(/usr/bin/gpg-agent --daemon)"
fi

export SSH_AUTH_SOCK

eval "$(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh,gpg)"
/usr/libexec/polkit-gnome-authentication-agent-1 &
echo 'power on' | /usr/bin/bluetoothctl
dbus-update-activation-environment --systemd DISPLAY
export DESKTOP_SESSION=gnome
numlockx &

xrdb -merge ~/.Xresources
exec i3
