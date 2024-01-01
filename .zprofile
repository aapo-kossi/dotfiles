export QT_QPA_PLATFORMTHEME=qt5ct

if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
else
    startx
fi
