[![](https://images.microbadger.com/badges/image/docurated/concourse-vault-resource.svg)](https://microbadger.com/images/docurated/concourse-vault-resource "Get your own image badge on microbadger.com")

# Vault Resource

Reads secrets from [Vault](https://www.vaultproject.io/). Authentication is done using the [aws-ec2 method](https://www.vaultproject.io/docs/auth/aws-ec2.html), which must be configured before using this resource.

## Source Configuration

* `uri`: *Optional.* The location of the Vault server. Defaults to `https://vault.service.consul:8200`.

* `role`: *Optional.* The role to authenticate as. Defaults to `concourse`.

* `nonce`: *Optional.* Client nonce whitelisted by Vault for this EC2 auth. Defaults to `vault-concourse-nonce`, which should probably be changed.

* `paths`: *Optional.* If specified (as a list of glob patterns), only changes
  to the specified files will yield new versions from `check`.

* `tls_skip_verify`: *Optional.* Skips Vault SSL verification by exporting
  `VAUKT_SKIP_VERIFY=1`.

### Example

Resource configuration:

``` yaml
resources:
- name: vault
  type: vault
  source:
    uri: https://secure.legitcompany.com:8200
    role: build-server
    nonce: cantguessme
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
