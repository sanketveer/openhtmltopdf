require "openhtmltopdf"

html = <<~HTML
  <!DOCTYPE html>
  <html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <meta charset="UTF-8" />
    <title>Accessibility Test</title>

    <style>
      @page {
        size: A4;
        margin: 40pt;
      }

      body {
        font-family: Arial;
        font-size: 16pt;
      }

      h1 {
        font-size: 24pt;
      }

      h2 {
        font-size: 20pt;
      }
    </style>
  </head>

  <body>
    <h1>Hello from OpenHtmlToPdf Gem</h1>

    <p>
      This PDF was generated through Ruby and Java.
    </p>

    <h2>Accessibility Test</h2>

    <p>
      This is a PDF/UA accessibility test.
    </p>
  </body>
  </html>
HTML

output = OpenHtmlToPdf.render(
  html,
  output: "gem-test.pdf"
)

puts "PDF generated: #{output}"
