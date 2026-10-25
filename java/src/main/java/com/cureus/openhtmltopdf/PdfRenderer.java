package com.cureus.openhtmltopdf;

import com.openhtmltopdf.pdfboxout.PdfRendererBuilder;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;

public class PdfRenderer {

    private static final String FONT_RESOURCE =
        "/fonts/Arial.ttf";

    private static final String FONT_FAMILY =
        "Arial";

    public static void main(String[] args) throws Exception {

        if (args.length != 2) {
            System.err.println(
                "Usage: PdfRenderer <input.html> <output.pdf>"
            );
            System.exit(1);
        }

        File htmlFile =
            new File(args[0]).getAbsoluteFile();

        File outputFile =
            new File(args[1]).getAbsoluteFile();

        if (!htmlFile.exists()) {
            throw new IllegalArgumentException(
                "HTML file not found: " +
                htmlFile.getAbsolutePath()
            );
        }

        File parentDirectory =
            htmlFile.getParentFile();

        if (parentDirectory == null) {
            throw new IllegalArgumentException(
                "Could not determine HTML parent directory"
            );
        }

        String html =
            Files.readString(
                htmlFile.toPath(),
                StandardCharsets.UTF_8
            );

        String baseUri =
            parentDirectory.toURI().toString();

        System.out.println(
            "Input HTML : " +
            htmlFile.getAbsolutePath()
        );

        System.out.println(
            "Output PDF : " +
            outputFile.getAbsolutePath()
        );

        System.out.println(
            "Base URI   : " +
            baseUri
        );

        System.out.println(
            "HTML size  : " +
            html.length()
        );

        /*
         * Load the bundled font.
         */
        File fontFile = extractFont();

        System.out.println(
            "Font       : " +
            fontFile.getAbsolutePath()
        );

        System.out.println(
            "Font size  : " +
            fontFile.length() +
            " bytes"
        );

        if (!fontFile.exists() ||
            fontFile.length() == 0) {

            throw new IllegalStateException(
                "Font file is empty or does not exist"
            );
        }

        /*
         * Create the PDF.
         */
        try (
            OutputStream outputStream =
                new FileOutputStream(outputFile)
        ) {

            PdfRendererBuilder builder =
                new PdfRendererBuilder();

            System.out.println(
                "Registering font: " +
                fontFile.getAbsolutePath()
            );

            builder
                .withHtmlContent(
                    html,
                    baseUri
                )
                .useFont(
                    fontFile,
                    "Arial",
                    400,
                    PdfRendererBuilder.FontStyle.NORMAL,
                    true
                )
                .usePdfUaAccessbility(true)
                .toStream(outputStream);

            builder.run();
        }

        System.out.println(
            "PDF generated successfully."
        );
    }

    /**
     * Extract the bundled TTF font from the JAR
     * into a temporary file.
     */
    private static File extractFont()
        throws Exception {

        InputStream inputStream =
            PdfRenderer.class.getResourceAsStream(
                FONT_RESOURCE
            );

        if (inputStream == null) {
            throw new IllegalStateException(
                "Font resource not found: " +
                FONT_RESOURCE
            );
        }

        File fontFile =
            File.createTempFile(
                "openhtmltopdf-",
                ".ttf"
            );

        fontFile.deleteOnExit();

        System.out.println(
            "Extracting font resource: " +
            FONT_RESOURCE
        );

        try (
            InputStream input =
                inputStream;

            OutputStream output =
                new FileOutputStream(fontFile)
        ) {

            input.transferTo(output);
        }

        return fontFile;
    }
}