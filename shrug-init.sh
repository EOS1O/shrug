#!/bin/dash
if test -d ".shrug"
then
	echo "shrug-init: error: .shrug already exists"
else
	mkdir -p ".shrug/index"
	mkdir -p ".shrug/versions"
	mkdir -p ".shrug/branches/master"
	touch ".shrug/.branch"
	touch ".shrug/.log"
	touch ".shrug/.master"
	touch ".shrug/readme.md"
	echo "Initialized empty shrug repository in .shrug"
	echo "* master" >.shrug/.branch
fi
