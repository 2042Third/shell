#!/bin/bash
githubOutFile='./github_out.json'
# cur_page=1
per_page=100
get_repo(){
  jqvars="$(cat $githubOutFile | jq '[.items] | .[0] | .[0]|{branch: .default_branch, name: .full_name}')"
  reponame="$(  echo "${jqvars}" | jq -r '.name' )"
  repobranch="$(  echo "${jqvars}" | jq -r '.branch' )"
  echo "https://api.github.com/repos/${reponame}/contents?ref=${repobranch}"
}

get_query_len(){
  query_len="$(cat $githubOutFile | jq -r '[.total_count]|.[0] ')"
  echo "${query_len}"
}

write_page(){
  _page="$(curl -s -H "Accept: application/vnd.github.v3+json" -X GET https://api.github.com/search/repositories?q=language:Python+is:public&page=$cur_page&per_page=$per_page)"
  echo "${_page}"
}
# resolve(){

# }
write_repo(){
  curl_out="$(curl -s $(get_repo))" 
  geturl="$(echo "${curl_out}"| jq -r '.[]')"
  row="${geturl}"
  _jq() {
   echo ${row}  | jq -r ${1}
  }
  echo $(_jq '.name')
  

}
i=1
while [ "$i" -le 8000 ]; do
    # amixer cset numid=1 "$i%"

  echo "Page $i"
  echo "Page $i" >> logs
  cur_page=$i
  write_page > github_out.json
  write_repo
  echo $(get_query_len)
  i=$(( i + 1 ))
done 


# for (( a=1; a<=8; a++ ))
# do
#   cur_page=$a
#   write_page > github_out.json
#   echo $(get_repo)
#   echo $(get_query_len)
#   echo $cur_page
# done

