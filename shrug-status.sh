#!/bin/dash

for i in *
do
	if [ $i = "*" ]
	then
		break
	fi
	#echo "$i"
	if [ -e ".shrug/index/$i" ]
	then
		if [ -e "$i" ] && [ -e ".shrug/index/$i" ]
		then
			diff "$i" ".shrug/index/$i" > /dev/null
			local_index=$?
			#echo "$i l_i $local_index"
		fi		
		num=$(cat .shrug/.log | cut -d' ' -f2 | tail -1)
		#echo "$num"
		if [ -e ".shrug/index/$i" ] && [ -e ".shrug/versions/$num/$i" ]
		then
			diff ".shrug/index/$i" ".shrug/versions/$num/$i" > /dev/null
			index_versions=$?
			#echo "$i index_versions $index_versions"
		fi
		if [ -e "$i" ] && [ -e ".shrug/versions/$num/$i" ]
		then
			diff "$i" ".shrug/versions/$num/$i" >/dev/null
			local_versions=$?
			#echo "$i l_v $local_versions"
		fi

		if [ -e ".shrug/index/$i" ] && [ ! -e ".shrug/versions/$num/$i" ]
		then
			diff "$i" ".shrug/index/$i" > /dev/null
			if [ $? != 0 ]
			then
				echo "$i - added to index, file changed" >>status
			elif [ ! -e $i ]
			then 
				echo "$i - added to index, file deleted" >>status
			else
				echo "$i - added to index" >>status
			fi
		elif [ "$local_index" = "0" ] && [ "$local_versions" = "0" ] && [ "$index_versions" = "0" ]
		then
			echo "$i - same as repo" >>status
		elif [ "$local_versions" = "1" ] && [ "$local_index" = "1" ] && [ "$index_versions" = "1" ]
		then
			echo "$i - file changed, different changes staged for commit" >>status
		elif [ "$local_versions" = "1" ] && [ "$local_index" = "0" ] && [ "$index_versions" = "1" ]
		then
			echo "$i - file changed, changes staged for commit" >>status
		elif [ "$local_versions" = "1" ] && [ "$local_index" = "1" ] && [ "$index_versions" = "0" ]
		then
			echo "$i - file changed, changes not staged for commit" >>status
		elif [ -e ".shrug/index/$i" ] && [ ! -e "$i" ]
		then
			echo "$i - file deleted" >>status
		elif [ -e "$i" ] && [ ! -e ".shrug/index/$i" ]
		then
			echo "$i - deleted" >>status
		fi	
		
	else
		echo "$i - untracked " >>status
	fi
done



num=$(cat .shrug/.log | cut -d' ' -f2 | tail -1)

for j in `ls .shrug/versions/$num`
do
	#echo "num $num"
	#echo `ls .shrug/versions/$num`
	#echo "$j"
	if [ -e ".shrug/versions/$num/$j" ] && [ ! -e "$j" ] && [ -e ".shrug/index/$j" ]
	then
		echo "$j - file deleted" >> status
	elif [ ! -e ".shrug/index/$j" ] && [ ! -e "$j" ] && [ -e ".shrug/versions/$num/$j" ]
	then		
		#echo "here"
		#echo "$j"
		echo "$j - deleted" >>status 
	fi
done

for k in `ls .shrug/index`
do
	if [ -e ".shrug/index/$k" ] && [ ! -e "$k" ]
	then
		echo "$k - added to index, file deleted" >>status
	fi
done



#cat status
if [ -s status ]
then 
	sort status
fi 
rm status >/dev/null 2>&1
