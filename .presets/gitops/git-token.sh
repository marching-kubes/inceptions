#!/bin/env bash

## Expected env vars
# IP
# GIT_SCHEME
# GIT_HOST
# GIT_URL
# GIT_KIND
# INTERNAL_GIT_HOST
# INTERNAL_GIT_URL
# INTERNAL_GIT_HOST
# INTERNAL_GIT_URL
# GITEA_ADMIN_USER
# GITEA_ADMIN_PASSWORD

CURL_AUTH_HEADER=""
declare -a CURL_AUTH=()

curlBasicAuth() {
  username=$1
  password=$2
  basic=`echo -n "${username}:${password}" | base64`
  CURL_AUTH=("-H" "Authorization: Basic $basic")

  CURL_AUTH_HEADER="Authorization: Basic $basic"
}

curlBasicAuth "${GITEA_ADMIN_USER}" "${GITEA_ADMIN_PASSWORD}"
CURL_GIT_ADMIN_AUTH=("${CURL_AUTH[@]}")

declare -a CURL_TYPE_JSON=("-H" "Accept: application/json" "-H" "Content-Type: application/json")


TOKEN_SCOPES_JSON=`cat << EOF
{
  "name": "$1",
  "scopes": ["all"]
}
EOF
`


request=`echo "${TOKEN_SCOPES_JSON}"`

echo "Creating token for user [${username}] in [${GIT_KIND}] @ [${GIT_URL}], request: [${request}]"
response=`echo "${request}" | curl -s -X POST -u $username:$password ${GIT_URL}/api/v1/users/${GITEA_ADMIN_USER}/tokens "${CURL_TYPE_JSON[@]}" --data @-`
token=`echo "${response}" | yq eval '.sha1' -`
message=`echo "${response}" | yq eval '.message' -`

if [[ "$message" == "access token name has been used already" ]]; then
    echo "Token "jx" already exists for user [${username}] in [${GIT_KIND}] @ [${GIT_URL}]"
else 
    echo "Token=[${token}]"
fi

echo "List tokens for user [${username}] in [${GIT_KIND}] @ [${GIT_URL}]"
response=`echo "${request}" | curl -s -u $username:$password ${GIT_URL}/api/v1/users/${GITEA_ADMIN_USER}/tokens`
echo $response | yq -P

if [[ "$token" == "null" ]]; then
    echo "Failed to create token for ${username}, json response: \n${response}"
    (return 1 &> /dev/null) || exit 1
fi
TOKEN="${token}"

echo "TOKEN: [${TOKEN}]"

export GIT_TOKEN=${TOKEN}