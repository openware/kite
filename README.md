# Kite

![Build Status](https://ci.helioscloud.com/api/v1/teams/heliostech/pipelines/kite/jobs/build-master/badge)
[![Build Status](https://travis-ci.org/helios-technologies/kite.svg?branch=master)](https://travis-ci.org/helios-technologies/kite)
[![codecov](https://codecov.io/gh/helios-technologies/kite/branch/master/graph/badge.svg)](https://codecov.io/gh/helios-technologies/kite)


Kite is a CLI for scaffolding and managing devops modules
The main purpose is templating of various tools for devops around terraform, bosh, ansible
Currently Kite support one Stack on both AWS and GCP.

We plan in adding community stack using a simple template repository structure.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kite'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kite

## Usage

To start using kite for bootstraping your infrastructure
follow the steps below :

### Create your Infrastructure as Code base repository

Create a new kite project using:

```
$ kite new PROJECT_NAME
```

### Configure your cloud and credentials

- Fill out the `config/cloud.yml` file with your credentials.
- For BOSH you'll need an SSH key, to generate one, use `ssh-keygen -f *path_to_key*`

### Generate your infrastructure using terraform

Generate the cloud IaC needed with

```
$ kite generate cloud --provider=aws|gcp
```

you can now review and apply your terraform files.

### Deploy the default stack (BOSH / Concourse / Vault / Kubernetes)

Continue with instructions from newly generated README.md

## Getting help

To list all Kite commands, use

```shell
$> kite help
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Concourse Resource

To use resource scripts locally, set env variable `is_devel` to `true`, e.h.:

```sh
$ is_devel=true ./bin/concourse/in
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/helios-technologies/kite.
