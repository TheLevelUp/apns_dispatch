# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'apns_dispatch/version'

Gem::Specification.new do |gem|
  gem.name          = 'apns_dispatch'
  gem.version       = ApnsDispatch::VERSION
  gem.authors       = ['Costa Walcott']
  gem.email         = ['costa@scvngr.com']
  gem.summary       = 'A simple Ruby framework for communicating with the APNs'
  gem.description   = 'A simple Ruby framework for sending push notifications and receving feedback using the Apple Push Nofitication service'
  gem.homepage      = 'http://github.com/TheLevelUp/apns_dispatch'

  gem.files         = `git ls-files`.split($/)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})

  gem.add_dependency 'json', '~> 1.7.5'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec', '~> 2.0'

  gem.required_ruby_version = Gem::Requirement.new('>= 1.9.2')
  gem.require_paths = ["lib"]
end
