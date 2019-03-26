#!/bin/bash
#Author: Carl Dunkelberger (cdunkelb)
#Usage: pull-repos.sh DTR_HOST ADMIN_USER TOKEN
#

if [[ $# -eq 0 ]] ; then
    echo 'Usage: pull-repos.sh DTR_HOST ADMIN_USER TOKEN'
    echo 'Example: ./pull-repos.sh dt.example.com admin $(cat dtr-token)'
    exit 1
fi
# DTR_HOST="dtr.example.com"
DTR_HOST=$1

#ADMIN_USER=admin
ADMIN_USER=$2

# TOKEN=$(cat ~/lab/dtr-token)
TOKEN=$3 


#Get a list of repos
echo "INFO: Getting list of repos"
curl -u $ADMIN_USER:$TOKEN -X GET "https://$DTR_HOST/api/v0/repositories?pageSize=1000" -H "accept: application/json" > docker-repos.json

echo "INFO: cleaning up any old repo-tags.txt files..."
rm repo-tags.txt

echo "INFO: Getting tags for each repo"
for REPONAME in $(jq -r '.repositories | .[] | .namespace + "/" + .name' < docker-repos.json); do
	echo "INFO: Enumerating $REPONAME"
	for TAG in $(curl -u $ADMIN_USER:$TOKEN -s -X GET "https://$DTR_HOST/api/v0/repositories/$REPONAME/tags" -H "accept: application/json" | jq -r '.[].name'); do
		echo "$REPONAME:$TAG"
		echo "$REPONAME:$TAG" >> repo-tags.txt
	done
done

echo "INFO: found $(wc -l < repo-tags.txt) repos/tags"

continue_on (){
echo -n "$1: (y/n)? "
read answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
    echo "Proceeding..."
else
    echo "Exiting..."
    exit
fi
}


continue_on "Continue to pull images to local host"

echo "INFO: Pulling images"
for i in $(cat repo-tags.txt); do
	echo "INFO: pulling $DTR_HOST/$i"
	docker pull $DTR_HOST/$i
done
