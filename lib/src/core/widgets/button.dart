import 'package:flutter/cupertino.dart';

class Button extends StatelessWidget {
  const Button({
    super.key,
    this.onPressed,
    this.padding = EdgeInsets.zero,
    this.minSize = kMinInteractiveDimensionCupertino,
    required this.child,
  });

  final VoidCallback? onPressed;
  final EdgeInsetsGeometry padding;
  final double minSize;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      padding: padding,
      sizeStyle: CupertinoButtonSize.small,
      // minimumSize: Size(minSize, minSize),
      child: child,
    );
  }
}
