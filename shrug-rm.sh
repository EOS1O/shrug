#!/bin/dash

########## main script ##########
# check input params
# default
forced=0
cached=0

if test $# -eq 0
then
	echo "usage: shrug-rm [--force] [--cached] <filenames>"
	exit 1
fi
# get forced param
if test "$1" = "--force"
then
	forced=1
	shift
fi
# get cached params
if test "$1" = "--cached"
then 
	cached=1
	shift
fi

# check file names
for file in $@
do
	if echo "$file"| grep '^-' >> /dev/null
	then
		echo "usage: shrug-rm [--force] [--cached] <filenames>"
		exit 1
	fi
done


check_forced_delete() {
	cached=$1
	file_name=$2
	if [ ! -e ".shrug/index/$file_name" ]
    then
		echo "shrug-rm: error: '$file_name' is not in the shrug repository"
        exit 1	
	fi	
}


check_cached_delete() {
	cached=$1
	file=$2
	index_file=".shrug/index/$file"
	# get current branch
	current_branch=`cat .shrug/.branch | egrep '^\* .*' | cut -d' ' -f2-`
	# get current branch	
	if test -z "$current_branch"
	then
		current_branch="master"
	fi
	# master file
	master_file=".shrug/branches/$current_branch/$file"
	
	if [ ! -e "$index_file" ] 
	then
		echo "shrug-rm: error: '$file' is not in the shrug repository"
        exit 1
	else
		if [ -e "$file" ] 
		then
			if [ -e "$master_file" ]
			then
				# three files all different
				if ! diff -q "$file" "$index_file">/dev/null && ! diff -q "$index_file" "$master_file">/dev/null
				then
					echo "shrug-rm: error: '$file' in index is different to both working file and repository"
					exit 1
				fi
				# check not cached but file difference
				if test "$cached" -eq 0 && diff -q "$file" "$index_file">/dev/null && ! diff -q "$index_file" "$master_file">/dev/null
                then
					echo "shrug-rm: error: '$file' has changes staged in the index"
                    exit 1
                fi
			else
				if test "$cached" -eq 0 
				then 
					echo "shrug-rm: error: '$file' has changes staged in the index"
                    exit 1
				fi
			fi
			
			# current file is different from index
			if test "$cached" -eq 0 && ! diff -q "$file" "$index_file">/dev/null
			then
				echo "shrug-rm: error: '$file' in repository is different to working file"
				exit 1
			fi
		fi
	fi
}

# delete all the files
delete_files()  {
	forced=$1
	cached=$2
	file_name=$3
	index_file=".shrug/index/$file_name"
	if test "$forced" -eq 1
	then
		# forced files
		if test "$cached" -eq 0
		then
			if [ -e "$file_name" ]
			then
				rm $file_name
			fi
		fi		
		rm .shrug/index/$file_name	
	else
		# delte index file
		rm "$index_file"
		# check cached files
		if test "$cached" -eq 0 && [ -e "$file" ]
		then
			rm "$file"
		fi
	fi
}

for file in $@
do
	if test "$forced" -eq 1
	then
		check_forced_delete "$cached" "$file"
	else
		check_cached_delete "$cached" "$file"
	fi	
done

for file in $@
do
	delete_files "$forced" "$cached" "$file"
		
done