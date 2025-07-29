import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_review/in_app_review.dart';

import '../../../core/config/constants.dart';
import '../../../core/models/vip.dart';
import '../../../core/utils.dart';
import '../data/vip_repository.dart';

part 'vip_event.dart';

class VipBloc extends Bloc<VipEvent, Vip> {
  final VipRepository _repository;

  VipBloc({required VipRepository repository})
      : _repository = repository,
        super(Vip()) {
    on<VipEvent>(
      (event, emit) => switch (event) {
        CheckVip() => _checkVip(event, emit),
      },
    );
  }

  void _checkVip(
    CheckVip event,
    Emitter<Vip> emit,
  ) async {
    if (Platform.isIOS) {
      emit(Vip(loading: true));

      try {
        late String identifier;
        if (event.initial) {
          final showCount = _repository.getShowCount();
          final isFirstOrSecondShow =
              showCount == 2 || showCount == 3 || showCount == 7;
          identifier =
              isFirstOrSecondShow ? Identifiers.paywall4 : Identifiers.paywall1;
          await _repository.saveShowCount(showCount + 1);
          if (showCount == 2 || showCount == 4 || showCount == 6) {
            InAppReview.instance.requestReview();
          }
        } else {
          identifier = event.identifier;
        }

        final isVip = await _repository.getVip();
        final offering = await _repository.getOffering(identifier);

        emit(Vip(
          isVip: isVip,
          offering: offering,
        ));
      } catch (e) {
        logger(e);
        emit(Vip());
      }
    } else {
      emit(Vip(isVip: true));
    }
  }
}
