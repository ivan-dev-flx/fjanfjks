part of 'internet_bloc.dart';

@immutable
sealed class InternetEvent {}

class CheckInternet extends InternetEvent {}

class ChangeInternet extends InternetEvent {
  ChangeInternet({required this.connected});

  final bool connected;
}
