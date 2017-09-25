FROM ubuntu:trusty AS kitehelper

RUN apt-get update && apt-get install -y \
	nano \
	ssh \
	wget \
	unzip \
	graphviz \
	git

# install dependencies fpr bosh-init (see https://bosh.io/docs/install-bosh-init.html )
RUN apt-get install -y build-essential zlibc zlib1g-dev ruby ruby-dev openssl libxslt-dev libxml2-dev libssl-dev libreadline6 libreadline6-dev libyaml-dev libsqlite3-dev sqlite3

# install terraform
RUN wget -q https://releases.hashicorp.com/terraform/0.10.4/terraform_0.10.4_linux_amd64.zip; \
	unzip terraform_0.10.4_linux_amd64.zip; \
	chmod +x terraform; \
	mv terraform /usr/local/bin; \
# install bosh-init
	wget -q https://s3.amazonaws.com/bosh-init-artifacts/bosh-init-0.0.103-linux-amd64; \
	chmod +x bosh-init-*; \
	mv bosh-init-* /usr/local/bin/bosh-init; \
# install bosh cli v2
	wget -q https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-2.0.31-linux-amd64; \
	chmod +x bosh-cli-*; \
	mv bosh-cli-* /usr/local/bin/bosh; \
# compile and install kite
	cd /root; \
	git clone https://github.com/helios-technologies/kite.git; \
	cd kite; \
	gem build kite.gemspec; \
	gem install kite-0.0.?.gem;

# make dir for ssh keys
RUN mkdir /root/.ssh

COPY create_new_cloud.sh /root
RUN chmod u+x /root/create_new_cloud.sh
