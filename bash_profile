echo “Charlie You’re bad at typing”



export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin
eval "$(rbenv init -)"

# Console Prompt
export PS1="\u|\W:~> "

# Alias'
alias be="bundle exec"

alias gs="git status"
alias ga="git add ."
alias gc="git commit -m"

alias gb="git branch"

alias gch="git checkout"
alias st="pwd && git branch && git status"
alias gdm="git diff master --name-only"

if [ -f ~/.git-completion.bash ]; then
	. ~/.git-completion.bash

__git_complete gb _git_branch
__git_complete gch _git_checkout
fi

alias pu="pushd"
alias pp="popd"

alias ll="ls -al"

# Alias to point to Homebrew Version of Vim
alias vim='/usr/local/Cellar/vim/7.4.2109/bin/vim'
