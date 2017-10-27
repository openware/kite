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

- AlertManager: http://10.0.0.14:9093
- Grafana:      http://10.0.0.15:3000
- Prometheus:   http://10.0.0.16:9090

You can find related credentials in `config/creds.yml`
