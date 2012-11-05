# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'apns_dispatch/version'

Gem::Specification.new do |gem|
  gem.name          = "apns_dispatch"
  gem.version       = ApnsDispatch::VERSION
  gem.authors       = ["Costa Walcott"]
  gem.email         = ["costa@scvngr.com"]
  gem.description   = %q{A simple Ruby framework for sending push notifications and receving feedback using the Apple Push Nofitication service}
  gem.summary       = %q{A simple Ruby framework for communicating with the APNs}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
