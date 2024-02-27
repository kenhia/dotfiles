function kpanes --description 'Ken\'s three pane setup'
    if test "$TMUX" = ""
        set_color red
        echo "Not in a tmux session"
        set_color normal
        return 1
    end

    set pane_count (tmux display-message -p '#{window_panes}')
    if test $pane_count -eq 1;
        echo "setting Ken's three pane"
        tmux split-window -v ';' split-window -v
        tmux resize-pane -t 0 -y 15 ';' resize-pane -t 2 -y 22
        tmux select-pane -t 1
    else
        if test $pane_count -eq 3;
            echo "we have three panes, let's make sure they are sized correctly."
            tmux resize-pane -t 0 -y 15 ';' resize-pane -t 2 -y 22
        else
            echo "already split...not going to split more"
        end

    end
end
