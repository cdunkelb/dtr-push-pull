#!/bin/bash
#Author: Carl Dunkelberger (cdunkelb)

TOKEN=$(cat ~/lab/dtr-token)
DTR_HOST="dtr.cdunkelb.com"

#Get a list of repos
echo "INFO: Getting list of repos"
curl -u admin:$TOKEN -X GET "https://$DTR_HOST/api/v0/repositories?pageSize=1000" -H "accept: application/json" > docker-repos.json

echo "INFO: cleaning up any old repo-tags.txt files..."
rm repo-tags.txt

echo "INFO: Getting tags for each repo"
for REPONAME in $(jq -r '.repositories | .[] | .namespace + "/" + .name' < docker-repos.json); do
	echo "INFO: Enumerating $REPONAME"
	for TAG in $(curl -u admin:$TOKEN -s -X GET "https://$DTR_HOST/api/v0/repositories/$REPONAME/tags" -H "accept: application/json" | jq -r '.[].name'); do
		echo "$REPONAME:$TAG"
		echo "$REPONAME:$TAG" >> repo-tags.txt
	done
done

echo "INFO: found $(wc -l < repo-tags.txt) repos/tags"


# read -p "Pull these images to the local host? [y/n]:" PROCEED
# [[ $PROCEED != "y" ]] && echo "exiting"; exit
# echo "DEBUG: PROCEED = $PROCEED"

echo "INFO: Pulling images"
for i in $(cat repo-tags.txt); do
	echo "INFO: pulling $DTR_HOST/$i"
	docker pull $DTR_HOST/$i
done
