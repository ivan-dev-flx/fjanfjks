import 'package:flutter/material.dart';

// final colors = Theme.of(context).extension<MyColors>()!;

final class MyColors extends ThemeExtension<MyColors> {
  const MyColors({
    required this.bgOne,
    required this.bgTwo,
    required this.layerOne,
    required this.layerTwo,
    required this.layerThree,
    required this.layerFour,
    required this.layerFive,
    required this.accentPrimary,
    required this.accentSecondary,
    required this.textPrimary,
    required this.textSecondary,
    required this.tertiaryOne,
    required this.tertiaryTwo,
    required this.tertiaryThree,
    required this.tertiaryFour,
    required this.system,
    required this.gradient1,
    required this.gradient2,
  });

  final Color bgOne;
  final Color bgTwo;
  final Color layerOne;
  final Color layerTwo;
  final Color layerThree;
  final Color layerFour;
  final Color layerFive;
  final Color accentPrimary;
  final Color accentSecondary;
  final Color textPrimary;
  final Color textSecondary;
  final Color tertiaryOne;
  final Color tertiaryTwo;
  final Color tertiaryThree;
  final Color tertiaryFour;
  final Color system;
  final Color gradient1;
  final Color gradient2;

  factory MyColors.light() {
    return MyColors(
      bgOne: const Color(0xfff8fcff),
      bgTwo: const Color(0xffbadcff),
      layerOne: const Color(0xffffedd4),
      layerTwo: const Color(0xffd5d9ff),
      layerThree: const Color(0xffc7ffcd),
      layerFour: const Color(0xfffdd4ff),
      layerFive: const Color(0xff000000).withValues(alpha: 0.6),
      accentPrimary: const Color(0xff097af1),
      accentSecondary: const Color(0xffffdb4a),
      textPrimary: const Color(0xff000000),
      textSecondary: const Color(0xff96a0a9),
      tertiaryOne: const Color(0xff8091a4),
      tertiaryTwo: const Color(0xffe0f0fe),
      tertiaryThree: const Color(0xffeaeff4),
      tertiaryFour: const Color(0xffffffff),
      system: const Color(0xffff3b30),
      gradient1: const Color(0xff097AF1),
      gradient2: const Color(0xff003C7C),
    );
  }

  @override
  MyColors copyWith({
    Color? bgOne,
    Color? bgTwo,
    Color? layerOne,
    Color? layerTwo,
    Color? layerThree,
    Color? layerFour,
    Color? layerFive,
    Color? accentPrimary,
    Color? accentSecondary,
    Color? textPrimary,
    Color? textSecondary,
    Color? tertiaryOne,
    Color? tertiaryTwo,
    Color? tertiaryThree,
    Color? tertiaryFour,
    Color? system,
    Color? gradient1,
    Color? gradient2,
  }) {
    return MyColors(
      bgOne: bgOne ?? this.bgOne,
      bgTwo: bgTwo ?? this.bgTwo,
      layerOne: layerOne ?? this.layerOne,
      layerTwo: layerTwo ?? this.layerTwo,
      layerThree: layerThree ?? this.layerThree,
      layerFour: layerFour ?? this.layerFour,
      layerFive: layerFive ?? this.layerFive,
      accentPrimary: accentPrimary ?? this.accentPrimary,
      accentSecondary: accentSecondary ?? this.accentSecondary,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      tertiaryOne: tertiaryOne ?? this.tertiaryOne,
      tertiaryTwo: tertiaryTwo ?? this.tertiaryTwo,
      tertiaryThree: tertiaryThree ?? this.tertiaryThree,
      tertiaryFour: tertiaryFour ?? this.tertiaryFour,
      system: system ?? this.system,
      gradient1: gradient1 ?? this.gradient1,
      gradient2: gradient2 ?? this.gradient2,
    );
  }

  @override
  MyColors lerp(ThemeExtension<MyColors>? other, double t) {
    if (other is! MyColors) return this;
    return MyColors(
      bgOne: Color.lerp(bgOne, other.bgOne, t)!,
      bgTwo: Color.lerp(bgTwo, other.bgTwo, t)!,
      layerOne: Color.lerp(layerOne, other.layerOne, t)!,
      layerTwo: Color.lerp(layerTwo, other.layerTwo, t)!,
      layerThree: Color.lerp(layerThree, other.layerThree, t)!,
      layerFour: Color.lerp(layerFour, other.layerFour, t)!,
      layerFive: Color.lerp(layerFive, other.layerFive, t)!,
      accentPrimary: Color.lerp(accentPrimary, other.accentPrimary, t)!,
      accentSecondary: Color.lerp(accentSecondary, other.accentSecondary, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      tertiaryOne: Color.lerp(tertiaryOne, other.tertiaryOne, t)!,
      tertiaryTwo: Color.lerp(tertiaryTwo, other.tertiaryTwo, t)!,
      tertiaryThree: Color.lerp(tertiaryThree, other.tertiaryThree, t)!,
      tertiaryFour: Color.lerp(tertiaryFour, other.tertiaryFour, t)!,
      system: Color.lerp(system, other.system, t)!,
      gradient1: Color.lerp(gradient1, other.gradient1, t)!,
      gradient2: Color.lerp(gradient2, other.gradient2, t)!,
    );
  }
}
