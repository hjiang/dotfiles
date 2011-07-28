parse_git_branch() {
  RSLT=''
  GIT_BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' | awk '{print $2}'`
  if [ "$GIT_BRANCH" ]
  then
    GIT_STATUS=`git status 2> /dev/null | grep 'working directory clean'`
    CLR='2'
    if [ "$GIT_STATUS" ]
    then
      CLR='2'
    else
      CLR='1'
    fi
    RSLT="──[3${CLR};40m[${GIT_BRANCH}][0m"
  fi
  echo $RSLT
}

export PS1='┌─[32m[\u@\h][0m──[36m[\t][0m──[34m[\W][0m$(parse_git_branch)
└─> \$ '
