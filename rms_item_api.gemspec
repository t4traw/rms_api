# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rms_item_api/version'

Gem::Specification.new do |spec|
  spec.name          = "rms_item_api"
  spec.version       = RmsItemApi::VERSION
  spec.authors       = ["t4traw"]
  spec.email         = ["t4traw@gmail.com"]

  spec.summary       = %q{RMSの商品APIを簡単に叩けるrubyラッパー}
  spec.description   = %q{RMSの商品APIを簡単に叩けるrubyラッパー}
  spec.homepage      = "https://github.com/t4traw/rms_item_api"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday"
  spec.add_dependency "activesupport"
  spec.add_dependency "activemodel"
  spec.add_dependency "builder"
  spec.add_dependency "oga"
  spec.add_dependency "hashie"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
end
