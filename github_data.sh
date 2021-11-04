#!/bin/bash
githubOutFile='./github_out.json'
save_p='../checkout'
# cur_page=1
per_page=100
file_count=0
get_repo(){
  jqvars="$(echo "$1" | jq '{branch: .default_branch, name: .full_name}')"
  reponame="$(  echo "${jqvars}" | jq -r '.name' )"
  repobranch="$(  echo "${jqvars}" | jq -r '.branch' )"

  echo "$file_count: $reponame, $repobranch" >> logs
  echo "https://api.github.com/repos/${reponame}/contents?ref=${repobranch}"
}
get_repo_n(){
  # exit
  jqvars="$(echo "$1" | jq '{branch: .default_branch, name: .full_name}')"
  reponame="$(  echo "${jqvars}" | jq -r '.name' )"
  echo "${reponame}"
}

get_query_len(){
  query_len="$(cat $githubOutFile | jq -r '[.total_count]|.[0] ')"
  echo "${query_len}"
}

write_page(){
  _page="$(curl -s -H "Accept: application/vnd.github.v3+json" -X GET https://api.github.com/search/repositories?q=language:Python+is:public&page=$cur_page&per_page=$per_page)"
  echo "${_page}"
}

resolve_file(){
  repofull_path=$2
  geturl="$(echo $1 | jq -cr '.[]')"
  for cur_f in ${geturl}; do
    wrepo_name="$(echo "${cur_f}"| jq -r '.name')"
    wrepo_type="$(echo "${cur_f}"| jq -r '.type')"
    wrepo_url="$(echo "${cur_f}"| jq -r '.url')"
    wrepo_path="$(echo "${cur_f}"| jq -r '.path')"
    # echo "[]get $wrepo_name $wrepo_type;"
    case $wrepo_type in
      file)
        # echo "[]$wrepo_name is file."
        file_count=$((file_count+1))
        wrepo_dl="$(echo "${cur_f}"| jq -r '.download_url')"
        case $wrepo_name in
          *.py)
            mkdir -p "$save_p/$repofull_path/${wrepo_path%/*}"
            curl -s $wrepo_dl > "$save_p/$repofull_path/$wrepo_path"
            echo "[written] $save_p/$repofull_path/$wrepo_path "
            echo "[written] $save_p/$repofull_path/$wrepo_path " >> logs
            ;;
          *)
            
            ;;
        esac
        ;;
      dir)
        # echo "[]$wrepo_name is folder."
        case $wrepo_name in
          .git)
            ;;
          .github)
            ;;
            *)
              wrepo_curl_out="$(curl -s $wrepo_url)" 
              resolve_file "${wrepo_curl_out}" $repofull_path
            ;;
        esac
        ;;
      *)echo "[]Skipped $wrepo_type";;
    esac
  done
}



write_repo(){
  cur_page_file="$(cat  $githubOutFile | jq -c '[.items] | .[0]| .[] | {default_branch: .default_branch, full_name: .full_name}')"

  for one_repo in ${cur_page_file}; do
    currepo_name="$(get_repo_n $one_repo )"
    curl_out="$(curl -s $(get_repo $one_repo ))" 
    resolve_file "${curl_out}" $currepo_name
  done

}
echo "" > logs
i=1
while [ "$i" -le 4 ]; do
    # amixer cset numid=1 "$i%"

  echo "Page $i"
  echo "Page $i, $(date)" >> logs
  cur_page=$i
  write_page > github_out.json
  write_repo
  echo $(get_query_len)
  i=$(( i + 1 ))
done 


