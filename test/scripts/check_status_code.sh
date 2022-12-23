#!/bin/bash

# export INPUT_SITES='["http://github.com", "https://education.github.com"]'
# export INPUT_EXPECTED='[301, 200]'
# https://github.com/lakuapik/gh-actions-http-status

LRED="\033[1;31m"   # Light Red
LGREEN="\033[1;32m" # Light Green
NC='\033[0m'        # No Color

text_success="(${LGREEN}Success${NC})"
text_failed="(${LRED}Failed${NC}) "

http_status() {
    site_url=$1
    expected_status=$2

    actual_status=$(curl -o /dev/null -s -w "%{http_code}" $site_url)

    if [ "${actual_status}" == "${expected_status}" ]; then
        result=${text_success}
    else
        result=${text_failed}
        final_result=${text_failed}
        final_result_code=127

    fi

    echo -e "${result} HTTP Status for ${site_url} is ${actual_status}, expected ${expected_status}"
}

echo -e "\n\n==Starting gh-actions HTTP Status==\n"

final_result="${LGREEN}Success${NC}"
final_result_code=0

len=$(printenv INPUT_SITES | jq -r '. | length')

for ((i=0; i<len; i++))
do
    site=$(printenv INPUT_SITES | jq -r '.['${i}']')
    expected=$(printenv INPUT_EXPECTED | jq -r '.['${i}']')
    http_status $site $expected
done

echo -e "\nHTTP Status result: ${final_result}"
echo -e "\n==END==\n\n"

exit ${final_result_code}
