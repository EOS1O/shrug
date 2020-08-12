#!/bin/dash

#echo "$1"
left=$(echo "$1" | cut -d':' -f1)
right=$(echo $1 | cut -d':' -f2)
#echo "$left"
#echo "$right"

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

commit_number
number=$?
newnum=$(expr $number - 1)

num=${#left}

if [ $num -eq 0 ]
then
	#for i in `ls .shrug/versions`
	#do
		#cat .shrug/versions/$i/$right

	#done
	if [ -e ".shrug/index/$right" ]
	then
		cat ".shrug/index/$right"
	else
		echo "shrug-show: error: '$right' not found in index"
	fi
else
	if [ -e ".shrug/versions/$left/$right" ]
	then
		cat ".shrug/versions/$left/$right"
	elif [ $left -gt $number ]
	then
		echo "shrug-show: error: unknown commit '$left'"
	else
		echo "shrug-show: error: '$right' not found in commit $newnum"	
	fi	
	
fi
