import 'package:flutter/material.dart';
import '../services/auth_storage_service.dart';
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

    // 1. Fade-in: 0.0 -> 1.0 over ~200ms with easeOutCubic, then holds permanently
    _logoFadeAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 200.0,
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(1.0),
        weight: 1400.0,
      ),
    ]).animate(_controller);

    // 2. Scale: single smooth ease 0.94 -> 1.00 over ~300ms, no overshoot, then holds
    _logoScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.94, end: 1.00)
            .chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 300.0,
      ),
      // Holds steady at 100% for the remainder
      TweenSequenceItem(
        tween: ConstantTween<double>(1.00),
        weight: 1300.0,
      ),
    ]).animate(_controller);

    // Initialize local storage in parallel
    AuthStorageService.init();
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
          transitionDuration: const Duration(milliseconds: 550),
          pageBuilder: (context, animation, secondaryAnimation) => destination,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            );

            return FadeTransition(
              opacity: curvedAnimation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.98, end: 1.0).animate(curvedAnimation),
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
    // The PNG has a white background — intentionally contain it inside a
    // rounded white badge (like an app icon) so it looks clean on the blue splash.
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Image.asset(
          'assets/icons/11job_icon_splace.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
