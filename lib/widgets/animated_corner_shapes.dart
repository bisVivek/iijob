import 'package:flutter/material.dart';

class AnimatedCornerShapes extends StatelessWidget {
  final Animation<double> entranceProgress;

  const AnimatedCornerShapes({
    super.key,
    required this.entranceProgress,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: entranceProgress,
      builder: (context, child) {
        final entrance = entranceProgress.value;

        return Stack(
          children: [
            // Top-Right Outer Light Blue Halo
            Positioned(
              top: -120 + (1 - entrance) * -140,
              right: -100 + (1 - entrance) * 140,
              child: Transform.scale(
                scale: entrance,
                child: Container(
                  width: 320,
                  height: 320,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFE3EFFF).withValues(alpha: 0.9),
                  ),
                ),
              ),
            ),

            // Top-Right Inner Royal Blue Sphere
            Positioned(
              top: -85 + (1 - entrance) * -120,
              right: -75 + (1 - entrance) * 120,
              child: Transform.scale(
                scale: entrance,
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF236DF6),
                        Color(0xFF004BD6),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF004BD6).withValues(alpha: 0.35),
                        blurRadius: 35,
                        offset: const Offset(-5, 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Top-Left Floating Sphere (Medium Blue)
            Positioned(
              top: 90 + (1 - entrance) * -80,
              left: 24 + (1 - entrance) * -60,
              child: Transform.scale(
                scale: entrance,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF3B82F6),
                        Color(0xFF1D4ED8),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1D4ED8).withValues(alpha: 0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Top-Left Secondary Soft Sphere (Small Light Blue)
            Positioned(
              top: 135 + (1 - entrance) * -60,
              left: 68 + (1 - entrance) * -40,
              child: Transform.scale(
                scale: entrance,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFBFDBFE).withValues(alpha: 0.75),
                  ),
                ),
              ),
            ),

            // Bottom-Left Outer Light Blue Halo
            Positioned(
              bottom: -130 + (1 - entrance) * -140,
              left: -110 + (1 - entrance) * -140,
              child: Transform.scale(
                scale: entrance,
                child: Container(
                  width: 340,
                  height: 340,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFE3EFFF).withValues(alpha: 0.9),
                  ),
                ),
              ),
            ),

            // Bottom-Left Inner Royal Blue Sphere
            Positioned(
              bottom: -90 + (1 - entrance) * -120,
              left: -80 + (1 - entrance) * -120,
              child: Transform.scale(
                scale: entrance,
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF236DF6),
                        Color(0xFF004BD6),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF004BD6).withValues(alpha: 0.35),
                        blurRadius: 35,
                        offset: const Offset(8, -8),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom-Left Companion Soft Blue Sphere
            Positioned(
              bottom: 48 + (1 - entrance) * -50,
              left: 165 + (1 - entrance) * -50,
              child: Transform.scale(
                scale: entrance,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFD3E5FD).withValues(alpha: 0.8),
                  ),
                ),
              ),
            ),

            // Bottom-Right Floating Sphere
            Positioned(
              bottom: 125 + (1 - entrance) * -80,
              right: 32 + (1 - entrance) * 60,
              child: Transform.scale(
                scale: entrance,
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF60A5FA),
                        Color(0xFF2563EB),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2563EB).withValues(alpha: 0.28),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
