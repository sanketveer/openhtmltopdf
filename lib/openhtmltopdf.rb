# frozen_string_literal: true

require "fileutils"
require "tempfile"

require_relative "openhtmltopdf/version"

module OpenHtmlToPdf
  class Error < StandardError
  end

  JAVA_JAR = File.expand_path(
    "openhtmltopdf/java/openhtmltopdf-runner-0.1.0-jar-with-dependencies.jar",
    __dir__
  )

  def self.java_jar
    unless File.exist?(JAVA_JAR)
      raise Error,
            "OpenHTMLtoPDF Java JAR not found: #{JAVA_JAR}\n" \
            "Run `mvn clean package` inside the java directory."
    end

    JAVA_JAR
  end

  def self.render(html, output:, base_url: nil)
    Renderer.new(
      java_jar: java_jar
    ).render(
      html: html,
      output: output,
      base_url: base_url
    )
  end
end

require_relative "openhtmltopdf/renderer"