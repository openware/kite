# Kite concourse resource

When you define kite resource you should defind `kubeconfig` or kite can generate it from defined `token`, `endpoint`, `user`, `cluster`, `certificate-authority` parameters.

Here is description of parameters:
- __token__ - service account token for your cluster
- __endpoint__ - cluster server adress
- __certificate-autority__ - service account certificate for cluster

### Where to get this parameters ?

Get secret's name
```shell
kubectl get serviceAccount <service_account_name> -oyaml
echo -n SECRET | base64 -d
```

Then look on secret's yaml. Here you can find certificate-authority and token values:
```shell
kubectl get secrets <secrets_name> -oyaml
echo -n SECRET | base64 -d
```

Find server address:
```shell
kubectl config view
```

*Example*

```yaml
resource_types:
  - name: kite
    type: docker-image
    source:
      repository: heliostech/kite

resources:
  - name: kite-test
    type: kite
    source:
      token: {{sa_token}}
      endpoint: {{server_ip}}
      certificate-autority: {{certificate-autority}}
```
