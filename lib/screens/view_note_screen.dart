import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_taking_app/screens/note_edit_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../models/note.dart';
import '../providers/notes_provider.dart';

class NoteViewScreen extends ConsumerStatefulWidget {
  final Note note;

  const NoteViewScreen({super.key, required this.note});

  @override
  ConsumerState<NoteViewScreen> createState() => _NoteViewScreenState();
}

class _NoteViewScreenState extends ConsumerState<NoteViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded),
            onPressed: () => _navigateToEditScreen(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _confirmDelete,
          ),
          IconButton(
            icon: const Icon(Icons.ios_share_rounded),
            onPressed: _showShareOptions,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.note.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 33,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Date Created: ${_formatDate(widget.note.createdAt)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Last Modified: ${_formatDate(widget.note.updatedAt)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              Text(
                widget.note.content,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToEditScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteEditor(
          note: widget.note,
          isNew: false,
        ),
      ),
    );
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Note'),
          content: const Text('Are you sure you want to delete this note?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                ref.read(notesProvider.notifier).deleteNote(widget.note.id);

                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showShareOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.text_snippet),
                title: const Text('Share as Text'),
                onTap: () {
                  Navigator.pop(context);
                  _shareAsText();
                },
              ),
              ListTile(
                leading: const Icon(Icons.picture_as_pdf),
                title: const Text('Share as PDF'),
                onTap: () {
                  Navigator.pop(context);
                  _shareAsPDF();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _shareAsText() async {
    await Share.share(
      '${widget.note.title}\n\n${widget.note.content}',
      subject: 'Shared Note: ${widget.note.title}',
    );
  }

  Future<void> _shareAsPDF() async {
    try {
      // Add font initialization
      final font = pw.Font.courier(); // Default font

      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Padding(
              padding: const pw.EdgeInsets.all(40),
              child: pw.Column(
                children: [
                  pw.Text(
                    widget.note.title,
                    style: pw.TextStyle(font: font, fontSize: 24),
                  ),
                  pw.Text(
                    _formatDate(widget.note.createdAt),
                    style: pw.TextStyle(font: font, fontSize: 12),
                  ),
                  pw.Paragraph(
                    text: widget.note.content,
                    style: pw.TextStyle(font: font, fontSize: 16),
                  ),
                ],
              ),
            );
          },
        ),
      );

      // Save to file
      final output = await getTemporaryDirectory();
      final file = File('${output.path}/note_${DateTime.now().millisecondsSinceEpoch}.pdf');
      await file.writeAsBytes(await pdf.save());

      // Share
      await Share.shareFiles(
        [file.path],
        mimeTypes: ['application/pdf'],
      );
    } catch (e) {
      debugPrint('PDF Error: $e');
    }
  }

  Future<pw.Font> _loadPdfFont() async {
    // For default font:
    return pw.Font.courier();

    // For custom font (uncomment and replace with your font):
    // final fontData = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
    // return pw.Font.ttf(fontData);
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} - ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
