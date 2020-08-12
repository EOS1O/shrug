#!/bin/dash

current_branch=`cat .shrug/.branch | egrep '\*' | sed 's/\* //g'`
#echo "$current_branch"
if [ "$current_branch" = "master" ]
then
	cat ".shrug/.log" | egrep '^master' | cut -d' ' -f2- | sort -rn
else
	if [ -e ".shrug/.$current_branch.log" ]
	then
		cat .shrug/.$current_branch | cut -d' ' -f2- | sort -rn
	fi
fi
