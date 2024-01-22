require_relative 'lib/sip2/version'

Gem::Specification.new do |spec|
  spec.name          = "sip2-parser"
  spec.version       = Sip2::VERSION
  spec.authors       = ["Daniel Sandbecker"]
  spec.email         = ["daniel.sandbecker@hb.se"]

  spec.summary       = "Parse and encode SIP2 messages"
  spec.description   = <<-EOS
    A library and executables for parsing and encoding SIP2 messages (a standard
    for data exchange between Library Automation Systems and Library Systems).
  EOS
#  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

#  spec.metadata["homepage_uri"] = spec.homepage
#  spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
#  spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files = Dir.glob("{lib,test}/**/*") + %w[
      LICENSE.txt
      Rakefile
      README.md
      sip2-parser.gemspec
    ]
  spec.bindir        = "bin"
  spec.executables   = %w[sip2-to-json json-to-sip2]
  spec.require_paths = %w[lib]

  spec.add_runtime_dependency "dry-struct", "~> 1.4"
  spec.add_runtime_dependency "parslet", "~> 2.0"
  spec.add_runtime_dependency "yajl-ruby", "~> 1.4"

  spec.add_development_dependency "minitest", "~> 5.19"
  spec.add_development_dependency "minitest-reporters", "~> 1.6"
  spec.add_development_dependency "pry"
end
