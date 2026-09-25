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
    this.color = const Color(0xFFFACC15), // Vibrant 11Jobs Yellow
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

/// Professional Drawer Theme Toggle Card (Linear / Raycast Styled)
class DrawerThemeToggleCard extends StatelessWidget {
  const DrawerThemeToggleCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.themeModeNotifier,
      builder: (context, currentMode, _) {
        final isDark = currentMode == ThemeMode.dark;

        final cardBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
        final cardBorder = isDark
            ? const Color(0xFFFACC15).withValues(alpha: 0.35)
            : const Color(0xFFE2E8F0);
        final txtPrimary = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
        final txtSecondary = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: cardBorder,
              width: isDark ? 1.4 : 1.0,
            ),
            boxShadow: [
              if (isDark)
                BoxShadow(
                  color: const Color(0xFFFACC15).withValues(alpha: 0.12),
                  blurRadius: 18,
                  offset: const Offset(0, 4),
                )
              else
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row: Icon + Title + Switch
              Row(
                children: [
                  // Animated Morphing Icon Badge (Yellow Glow in Dark Mode, Golden Sun in Light Mode)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFFEF9C3),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? const Color(0xFFFACC15) : const Color(0xFFFDE047),
                        width: 1.5,
                      ),
                      boxShadow: [
                        if (isDark)
                          BoxShadow(
                            color: const Color(0xFFFACC15).withValues(alpha: 0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 2),
                          )
                        else
                          BoxShadow(
                            color: const Color(0xFFFACC15).withValues(alpha: 0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                      ],
                    ),
                    child: AnimatedRotation(
                      turns: isDark ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOutBack,
                      child: Icon(
                        isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                        size: 20,
                        color: isDark ? const Color(0xFFFACC15) : const Color(0xFFD97706),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Label and Subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Dark Mode",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: txtPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isDark ? "11Jobs Midnight Dark 🌙" : "Clean Crisp Light ☀️",
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: isDark ? const Color(0xFFFACC15) : txtSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Yellow-Themed Switch Toggle with Thumb Icons
                  Switch(
                    key: const Key('drawerThemeSwitch'),
                    value: isDark,
                    activeThumbColor: const Color(0xFFFACC15), // Vibrant 11Jobs Yellow
                    activeTrackColor: const Color(0xFF334155),
                    inactiveThumbColor: const Color(0xFFF59E0B),
                    inactiveTrackColor: const Color(0xFFE2E8F0),
                    trackOutlineColor: WidgetStateProperty.resolveWith<Color?>(
                      (states) => states.contains(WidgetState.selected)
                          ? const Color(0xFFFACC15).withValues(alpha: 0.6)
                          : const Color(0xFFCBD5E1),
                    ),
                    thumbIcon: WidgetStateProperty.resolveWith<Icon?>(
                      (Set<WidgetState> states) {
                        if (states.contains(WidgetState.selected)) {
                          return const Icon(
                            Icons.dark_mode_rounded,
                            size: 13,
                            color: Color(0xFF0F172A),
                          );
                        }
                        return const Icon(
                          Icons.light_mode_rounded,
                          size: 13,
                          color: Color(0xFFFFFFFF),
                        );
                      },
                    ),
                    onChanged: (val) {
                      AppTheme.toggleTheme();
                    },
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Segmented Modern Theme Tabs (Light / Dark)
              Container(
                height: 40,
                padding: const EdgeInsets.all(3.5),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF070C1E) : const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(12),
                  border: isDark
                      ? Border.all(
                          color: const Color(0xFF1E293B),
                          width: 1,
                        )
                      : null,
                ),
                child: Row(
                  children: [
                    // Light Tab Pill
                    Expanded(
                      child: InkWell(
                        key: const Key('themeSelectorLightTab'),
                        borderRadius: BorderRadius.circular(9),
                        splashColor: const Color(0xFFFACC15).withValues(alpha: 0.2),
                        highlightColor: const Color(0xFFFACC15).withValues(alpha: 0.1),
                        onTap: () {
                          if (isDark) AppTheme.setTheme(ThemeMode.light);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeInOut,
                          decoration: BoxDecoration(
                            color: !isDark ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(9),
                            border: !isDark
                                ? Border.all(
                                    color: const Color(0xFFCBD5E1),
                                    width: 1,
                                  )
                                : null,
                            boxShadow: !isDark
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.06),
                                      blurRadius: 4,
                                      offset: const Offset(0, 1),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.light_mode_rounded,
                                size: 16,
                                color: !isDark ? const Color(0xFFD97706) : const Color(0xFF64748B),
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  "Light",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: !isDark ? FontWeight.w800 : FontWeight.w600,
                                    color: !isDark ? const Color(0xFF0F172A) : const Color(0xFF64748B),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 4),

                    // Dark Tab Pill (Glowing Yellow Accent when active)
                    Expanded(
                      child: InkWell(
                        key: const Key('themeSelectorDarkTab'),
                        borderRadius: BorderRadius.circular(9),
                        splashColor: const Color(0xFFFACC15).withValues(alpha: 0.2),
                        highlightColor: const Color(0xFFFACC15).withValues(alpha: 0.1),
                        onTap: () {
                          if (!isDark) AppTheme.setTheme(ThemeMode.dark);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeInOut,
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF16233B) : Colors.transparent,
                            borderRadius: BorderRadius.circular(9),
                            border: isDark
                                ? Border.all(
                                    color: const Color(0xFFFACC15).withValues(alpha: 0.6),
                                    width: 1.2,
                                  )
                                : null,
                            boxShadow: isDark
                                ? [
                                    BoxShadow(
                                      color: const Color(0xFFFACC15).withValues(alpha: 0.22),
                                      blurRadius: 8,
                                      offset: const Offset(0, 1),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.dark_mode_rounded,
                                size: 16,
                                color: isDark ? const Color(0xFFFACC15) : const Color(0xFF64748B),
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  "Dark",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: isDark ? FontWeight.w800 : FontWeight.w600,
                                    color: isDark ? const Color(0xFFFACC15) : const Color(0xFF64748B),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Floating Docked Theme Toggle (Optional)
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
                    color: isDark ? const Color(0xE6151E2E) : const Color(0xF0FFFFFF),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                    border: Border(
                      left: BorderSide(
                        color: isDark ? const Color(0xFFFACC15).withValues(alpha: 0.7) : const Color(0xFFCBD5E1),
                        width: 1.4,
                      ),
                      top: BorderSide(
                        color: isDark ? const Color(0xFF2E3D59) : const Color(0xFFCBD5E1),
                        width: 1.2,
                      ),
                      bottom: BorderSide(
                        color: isDark ? const Color(0xFF2E3D59) : const Color(0xFFCBD5E1),
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
                          color: const Color(0xFFFACC15).withValues(alpha: 0.25),
                          blurRadius: 10,
                          offset: const Offset(-1, 0),
                        ),
                    ],
                  ),
                  child: RotationTransition(
                    turns: _rotationController,
                    child: ElevenJobsFlowerIcon(
                      size: 26,
                      color: isDark ? const Color(0xFFFACC15) : const Color(0xFFEAB308),
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
            },
            borderRadius: BorderRadius.circular(20),
            splashColor: const Color(0xFFFACC15).withValues(alpha: 0.3),
            highlightColor: const Color(0xFFFACC15).withValues(alpha: 0.15),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF162035) : const Color(0xFFFEF9C3),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? const Color(0xFFFACC15) : const Color(0xFFFDE047),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? const Color(0xFFFACC15).withValues(alpha: 0.35)
                        : const Color(0xFFF59E0B).withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: AnimatedRotation(
                turns: isDark ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutBack,
                child: Icon(
                  isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                  size: 19,
                  color: isDark ? const Color(0xFFFACC15) : const Color(0xFFD97706),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
