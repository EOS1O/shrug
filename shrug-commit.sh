#!/bin/dash

commit_number(){
	num=$(cat ".shrug/.log" | cut -d' ' -f2 | tail -1)
	if [ -z $num ]
	then
		num=0
	else
		num=$(expr $num + 1)
	fi
	return $num
}

flag=0

if [ "$#" -eq 0 ] || [ "$#" -eq 1 ] 
then
	echo "usage: $repo_name-commit [-a] -m commit-message"
	exit 0
elif [ "$1" = "-a" ]
then
	flag=1
	shift
elif [ "$1" = "-m" ]
then
	shift
fi

current_branch=`cat .shrug/.branch | grep '\*' | sed 's/\* //g'`
commit_number
number=$?


if [ $flag -eq 1 ]
then
	for file in `ls .shrug/index`
	do
		if [ -e "$file" ]
		then 
			cp "$file" ".shrug/index"
		fi
	done 
fi


diff -q ".shrug/index" ".shrug/branches/$current_branch" > /dev/null
if [ $? = 0 ] 
then
	echo "nothing to commit"
else
	mkdir -p ".shrug/versions/$number"
	for file1 in `ls .shrug/index`
	do
		if [ -e `ls .shrug/index/$file1` ]
		then
			cp ".shrug/index/$file1" ".shrug/versions/$number" >/dev/null 2>&1
		fi
	done

	rm -rf ".shrug/branches/$current_branch/*"

	for file2 in `ls .shrug/index`
	do
		if [ -e ".shrug/index/$file2" ]
		then
			cp ".shrug/index/$file2" ".shrug/branches/$current_branch" >/dev/null 2>&1
		fi
	done

	echo "$current_branch $number $1" >> ".shrug/.$current_branch.log"
	echo "$current_branch $number $1" >> ".shrug/.log"
	echo "Committed as commit $number"
fi









