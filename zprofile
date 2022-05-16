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


# not tested ....
swab()
{
  git branch --merged master --no-color | grep -v '^[ *]*master$' | xargs -n1 git branch -d
}
############ fzf/ag/whateverthefuck ############
#export FZF_DEFAULT_COMMAND="ag -g \"\" --path-to-ignore ~/.ignore"

############ COOLORS ############

# \[\e[0m\] resets the color to default color
c_reset='\[\e[0m\]'
# \e[0;31m\ sets the color to red
c_git_dirty='\[\e[0;31m\]'
c_red='\[\e[0;31m\]'
# \033[0;36m\ sets the color to cyan
c_cyan="\[\033[0;36m\]"
# \e[0;32m\ sets the color to green
c_git_clean='\[\e[0;32m\]'
c_green='\[\e[0;32m\]'

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

# Git log of changes since last tag
alias glt="git log $(git describe --tags --abbrev=0)..HEAD --oneline"
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
alias vim="mvim -u ~/.nvimrc"
alias work="cd ~/Workspace"

# Wam Stuff

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

# Testing Stuff
alias rspcf="rspec --format documentation"
alias rspecf="rspec --format documentation"

# STOLEN LIKE A THIEF
# Adds the current branch to the bash prompt when the working directory is
# part of a Git repository. Includes color-coding and indicators to quickly
# indicate the status of working directory.
#
# To use: Copy into ~/.bashrc and tweak if desired.
#
# Based upon the following gists:
# <https://gist.github.com/henrik/31631>
# <https://gist.github.com/srguiwiz/de87bf6355717f0eede5>
# Modified by me, using ideas from comments on those gists.
#
# License: MIT, unless the authors of those two gists object :)

git_branch() {
    # -- Finds and outputs the current branch name by parsing the list of
    #    all branches
    # -- Current branch is identified by an asterisk at the beginning
    # -- If not in a Git repository, error message goes to /dev/null and
    #    no output is produced
    git branch --no-color 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/' | cut -c1-7
}

git_status() {
    # Outputs a series of indicators based on the status of the
    # working directory:
    # + changes are staged and ready to commit
    # ! unstaged changes are present
    # ? untracked files are present
    # S changes have been stashed
    # P local commits need to be pushed to the remote
    local status="$(git status --porcelain 2>/dev/null)"
    local output=''
    [[ -n $(egrep '^[MADRC]' <<<"$status") ]] && output="$output+"
    [[ -n $(egrep '^.[MD]' <<<"$status") ]] && output="$output!"
    [[ -n $(egrep '^\?\?' <<<"$status") ]] && output="$output?"
    [[ -n $(git stash list) ]] && output="${output}S"
    [[ -n $(git log --branches --not --remotes) ]] && output="${output}P"
    [[ -n $output ]] && output="|$output"  # separate from branch name
    echo $output
}

git_color() {
    # Receives output of git_status as argument; produces appropriate color
    # code based on status of working directory:
    # - White if everything is clean
    # - Green if all changes are staged
    # - Red if there are uncommitted changes with nothing staged
    # - Yellow if there are both staged and unstaged changes
    # - Blue if there are unpushed commits
    local staged=$([[ $1 =~ \+ ]] && echo yes)
    local dirty=$([[ $1 =~ [!\?] ]] && echo yes)
    local needs_push=$([[ $1 =~ P ]] && echo yes)
    if [[ -n $staged ]] && [[ -n $dirty ]]; then
        echo -e '\033[1;33m'  # bold yellow
    elif [[ -n $staged ]]; then
        echo -e '\033[1;32m'  # bold green
    elif [[ -n $dirty ]]; then
        echo -e '\033[1;31m'  # bold red
    elif [[ -n $needs_push ]]; then
        echo -e '\033[1;34m' # bold blue
    else
        echo -e '\033[1;37m'  # bold white
    fi
}

git_prompt() {
    # First, get the branch name...
    local branch=$(git_branch)
    # Empty output? Then we're not in a Git repository, so bypass the rest
    # of the function, producing no output
    if [[ -n $branch ]]; then
        local state=$(git_status)
        local color=$(git_color $state)
        # Now output the actual code to insert the branch and status
        echo -e "\x01$color\x02[$branch$state]\x01\033[00m\x02"  # last bit resets color
    fi
}

PS1='\u|$(git_prompt)|\W:~> '

# auto set by vscode
# Setting PATH for Python 3.7
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.7/bin:${PATH}"
export PATH

export PATH="$HOME/.cargo/bin:$PATH"
