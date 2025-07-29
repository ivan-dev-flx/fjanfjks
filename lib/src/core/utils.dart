import 'dart:developer' as developer;
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

void logger(Object message) => developer.log(message.toString());

Future<Uint8List> getBytes(ScreenshotController controller) async {
  try {
    final bytes = await controller.capture();
    if (bytes == null) throw Exception('null bytes');
    return bytes;
  } catch (e) {
    logger(e);
    return Uint8List(0);
  }
}

Future<File> getFile(Uint8List bytes) async {
  try {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/printable.png');
    await file.writeAsBytes(bytes);
    return file;
  } catch (e) {
    logger(e);
    return File('');
  }
}

void printPdf(Document pdf) {
  try {
    Printing.layoutPdf(
      format: PdfPageFormat.a4,
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  } catch (e) {
    logger(e);
  }
}

void shareFiles(List<File> files) async {
  try {
    await Share.shareXFiles(
      List.generate(
        files.length,
        (index) {
          return XFile(files[index].path);
        },
      ),
      sharePositionOrigin: Rect.fromLTWH(100, 100, 200, 200),
    );
  } catch (e) {
    logger(e);
  }
}

Future<File?> pickFile() async {
  try {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'txt', 'png', 'jpg'],
    );
    if (result != null && result.files.single.path != null) {
      return File(result.files.single.path!);
    }
  } catch (e) {
    logger(e);
  }
  return null;
}

Future<File?> pickImage({bool camera = true}) async {
  try {
    final photo = await ImagePicker().pickImage(
      source: camera ? ImageSource.camera : ImageSource.gallery,
    );
    if (photo != null) {
      return File(photo.path);
    }
  } catch (e) {
    logger(e);
  }
  return null;
}
