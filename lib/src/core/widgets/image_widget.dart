import 'package:flutter/material.dart';

import '../utils.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget(
    this.asset, {
    super.key,
    this.width,
    this.height,
    this.fit,
    this.alignment = Alignment.center,
    this.borderRadius = BorderRadius.zero,
    this.cacheWidth,
    this.cacheHeight,
  });

  final String asset;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final AlignmentGeometry alignment;
  final BorderRadiusGeometry borderRadius;
  final int? cacheWidth;
  final int? cacheHeight;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Image.asset(
        asset,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        frameBuilder: frameBuilder,
        cacheWidth: cacheWidth,
        cacheHeight: cacheHeight,
        errorBuilder: (context, error, stackTrace) {
          logger(error);

          return SizedBox(
            width: width,
            height: height,
          );
        },
      ),
    );
  }
}

Widget frameBuilder(
  BuildContext context,
  Widget child,
  int? frame,
  bool wasSynchronouslyLoaded,
) {
  return AnimatedOpacity(
    opacity: frame == null ? 0.0 : 1.0,
    duration: const Duration(milliseconds: 1000),
    curve: Curves.easeInOut,
    child: child,
  );
}
