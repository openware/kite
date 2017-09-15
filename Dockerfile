FROM ruby:2.4.1

RUN apt-get update && apt-get install -y zip

# Install Terraform
RUN curl https://releases.hashicorp.com/terraform/0.10.5/terraform_0.10.5_linux_amd64.zip?_ga=2.49593953.619315674.1505216069-1504763789.1498760046 -o terraform.zip
RUN unzip terraform -d /usr/bin/terraform && chmod +x /usr/bin/terraform

# Install BOSH v2
RUN curl https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-2.0.31-linux-amd64 -o /usr/bin/bosh && chmod +x /usr/bin/bosh

# Copy kite source, build and install the gem , egnerate a test cloud skeleton
COPY . /kite
WORKDIR /kite
RUN bundle && rake build && gem install pkg/kite-*
RUN kite new test
