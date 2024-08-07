if status is-interactive
    # Commands to run in interactive sessions can go here

    # set the last time we started an interactive fish
    set -U last_interactive_fish (date +%s)

    # Paths to stuff
    fish_add_path /home/ken/.local/bin
    fish_add_path /home/ken/.cargo/bin
    fish_add_path /home/ken/bin

    # Colorize man pages
    export MANPAGER="less -R --use-color -Dd+r -Du+b"
    export MANROFFOPT="-P -c"
    
    # abbreviations
    abbr -a gco git checkout
    abbr -a gs git status
    abbr -a dotdot --regex '^.\.+$' --function multicd
    abbr -a gls git log --oneline --no-decorate -10
    abbr -a tmuxm tmux -2 new -s m
    abbr -a lsgt eza -l --icons --git -R -T --git-ignore
    abbr -a lsg eza -l --icons --git -R --git-ignore

    # Use nvim for editor
    set -gx VISUAL /usr/bin/nvim
    set -gx EDITOR /usr/bin/nvim

    # zoxide (sudo pacman -S zoxide # https://github.com/ajeetdsouza/zoxide)
    zoxide init fish | source

    # atuin - shell history replacement
    atuin init fish --disable-up-arrow | source

    # I want a cookie!
    occasional_fortune
end

