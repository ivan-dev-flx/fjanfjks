import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../core/config/constants.dart';
import '../../../core/config/my_colors.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/svg_widget.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key, required this.file});

  static const routePath = '/DocumentsScreen';

  final File file;

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  final pdf = pw.Document();
  Uint8List? imageBytes;

  void createPdf() async {
    try {
      final path = widget.file.path.toLowerCase();

      if (path.endsWith('.txt')) {
        final textContent = await widget.file.readAsString();
        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(32),
            build: (pw.Context context) {
              return pw.Text(
                textContent,
                style: const pw.TextStyle(fontSize: 14),
              );
            },
          ),
        );
      } else {
        imageBytes = await widget.file.readAsBytes();

        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            margin: pw.EdgeInsets.zero,
            build: (pw.Context context) {
              return pw.Center(
                child: pw.Image(
                  pw.MemoryImage(imageBytes!),
                ),
              );
            },
          ),
        );
      }
    } catch (e) {
      logger(e);
    }
  }

  void printDocument() {
    if (widget.file.path.toLowerCase().endsWith('.pdf')) {
      Printing.layoutPdf(onLayout: (_) => widget.file.readAsBytes());
    } else {
      printPdf(pdf);
    }
  }

  @override
  void initState() {
    super.initState();
    createPdf();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return Scaffold(
      appBar: Appbar(
        title: 'Documents',
        right: Button(
          onPressed: printDocument,
          child: const SvgWidget(Assets.print),
        ),
      ),
      body: PdfPreview(
        useActions: false,
        pdfPreviewPageDecoration: BoxDecoration(color: colors.bgOne),
        scrollViewDecoration: BoxDecoration(color: colors.bgTwo),
        loadingWidget: const LoadingWidget(),
        build: (format) {
          if (widget.file.path.toLowerCase().endsWith('.pdf')) {
            return imageBytes!;
          }

          return pdf.save();
        },
      ),
    );
  }
}
