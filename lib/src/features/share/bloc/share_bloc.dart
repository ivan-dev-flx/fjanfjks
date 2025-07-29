import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

import '../../../core/utils.dart';

part 'share_event.dart';
part 'share_state.dart';

class ShareBloc extends Bloc<ShareEvent, ShareState> {
  late final StreamSubscription<List<SharedMediaFile>> _intentSub;

  ShareBloc() : super(ShareInitial()) {
    on<ShareEvent>(
      (event, emit) => switch (event) {
        ListenToShare() => _onListenToShare(event, emit),
        ShareReceived() => _onShareReceived(event, emit),
      },
    );
  }

  void _onListenToShare(ListenToShare event, Emitter<ShareState> emit) async {
    // Listen while app is in foreground
    _intentSub = ReceiveSharingIntent.instance.getMediaStream().listen(
      (files) {
        add(ShareReceived(files: files));
      },
      onError: (e) {
        logger(e);
      },
    );

    // Check initial shared intent (when app was launched via share)
    final initial = await ReceiveSharingIntent.instance.getInitialMedia();
    if (initial.isNotEmpty) {
      add(ShareReceived(files: initial));
      ReceiveSharingIntent.instance.reset(); // Mark as handled
    }
  }

  void _onShareReceived(
    ShareReceived event,
    Emitter<ShareState> emit,
  ) {
    emit(ShareLoaded(files: event.files));
  }

  @override
  Future<void> close() {
    _intentSub.cancel();
    return super.close();
  }
}
