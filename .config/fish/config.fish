fish_vi_key_bindings

if status is-login

    export QT_QPA_PLATFORMTHEME=qt5ct

    if test -n "$SSH_CLIENT"; or test -n "$SSH_TTY"
    else
        if uwsm check may-start
            exec uwsm start hyprland.desktop
        end
        # start-hyprland
    end

end

if status is-interactive
    if command -sq tmux; and test -n "$DISPLAY"; and test -z "$TMUX"
        tmux new-session >/dev/null 2>&1
    end

    alias l='ls -lah --color=auto'
    alias la='ls -lAh --color=auto'
    alias ll='ls -lh --color=auto'
    alias vi='nvim'
    alias vim='nvim'
    alias f='fastfetch'
    alias p='pass -c'
    alias dotconfig='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'

    # Commands to run in interactive sessions can go here
end


# Created by `pipx` on 2025-05-07 14:41:12
set PATH $PATH /home/akossi/.local/bin
