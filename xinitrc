dbus-update-activation-environment --systemd DISPLAY
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
export SSH_AUTH_SOCK
export DESKTOP_SESSION=gnome

exec i3
