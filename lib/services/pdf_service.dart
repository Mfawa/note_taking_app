import 'dart:io';
import 'dart:js';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

Future<void> _shareAsPDF() async {
  try {
    final pdf = pw.Document();
    final note = widget.note;

    // Add a custom font (replace with your actual font)
    final font = await _loadPdfFont();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(40),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  note.title,
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    font: font,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  _formatDate(note.createdAt),
                  style: pw.TextStyle(
                    fontSize: 12,
                    font: font,
                    color: PdfColors.grey600,
                  ),
                ),
                pw.Divider(),
                pw.Expanded(
                  child: pw.ListView(
                    children: [
                      pw.Paragraph(
                        text: note.content,
                        style: pw.TextStyle(
                          fontSize: 16,
                          font: font,
                          lineSpacing: 5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/note_${note.id}.pdf');
    final pdfBytes = await pdf.save();
    await file.writeAsBytes(pdfBytes.toList());

    await Share.shareFiles(
      [file.path],
      mimeTypes: ['application/pdf'],
      text: 'Shared Note: ${note.title}',
      subject: 'Note PDF Export',
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('PDF Generation Failed: ${e.toString()}')),
    );
  }
}

Future<pw.Font> _loadPdfFont() async {
  // For default font:
  return pw.Font.courier();

  // For custom font (uncomment and replace with your font):
  // final fontData = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
  // return pw.Font.ttf(fontData);
}
