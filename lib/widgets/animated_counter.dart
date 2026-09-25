import 'package:flutter/material.dart';

/// Smooth animated number counter widget that counts up to the target value.
class AnimatedCounter extends StatelessWidget {
  final double value;
  final String prefix;
  final String suffix;
  final TextStyle? style;
  final Duration duration;
  final Curve curve;
  final int fractionDigits;

  const AnimatedCounter({
    super.key,
    required this.value,
    this.prefix = '',
    this.suffix = '',
    this.style,
    this.duration = const Duration(milliseconds: 1000),
    this.curve = Curves.easeOutExpo,
    this.fractionDigits = 0,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: value),
      duration: duration,
      curve: curve,
      builder: (context, val, child) {
        final text = fractionDigits > 0
            ? val.toStringAsFixed(fractionDigits)
            : val.round().toString();
        return Text(
          '$prefix$text$suffix',
          style: style,
        );
      },
    );
  }
}
