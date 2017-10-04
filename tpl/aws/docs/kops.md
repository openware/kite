#### KOPS

### Prerequisites

- [kubectl](https://github.com/kubernetes/kops/blob/master/docs/install.md#kubectl) installed
- [kops](https://github.com/kubernetes/kops/blob/master/docs/install.md) client installed
- Amazon S3 bucket for storing cluster's state created
- Route 53 domain for cluster access
-  IAM user with correct policies:
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

Create cluster configuration
```
kops create cluster --name *kops.example.com* --state "s3://kops-example-state-store" --zones *eu-central-1b*
```

Review and edit cluster configuration if needed
```
kops edit cluster *kops.example.com*
```

Build the cluster
```
kops update cluster *kops.example.com* --yes
```
