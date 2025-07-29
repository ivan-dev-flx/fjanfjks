part of 'photo_bloc.dart';

@immutable
sealed class PhotoState {}

final class PhotoLoading extends PhotoState {}

final class PhotoError extends PhotoState {}

final class PhotosLoaded extends PhotoState {
  PhotosLoaded({
    required this.albums,
    required this.assetEntities,
    required this.bytes,
    required this.albumTitle,
    required this.showAlbums,
  });

  final List<Album> albums;
  final List<AssetEntity> assetEntities;
  final List<Uint8List> bytes;
  final String albumTitle;
  final bool showAlbums;
}
