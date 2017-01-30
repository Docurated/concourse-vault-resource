login_aws_ec2() {
    vault_role="$1"
    vault_nonce="$2"
    cert=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/pkcs7 | tr -d '\n')
    token=$(vault write -format=json auth/aws-ec2/login role=${vault_role} pkcs7=${cert} nonce=${vault_nonce} | jq -r '.auth.client_token')
    if [ -z "${token}" ]; then
        echo "ERROR: No token retrieved"
	return 1
    fi
    echo -n "${token}" > ~/.vault-token
}

login_approle() {
    vault_role_id="$1"
    vault_secret_id="$2"
    token=$(vault write -format=json auth/approle/login role_id=${vault_role_id} secret_id=${vault_secret_id} | jq -r '.auth.client_token')
    if [ -z "${token}" ]; then
        echo "ERROR: No token retrieved"
	return 1
    fi
    echo -n "${token}" > ~/.vault-token
}

get_secret() {
    vault read -format=json ${1} | jq -r '.data'
}
