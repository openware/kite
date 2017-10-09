#### [Back](../README.md)

## Concourse

### Prerequisites

- Vault [deployed and initialized](vault.md)

### Setup

Fill out the "token" field in `deployments/concourse/concourse.yml` with root token received from `vault init`.

Deploy Concourse by running the script with the required arguments
```
./bin/concourse-deploy.sh *concourse_auth_password* *concourse_db_password* *vault_token*
```

### Connect GitHub oAuth

To configure GitHub oAuth, you'll first need to [create](https://developer.github.com/apps/building-integrations/setting-up-and-registering-oauth-apps/registering-oauth-apps) a GitHub oAuth app.

```
fly set-team -n concourse \
    --github-auth-client-id D \
    --github-auth-client-secret $CLIENT_SECRET \
    --github-auth-team concourse/Pivotal
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
