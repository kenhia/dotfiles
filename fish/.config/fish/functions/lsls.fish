function lsls --wraps=/usr/bin/ls --description 'use actual ls instead of exa'
  command ls $argv
end
