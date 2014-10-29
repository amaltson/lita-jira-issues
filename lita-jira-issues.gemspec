Gem::Specification.new do |spec|
  spec.name          = "lita-jira-issues"
  spec.version       = "0.1.0"
  spec.authors       = ["Arthur Maltson"]
  spec.email         = ["arthur@maltson.com"]
  spec.description   = "Show JIRA issue details in Lita"
  spec.summary       = "Lita plugin for listing JIRA issue details when they are mentioned in chat."
  spec.homepage      = "https://github.com/amaltson/lita-jira-issues"
  spec.license       = "MIT"
  spec.metadata      = { "lita_plugin_type" => "handler" }

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "lita", "~> 3.3"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", ">= 3.0.0"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "coveralls"
end
