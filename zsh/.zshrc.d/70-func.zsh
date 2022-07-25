_mkcd() { _wanted directories expl directory _path_files -/; }
compdef _mkcd mkcd

awsmfa() {
  local -r profile=default
  local -r serial_number="$(aws configure get --profile="$profile" mfa_serial)"
  if [[ -z $serial_number ]]; then
    echo "no serial number" >&2
    return 1
  fi
  if [[ -n $1 ]]; then
    unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
    local -r token="$(aws sts get-session-token --serial-number "$serial_number" --token-code "$1")"
    AWS_ACCESS_KEY_ID=$(echo "$token" | jq -r .Credentials.AccessKeyId)
    AWS_SECRET_ACCESS_KEY=$(echo "$token" | jq -r .Credentials.SecretAccessKey)
    AWS_SESSION_TOKEN=$(echo "$token" | jq -r .Credentials.SessionToken)
    aws configure set --profile="${profile}-mfa" aws_access_key_id "$AWS_ACCESS_KEY_ID"
    aws configure set --profile="${profile}-mfa" aws_secret_access_key "$AWS_SECRET_ACCESS_KEY"
    aws configure set --profile="${profile}-mfa" aws_session_token "$AWS_SESSION_TOKEN"
  else
    AWS_ACCESS_KEY_ID="$(aws configure get --profile="${profile}-mfa" aws_access_key_id)"
    AWS_SECRET_ACCESS_KEY="$(aws configure get --profile="${profile}-mfa" aws_secret_access_key)"
    AWS_SESSION_TOKEN="$(aws configure get --profile="${profile}-mfa" aws_session_token)"
  fi
  export AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
}
