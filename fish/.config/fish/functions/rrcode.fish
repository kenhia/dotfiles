function rrcode --description 'call krrr via curl'
    set -l host (string split -f 1 ' ' $SSH_CLIENT)
    echo "Calling krrr on $host with USER=$USER and PWD=$PWD"
    curl --request GET "http://$host:42271/rcode?client=karch9&user=$USER&path=$PWD"
end
