import 'dart:io';

import 'package:photo_manager/photo_manager.dart';

class Album {
  Album({
    required this.assetPathEntity,
    required this.previewFile,
    required this.amount,
  });

  final AssetPathEntity assetPathEntity;
  final File previewFile;
  final int amount;
}
