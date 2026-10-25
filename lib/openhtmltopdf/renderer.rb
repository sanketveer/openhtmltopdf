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
        html_file.write(html)
        html_file.flush

        command = [
          "java",
          "-jar",
          @java_jar,
          html_file.path,
          output
        ]

        stdout, stderr, status = Open3.capture3(*command)

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
  end
end