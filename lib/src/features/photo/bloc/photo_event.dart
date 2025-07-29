part of 'photo_bloc.dart';

@immutable
sealed class PhotoEvent {}

final class LoadPhotos extends PhotoEvent {
  LoadPhotos({
    this.assetPathEntity,
    this.showAlbums = false,
  });

  final AssetPathEntity? assetPathEntity;
  final bool showAlbums;
}
