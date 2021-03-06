# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gipull/version'

Gem::Specification.new do |spec|
  spec.name          = "gipull"
  spec.version       = Gipull::VERSION
  spec.authors       = ["zaru"]
  spec.email         = ["zarutofu@gmail.com"]

  spec.summary       = %q{To get the pull request list of GitHub}
  spec.description   = %q{To get the pull request list of GitHub}
  spec.homepage      = "https://github.com/zaru/gipull"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "thor"
  spec.add_dependency "octokit"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency 'pry-byebug'
end
