import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Interactive Raycast / Linear Styled Drawer Theme Toggle Card (No Yellow - Sleek Blue/Indigo/Slate Flow)
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
            ? const Color(0xFF6366F1).withValues(alpha: 0.4)
            : const Color(0xFFCBD5E1);
        final txtPrimary = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);

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
                  color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                  blurRadius: 18,
                  offset: const Offset(0, 4),
                )
              else
                BoxShadow(
                  color: const Color(0xFF005BFF).withValues(alpha: 0.05),
                  blurRadius: 10,
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
                  // Animated Morphing Icon Badge (Indigo/Cyan in Dark Mode, Royal Blue in Light Mode)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? const Color(0xFF6366F1) : const Color(0xFF38BDF8),
                        width: 1.5,
                      ),
                      boxShadow: [
                        if (isDark)
                          BoxShadow(
                            color: const Color(0xFF6366F1).withValues(alpha: 0.35),
                            blurRadius: 12,
                            offset: const Offset(0, 2),
                          )
                        else
                          BoxShadow(
                            color: const Color(0xFF005BFF).withValues(alpha: 0.2),
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
                        color: isDark ? const Color(0xFF818CF8) : const Color(0xFF005BFF),
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
                          "Theme Preference",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: txtPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isDark ? "Midnight Obsidian 🌙" : "Daylight Crisp ☀️",
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: isDark ? const Color(0xFF818CF8) : const Color(0xFF005BFF),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Interactive Custom Pill Switch (Fluid Slide Animation)
                  GestureDetector(
                    key: const Key('drawerThemeSwitch'),
                    onTap: () {
                      AppTheme.toggleTheme();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 280),
                      curve: Curves.easeInOut,
                      width: 52,
                      height: 28,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF312E81) : const Color(0xFF005BFF),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: (isDark ? const Color(0xFF6366F1) : const Color(0xFF005BFF))
                                .withValues(alpha: 0.35),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          AnimatedAlign(
                            duration: const Duration(milliseconds: 280),
                            curve: Curves.easeOutBack,
                            alignment: isDark ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              width: 22,
                              height: 22,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Icon(
                                  isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                                  size: 13,
                                  color: isDark ? const Color(0xFF4338CA) : const Color(0xFF005BFF),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Segmented Modern Theme Tabs (Daylight Light / Obsidian Dark)
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
                        splashColor: const Color(0xFF005BFF).withValues(alpha: 0.15),
                        highlightColor: const Color(0xFF005BFF).withValues(alpha: 0.08),
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
                                color: !isDark ? const Color(0xFF005BFF) : const Color(0xFF64748B),
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

                    // Dark Tab Pill (Glowing Electric Indigo & Cyan when active)
                    Expanded(
                      child: InkWell(
                        key: const Key('themeSelectorDarkTab'),
                        borderRadius: BorderRadius.circular(9),
                        splashColor: const Color(0xFF6366F1).withValues(alpha: 0.2),
                        highlightColor: const Color(0xFF6366F1).withValues(alpha: 0.1),
                        onTap: () {
                          if (!isDark) AppTheme.setTheme(ThemeMode.dark);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeInOut,
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E293B) : Colors.transparent,
                            borderRadius: BorderRadius.circular(9),
                            border: isDark
                                ? Border.all(
                                    color: const Color(0xFF6366F1).withValues(alpha: 0.8),
                                    width: 1.2,
                                  )
                                : null,
                            boxShadow: isDark
                                ? [
                                    BoxShadow(
                                      color: const Color(0xFF6366F1).withValues(alpha: 0.25),
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
                                color: isDark ? const Color(0xFF818CF8) : const Color(0xFF64748B),
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  "Dark",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: isDark ? FontWeight.w800 : FontWeight.w600,
                                    color: isDark ? const Color(0xFFF8FAFC) : const Color(0xFF64748B),
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

/// Standard AppBar / In-line Theme Switcher Button (No Yellow - Interactive Blue/Indigo Glow)
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
          message: isDark ? "Switch to Daylight Theme" : "Switch to Midnight Theme",
          child: InkWell(
            key: const Key('themeSwitcherButton'),
            onTap: () {
              AppTheme.toggleTheme();
            },
            borderRadius: BorderRadius.circular(20),
            splashColor: const Color(0xFF005BFF).withValues(alpha: 0.2),
            highlightColor: const Color(0xFF005BFF).withValues(alpha: 0.1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF162035) : const Color(0xFFEFF6FF),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? const Color(0xFF6366F1) : const Color(0xFF38BDF8),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? const Color(0xFF6366F1).withValues(alpha: 0.35)
                        : const Color(0xFF005BFF).withValues(alpha: 0.2),
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
                  color: isDark ? const Color(0xFF818CF8) : const Color(0xFF005BFF),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Floating Docked Theme Toggle
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
      duration: const Duration(milliseconds: 500),
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
              message: isDark ? "Switch to Daylight Theme" : "Switch to Midnight Theme",
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
                        color: isDark
                            ? const Color(0xFF6366F1).withValues(alpha: 0.7)
                            : const Color(0xFF005BFF),
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
                          color: const Color(0xFF6366F1).withValues(alpha: 0.25),
                          blurRadius: 10,
                          offset: const Offset(-1, 0),
                        ),
                    ],
                  ),
                  child: RotationTransition(
                    turns: _rotationController,
                    child: Icon(
                      isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                      size: 24,
                      color: isDark ? const Color(0xFF818CF8) : const Color(0xFF005BFF),
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
