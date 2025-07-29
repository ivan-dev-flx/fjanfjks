import 'package:flutter/material.dart';

class RotatedWidget extends StatelessWidget {
  const RotatedWidget({
    super.key,
    required this.degree,
    required this.child,
  });

  final int degree;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: AlwaysStoppedAnimation(degree / 360),
      child: child,
    );
  }
}
