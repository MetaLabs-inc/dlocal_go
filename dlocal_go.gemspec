# frozen_string_literal: true

require_relative "lib/dlocal_go/version"

Gem::Specification.new do |spec|
  spec.name = "dlocal_go"
  spec.version = DlocalGo::VERSION
  spec.authors = ["matiassalles99"]
  spec.email = ["matiassalles99@gmail.com"]

  spec.summary = "Dlocal Go client for ruby"
  spec.description = "Dlocal Go client written in ruby to interact with Dlocal Go's API"
  spec.homepage = "https://metalabs.software"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://metalabs.software"
  spec.metadata["changelog_uri"] = "https://metalabs.software"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "http"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
