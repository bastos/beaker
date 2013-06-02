# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'beaker/version'

Gem::Specification.new do |spec|
  spec.name          = "beaker"
  spec.version       = Beaker::VERSION
  spec.authors       = ["Tiago Bastos"]
  spec.email         = ["contact@tiagobastos.me"]
  spec.description   = %q{A simple BERT-RPC server}
  spec.summary       = %q{BERT-RPC server}
  spec.homepage      = "https://github.com/bastos/beaker"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rspec", ">= 2.14.rc1"
  spec.add_development_dependency "bertrpc", "~> 1.3.1"

  spec.add_dependency "rake"
  spec.add_dependency "celluloid-io", "~> 0.14.1"
  spec.add_dependency "yell", "~> 1.3.0"
  spec.add_dependency "dotenv", "~> 0.6.0"
  spec.add_dependency "bert", "~> 1.1.6"
  spec.add_dependency "activesupport", "~> 3.2.13"
  spec.add_dependency "pry", "~> 0.9.12"
end
