# OpenHTMLtoPDF Ruby Gem

A Ruby wrapper around [OpenHTMLtoPDF](https://github.com/danfickle/openhtmltopdf) for converting HTML documents to PDF.

The gem runs a Java-based OpenHTMLtoPDF runner internally. The runner JAR is packaged with the gem, so Ruby applications can generate PDFs without a separate Java project at runtime.

## Features

- Convert HTML strings to PDF
- Convert HTML files to PDF
- Embedded fonts (Myriad Pro family)
- PDF/UA accessibility mode through the OpenHTMLtoPDF Java renderer
- Designed for Ruby on Rails applications

## Requirements

- Ruby `>= 3.2`
- Java 11 or newer (`java` on `PATH`)

```bash
java -version
```

## Installation

```ruby
gem "openhtmltopdf"
```

```bash
bundle install
```

Or install directly:

```bash
gem install openhtmltopdf
```

## Usage

### Render an HTML string

```ruby
require "openhtmltopdf"

OpenHtmlToPdf.render(
  "<h1>Invoice</h1><p>Thank you.</p>",
  output: "invoice.pdf"
)
```

### Render an HTML file

```ruby
OpenHtmlToPdf.render_file(
  "article.html",
  output: "article.pdf"
)
```

Relative images, stylesheets and links in `article.html` are resolved against the file's directory.

### Base URL

Pass `base_url:` to control how relative references are resolved when rendering a string. It may be a directory path or a URL:

```ruby
OpenHtmlToPdf.render(
  html,
  output: "report.pdf",
  base_url: "/srv/app/public"
)
```

If omitted, relative references are resolved against the temporary directory used for the render, so use absolute URLs or pass `base_url:`.

Both methods create missing output directories and return the output path.

## Rails Usage

```ruby
pdf_path = Rails.root.join("tmp", "article.pdf")

OpenHtmlToPdf.render(
  article_html,
  output: pdf_path.to_s,
  base_url: Rails.root.join("public").to_s
)
```

Return the file from a controller:

```ruby
send_file pdf_path,
          type: "application/pdf",
          disposition: "inline"
```

## Errors

- `OpenHtmlToPdf::Error` is raised when the runner fails (the message includes its STDOUT/STDERR), when `java` is not installed, when the bundled JAR is missing, or when `render_file` gets a missing path.
- `ArgumentError` is raised for empty HTML.

## Fonts

The runner embeds the Myriad Pro family and registers it as the font family `MyriadPro` with weights 300 (light), 400 (regular), 600 (semibold) and 700 (bold):

```css
body {
  font-family: MyriadPro;
}
```

Verify embedding with:

```bash
pdffonts output.pdf
```

The important columns are `emb = yes`, `sub = yes` and `uni = yes`.

## PDF Accessibility

The runner enables OpenHTMLtoPDF's PDF/UA mode. The PDF structure comes from semantic HTML (headings, paragraphs, lists, tables, `alt` text on images, `lang` and `<title>`).

Validate output with a PDF/UA validator such as veraPDF:

```bash
verapdf -f ua1 output.pdf
```

Compliance also depends on the content of the source HTML. Validate production documents, not only test documents.

## Development

```bash
git clone https://github.com/sanketveer/openhtmltopdf.git
cd openhtmltopdf
bundle install

# Rebuild the Java runner (only needed when java/ changes)
cd java && mvn clean package && cp target/openhtmltopdf-runner-0.1.0-jar-with-dependencies.jar ../lib/openhtmltopdf/java/ && cd ..

bundle exec rspec                 # all tests
bundle exec rspec --tag ~integration   # Ruby-only tests, no Java needed
ruby -Ilib gem_test.rb            # manual smoke test, writes gem-test.pdf
```

## Building and Installing the Gem

```bash
gem build openhtmltopdf.gemspec
gem contents ./openhtmltopdf-0.1.0.gem | grep jar   # confirm runner is packaged
gem install ./openhtmltopdf-0.1.0.gem
ruby -e 'require "openhtmltopdf"; puts OpenHtmlToPdf.java_jar'
```

## Project Structure

```text
openhtmltopdf/
├── java/                       # Java runner (Maven project)
│   ├── pom.xml
│   └── src/main/
│       ├── java/com/cureus/openhtmltopdf/PdfRenderer.java
│       └── resources/fonts/    # Myriad Pro font files
├── lib/
│   ├── openhtmltopdf.rb        # Public API
│   └── openhtmltopdf/
│       ├── renderer.rb         # Runs the Java runner
│       ├── version.rb
│       └── java/               # Packaged runner JAR
├── sig/                        # RBS signatures
├── spec/
├── gem_test.rb
├── Gemfile
├── Rakefile
└── openhtmltopdf.gemspec
```

## Java Runner

The runner (`java -jar runner.jar <input.html> <output.pdf> [base-uri]`):

1. Reads the HTML input.
2. Resolves the base URI (the optional third argument, otherwise the HTML file's directory).
3. Registers the embedded fonts.
4. Renders the document with OpenHTMLtoPDF in PDF/UA mode.

## License

MIT
