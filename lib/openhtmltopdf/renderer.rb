# frozen_string_literal: true

require "fileutils"
require "open3"
require "tempfile"

module OpenHtmlToPdf
  class Renderer
    def initialize(java_jar:)
      @java_jar = File.expand_path(java_jar)
    end

    def render(html:, output:, base_url: nil)
      raise ArgumentError, "HTML cannot be empty" if html.to_s.strip.empty?

      output = File.expand_path(output)
      FileUtils.mkdir_p(File.dirname(output))

      html_file = Tempfile.new(["openhtmltopdf-", ".html"])

      begin
        html_file.binmode
        html_file.write(html.to_s.encode("UTF-8"))
        html_file.flush

        command = ["java", "-jar", @java_jar, html_file.path, output]
        command << resolve_base_url(base_url) if base_url

        stdout, stderr, status = run(command)

        unless status.success?
          raise Error,
                "OpenHTMLtoPDF failed\n\n" \
                "STDOUT:\n#{stdout}\n\n" \
                "STDERR:\n#{stderr}"
        end

        output
      ensure
        html_file.close
        html_file.unlink
      end
    end

    private

    def run(command)
      Open3.capture3(*command)
    rescue Errno::ENOENT
      raise Error,
            "Java executable not found. Install Java 11 or newer and ensure `java` is on PATH."
    end

    def resolve_base_url(base_url)
      base_url = base_url.to_s
      return base_url if base_url.include?("://")

      File.expand_path(base_url)
    end
  end
end
