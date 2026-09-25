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
    // The SVG uses white (#f8fcff) text on a transparent background.
    // When showContainer is true we wrap it in the dark badge so the
    // white lettering stands out. When false (e.g. on dark/blue backgrounds)
    // we render the SVG directly — it will be visible against dark surfaces.
    if (showContainer) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
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
          // Explicitly allow the SVG's own fill colours to render
          colorFilter: null,
        ),
      );
    }

    return SvgPicture.asset(
      'assets/icons/11jobs.svg',
      height: height,
      colorFilter: null,
    );
  }
}
