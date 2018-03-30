# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kite/version'

Gem::Specification.new do |spec|
  spec.name          = "kite"
  spec.version       = Kite::VERSION
  spec.authors       = ["Louis Bellet"]
  spec.email         = ["lbellet@heliostech.fr"]

  spec.summary       = %q{Command line tool for devops scaffolding.}
  spec.description   = %q{Kite is a bootstraping tool for your cloud provider and long term administration.}
  spec.homepage      = "http://www.heliostech.fr"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "bin"
  spec.executables   = ["kite"]
  spec.require_paths = ["lib"]

  spec.add_dependency "thor"
  spec.add_dependency "git"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.7"
  spec.add_development_dependency "git"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "codecov"
end
