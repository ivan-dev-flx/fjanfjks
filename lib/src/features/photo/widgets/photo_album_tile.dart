import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/config/constants.dart';
import '../../../core/config/my_colors.dart';
import '../../../core/models/album.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/image_widget.dart';
import '../bloc/photo_bloc.dart';

class PhotoAlbumTile extends StatelessWidget {
  const PhotoAlbumTile({super.key, required this.album});

  final Album album;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return SizedBox(
      height: 80,
      child: Button(
        onPressed: () {
          context
              .read<PhotoBloc>()
              .add(LoadPhotos(assetPathEntity: album.assetPathEntity));
        },
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(2.5),
              child: Image.file(
                album.previewFile,
                height: 64,
                width: 64,
                fit: BoxFit.cover,
                frameBuilder: frameBuilder,
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox();
                },
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  album.assetPathEntity.name,
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: 16,
                    fontFamily: AppFonts.inter600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  album.amount.toString(),
                  style: TextStyle(
                    color: colors.textSecondary,
                    fontSize: 14,
                    fontFamily: AppFonts.inter400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
