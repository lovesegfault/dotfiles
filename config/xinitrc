eval "$(systemctl --user show-environment)"
dbus-update-activation-environment --all
eval "$(/usr/bin/gnome-keyring-daemon --daemonize --start --components=pkcs11,secrets,ssh,gpg)"
export SSH_AUTH_SOCK
export GPG_AGENT_INFO
export GNOME_KEYRING_CONTROL
export GNOME_KEYRING_PID
export XDG_CURRENT_DESKTOP=GNOME
export DESKTOP_SESSION=gnome

xrdb -merge ~/.Xresources
exec i3
