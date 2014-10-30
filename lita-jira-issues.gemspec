Gem::Specification.new do |spec|
  spec.name          = "lita-jira-issues"
  spec.version       = "0.1.0"
  spec.authors       = ["Arthur Maltson"]
  spec.email         = ["arthur@maltson.com"]
  spec.description   = "Lita handler to show JIRA issue details"
  spec.summary       = %q{Lita handler that looks for JIRA issue keys and
  helpfully inserts details into the chat conversation.}
  spec.homepage      = "https://github.com/amaltson/lita-jira-issues"
  spec.license       = "MIT"
  spec.metadata      = { "lita_plugin_type" => "handler" }

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "lita", "~> 3.3"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake", "~> 10.3"
  spec.add_development_dependency "rspec", ">= 3.0.0"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "coveralls"
end
