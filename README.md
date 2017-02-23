[![](https://images.microbadger.com/badges/image/docurated/concourse-vault-resource.svg)](https://microbadger.com/images/docurated/concourse-vault-resource "Get your own image badge on microbadger.com")

# Vault Resource

Reads secrets from [Vault](https://www.vaultproject.io/). Authentication is done (by default) using the [aws-ec2 method](https://www.vaultproject.io/docs/auth/aws-ec2.html), which must be configured before using this resource.
It can also use the [AppRole method](https://www.vaultproject.io/docs/auth/approle.html) to authenticate.

## Source Configuration

* `url`: *Optional.* The location of the Vault server. Defaults to `https://vault.service.consul:8200`.

* `role`: *Optional.* The role to authenticate as. Defaults to `concourse`.

* `nonce`: *Optional.* Client nonce whitelisted by Vault for this EC2 auth. Defaults to `vault-concourse-nonce`, which should probably be changed.

* `paths`: *Optional.* If specified (as a list of glob patterns), only changes
  to the specified files will yield new versions from `check`.
  
* `expose_token`: *Optional.* If specified, this option will expose the token to make it available to other resources
  
* `auth_method`: *Optional.* By default will use the `aws-ec2` method. If `AppRole` is specified, it will read the `role_id` and `secret_id` parameter to authenticate on the approle endpoint. 

* `role_id`: *Optional.* Use a specific role id to authenticate. This parameter is used only with `auth_method: AppRole`. 

* `secret_id`: *Optional.* Use a specific secret id to authenticate. This parameter is used only with `auth_method: AppRole`. 

* `tls_skip_verify`: *Optional.* Skips Vault SSL verification by exporting
  `VAUKT_SKIP_VERIFY=1`.

### Example

Resource configuration using aws-ec2 authentication:

``` yaml
resources:
- name: vault
  type: vault
  source:
    url: https://secure.legitcompany.com:8200
    role: build-server
    nonce: cantguessme
```

Resource configuration using AppRole authentication:

``` yaml
resources:
- name: vault
  type: vault
  source:
    url: https://secure.legitcompany.com:8200
    auth_method: AppRole
    role_id: e6889709-5ff8-c670-a083-79f1c5035709
    secret_id: e6889709-5ff8-c670-a083-79f1c5035709
```

Fetching secrets:

``` yaml
- get: vault
  params:
    paths:
      - secret/build/git
      - secret/build/aws/s3
```

## Behavior

### `check`: Check for new versions.

Essentially a noop, the current date is always returned as `{"date": "$DATE"}`

### `in`: Read secrets from Vault

Reads secrets from Vault and stores them on disk as JSON files.

The path of the secret will match the path on disk - ie in the example above, `vault/build/git.json` and `vault/build/aws/s3.json` will be created.

#### Parameters

* `paths`: *Required.* List of paths to read from the Vault secret mount.
