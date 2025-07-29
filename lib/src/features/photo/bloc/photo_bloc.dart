import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../core/models/album.dart';
import '../../../core/utils.dart';
import '../data/photo_repository.dart';

part 'photo_event.dart';
part 'photo_state.dart';

class PhotoBloc extends Bloc<PhotoEvent, PhotoState> {
  final PhotoRepository _repository;

  List<Album> albums = [];
  List<AssetEntity> assetEntities = [];
  List<Uint8List> bytes = [];

  PhotoBloc({required PhotoRepository repository})
      : _repository = repository,
        super(PhotoLoading()) {
    on<PhotoEvent>(
      (event, emit) => switch (event) {
        LoadPhotos() => _loadPhotos(event, emit),
      },
    );
  }

  void _loadPhotos(
    LoadPhotos event,
    Emitter<PhotoState> emit,
  ) async {
    emit(PhotoLoading());

    try {
      if (await _repository.hasAccess()) {
        if (albums.isEmpty && assetEntities.isEmpty && bytes.isEmpty ||
            event.assetPathEntity != null) {
          final assetPathEntities = await _repository.getAssetPathEntities();
          albums = await _repository.getAlbums(assetPathEntities);
          assetEntities = await _repository.getPhotos(
            assetPathEntities,
            assetPathEntity: event.assetPathEntity,
          );
          bytes = await _repository.getBytes(assetEntities);
        }

        emit(PhotosLoaded(
          albums: albums,
          assetEntities: assetEntities,
          bytes: bytes,
          albumTitle:
              event.assetPathEntity?.name ?? albums[0].assetPathEntity.name,
          showAlbums: event.showAlbums,
        ));
      } else {
        PhotoManager.openSetting();
      }
    } catch (e) {
      logger(e);
    }
  }
}
