FROM ruby:2.4.1

RUN apt-get update && apt-get install -y zip curl wget

# Install Terraform
RUN curl https://releases.hashicorp.com/terraform/0.10.5/terraform_0.10.5_linux_amd64.zip?_ga=2.49593953.619315674.1505216069-1504763789.1498760046 -o terraform.zip
RUN unzip terraform -d /usr/bin/terraform && chmod +x /usr/bin/terraform

# Install BOSH v2
RUN curl https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-2.0.31-linux-amd64 -o /usr/bin/bosh && chmod +x /usr/bin/bosh

# Install kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.8.0/bin/linux/amd64/kubectl && \
      chmod +x ./kubectl && \
      mv ./kubectl /usr/local/bin/kubectl

# Install helm
RUN curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash

# Install Kite
RUN gem install kite
