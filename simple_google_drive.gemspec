# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name        = "simple_google_drive"
  spec.version     = SimpleGoogleDrive::GEM_VERSION
  spec.authors     = ["Guilherme Vinicius Moreira"]
  spec.email       = ["gui.vinicius@gmail.com"]
  spec.summary     = "A simple interface for Google Drive API"
  spec.description = "A simple interface for Google Drive API"
  spec.homepage    = "https://github.com/guivinicius/simple_google_drive"
  spec.license     = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
