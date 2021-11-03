#!/bin/bash
vari='.branch'
# jqvar='$(cat github_out.json | jq "[.items] | .[0] | .[0]|{branch: .default_branch, name: .full_name}")'
jqvars="$(cat github_out.json | jq '[.items] | .[0] | .[0]|{branch: .default_branch, name: .full_name}')"

reponame="$(  echo "${jqvars}" | jq '.name' )"
reponame="$(  echo "${jqvars}" | jq '.name' )"
echo "${reponame}"
# echo "$varname"
# https://api.github.com/repos/RaviKharatmal/test/contents?ref=develop