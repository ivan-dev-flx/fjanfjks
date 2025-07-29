import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../../core/config/constants.dart';
import '../../../core/config/my_colors.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/svg_widget.dart';

class WebPagesScreen extends StatefulWidget {
  const WebPagesScreen({super.key});

  static const routePath = '/WebPagesScreen';

  @override
  State<WebPagesScreen> createState() => _WebPagesScreenState();
}

class _WebPagesScreenState extends State<WebPagesScreen> {
  InAppWebViewController? webViewController;

  void onLeft() async {
    try {
      if (await webViewController!.canGoBack()) {
        await webViewController!.goBack();
      }
    } catch (e) {
      logger(e);
    }
  }

  void onRight() async {
    try {
      if (await webViewController!.canGoForward()) {
        await webViewController!.goForward();
      }
    } catch (e) {
      logger(e);
    }
  }

  void onReload() async {
    try {
      if (webViewController != null) {
        await webViewController!.reload();
      }
    } catch (e) {
      logger(e);
    }
  }

  void onPrint() async {
    try {
      Uint8List? bytes = await webViewController!.takeScreenshot();
      if (bytes == null) return;

      final pdf = pw.Document();
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
      printPdf(pdf);
    } catch (e) {
      logger(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return Scaffold(
      appBar: Appbar(
        title: 'Web Pages',
        right: Button(
          onPressed: onPrint,
          child: const SvgWidget(Assets.print),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri('https://google.com'),
              ),
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              onLoadStart: (controller, url) {
                logger("Page started loading: $url");
              },
              onLoadStop: (controller, url) async {
                logger("Page finished loading: $url");
              },
              onReceivedError: (controller, request, error) {
                logger("Error: ${error.description}");
              },
            ),
          ),
          Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Button(
                  onPressed: onLeft,
                  child: SvgWidget(
                    Assets.left,
                    color: colors.textPrimary,
                  ),
                ),
                Button(
                  onPressed: onRight,
                  child: SvgWidget(
                    Assets.right,
                    color: colors.textPrimary,
                  ),
                ),
                Button(
                  onPressed: onReload,
                  child: Icon(
                    Icons.refresh_rounded,
                    color: colors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
