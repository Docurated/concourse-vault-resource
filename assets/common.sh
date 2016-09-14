login() {
    vault_url="$1"
    vault_role="$2"
    vault_nonce="$3"
    curl -skL -XPOST "${vault_url}/v1/auth/aws-ec2/login" -d "{\"role\":\"${vault_role}\",\"pkcs7\":\"$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/pkcs7 | tr -d '\n')\",\"nonce\":\"${vault_nonce}\"}" | \
        jq -r '.auth.client_token'
}

get_secret() {
    vault_url="$1"
    path="$2"
    curl -skL "${vault_url}/v1/secret/${path}" | jq -r '.data'
}
