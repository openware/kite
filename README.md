# Kite

[![Build Status](https://travis-ci.org/helios-technologies/kite.svg?branch=master)](https://travis-ci.org/helios-technologies/kite)

Kite is a CLI for scaffolding and managing devops modules
The main purpose is templating of various tools for devops around terraform, bosh, ansible

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

To start using kite from scratch:
- Create a new kite project, use `kite new`
- Fill out the `config/cloud.yml` file with your credentials.
- For BOSH you'll need an SSH key, to generate one, use `ssh-keygen -f *path_to_key*`
- Generate the cloud IaC needed with `kite generate --cloud=*aws or gcp*`
- Continue with instructions from newly generated README.md


To list all Kite commands, use

```shell
$> kite help
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/helios-technologies/kite.
