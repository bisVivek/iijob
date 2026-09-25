import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// 11Jobs Signature Yellow Flower / Asterisk Custom Painter
class ElevenJobsFlowerPainter extends CustomPainter {
  final Color color;
  final int petalCount;

  const ElevenJobsFlowerPainter({
    required this.color,
    this.petalCount = 12,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final petalLength = radius * 0.85;
    final petalWidth = radius * 0.22;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    for (int i = 0; i < petalCount; i++) {
      final angle = (i * 2 * math.pi) / petalCount;
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(angle);

      // Draw rounded petal
      final petalRect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(0, -petalLength / 2),
          width: petalWidth,
          height: petalLength,
        ),
        Radius.circular(petalWidth / 2),
      );
      canvas.drawRRect(petalRect, paint);

      canvas.restore();
    }

    // Center hub
    canvas.drawCircle(center, radius * 0.22, paint);
  }

  @override
  bool shouldRepaint(covariant ElevenJobsFlowerPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.petalCount != petalCount;
  }
}

/// 11Jobs Flower Icon Widget
class ElevenJobsFlowerIcon extends StatelessWidget {
  final double size;
  final Color color;

  const ElevenJobsFlowerIcon({
    super.key,
    this.size = 22,
    this.color = const Color(0xFFEAB308), // Bright 11Jobs Yellow
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: ElevenJobsFlowerPainter(
          color: color,
          petalCount: 12,
        ),
      ),
    );
  }
}

/// Floating Docked Theme Toggle (Matching exact 11Jobs website screenshot)
class ElevenJobsFloatingThemeToggle extends StatefulWidget {
  final double topOffset;

  const ElevenJobsFloatingThemeToggle({
    super.key,
    this.topOffset = 140,
  });

  @override
  State<ElevenJobsFloatingThemeToggle> createState() => _ElevenJobsFloatingThemeToggleState();
}

class _ElevenJobsFloatingThemeToggleState extends State<ElevenJobsFloatingThemeToggle>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  void _handleToggle() {
    _rotationController.forward(from: 0.0);
    AppTheme.toggleTheme();
    final isDarkNow = AppTheme.isDark;

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isDarkNow ? const Color(0xFF0F1A30) : const Color(0xFF005BFF),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          children: [
            ElevenJobsFlowerIcon(
              size: 20,
              color: isDarkNow ? const Color(0xFFFACC15) : Colors.white,
            ),
            const SizedBox(width: 10),
            Text(
              isDarkNow
                  ? "Switched to 11Jobs Midnight Navy Theme 🌙"
                  : "Switched to 11Jobs Light Theme ☀️",
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.themeModeNotifier,
      builder: (context, currentMode, _) {
        final isDark = currentMode == ThemeMode.dark;

        return Positioned(
          top: widget.topOffset,
          right: 0,
          child: MouseRegion(
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            child: Tooltip(
              message: isDark ? "Switch to Light Theme" : "Switch to 11Jobs Dark Theme",
              child: GestureDetector(
                key: const Key('floating11JobsThemeToggle'),
                onTap: _handleToggle,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: EdgeInsets.only(
                    left: _isHovered ? 12 : 10,
                    right: 8,
                    top: 10,
                    bottom: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xE6151E2E)
                        : const Color(0xF0FFFFFF),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                    border: Border(
                      left: BorderSide(
                        color: isDark
                            ? const Color(0xFF2E3D59)
                            : const Color(0xFFCBD5E1),
                        width: 1.2,
                      ),
                      top: BorderSide(
                        color: isDark
                            ? const Color(0xFF2E3D59)
                            : const Color(0xFFCBD5E1),
                        width: 1.2,
                      ),
                      bottom: BorderSide(
                        color: isDark
                            ? const Color(0xFF2E3D59)
                            : const Color(0xFFCBD5E1),
                        width: 1.2,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.12),
                        blurRadius: 12,
                        offset: const Offset(-2, 4),
                      ),
                      if (isDark)
                        BoxShadow(
                          color: const Color(0xFFFACC15).withValues(alpha: 0.18),
                          blurRadius: 10,
                          offset: const Offset(-1, 0),
                        ),
                    ],
                  ),
                  child: RotationTransition(
                    turns: _rotationController,
                    child: ElevenJobsFlowerIcon(
                      size: 26,
                      color: isDark
                          ? const Color(0xFFFACC15)
                          : const Color(0xFFEAB308),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Standard AppBar / In-line Theme Switcher Button
class ThemeSwitcherButton extends StatelessWidget {
  final bool isFloating;

  const ThemeSwitcherButton({
    super.key,
    this.isFloating = false,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.themeModeNotifier,
      builder: (context, currentMode, _) {
        final isDark = currentMode == ThemeMode.dark;

        return Tooltip(
          message: isDark ? "Switch to Light Theme" : "Switch to 11Jobs Dark Theme",
          child: InkWell(
            key: const Key('themeSwitcherButton'),
            onTap: () {
              AppTheme.toggleTheme();
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: isDark ? const Color(0xFF0F1A30) : const Color(0xFF005BFF),
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  content: Row(
                    children: [
                      ElevenJobsFlowerIcon(
                        size: 20,
                        color: isDark ? const Color(0xFFFACC15) : Colors.white,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        isDark
                            ? "Switched to Light Theme ☀️"
                            : "Switched to 11Jobs Midnight Navy Theme 🌙",
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              );
            },
            borderRadius: BorderRadius.circular(20),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF162035) : const Color(0xFFEFF6FF),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? const Color(0xFFFACC15).withValues(alpha: 0.6) : const Color(0xFFBFDBFE),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? const Color(0xFFFACC15).withValues(alpha: 0.25)
                        : const Color(0xFF005BFF).withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ElevenJobsFlowerIcon(
                size: 20,
                color: isDark ? const Color(0xFFFACC15) : const Color(0xFF005BFF),
              ),
            ),
          ),
        );
      },
    );
  }
}
