import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/firebase_data.dart';
import '../data/firebase_repository.dart';

part 'firebase_event.dart';
part 'firebase_state.dart';

class FirebaseBloc extends Bloc<FirebaseEvent, FirebaseData> {
  final FirebaseRepository _repository;

  FirebaseBloc({required FirebaseRepository repository})
      : _repository = repository,
        super(FirebaseData()) {
    on<FirebaseEvent>(
      (event, emit) => switch (event) {
        GetFirebaseData() => _getFirebaseData(event, emit),
      },
    );
  }

  void _getFirebaseData(
    GetFirebaseData event,
    Emitter<FirebaseData> emit,
  ) async {
    final data = await _repository.checkInvoice();
    emit(data);
  }
}
