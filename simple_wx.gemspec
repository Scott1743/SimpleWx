# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simple_wx/version'

Gem::Specification.new do |spec|
  spec.name          = "simple_wx"
  spec.version       = SimpleWx::VERSION
  spec.authors       = ["Scott1743"]
  spec.email         = ["512981271@qq.com"]
  spec.summary       = ""
  spec.description   = %q{Ruby Api for Wechat(WeiXin)}
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'rest-client', '>= 1.6.1'
  spec.add_dependency 'redis', '>= 2.0.0'
  spec.add_dependency 'yell', '>= 1.2.0'
  spec.add_dependency 'nokogiri', '>= 1.4.4'

  spec.add_development_dependency "bundler", "~> 1.6"

end
