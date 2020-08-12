#!/bin/dash

if test ! -d ".shrug"
then
	echo "shrug-add: error: no .shrug directory containing shrug repository exists"
	exit 0
fi

for i in $@
do 
	if [ ! -e "$i" ] && [ ! -e ".shrug/index/$i" ]
	then
		echo "shrug-add: error: can not open '$i'"
		exit 0
	fi
done

for j in $@
do
	if [ -e $j ]
	then
		cp "$j" ".shrug/index"
	else
		if [ -e ".shrug/index/$j" ]
		then
			rm .shrug/index/$j
		fi
	fi	
done








