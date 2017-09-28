#### [Back](../README.md)

## BOSH

### Prerequisites

- Terraform IaC applied
- [BOSH CLI v2](https://bosh.io/docs/cli-v2.html#install) installed

### Setup

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
