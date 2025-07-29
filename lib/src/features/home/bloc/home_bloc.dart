import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomePrinter()) {
    on<HomeEvent>(
      (event, emit) => switch (event) {
        ChangePage() => _changePage(event, emit),
      },
    );
  }

  void _changePage(
    ChangePage event,
    Emitter<HomeState> emit,
  ) {
    if (event.index == 1) emit(HomePrinter());
    if (event.index == 2) emit(HomeSettings());
  }
}
