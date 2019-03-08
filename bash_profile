[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

# jEnv in front, rvm wants to be in bashrc for some reason
PATH="$HOME/.jenv/bin:$PATH"
PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

source ~/git-completion.bash
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

curl_helpers ()
{
  echo '"http://local.marqeta.com:8080/v3/"'
  echo '-H "Content-Type: application/json"'
  echo '-H "Authorization: Basic YWRtaW5fY29uc3VtZXI6bWFycWV0YQ=="'
  echo "curl -X METHOD HEADERS -d '{json}' URL | python -m json.tool"
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

# removes local branches that have been merged
alias gbranchclean="git branch --merged | grep -v \"\\*\" | grep -v master | xargs -n 1 git branch -d"

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

# Searching stuff...
alias acl='ack'
alias ag='ag --path-to-ignore ~/.ignore --color-path "1;36"'

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
alias lp=local_ping
local_ping() {
  echo -e "\n___ PAPI ___"
  curl --silent http://localhost:8080/v3/ping | grep -E -o ".version\"\:\".+?\""
  echo -e "___ DNA ___"
  curl --silent http://localhost:8081/dna-api/ping | grep -E -o ".build_version\"\:\".+?\""
  echo -e "___ Zion ___"
  curl --silent http://localhost:9081/zion-api/ping | grep -E -o ".success\"\:.+$"
  echo -e "___ Consul ___"
  curl --silent http://localhost:8500/v1/status/leader #| grep -E -o ".success\"\:.+$"
  echo -e "\n"
}

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

# Navigate to Vagrant, SSH, get to logs as root
alias logs="cd ~/Workspace/localdocker && ssh -t vagrant@localdocker \"sudo sh -c 'cd /var/log/jcard; ls -altr; bash'\""

alias logs1="cd ~/Workspace/localdocker && ssh -t vagrant@localdocker \"sudo sh -c 'cd /var/log/jcard/local1; ls -altr; bash'\""
alias logs2="cd ~/Workspace/localdocker && ssh -t vagrant@localdocker \"sudo sh -c 'cd /var/log/jcard/local2; ls -altr; bash'\""
alias logs3="cd ~/Workspace/localdocker && ssh -t vagrant@localdocker \"sudo sh -c 'cd /var/log/jcard/local3; ls -altr; bash'\""

# Same, but for Remote / Hyrdo
# not currently working the way I would like, the ending bash is weird
alias logsremote="ssh -t lvpmtqapool01 \"sh -c 'cd /var/log/jcard/local6; ls -altr;'\""

alias remote="ssh -t lvpmtqapool01"

# Pretty Git Log, pass the number of records to view
alias gl="pretty_git_log $1"
pretty_git_log() {
  lines_to_show=${1:-10}
  git log -${lines_to_show} --pretty=format:'%h - %an, %ar : %s'
}

# Ping all Local Dockers
#alias lp=local_ping
#local_ping() {
  #for i in {1..3};
  #do
    #echo -e "\n___ Local $i ___"
    #curl --silent "local$i.marqeta.com/v3/ping" | grep -E -o ".version\"\:\".+?\""
  #done
  #echo -e "\n"
#}

alias pp=ping_payments
# not returning the entire branch name after a second '.'
ping_payments() {
  echo -e "\n___ Payment 1 ___"
  curl --silent https://payment1-qa.marqeta.com/v3/ping | grep -E -o ".version\"\:\".+?\""
  echo -e "___ Payment 2 ___"
  curl --silent https://payment2-qa.marqeta.com/v3/ping | grep -E -o ".version\"\:\".+?\""
  echo -e "\n"
}

alias pr=ping_remote
# not returning the entire branch name after a second '.'
ping_remote() {
  echo -e "\n___ Remote (Local 6) ___"
  curl --silent http://local6.qa.marqeta.com/v3/ping #| grep -E -o ".version\"\:\".+?\""
  echo -e "\n"
}

# Ping all Hydras
alias par=ping_all_remotes
ping_all_remotes() {
  for i in {1..15};
  do
    echo -e "\n___ Local $i ___"
    curl --silent "local$i.qa.marqeta.com/v3/ping" | grep -E -o ".version\"\:\".+?\""
  done
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

alias sb_mt="jenkins_switch_branch_multi_tenant $1 $2"
jenkins_switch_branch_multi_tenant() {
  java -jar ~/Workspace/jenkins-cli.jar -noKeyAuth -s http://localdocker.marqeta.com:8090/ build switch2_mt_branch -f -v -p container=$1 -p branch=$2
  echo "Deploying ${$2} to ${$1} as Multi Tenant Instance..."
}

alias rc="jenkins_restart_containers"
jenkins_restart_containers() {
  # stolen shamelessly from https://stackoverflow.com/questions/1885525/how-do-i-prompt-a-user-for-confirmation-in-bash-script
  echo "Are you sure you want to restart all containers?"
  read -p "y/n " -n 1 -r
  echo 
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    echo "Restarting containers..."
    java -jar ~/Workspace/jenkins-cli.jar -noKeyAuth -s http://localdocker.marqeta.com:8090/ build restart_container -f -v
  else
    echo "Alrighty - quitter"
  fi
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
