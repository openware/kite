# Vault usage

## Prerequisites

Before using Vault, you should have the client installed:

- Download the binary for your OS
- Unzip it and run `chmod +x vault && sudo mv vault /usr/local/bin/vault`
- Check if the Vault is installed by running `vault -v`

## Deployment

To deploy Vault, use `bin/vault-deploy.sh`

## Connection

- Export your Vault's IP using `export VAULT_ADDR=*vault_ip*`
- Run `vault init` to initialize the vault
- Store the keys displayed after init
- Unseal the vault by running `vault unseal` three times using three keys from the previous step

[Optional]
- Try to store a dummy secret: `vault write secret/handshake knock=knock`
- Read it: `vault read secret/handshake`

You're good to go!
