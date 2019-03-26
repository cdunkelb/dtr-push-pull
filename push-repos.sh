#!/bin/bash
#Author: Carl Dunkelberger (cdunkelb)
#Usage: push-repos.sh DTR_HOST ADMIN_USER TOKEN

if [[ $# -eq 0 ]] ; then
    echo 'Usage: pull-repos.sh DTR_HOST ADMIN_USER TOKEN'
    exit 1
fi

# DTR_HOST="dtr.example.com"
DTR_HOST=$1

#ADMIN_USER=admin
ADMIN_USER=$2

# TOKEN=$(cat ~/lab/dtr-token)
TOKEN=$3 

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

echo "Found $(wc -l < repo-tags.txt) tags to push."
continue_on

for i in $(cat repo-tags.txt); do
	echo pushing "$DTR_HOST/$i"
	docker push $DTR_HOST/$i
done
