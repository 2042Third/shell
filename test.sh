#!/bin/bash
# geturl="$(cat test| jq -r '.[]')"
# row="${geturl}"
_jq() {
 echo ${row}  | jq -r ${1}
}
# echo $(_jq '.name')
get_repo(){
  echo "In repo"
  # jqvars="$(echo "${row}" | jq '{branch: .default_branch, name: .full_name}')"
  reponame="$(  echo "${row}" | jq -r '.full_name' )"
  repobranch="$(  echo "${row}" | jq -r '.default_branch' )"
  echo "https://api.github.com/repos/$reponame/contents?ref=$repobranch"
}

var1="$(cat  test | jq -c '[.items] | .[0]| .[] | {full_name: .full_name, defualt_branch: .default_branch}')"
row="${var1}"

# while read a
# do
#         echo "$a"
# done < "${row}"

# while read line
# do
#   echo "haha $line"
# done < <("${row}" |tr ' ' '\n' )


for a in ${row}; do
  echo "hahahha $a"
done