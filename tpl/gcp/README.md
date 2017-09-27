## GCP Cloud

### Usage

Set path to your service account credentials:
```
export GOOGLE_CREDENTIALS=*~/credentials/service-account.json*
```

Apply terraform code
```
pushd terraform && terraform init && terraform apply && popd
```

Render bosh deployment
```
kite render manifest bosh --cloud=gcp
```

Setup tunnel
```
. bin/setup-tunnel.sh
```

Install BOSH
```
./bin/bosh-install.sh
```

Connect to the Director
```
. bin/set-env.sh

```

Deploy Vault
```
./bin/vault-deploy.sh
```

Follow instructions from `docs/vault.md` to initialize Vault

Render Concourse deployment
```
kite render manifest concourse --cloud=gcp
```

Fill out Vault-related fields in `deployments/concourse/concourse.yml`

Deploy Concourse
```
./bin/concourse-deploy.sh
```

[Optional]

To run a test Concourse job:

- Go to test folder: `cd deployments/concourse/test`
- Fill out `test-credentials.yml`
- Add necessary secrets to your Vault(see `docs/vault.md`)
- Login to Concourse using the `fly` client: `fly -t ci --concourse-url *concourse-url*`
- Create a test pipeline with `fly set-pipeline -t ci -c test-pipeline.yml -p test --load-vars-from test-credentials.yml -n`
- Unpause pipeline `fly unpause-pipeline -t ci -p test`
- Trigger and unpause the test job `fly trigger-job -t ci -j test/test-publish`
- See the results on Concourse web panel or use `fly watch -p test -j test/test-publish`
