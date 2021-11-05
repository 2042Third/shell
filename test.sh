#!/bin/bash
path=/foo/bar/bim/baz/file.gif
tvar='{"full_name":"foo","default_branch":"hah1}'
# file="$(cat test | jq '.full_name') " 
_page="$(curl -s -H "Accept: application/vnd.github.v3+json" -X GET 'https://api.github.com/search/repositories?q=language:Python+is:public&page=4&per_page=100&sort=updated')"


if ! echo "${_page}" | jq -c '[.items] | .[0]| .[] | {default_branch: .default_branch, full_name: .full_name}' ;then
  sleep 10m
  echo "Slept 10m $(date)" 
fi