require_relative 'lib/rms_api/version'

Gem::Specification.new do |spec|
  spec.name          = "rms_api"
  spec.version       = RmsApi::VERSION
  spec.authors       = ["t4traw"]
  spec.email         = ["t4traw@gmail.com"]

  spec.summary       = 'RMSのAPIを簡単に叩けるrubyラッパー'
  spec.description   = 'RMSのAPIを簡単に叩けるrubyラッパー'
  spec.homepage      = 'https://github.com/t4traw/rms_api'
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'activemodel', '>= 4.2.8'
  spec.add_dependency 'activesupport', '>= 4.2.8'
  spec.add_dependency 'builder'
  spec.add_dependency 'faraday', '>= 0.12.1'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'dotenv'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'minitest-reporters'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake', '>= 12.3.3'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'
end
