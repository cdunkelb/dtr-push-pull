#!/bin/bash
#Author: Carl Dunkelberger (cdunkelb)
#Usage: push-repos.sh OLD_DTR NEW_DTR

if [[ $# -eq 0 ]] ; then
    echo 'Usage: re-tag.sh OLD_DTR NEW_DTR'
    exit 1
fi

OLD_DTR=$1
NEW_DTR=$2

continue_on (){
echo -n "Continue: (y/n)? "
read answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
    echo "Proceeding..."
else
    echo "Exiting..."
    exit
fi
}

echo "Found $(wc -l < repo-tags.txt) tags to re-tag"
continue_on

for i in $(cat ./repo-tags.txt); do
	echo "tagging $OLD_DTR/$i to $NEW_DTR/$i"
	docker tag $OLD_DTR/$i $NEW_DTR/$i
done
