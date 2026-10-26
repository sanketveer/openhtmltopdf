package com.cureus.openhtmltopdf;

import com.openhtmltopdf.pdfboxout.PdfRendererBuilder;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;

public class PdfRenderer {

    private static final String FONT_FAMILY = "MyriadPro";

    private static final String LIGHT_FONT =
        "/fonts/myriadprolight.ttf";

    private static final String REGULAR_FONT =
        "/fonts/myriadproregular.ttf";

    private static final String SEMIBOLD_FONT =
        "/fonts/myriadprosemibold.ttf";

    private static final String BOLD_FONT =
        "/fonts/myriadprobold.ttf";

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

        File lightFont = extractFont(LIGHT_FONT);
        File regularFont = extractFont(REGULAR_FONT);
        File semiboldFont = extractFont(SEMIBOLD_FONT);
        File boldFont = extractFont(BOLD_FONT);

        System.out.println(
            "Light font     : " +
            lightFont.getAbsolutePath()
        );

        System.out.println(
            "Regular font   : " +
            regularFont.getAbsolutePath()
        );

        System.out.println(
            "Semibold font  : " +
            semiboldFont.getAbsolutePath()
        );

        System.out.println(
            "Bold font      : " +
            boldFont.getAbsolutePath()
        );

        try (
            OutputStream outputStream =
                new FileOutputStream(outputFile)
        ) {

            PdfRendererBuilder builder =
                new PdfRendererBuilder();

            builder
                .withHtmlContent(
                    html,
                    baseUri
                )

                .useFont(
                    lightFont,
                    FONT_FAMILY,
                    300,
                    PdfRendererBuilder.FontStyle.NORMAL,
                    true
                )

                .useFont(
                    regularFont,
                    FONT_FAMILY,
                    400,
                    PdfRendererBuilder.FontStyle.NORMAL,
                    true
                )

                .useFont(
                    semiboldFont,
                    FONT_FAMILY,
                    600,
                    PdfRendererBuilder.FontStyle.NORMAL,
                    true
                )

                .useFont(
                    boldFont,
                    FONT_FAMILY,
                    700,
                    PdfRendererBuilder.FontStyle.NORMAL,
                    true
                )

                .usePdfUaAccessibility(true)

                .toStream(outputStream);

            builder.run();
        }

        System.out.println(
            "PDF generated successfully."
        );
    }

    private static File extractFont(String resource)
        throws Exception {

        InputStream inputStream =
            PdfRenderer.class.getResourceAsStream(
                resource
            );

        if (inputStream == null) {
            throw new IllegalStateException(
                "Font resource not found: " +
                resource
            );
        }

        File fontFile =
            File.createTempFile(
                "openhtmltopdf-",
                ".ttf"
            );

        fontFile.deleteOnExit();

        System.out.println(
            "Extracting font: " +
            resource
        );

        try (
            InputStream input = inputStream;
            OutputStream output =
                new FileOutputStream(fontFile)
        ) {
            input.transferTo(output);
        }

        if (fontFile.length() == 0) {
            throw new IllegalStateException(
                "Extracted font is empty: " +
                resource
            );
        }

        return fontFile;
    }
}