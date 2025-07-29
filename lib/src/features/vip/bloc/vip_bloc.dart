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
      emit(state.copyWith(loading: true));

      try {
        // Сначала проверяем VIP статус
        final isVip = await _repository.getVip();

        // Если пользователь VIP, не нужно загружать offering
        if (isVip) {
          emit(state.copyWith(
            isVip: true,
            loading: false,
          ));
          return;
        }

        // Определяем identifier только если пользователь не VIP
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

        final offering = await _repository.getOffering(identifier);

        emit(state.copyWith(
          isVip: false,
          offering: offering,
          loading: false,
        ));
      } catch (e) {
        logger(e);
        emit(state.copyWith(
          isVip: false,
          loading: false,
        ));
      }
    } else {
      emit(state.copyWith(isVip: true, loading: false));
    }
  }
}
