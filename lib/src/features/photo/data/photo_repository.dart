import 'dart:io';
import 'dart:typed_data';

import 'package:photo_manager/photo_manager.dart';

import '../../../core/models/album.dart';

abstract interface class PhotoRepository {
  const PhotoRepository();

  Future<bool> hasAccess();
  Future<List<AssetPathEntity>> getAssetPathEntities();
  Future<List<AssetEntity>> getPhotos(
    List<AssetPathEntity> assetPathEntities, {
    AssetPathEntity? assetPathEntity,
  });
  Future<List<Uint8List>> getBytes(List<AssetEntity> assetEntities);
  Future<List<File>> getFiles(List<AssetEntity> assetEntities);
  Future<List<Album>> getAlbums(List<AssetPathEntity> assetPathEntities);
}

final class PhotoRepositoryImpl implements PhotoRepository {
  PhotoRepositoryImpl();

  @override
  Future<bool> hasAccess() async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    return ps.hasAccess;
  }

  @override
  Future<List<AssetPathEntity>> getAssetPathEntities() async {
    return await PhotoManager.getAssetPathList(type: RequestType.image);
  }

  @override
  Future<List<AssetEntity>> getPhotos(
    List<AssetPathEntity> assetPathEntities, {
    AssetPathEntity? assetPathEntity,
  }) async {
    late AssetPathEntity data;
    data = assetPathEntity ?? assetPathEntities[0];
    final photos = await data.getAssetListRange(
      start: 0,
      end: await data.assetCountAsync,
    );
    return photos;
  }

  @override
  Future<List<Uint8List>> getBytes(List<AssetEntity> assetEntities) async {
    final bytes = (await Future.wait(
      assetEntities.map(
        (e) => e.thumbnailDataWithSize(ThumbnailSize(200, 200)),
      ),
    ))
        .whereType<Uint8List>()
        .toList();
    return bytes;
  }

  @override
  Future<List<File>> getFiles(List<AssetEntity> assetEntities) async {
    List<File> files = (await Future.wait(assetEntities.map((e) => e.file)))
        .whereType<File>()
        .toList();
    return files;
  }

  @override
  Future<List<Album>> getAlbums(List<AssetPathEntity> assetPathEntities) async {
    List<Album> albums = [];
    for (AssetPathEntity assetPathEntity in assetPathEntities) {
      final amount = await assetPathEntity.assetCountAsync;
      final photos = await assetPathEntity.getAssetListRange(start: 0, end: 1);
      if (amount > 0) {
        albums.add(Album(
          assetPathEntity: assetPathEntity,
          previewFile: await photos[0].file ?? File(''),
          amount: amount,
        ));
      }
    }
    return albums;
  }
}
