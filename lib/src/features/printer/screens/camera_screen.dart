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

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key, required this.file});

  static const routePath = '/CameraScreen';

  final File file;

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final pdf = pw.Document();
  Uint8List? imageBytes;

  void createPdf() async {
    try {
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
    } catch (e) {
      logger(e);
    }
  }

  void printDocument() {
    printPdf(pdf);
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
        title: 'Camera',
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
          return pdf.save();
        },
      ),
    );
  }
}
