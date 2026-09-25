import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../services/profile_storage_service.dart';
import 'animated_signin_screen.dart';

/// Clean, Minimal & Brand-Focused 11Jobs Splash Screen
///
/// Sequence:
/// 1. Solid Blue background (#005BFF)
/// 2. Original logo smoothly scales in (90% -> 101.5%) and fades in directly on blue
/// 3. Logo settles (101.5% -> 100%) with tiny natural motion and stays calm & fully visible
/// 4. Logo remains visually intact (no fading out, no shrinking, no blur, no disappearing)
/// 5. Blue splash screen naturally expands/reveals into the Sign In screen
///
/// Duration: 1.65s total, 60 FPS, native Flutter animations, zero bypass.
class SplashScreen extends StatefulWidget {
  final Widget? nextScreen;
  final Duration totalDuration;

  const SplashScreen({
    super.key,
    this.nextScreen,
    this.totalDuration = const Duration(milliseconds: 1600),
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // Logo Animation Tracks
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _logoScaleAnimation;

  bool _hasNavigated = false;

  // Signature Solid Brand Blue
  static const Color _brandBlue = Color(0xFF005BFF);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.totalDuration,
    );

    // 1. Instant Smooth Fade-in (0.0 -> 1.0 in first 0.15s, then STAYS at 1.0 permanently)
    _logoFadeAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 150.0,
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(1.0),
        weight: 1450.0,
      ),
    ]).animate(_controller);

    // 2. Fast entrance & settle: 0–0.15s (0.94 -> 1.02) -> 0.15–0.30s (1.02 -> 1.00) -> 0.30s onward (STABLE 1.00)
    _logoScaleAnimation = TweenSequence<double>([
      // 0–0.15s: Smooth scale from 0.94 to 1.02
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.94, end: 1.02)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 150.0,
      ),
      // 0.15–0.30s: Subtle natural settle from 1.02 to 1.00
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.02, end: 1.00)
            .chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 150.0,
      ),
      // 0.30s onward: Holds steady and stable at 100%
      TweenSequenceItem(
        tween: ConstantTween<double>(1.00),
        weight: 1300.0,
      ),
    ]).animate(_controller);

    // Initialize local storage in parallel
    ProfileStorageService.init();

    // Auto navigation only after the full animation completes
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _navigateToNext();
      }
    });

    _controller.forward();
  }

  void _navigateToNext() {
    if (_hasNavigated || !mounted) return;
    _hasNavigated = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final destination = widget.nextScreen ?? const AnimatedSignInScreen();
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (context, animation, secondaryAnimation) => destination,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            );

            return FadeTransition(
              opacity: curvedAnimation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.95, end: 1.0).animate(curvedAnimation),
                child: child,
              ),
            );
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _brandBlue,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final logoFade = _logoFadeAnimation.value;
            final logoScale = _logoScaleAnimation.value;

            return Opacity(
              opacity: logoFade,
              child: Transform.scale(
                scale: logoScale,
                child: SizedBox(
                  width: 120,
                  height: 120,
                  child: _buildLogoImage(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLogoImage() {
    return Image.asset(
      'assets/icons/11job_icon_splace.png',
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Center(
          child: SvgPicture.asset(
            'assets/icons/11jobs.svg',
            width: 95,
            fit: BoxFit.contain,
          ),
        );
      },
    );
  }
}
