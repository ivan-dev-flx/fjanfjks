part of 'vip_bloc.dart';

@immutable
sealed class VipEvent {}

final class CheckVip extends VipEvent {
  CheckVip({
    required this.identifier,
    this.initial = false,
  });

  final String identifier;
  final bool initial;
}
