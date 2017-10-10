#### KOPS

### Prerequisites

- [kubectl](https://github.com/kubernetes/kops/blob/master/docs/install.md#kubectl) installed
- [kops](https://github.com/kubernetes/kops/blob/master/docs/install.md) client installed
- SSH key generated(needed for accessing cluster's master)
- Amazon S3 bucket for storing cluster's state created
- Route 53 domain for cluster access
- IAM user with correct policies:
     - AmazonEC2FullAccess
     - AmazonRoute53FullAccess
     - AmazonS3FullAccess
     - IAMFullAccess
     - AmazonVPCFullAccess

### Setup

Export AWS access keys and ID if you didn't before
```
export AWS_ACCESS_KEY_ID=<access key>
export AWS_SECRET_ACCESS_KEY=<secret key>
```

Deploy the `kops` cluster
```
./bin/kops-deploy.sh
```

### Teardown

To tear down the kops cluster you've created, just run
```
./bin/kops-delete.sh
```
