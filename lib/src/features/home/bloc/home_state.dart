part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomePrinter extends HomeState {}

final class HomeSettings extends HomeState {}
