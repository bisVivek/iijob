import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BrandLogo extends StatelessWidget {
  final double height;
  final bool showContainer;

  const BrandLogo({
    super.key,
    this.height = 28,
    this.showContainer = true,
  });

  @override
  Widget build(BuildContext context) {
    // If showContainer is true, we place the SVG inside a sleek dark badge
    // so the white "11Jobs" lettering in the user's SVG stands out vividly on any background.
    if (showContainer) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF0A1424),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: SvgPicture.asset(
          'assets/icons/11jobs.svg',
          height: height,
        ),
      );
    }

    return SvgPicture.asset(
      'assets/icons/11jobs.svg',
      height: height,
    );
  }
}
