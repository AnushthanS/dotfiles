source <(fzf --zsh)
alias inv='nvim $(fzf -m --preview="bat --color=always {}")'
alias pv='fzf --preview="bat --color=always {}"'
alias cl='clear'
alias kt='tmux kill-server'
alias t='tmux'
eval "$(starship init zsh)"
