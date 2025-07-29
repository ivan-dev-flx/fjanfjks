part of 'share_bloc.dart';

@immutable
sealed class ShareEvent {}

class ListenToShare extends ShareEvent {}

class ShareReceived extends ShareEvent {
  ShareReceived({required this.files});

  final List<SharedMediaFile> files;
}
