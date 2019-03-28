# dtr-push-pull
Utility scripts to pull all repos from a DTR and push it to another.

# How to Use
1. Get an authentication token from DTR https://docs.docker.com/ee/dtr/user/access-tokens/ If the version of DTR does not support auth tokens, the password for that user may be used instead.
2. Pull *All* Repos from Source DTR
  - `Usage: pull-repos.sh DTR_HOST ADMIN_USER TOKEN`
  - `Example: ./pull-repos.sh olddtr.example.com admin $(cat dtr-token)`
3. Tag the source DTR repo images from the old URL to the new URL
  - `Usage: retag-repos.sh OLD_DTR NEW_DTR`
  - `Example: ./re-tag.sh olddtr.example.com newdtr.example.com`
4. Push Repos to target DTR
  - `Usage: push-repos.sh DTR_HOST ADMIN_USER TOKEN`
  - `Example: ./push-repos.sh newdtr.example.com admin $(cat dtr-token)`
