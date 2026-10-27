# frozen_string_literal: true

require_relative "openhtmltopdf/version"
require_relative "openhtmltopdf/renderer"

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
            "Reinstall the gem, or run `mvn clean package` inside the java directory."
    end

    JAVA_JAR
  end

  # Render an HTML string to a PDF file.
  #
  #   OpenHtmlToPdf.render("<h1>Hi</h1>", output: "hi.pdf")
  #
  # base_url: directory or URL used to resolve relative links, images and CSS.
  def self.render(html, output:, base_url: nil)
    Renderer.new(java_jar: java_jar).render(
      html: html,
      output: output,
      base_url: base_url
    )
  end

  # Render an HTML file to a PDF file. Relative assets are resolved against
  # the HTML file's directory unless base_url is given.
  #
  #   OpenHtmlToPdf.render_file("article.html", output: "article.pdf")
  def self.render_file(path, output:, base_url: nil)
    path = File.expand_path(path)
    raise Error, "HTML file not found: #{path}" unless File.file?(path)

    render(
      File.read(path, encoding: "UTF-8"),
      output: output,
      base_url: base_url || File.dirname(path)
    )
  end
end
