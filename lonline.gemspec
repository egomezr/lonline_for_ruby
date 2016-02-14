# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lonline/version'

Gem::Specification.new do |spec|
  spec.name = 'lonline'
  spec.version = LONLINE::VERSION
  spec.authors = ['lonline']
  spec.email = ['support@dynamicloud.com']
  spec.date = '2016-02-12'

  spec.summary = %q{This gem allows you to log into the cloud using Dynamicloud.}
  spec.description = %q{
    You will be able to execute the following operations:
    lonline.log.trace() -
    lonline.log.debug() -
    lonline.log.info() -
    lonline.log.warn() -
    lonline.log.error() -
    lonline.log.fatal() - Additionally, Lonline provides methods to get report about your logs.

  }
  spec.homepage = 'https://rubygems.org/gems/lonline'
  spec.license = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubyGems.org.com'
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = Dir['lib/**/*.rb']
  #spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rails'

  spec.add_runtime_dependency 'dynamicloud'
  spec.add_runtime_dependency 'json'
end