[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

# jEnv in front, rvm wants to be in bashrc for some reason
PATH="$HOME/.jenv/bin:$PATH"

source ~/git-completion.bash
export VISUAL='/usr/local/bin/vim'
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

curl_helpers ()
{
  echo '"http://local.marqeta.com:8080/v3/"'
  echo '-H "Content-Type: application/json"'
  echo '-H "Authorization: Basic YWRtaW5fY29uc3VtZXI6bWFycWV0YQ=="'
  echo "curl -X METHOD HEADERS -d '{json}' URL | python -m json.tool"
}

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
alias gdm="git diff master --name-only"
alias gch="git checkout"
alias st="pwd | grep --color='auto' -E -o '\/.-test-suite'; git branch && git status"
alias gf="git fetch --all"
alias gpm="git pull origin master"
# removes local branches that have been merged
alias gbranchclean="git branch --merged | grep -v \"\\*\" | grep -v master | xargs -n 1 git branch -d"

# Set AutoComplete for Git Alias'
__git_complete gch _git_checkout
__git_complete gb _git_branch

# General Use Alias
alias ..="cd .."
alias pud="pushd"
alias ppd="popd"
alias ll="ls -al"
alias grel="grep"
alias bp="mvim ~/.bash_profile"
alias vrc="mvim ~/.vimrc"

# Rails Alias
alias be="bundle exec"

# Testing Alias
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

# Navigate to Vagrant, SSH, get to logs as root
alias logs="cd ~/Workspace/localdocker && ssh -t vagrant@localdocker \"sudo sh -c 'cd /var/log/jcard; ls -altr; bash'\""

alias logs1="cd ~/Workspace/localdocker && ssh -t vagrant@localdocker \"sudo sh -c 'cd /var/log/jcard/local1; ls -altr; bash'\""
alias logs2="cd ~/Workspace/localdocker && ssh -t vagrant@localdocker \"sudo sh -c 'cd /var/log/jcard/local2; ls -altr; bash'\""
alias logs3="cd ~/Workspace/localdocker && ssh -t vagrant@localdocker \"sudo sh -c 'cd /var/log/jcard/local3; ls -altr; bash'\""

# Pretty Git Log, pass the number of records to view
alias gl="pretty_git_log $1"
pretty_git_log() {
  git log -10 --pretty=format:'%h - %an, %ar : %s'
}

# Ping all Local Dockers
alias lp=local_ping
local_ping() {
  echo -e "\n___ Local 1 ___"
  curl --silent local1.marqeta.com/v3/ping | grep -E -o ".version\"\:\".+?\""
  echo -e "___ Local 2 ___"
  curl --silent local2.marqeta.com/v3/ping | grep -E -o ".version\"\:\".+?\""
  echo -e "___ Local 3 ___"
  curl --silent local3.marqeta.com/v3/ping | grep -E -o ".version\"\:\".+?\""
  echo -e "\n"
}

alias pp=ping_payments
# not returning the entire branch name after a second '.'
ping_payments() {
  echo -e "\n___ Payment 1 ___"
  curl --silent https://payment1-qa.marqeta.com/v3/ping | grep -E -o ".version\"\:\".+?\""
  echo -e "___ Payment 2 ___"
  curl --silent https://payment1-qa.marqeta.com/v3/ping | grep -E -o ".version\"\:\".+?\""
  echo -e "\n"
}

alias rg=run_gatling
run_gatling() {
  if [ -z $1 ] || [ -z $2 ] 
  then
    echo "Please supply the target env and result directory"
    echo "ex - rg local1 regressions"
  else
    JAVA_OPTS="-Denv=$1" sh bin/gatling.sh -rf results/local/$2/
  fi
}

alias sb="jenkins_switch_branch $1 $2"
jenkins_switch_branch() {
  java -jar ~/Workspace/jenkins-cli.jar -noKeyAuth -s http://localdocker.marqeta.com:8090/ build switch_branch -f -v -p container=$1 -p branch=$2 -p program=doordash
  echo "Deploying ${$2} to ${$1}..."
}

alias rc="jenkins_restart_containers"
jenkins_restart_containers() {
  java -jar ~/Workspace/jenkins-cli.jar -noKeyAuth -s http://localdocker.marqeta.com:8090/ build restart_container -f -v
  echo "Restarting containers..."
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

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
