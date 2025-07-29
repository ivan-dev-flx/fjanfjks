import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:in_app_review/in_app_review.dart';
import '../../../core/models/firebase_data.dart';
import '../../../core/utils.dart';
import '../../../core/config/constants.dart';
import '../../../core/config/my_colors.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/image_widget.dart';
import '../../../core/widgets/snack_widget.dart';
import '../../../core/widgets/svg_widget.dart';
import '../../firebase/bloc/firebase_bloc.dart';
import '../../vip/bloc/vip_bloc.dart';
import '../../vip/screens/vip_screen.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key, required this.paths});

  static const routePath = '/ScannerScreen';

  final List<String> paths;

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  List<File> files = [];
  FirebaseData data = FirebaseData();
  bool isVip = false;

  void onCopyText() async {
    if (isVip) {
      InAppReview.instance.requestReview();
      final textRecognizer = TextRecognizer();
      final recognizedText = await textRecognizer.processImage(
        InputImage.fromFile(files.first),
      );
      final text = recognizedText.text;
      logger(text);
      textRecognizer.close();
      if (text.isNotEmpty) {
        await Clipboard.setData(ClipboardData(text: text));
      }
      if (mounted) {
        SnackWidget.show(
          context,
          text.isEmpty ? 'Text not found' : 'Copied to clipboard',
        );
      }
    } else {
      context.push(
        VipScreen.routePath,
        extra: Identifiers.paywall3,
      );
    }
  }

  void onAddImage() async {
    await CunningDocumentScanner.getPictures().then((value) {
      if (value != null && mounted) {
        for (String path in value) {
          files.add(File(path));
        }
        setState(() {});
      }
    });
  }

  void onShare() {
    if (isVip) {
      shareFiles(files);
    } else {
      context.push(
        VipScreen.routePath,
        extra: Identifiers.paywall3,
      );
    }
  }

  void onPrint() async {
    if (isVip) {
      final pdf = pw.Document();

      for (final file in files) {
        final bytes = await file.readAsBytes();

        pdf.addPage(
          pw.Page(
            margin: pw.EdgeInsets.zero,
            pageFormat: PdfPageFormat.a4,
            build: (context) {
              return pw.Center(
                child: pw.Image(
                  pw.MemoryImage(bytes),
                  fit: pw.BoxFit.contain,
                ),
              );
            },
          ),
        );
      }

      printPdf(pdf);
    } else {
      context.push(
        VipScreen.routePath,
        extra: Identifiers.paywall3,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    data = context.read<FirebaseBloc>().state;
    isVip = context.read<VipBloc>().state.isVip;
    files = List.generate(
      widget.paths.length,
      (index) {
        return File(widget.paths[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Text(
          'Scanned Document',
          style: TextStyle(
            color: colors.textPrimary,
            fontSize: 24,
            fontFamily: AppFonts.inter600,
          ),
        ),
        actions: [
          Button(
            onPressed: () {
              context.pop();
            },
            child: const SvgWidget(
              Assets.close,
              height: 32,
              width: 32,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: files.length,
              itemBuilder: (context, index) {
                return Image.file(
                  files[index],
                  frameBuilder: frameBuilder,
                );
              },
            ),
          ),
          SizedBox(
            height: 60,
            child: Row(
              children: [
                const SizedBox(width: 16),
                Button(
                  onPressed: onCopyText,
                  child: const SvgWidget(
                    Assets.copy,
                    width: 24,
                    height: 24,
                  ),
                ),
                const Spacer(),
                Button(
                  onPressed: onAddImage,
                  child: const SvgWidget(Assets.image),
                ),
                const Spacer(),
                Button(
                  onPressed: onShare,
                  child: SvgWidget(
                    Assets.share,
                    color: colors.accentPrimary,
                  ),
                ),
                const Spacer(),
                Button(
                  onPressed: onPrint,
                  child: const SvgWidget(Assets.print),
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
          const SizedBox(height: 34),
        ],
      ),
    );
  }
}
