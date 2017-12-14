# Kite concourse resource

When you define kite resource you should defind `kubeconfig` or kite can generate it from defined `token`, `endpoint`, `user`, `cluster`, `certificate-authority` parameters.

Here is description of parameters, that kite needs to generate kubeconfig:
- __token__ - service account token for your cluster
- __endpoint__ - cluster server adress
- __cluster__ - name of cluster
- __user__ - username
- __certificate-autority__ - service account certificate for cluster

### Where to get this parameters ?

Get secret's name
```shell
kubectl get serviceAccount <service_account_name> -oyaml
```

Then look on secret's yaml. Here you can find certificate-authority and token values:
```shell
kubectl get secrets <secrets_name> -oyaml
```
Get cluste's name:
```shell
kubectl config current-context
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
      json_key: {{gcp_service_account_key}}
      token: {{sa_token}}
      endpoint: {{server_ip}}
      cluster: {{cluster_name}}
      name: {{username}}
      certificate-autority: {{certificate-autority}}
```
