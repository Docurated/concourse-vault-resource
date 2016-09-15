login() {
    vault_role="$1"
    vault_nonce="$2"
    cert=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/pkcs7 | tr -d '\n')
    token=$(vault write -format=json auth/aws-ec2/login role=${vault_role} pkcs7=${cert} nonce=${vault_nonce} | jq -r '.auth.client_token')
    if [ -z "${token}" ]; then
        echo "ERROR: No token retrieved"
    fi
    echo -n "${token}" > ~/.vault-token
}

get_secret() {
    vault read -format=json secret/${1} | jq -r '.data'
}
