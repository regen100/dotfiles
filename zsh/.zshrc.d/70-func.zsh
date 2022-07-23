_mkcd() { _wanted directories expl directory _path_files -/; }
compdef _mkcd mkcd

awsmfa() {
  local -r token="$(aws sts get-session-token --serial-number "$(aws configure get mfa_serial)" --token-code "$1")"
  AWS_ACCESS_KEY_ID=$(echo "$token" | jq -r .Credentials.AccessKeyId)
  AWS_SECRET_ACCESS_KEY=$(echo "$token" | jq -r .Credentials.SecretAccessKey)
  AWS_SESSION_TOKEN=$(echo "$token" | jq -r .Credentials.SessionToken)
  export AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
}
