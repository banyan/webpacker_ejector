
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "webpacker_ejector/version"

Gem::Specification.new do |spec|
  spec.name          = "webpacker_ejector"
  spec.version       = WebpackerEjector::VERSION
  spec.authors       = ["Kohei Hasegawa"]
  spec.email         = ["ameutau@gmail.com"]

  spec.summary       = %q{Eject webpacker}
  spec.description   = %q{Eject webpacker}
  spec.homepage      = "https://github.com/banyan/webpacker_ejector"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.8.4"
  spec.add_development_dependency "minitest-hooks", "~> 1.5.0"
  spec.add_development_dependency "rails", "~> 6.0.0.beta3"
end
