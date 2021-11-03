#!/bin/bash
geturl="$(cat test| jq -r '.[]')"
row="${geturl}"
_jq() {
 echo ${row}  | jq -r ${1}
}
echo $(_jq '.name')

