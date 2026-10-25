# frozen_string_literal: true

require_relative "lib/openhtmltopdf/version"

Gem::Specification.new do |spec|
  spec.name = "openhtmltopdf"
  spec.version = Openhtmltopdf::VERSION
  spec.authors = ["Sanket Veer"]
  spec.email = ["146915033+SN-Sanket@users.noreply.github.com"]

  spec.summary = "Generate accessible, tagged PDFs from HTML using OpenHTMLtoPDF"
  spec.description = <<~DESC
    Ruby wrapper around OpenHTMLtoPDF for generating accessible,
    tagged PDF documents from HTML.
  DESC

  spec.homepage = "https://github.com/sanketveer/openhtmltopdf"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  gemspec = File.basename(__FILE__)

  spec.files = IO.popen(
    %w[git ls-files -z],
    chdir: __dir__,
    err: IO::NULL
  ) do |ls|
    ls.readlines("\x0", chomp: true).reject do |file|
      file == gemspec ||
        file.start_with?(
          "bin/",
          "Gemfile",
          ".gitignore",
          ".rspec",
          "spec/"
        )
    end
  end

  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) do |file|
    File.basename(file)
  end

  spec.require_paths = ["lib"]
end