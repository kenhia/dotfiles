function arg_or_pwd --argument-names 'dirname'
    set -l full_dirname $PWD
    if test -n "$dirname"
        set full_dirname $(realpath $dirname)
    end
    echo "doing $full_dirname"
end

