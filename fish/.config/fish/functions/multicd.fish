function multicd --description 'helper for multi-dot cd up'
    echo cd (string repeat -n (math (string length -- $argv[1]) -1) ../)
end
