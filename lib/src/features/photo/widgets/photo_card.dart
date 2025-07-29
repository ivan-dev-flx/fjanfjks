import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../core/config/constants.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/image_widget.dart';
import '../../../core/widgets/svg_widget.dart';

class PhotoCard extends StatelessWidget {
  const PhotoCard({
    super.key,
    required this.assetEntity,
    required this.bytes,
    required this.selected,
    required this.onPressed,
  });

  final AssetEntity assetEntity;
  final Uint8List bytes;
  final bool selected;
  final void Function(AssetEntity) onPressed;

  @override
  Widget build(BuildContext context) {
    return Button(
      onPressed: () {
        onPressed(assetEntity);
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: Image.memory(
              bytes,
              fit: BoxFit.cover,
              frameBuilder: frameBuilder,
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox();
              },
            ),
          ),
          if (selected)
            const Positioned(
              right: 8,
              bottom: 8,
              child: SvgWidget(Assets.checkbox),
            ),
        ],
      ),
    );
  }
}
