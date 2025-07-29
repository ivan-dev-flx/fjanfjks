part of 'share_bloc.dart';

@immutable
sealed class ShareState {}

final class ShareInitial extends ShareState {}

class ShareLoaded extends ShareState {
  ShareLoaded({required this.files});

  final List<SharedMediaFile> files;
}
