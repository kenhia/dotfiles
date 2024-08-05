function rrcode --description 'call krrr via curl' --argument-names 'dirname'
    set -l local_dir $PWD
    if test -n "$dirname"
        set local_dir $(realpath $dirname)
    end
    set -l host (string split -f 1 ' ' $SSH_CLIENT)
    echo "Calling krrr on $host with user=$USER and path=$local_dir"
    curl --request GET "http://$host:42271/rcode?client=karch9&user=$USER&path=$local_dir"
end
