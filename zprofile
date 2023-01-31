[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

# jEnv in front, rvm wants to be in bashrc for some reason
PATH="$HOME/.jenv/bin:$PATH"
PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
PATH="$PATH:/Applications/Xcode.app/Contents/Developer/usr/bin/"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

export VISUAL='/usr/local/bin/nvim'
export EDITOR='$VISUAL'
export GIT_EDITOR='$VISUAL'

############ JAVA  ############

export LIQUIBASE_HOME='/usr/local/opt/liquibase/libexec'

####### nothing works first try ... trying to get ctrl r working in zsh
bindkey -v
bindkey '^R' history-incremental-search-backward

# Ignore Duplicates in History
export HISTCONTROL=ignoredups

# Git Alias
alias wch="watch "
alias gs="git status"
alias ga="git add ."
alias gc="git commit -m"
alias gb="git branch"
alias gd="git diff"
alias gdc="git diff --cached"
alias gdm="git diff master --name-only"
alias gch="git checkout"
alias st="pwd | grep --color='auto' -E -o '\/.-test-suite'; git branch && git status"
alias gf="git fetch --all"
alias gpm="git pull origin master"
alias gstash="git stash"
alias gsl="git stash list"
alias gt="git tag --sort=-creatordate"
# Interactive git checkout, local or remote - requires vim and fzf
alias igch="git branch -a | FZF | xargs | sed -e's#^remotes/origin/##; s###' | xargs git checkout"

# removes local branches that have been merged
alias gbranchclean="git branch --merged | grep -v \"\\*\" | grep -v master | xargs -n 1 git branch -d"

# Pretty Git Log, pass the number of records to view
alias gl="pretty_git_log $1"
pretty_git_log() {
  lines_to_show=${1:-10}
  git log -${lines_to_show} --pretty=format:'%h - %an, %ar : %s'
}

# General Use Alias
alias reload="source ~/.zprofile"
alias mv="mv -i"
alias cp="cp -i"
alias ..="cd .."
alias pud="pushd"
alias ppd="popd"
alias ll="ls -alh"
alias grel="grep"
alias zp="nvim ~/.zprofile"
alias vrc="nvim ~/.vimrc"
alias nrc="nvim ~/.nvimrc"
alias notes="cd ~/Workspace/notes && nvim ."
alias work="cd ~/Workspace"

# FzF config
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'

# Wam Alias
alias be="bundle exec"
alias rr="bundle exec rake routes"
alias rail="rails"

# Docker Env Stuff
alias dc="docker-compose"
alias stand="docker-compose up -d && docker-compose logs -f"
alias sit="docker-compose down"
alias dps="docker ps --format \"table {{.Names}}\\t{{.Image}}\\t{{.RunningFor}} ago\\t{{.Status}}\\t{{.Ports}}\""
alias dpsp="docker ps --format \"table {{.Names}}\\t{{.Ports}}\""

# Will run docker container with plantuml server on localhost 8080
alias plantuml="docker run -d -p 8080:8080 plantuml/plantuml-server:jetty"

# Listening on a PORT
listening() {
    if [ $# -eq 0 ]; then
        lsof -iTCP -sTCP:LISTEN -n -P
    elif [ $# -eq 1 ]; then
        lsof -iTCP -sTCP:LISTEN -n -P | grep -i --color $1
    else
        echo "Usage: listening [pattern]"
    fi
}

# auto set by vscode
# Setting PATH for Python 3.7
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.7/bin:${PATH}"
export PATH

export PATH="$HOME/.cargo/bin:$PATH"
