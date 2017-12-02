lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "statum/version"

Gem::Specification.new do |spec|
  spec.name    = "statum"
  spec.version = Statum::VERSION
  spec.authors = ["Alexey Bespalov"]
  spec.email   = ["alex.coder1@gmail.com"]

  spec.summary     = "Ruby gem to control your states"
  spec.description = "Ruby state machine"
  spec.homepage    = "https://github.com/nulldef/statum"
  spec.license     = "MIT"


  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "coveralls", "~> 0.8"
  spec.add_development_dependency "pry", "~> 0.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
