import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:photo_manager/photo_manager.dart';

import '../../../core/config/constants.dart';
import '../../../core/config/my_colors.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/main_button.dart';
import '../../../core/widgets/svg_widget.dart';
import '../bloc/photo_bloc.dart';
import '../data/photo_repository.dart';
import '../widgets/photo_album_tile.dart';
import '../widgets/photo_card.dart';

class PhotoScreen extends StatefulWidget {
  const PhotoScreen({super.key});

  static const routePath = '/PhotoScreen';

  @override
  State<PhotoScreen> createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  List<AssetEntity> selectedAssetEntities = [];

  void onPhoto(AssetEntity value) {
    setState(() {
      if (selectedAssetEntities.contains(value)) {
        selectedAssetEntities.remove(value);
      } else {
        selectedAssetEntities.add(value);
      }
    });
  }

  void onShare() async {
    final state = context.read<PhotoBloc>().state;
    final files =
        await context.read<PhotoRepository>().getFiles(selectedAssetEntities);
    if (state is PhotosLoaded && mounted) {
      shareFiles(files);
    }
  }

  void onPrint() async {
    final state = context.read<PhotoBloc>().state;
    if (state is PhotosLoaded) {
      final pdf = pw.Document();

      final files =
          await context.read<PhotoRepository>().getFiles(selectedAssetEntities);

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

      if (mounted) printPdf(pdf);
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<PhotoBloc>().add(LoadPhotos());
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;
    final state = context.watch<PhotoBloc>().state;
    final loaded = state is PhotosLoaded;
    final loading = state is PhotoLoading;

    return Scaffold(
      appBar: Appbar(
        right: Button(
          onPressed: selectedAssetEntities.isNotEmpty ? onShare : null,
          child: SvgWidget(
            Assets.share,
            color: selectedAssetEntities.isNotEmpty
                ? colors.accentPrimary
                : colors.tertiaryOne,
          ),
        ),
        child: Button(
          onPressed: () {
            context
                .read<PhotoBloc>()
                .add(LoadPhotos(showAlbums: loaded && !state.showAlbums));
          },
          child: loading
              ? const SizedBox()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      loaded && !state.showAlbums ? state.albumTitle : 'Albums',
                      style: TextStyle(
                        color: colors.textPrimary,
                        fontSize: 14,
                        fontFamily: AppFonts.inter400,
                      ),
                    ),
                    const SizedBox(width: 4),
                    SvgWidget(
                      loaded && state.showAlbums ? Assets.up : Assets.down,
                    ),
                  ],
                ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<PhotoBloc, PhotoState>(
              builder: (context, state) {
                if (state is PhotosLoaded) {
                  return loaded && state.showAlbums
                      ? ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: state.albums.length,
                          itemBuilder: (context, index) {
                            return PhotoAlbumTile(
                              album: state.albums[index],
                            );
                          },
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 4,
                            mainAxisSpacing: 4,
                            childAspectRatio: 1,
                          ),
                          itemCount: state.assetEntities.length,
                          itemBuilder: (context, index) {
                            return PhotoCard(
                              assetEntity: state.assetEntities[index],
                              bytes: state.bytes[index],
                              selected: selectedAssetEntities.contains(
                                state.assetEntities[index],
                              ),
                              onPressed: onPhoto,
                            );
                          },
                        );
                }

                return const LoadingWidget();
              },
            ),
          ),
          Container(
            height: 110,
            color: colors.tertiaryFour,
            child: Column(
              children: [
                const SizedBox(height: 10),
                MainButton(
                  title: 'Print',
                  asset: Assets.print,
                  horizontal: 16,
                  active: selectedAssetEntities.isNotEmpty,
                  onPressed: onPrint,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
