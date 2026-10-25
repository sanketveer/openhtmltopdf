# OpenHTMLtoPDF Ruby Gem

A Ruby wrapper around [OpenHTMLtoPDF](https://github.com/danfickle/openhtmltopdf) for converting HTML documents to PDF.

The gem uses a Java-based OpenHTMLtoPDF runner internally. The Java runner is packaged with the gem, so Ruby applications can invoke PDF generation without requiring a separate Java project at runtime.

## Features

- Convert HTML files to PDF
- Convert HTML strings to PDF
- Uses OpenHTMLtoPDF internally
- Java runner packaged inside the gem
- Supports embedded fonts
- PDF/UA accessibility support through the OpenHTMLtoPDF Java renderer
- Designed for Ruby on Rails applications
- Java 11 compatible

## Requirements

- Ruby `>= 3.2`
- Java 11 or newer

Check Java:

```bash
java -version
```

The current Java runner is built and tested with Java 11.

## Installation

Add the gem to your application's Gemfile:

```ruby
gem "openhtmltopdf"
```

Then:

```bash
bundle install
```

Or install the gem directly:

```bash
gem install openhtmltopdf
```

## Basic Usage

Render an HTML file:

```ruby
require "openhtmltopdf"

OpenHtmlToPdf.render(
  "input.html",
  "output.pdf"
)
```

For example:

```ruby
OpenHtmlToPdf.render(
  "article.html",
  "article.pdf"
)
```

## Rendering HTML

The renderer can also accept HTML content directly.

```ruby
require "openhtmltopdf"

html = <<~HTML
  <!DOCTYPE html>
  <html>
    <head>
      <meta charset="UTF-8">
      <title>Example</title>
    </head>
    <body>
      <h1>Hello OpenHTMLtoPDF</h1>
      <p>This is a simple paragraph.</p>
    </body>
  </html>
HTML

OpenHtmlToPdf.render(
  html,
  "output.pdf"
)
```

## Rails Usage

The gem can be used from a Rails application.

For example:

```ruby
pdf_path = Rails.root.join("tmp", "article.pdf")

OpenHtmlToPdf.render(
  article_html,
  pdf_path.to_s
)
```

Then the generated PDF can be returned from a controller:

```ruby
send_file pdf_path,
          type: "application/pdf",
          disposition: "inline"
```

## PDF Accessibility

The Java renderer is configured to generate accessible PDF output using OpenHTMLtoPDF's PDF/UA support.

The PDF structure is generated from semantic HTML.

For example:

```html
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Accessible Document</title>
</head>

<body>
  <h1>Article Title</h1>

  <p>
    This is the article content.
  </p>

  <h2>Introduction</h2>

  <p>
    Additional article content.
  </p>
</body>
</html>
```

The resulting PDF should be validated with a PDF accessibility validator such as VeraPDF.

Example:

```bash
verapdf -f ua1 output.pdf
```

A compliant validation should report:

```text
isCompliant="true"
failedRules="0"
failedChecks="0"
```

PDF/UA compliance also depends on the source HTML structure, images, alternative text, tables, fonts, document metadata, and other content-specific requirements.

## Fonts

The Java runner includes an embedded Arial font:

```text
java/src/main/resources/fonts/Arial.ttf
```

The font is registered by the Java renderer and exposed to the HTML renderer as:

```css
body {
  font-family: Arial;
}
```

The generated PDF should contain the embedded font.

You can verify this using:

```bash
pdffonts output.pdf
```

For example:

```text
AAASQD+ArialMT  CID TrueType  Identity-H  yes  yes  yes
```

The important values are:

```text
emb = yes
sub = yes
uni = yes
```

## Testing the Java Runner

The Java runner is located in:

```text
java/
```

Build it with Maven:

```bash
cd java
mvn clean package
```

The executable JAR is generated at:

```text
java/target/openhtmltopdf-runner-0.1.0-jar-with-dependencies.jar
```

Test it directly:

```bash
java -jar \
  target/openhtmltopdf-runner-0.1.0-jar-with-dependencies.jar \
  test.html \
  test.pdf
```

Verify the generated PDF:

```bash
pdftotext test.pdf -
```

Check embedded fonts:

```bash
pdffonts test.pdf
```

Validate PDF/UA:

```bash
verapdf -f ua1 test.pdf
```

## Testing the Ruby Gem Locally

From the repository root:

```bash
bundle install
```

Verify that Ruby resolves the Java runner:

```bash
ruby -Ilib -e 'require "openhtmltopdf"; puts OpenHtmlToPdf.java_jar'
```

Run the Ruby integration test:

```bash
ruby -Ilib gem_test.rb
```

Expected result:

```text
PDF generated: .../gem-test.pdf
```

Then:

```bash
pdftotext gem-test.pdf -
```

And:

```bash
pdffonts gem-test.pdf
```

Finally:

```bash
verapdf -f ua1 gem-test.pdf
```

## Building the Gem

Build the gem with:

```bash
gem build openhtmltopdf.gemspec
```

Expected output:

```text
Successfully built RubyGem
Name: openhtmltopdf
Version: 0.1.0
File: openhtmltopdf-0.1.0.gem
```

Inspect the generated package:

```bash
gem contents ./openhtmltopdf-0.1.0.gem
```

You should verify that the Java runner is included in the gem.

## Installing the Locally Built Gem

Install the generated gem:

```bash
gem install ./openhtmltopdf-0.1.0.gem
```

Verify:

```bash
gem list openhtmltopdf
```

Then test:

```bash
ruby -e 'require "openhtmltopdf"; puts OpenHtmlToPdf.java_jar'
```

## Development

Clone the repository:

```bash
git clone https://github.com/sanketveer/openhtmltopdf.git
cd openhtmltopdf
```

Install dependencies:

```bash
bundle install
```

Build the Java runner:

```bash
cd java
mvn clean package
cd ..
```

Run the Ruby tests:

```bash
bundle exec rspec
```

Run the integration test:

```bash
ruby -Ilib gem_test.rb
```

## Project Structure

```text
openhtmltopdf/
├── bin/
├── java/
│   ├── pom.xml
│   ├── src/
│   │   └── main/
│   │       ├── java/
│   │       │   └── com/cureus/openhtmltopdf/
│   │       │       └── PdfRenderer.java
│   │       └── resources/
│   │           └── fonts/
│   │               └── Arial.ttf
│   └── test.html
├── lib/
│   ├── openhtmltopdf.rb
│   └── openhtmltopdf/
│       ├── renderer.rb
│       ├── java/
│       │   └── openhtmltopdf-runner-0.1.0-jar-with-dependencies.jar
│       └── version.rb
├── sig/
├── spec/
├── Gemfile
├── LICENSE.txt
├── README.md
├── Rakefile
└── openhtmltopdf.gemspec
```

## Java Runner

The Java runner is responsible for:

1. Reading the HTML input.
2. Resolving the HTML base URI.
3. Loading HTML and CSS.
4. Registering fonts.
5. Rendering the document using OpenHTMLtoPDF.
6. Generating the PDF.
7. Producing an accessible PDF structure when PDF/UA mode is enabled.

The Ruby layer is responsible for invoking the Java runner and exposing a Ruby-friendly API.

## PDF Validation Workflow

For accessibility development, use the following workflow:

```bash
# 1. Build Java renderer
cd java
mvn clean package

# 2. Generate PDF
java -jar \
  target/openhtmltopdf-runner-0.1.0-jar-with-dependencies.jar \
  test.html \
  test.pdf

# 3. Check extracted text
pdftotext test.pdf -

# 4. Check fonts
pdffonts test.pdf

# 5. Validate PDF/UA
verapdf -f ua1 test.pdf
```

For production documents, validation should be performed against the actual article/document HTML rather than only the test HTML.

## License

MIT