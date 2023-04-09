cat <<EOM > ".bash_aliases"

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# some personal aliases
alias growth='cd ~/Documents/work/GrowthEngine'
alias projects='cd ~/Documents/projects/'
alias config='pushd ~/.config/nvim/'
alias notes='pushd ~/Documents/notes/notes'
alias todo='nvim ~/Documents/notes/notes/todo.md'
EOM
