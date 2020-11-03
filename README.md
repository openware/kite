![Cryptocurrency Exchange Platform - OpenDAX](https://github.com/openware/meta/raw/main/images/github_opendax.png)

<h3 align="center">
<a href="https://www.openware.com/sdk">Guide</a> <span>&vert;</span>
<a href="https://www.openware.com/sdk/api.html">API Docs</a> <span>&vert;</span>
<a href="https://www.openware.com/">Consulting</a> <span>&vert;</span>
<a href="https://t.me/peatio">Community</a>
</h3>
<h6 align="center">Kite is part of <a href="https://github.com/openware/opendax">OpenDAX Trading Platform</a></h6>

---

# Kite

[![Gem Version](https://badge.fury.io/rb/kite.svg)](https://badge.fury.io/rb/kite)
[![license](https://img.shields.io/github/license/rubykube/kite.svg)](https://github.com/rubykube/kite/blob/master/LICENSE.md)

[![Build Status](https://travis-ci.org/rubykube/kite.svg?branch=master)](https://travis-ci.org/rubykube/kite)
[![codecov](https://codecov.io/gh/rubykube/kite/branch/master/graph/badge.svg)](https://codecov.io/gh/rubykube/kite)

Kite is a CLI for scaffolding and managing devops modules
The main purpose is templating of various tools for devops around terraform, bosh, ansible.
Currently Kite supports modular stacks(Kite modules) on both AWS and GCP.

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
follow the steps below.
[Note] Most kite commands can be referred by their first letter(for example `kite generate environment test` is the same as `kite g e test`)

### Create your Infrastructure as Code base repository

Create a new kite project using:

```
$ kite new PROJECT_NAME
```

### Generate an environment(e.g. development/test/production)

Kite environments are separated workspaces with their own credentials, variables and modules.

Generate an environment

```
$ kite generate environment *env_name* --provider=aws|gcp
```

If you want to change the credentials for an environment, edit `config/cloud.yml` and regenerate environment with the same command.

Now the environment should be generated at `config/environments/*env_name*`

### Add a module to your environment

To add a Kite module to your environment, you should first initialize it.
It's recommended to use specific module versions/tags(master branch would be used by default):

```
  kite module init https://url.for/your/module --env *env_name* --version *x.y.z/x-y-stable*
```

This should clone module's source files into `modules/*module_name*` and create a `vars.*module_name*.yml` file with all variables needed by the module.

Fill in `vars.*module_name*.yml` with correct values and render the module:

```
  kite module render modules/*module_name* --env *env_name*
```

### Apply Terraform configuration from the environment

Set your default gcloud credentials using

```
  gcloud auth application-default login
```

```
  kite terraform init
  kite terraform apply --env *env_name*
```

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
$ ruby -Ilib ./bin/concourse/in
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rubykube/kite.
