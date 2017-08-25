# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'verify/metadata/generator/version'

Gem::Specification.new do |spec|
  spec.name          = "verify-metadata-generator"
  spec.version       = Verify::Metadata::Generator::VERSION
  spec.authors       = ["Government Digital Service"]
  spec.email         = ["verify-tech@digital.cabinet-office.gov.uk"]
  spec.summary       = %q{A tool to generate metadata for the GOV.UK Verify federation}
  spec.homepage      = ""

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "cucumber"
  spec.add_development_dependency "aruba"
  spec.add_dependency "nokogiri"
  spec.add_dependency "activemodel"
  spec.add_dependency "json-schema"
end
