#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then







    xrdb -merge $sysresources

fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then







    xrdb -merge "$userresources"

fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

export GTK_THEME=Adwaita:dark
xbindkeys & 
xrandr --output DP-0 --rate 240 --mode 2560x1440 & 
xmodmap -e "keysym Alt_L = Multi_key" & 
xset r rate 250 30 & 
xautolock -time 15 -locker slock -detectsleep &
nvidia-settings --load-config-only & 
nvidia-settings -a "GPUGraphicsClockOffset[2]=150" & 
nvidia-settings -a "GPUGraphicsClockOffset[3]=150" & 
nvidia-settings -a "GPUGraphicsClockOffset[4]=150" & 
nvidia-settings -a "GPUMemoryTransferRateOffset[2]=700" & 
nvidia-settings -a "GPUMemoryTransferRateOffset[3]=700" & 
nvidia-settings -a "GPUMemoryTransferRateOffset[4]=700" & 
exec awesome
