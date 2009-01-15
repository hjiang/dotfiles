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
		RSLT="[3${CLR};40m[${GIT_BRANCH}][0m"
	fi
	echo $RSLT
}

COL=`expr $COLUMNS - 1`
LINE=''
COUNT=0
while test ${COL} -gt $COUNT
do
	let COUNT++
	LINE="${LINE}─"
done

export PS1='┌${LINE}[${COL}D────[30m[\u@\h][0m─────[36m[\t][0m─────[34m[\W][0m─────$(parse_git_branch)───
└──> \$ '
