#!/bin/bash
githubOutFile='./github_out.json'
save_p='../checkout'
# cur_page=1
per_page=100
file_count=0
get_repo(){
  echo "In repo $1"
  # exit
  jqvars="$(echo "$1" | jq '{branch: .default_branch, name: .full_name}')"
  reponame="$(  echo "${jqvars}" | jq -r '.name' )"
  repobranch="$(  echo "${jqvars}" | jq -r '.branch' )"

  echo "$file_count: $reponame, $repobranch" >> logs
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
  cur_page_file="$(cat  $githubOutFile | jq -c '[.items] | .[0]| .[] | {default_branch: .default_branch, full_name: .full_name}')"

  # exit
  for one_repo in ${cur_page_file}; do

    
    echo "$(get_repo $one_repo)"
    echo ""
    echo ""
    curl_out="$(curl -s $(get_repo $one_repo))" 
    geturl="$(echo "${curl_out}"| jq -cr '.[]')"
    # row="${geturl}"
    for cur_f in ${geturl}; do
      wrepo_name="$(echo "${cur_f}"| jq -r '.name')"
      wrepo_type="$(echo "${cur_f}"| jq -r '.type')"
      wrepo_url="$(echo "${cur_f}"| jq -r '.url')"
      case $wrepo_type in
        file)
          echo "$wrepo_name is file."
          ((file_count++))
          ;;
        dir)
          echo "$wrepo_name is folder."
          ;;
        *)echo "Skipped $wrepo_type";;
    
      esac
      
    done
    # echo "${geturl}"
    exit

  done

}
echo "" > logs
i=1
while [ "$i" -le 1 ]; do
    # amixer cset numid=1 "$i%"

  echo "Page $i"
  echo "Page $i, $(date)" >> logs
  cur_page=$i
  write_page > github_out.json
  write_repo
  echo $(get_query_len)
  i=$(( i + 1 ))
done 


