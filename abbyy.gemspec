# frozen_string_literal: true

require_relative "lib/abbyy/version"

Gem::Specification.new do |spec|
  spec.name = "abbyy"
  spec.version = Abbyy::VERSION
  spec.authors = ["Robert"]
  spec.email = ["16901597+aquaflamingo@users.noreply.github.com"]

  spec.summary = "CLI for OCR vendors"
  spec.description = "CLI for OCR vendors"
  spec.homepage = "https://github.com/aquaflamingo/abbyy"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "thor", "~> 1.1.0"
  spec.add_dependency "rest-client", "~> 2.1.0"
end
