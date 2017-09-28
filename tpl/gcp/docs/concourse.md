#### [Back](../README.md)

## Concourse

### Prerequisites

- Vault [deployed and initialized](vault.md)

### Setup

Fill out the "token" field in `deployments/concourse/concourse.yml` with root token received from `vault init`.

Deploy Concourse
```
./bin/concourse-deploy.sh
```

### Test

To run a test Concourse job:

- Go to test folder: `cd deployments/concourse/test`
- Fill out `test-credentials.yml`
- Add necessary secrets to your Vault(see [docs/vault.md](docs/vault.md))
- Download the `fly` client from Concourse web panel and add it to your PATH: `mv *path_to_fly* /usr/local/bin`
- Login to Concourse using the `fly` client: `fly -t ci --concourse-url *concourse-url*`
- Create a test pipeline with `fly set-pipeline -t ci -c test-pipeline.yml -p test --load-vars-from test-credentials.yml -n`
- Unpause pipeline: `fly unpause-pipeline -t ci -p test`
- Trigger and unpause the test job: `fly trigger-job -t ci -j test/test-publish`
- See the results on Concourse web panel or use: `fly watch -p test -j test/test-publish`
