[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

# jEnv in front, rvm wants to be in bashrc for some reason
PATH="$HOME/.jenv/bin:$PATH"
PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

source ~/.git-completion.bash
export VISUAL='/usr/local/bin/nvim'
export EDITOR='$VISUAL'
export GIT_EDITOR='$VISUAL'

############ AUTO COMPLETE ############

# Load git completions
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

if [ -f ~/.config/exercism/exercism_completion.bash ]; then
  . ~/.config/exercism/exercism_completion.bash
fi

############ HELPERS ############
gatling_helpers () {
  echo "JAVA_OPTS=\"-Denv=local1\" sh bin/gatling.sh -rf results/local/17-8-0/"
}

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

# Set AutoComplete for Git Alias'
__git_complete gch _git_checkout
__git_complete gb _git_branch

# General Use Alias
alias reload="source ~/.bash_profile"
alias mv="mv -i"
alias cp="cp -i"
alias ..="cd .."
alias pud="pushd"
alias ppd="popd"
alias ll="ls -al"
alias grel="grep"
alias bp="nvim ~/.bash_profile"
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
alias wam="cd ~/Workspace/wam"
alias wdock="cd ~/Workspace/wam/wam-docker/"
alias wd="cd ~/Workspace/wam/wam-docker/"
alias mon="cd ~/Workspace/wam/monterey"
alias pd="cd ~/Workspace/wam/program-dashboard"
alias volt="cd ~/Workspace/wam/wam/packages/voltron"
alias sushi="cd ~/Workspace/wam/sushi_boat"
alias 3ds="cd ~/Workspace/wam/3ds-challenge-lambdas"

alias wp=ping_wam
ping_wam() {
  echo -e "\n___ PAPI ___"
  curl --silent http://localhost:8080/v3/ping | grep -E -o ".version\"\:\".+?\""
  echo -e "___ DNA API ___"
  curl --silent http://localhost:8081/dna-api/ping | grep -E -o ".build_version\"\:\".+?\""
  echo -e "___ Zion API ___"
  curl --silent http://localhost:9081/zion-api/ping | grep -E -o ".success\"\:.+$"
  echo -e "\n"
}

# Docker Env Stuff
alias wdock="cd ~/Workspace/wam/wam-docker/"
alias wd="cd ~/Workspace/wam/wam-docker/"

alias qdock="cd ~/Workspace/qe-docker"
alias qd="cd ~/Workspace/qe-docker"

alias dc="docker-compose"
alias stand="docker-compose up -d && docker-compose logs -f"
alias sit="docker-compose down"
alias dps="docker ps --format \"table {{.Names}}\\t{{.Image}}\\t{{.RunningFor}} ago\\t{{.Status}}\\t{{.Ports}}\""

alias dpsp="docker ps --format \"table {{.Names}}\\t{{.Ports}}\""

# Testing Stuff
alias vgrnt="cd ~/Workspace/jpos-vagrant"
alias localdocker="cd ~/Workspace/localdocker"
alias tests="cd ~/Workspace/test_suites"
alias rspcf="rspec --format documentation"
alias rspecf="rspec --format documentation"
alias testa="cd ~/Workspace/test_suites/a-test-suite/app"
alias testb="cd ~/Workspace/test_suites/b-test-suite/app"
alias testc="cd ~/Workspace/test_suites/c-test-suite/app"
alias rt1="rake test env=local1"
alias rt2="rake test env=local2"
alias rt3="rake test env=local3"
alias gatling="cd ~/Workspace/gatling-perf"
alias localaws="cd ~/Workspace/awsvagrant"

# Tag all files different than master as test:true
alias tdat="tag_diff_as_test"
tag_diff_as_test() {
  original_path=pwd
  cd `git rev-parse --show-toplevel`
  git diff master --name-only | xargs mvim -c "bufdo exec \"norm 1 tes\""
  # Not able to cd back b/c we lose focus on bash. need another tool to return focus
  cd original_path
}

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

# Setting PATH for Python 3.7
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.7/bin:${PATH}"
export PATH
