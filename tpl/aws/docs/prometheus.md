#### [Back](../README.md)

## Prometheus

### Prerequisites

- BOSH environment [ready](bosh.md)
- Kops cluster [deployed](kops.md)

### Setup

Enter path to your Kubernetes config in `config/cloud.yml` and add the Kubernetes API server address to `config/bosh_vars.yml`.

Afterwards, deploy Prometheus
```
./bin/prometheus-deploy.sh
```

### Access

After the deployment process is done, you can reach each Prometheus' component's web UI at:

If you have [Ingress](ingress.md) deployed and DNS record created, each Prometheus stack component should be accessible by its respective address.

Without Ingress:

- AlertManager: http://10.0.0.18:9093
- Grafana:      http://10.0.0.18:3000
- Prometheus:   http://10.0.0.18:9090

You can find related credentials in `config/creds.yml`
