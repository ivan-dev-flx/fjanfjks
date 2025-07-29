part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class ChangePage extends HomeEvent {
  ChangePage({required this.index});

  final int index;
}
