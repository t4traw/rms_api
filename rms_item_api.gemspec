lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rms_item_api/version'

Gem::Specification.new do |spec|
  spec.name          = 'rms_item_api'
  spec.version       = RmsItemApi::VERSION
  spec.authors       = %w[t4traw]
  spec.email         = %w[t4traw@gmail.com]

  spec.summary       = 'RMSの商品APIを簡単に叩けるrubyラッパー'
  spec.description   = 'RMSの商品APIを簡単に叩けるrubyラッパー'
  spec.homepage      = 'https://github.com/t4traw/rms_item_api'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = %w[lib]

  spec.add_dependency 'activemodel', '>= 4.2.8'
  spec.add_dependency 'activesupport', '>= 4.2.8'
  spec.add_dependency 'builder'
  spec.add_dependency 'faraday', '>= 0.12.1'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'dotenv'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'minitest-reporters'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake', '>= 12.3.3'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'
end
