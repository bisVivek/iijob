import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_corner_shapes.dart';
import '../widgets/animated_sign_in_button.dart';
import '../widgets/brand_logo.dart';
import '../widgets/custom_text_field.dart';
import 'home_screen.dart';

class AnimatedSignInScreen extends StatefulWidget {
  const AnimatedSignInScreen({super.key});

  @override
  State<AnimatedSignInScreen> createState() => _AnimatedSignInScreenState();
}

class _AnimatedSignInScreenState extends State<AnimatedSignInScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _mainController;

  // Staggered Entrance Animations (Plays only once on startup)
  late Animation<double> _cornerShapesAnimation;
  late Animation<double> _cardScaleAnimation;
  late Animation<double> _cardFadeAnimation;
  late Animation<Offset> _cardSlideAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<Offset> _logoSlideAnimation;
  late Animation<double> _titleFadeAnimation;
  late Animation<Offset> _titleSlideAnimation;
  late Animation<double> _field1Animation;
  late Animation<Offset> _field1SlideAnimation;
  late Animation<double> _field2Animation;
  late Animation<Offset> _field2SlideAnimation;
  late Animation<double> _buttonAnimation;
  late Animation<Offset> _buttonSlideAnimation;
  late Animation<double> _footerAnimation;

  // Mode: Sign In vs Sign Up
  bool _isSignUp = false;
  bool _isLoading = false;

  // Form & Controllers
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _setupAnimations();
    _mainController.forward();
  }

  void _setupAnimations() {
    // 1. Background corner shapes
    _cornerShapesAnimation = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.0, 0.55, curve: Curves.easeOutBack),
    );

    // 2. White Card Container
    _cardScaleAnimation = Tween<double>(begin: 0.90, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.15, 0.65, curve: Curves.easeOutBack),
      ),
    );
    _cardFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.15, 0.55, curve: Curves.easeOut),
      ),
    );
    _cardSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.15, 0.65, curve: Curves.easeOutCubic),
      ),
    );

    // 3. 11Jobs Logo
    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.25, 0.65, curve: Curves.easeOut),
      ),
    );
    _logoSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.25, 0.65, curve: Curves.easeOutCubic),
      ),
    );

    // 4. Title & Subtitle
    _titleFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.35, 0.70, curve: Curves.easeOut),
      ),
    );
    _titleSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.35, 0.70, curve: Curves.easeOutCubic),
      ),
    );

    // 5. Input Fields
    _field1Animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.45, 0.80, curve: Curves.easeOut),
      ),
    );
    _field1SlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.45, 0.80, curve: Curves.easeOutCubic),
      ),
    );

    _field2Animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.55, 0.88, curve: Curves.easeOut),
      ),
    );
    _field2SlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.55, 0.88, curve: Curves.easeOutCubic),
      ),
    );

    // 6. Action Button
    _buttonAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.65, 0.95, curve: Curves.easeOutBack),
      ),
    );
    _buttonSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.65, 0.95, curve: Curves.easeOutCubic),
      ),
    );

    // 7. Footer Links
    _footerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.75, 1.0, curve: Curves.easeOut),
      ),
    );
  }

  @override
  void dispose() {
    _mainController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _toggleMode() {
    setState(() {
      _isSignUp = !_isSignUp;
    });
  }

  void _handleAuth() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
    });

    // Simulating authentication delay
    await Future.delayed(const Duration(milliseconds: 900));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      final displayName = _isSignUp
          ? (_nameController.text.trim().isNotEmpty
              ? _nameController.text.trim()
              : "11Jobs User")
          : (_emailController.text.trim().isNotEmpty
              ? _emailController.text.trim().split('@').first
              : "11Jobs User");

      // Navigate to blank Coming Soon Home Screen
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 550),
          pageBuilder: (context, animation, secondaryAnimation) =>
              HomeScreen(username: displayName),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    }
  }

  Widget _buildFieldLabel(String label, {bool showInfo = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          if (showInfo) ...[
            const SizedBox(width: 4),
            Tooltip(
              message: "Must be at least 6 characters",
              child: Icon(
                Icons.info_outline_rounded,
                size: 15,
                color: AppTheme.textSecondary.withValues(alpha: 0.8),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          // 1. Background Orbs & Concentric Halos (One-time smooth entrance)
          AnimatedCornerShapes(
            entranceProgress: _cornerShapesAnimation,
          ),

          // 2. Central Sign In / Sign Up Card
          Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 32.0),
              child: AnimatedBuilder(
                animation: _mainController,
                builder: (context, child) {
                  return SlideTransition(
                    position: _cardSlideAnimation,
                    child: FadeTransition(
                      opacity: _cardFadeAnimation,
                      child: Transform.scale(
                        scale: _cardScaleAnimation.value,
                        child: child,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 390),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 30.0,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.cardSurface,
                    borderRadius: BorderRadius.circular(32.0),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF005BFF).withValues(alpha: 0.08),
                        blurRadius: 35.0,
                        spreadRadius: 2.0,
                        offset: const Offset(0, 16),
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10.0,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // --- 11Jobs SVG Logo Header ---
                        AnimatedBuilder(
                          animation: _mainController,
                          builder: (context, child) {
                            return SlideTransition(
                              position: _logoSlideAnimation,
                              child: FadeTransition(
                                opacity: _logoFadeAnimation,
                                child: child,
                              ),
                            );
                          },
                          child: const Align(
                            alignment: Alignment.centerLeft,
                            child: BrandLogo(height: 28),
                          ),
                        ),

                        const SizedBox(height: 20.0),

                        // --- Title & Subtitle: "Sign In" / "Sign Up" ---
                        AnimatedBuilder(
                          animation: _mainController,
                          builder: (context, child) {
                            return SlideTransition(
                              position: _titleSlideAnimation,
                              child: FadeTransition(
                                opacity: _titleFadeAnimation,
                                child: child,
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _isSignUp ? "Sign Up" : "Sign In",
                                style: const TextStyle(
                                  fontSize: 26.0,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.textPrimary,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              const SizedBox(height: 6.0),
                              Text(
                                _isSignUp
                                    ? "Create your account to access 11Jobs dashboard"
                                    : "Login to access your 11Jobs dashboard",
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w400,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24.0),

                        // --- Extra Name Field for Sign Up ---
                        AnimatedSize(
                          duration: const Duration(milliseconds: 320),
                          curve: Curves.easeInOutCubic,
                          child: _isSignUp
                              ? Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildFieldLabel("Full Name"),
                                      CustomTextField(
                                        controller: _nameController,
                                        hintText: "Enter your name",
                                        prefixIcon: Icons.badge_outlined,
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),

                        // --- Field 1: Company Email ---
                        AnimatedBuilder(
                          animation: _mainController,
                          builder: (context, child) {
                            return SlideTransition(
                              position: _field1SlideAnimation,
                              child: FadeTransition(
                                opacity: _field1Animation,
                                child: child,
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFieldLabel("Company Email"),
                              CustomTextField(
                                controller: _emailController,
                                hintText: "Email",
                                prefixIcon: Icons.mail_outline_rounded,
                                keyboardType: TextInputType.emailAddress,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16.0),

                        // --- Field 2: Password with Info Icon ---
                        AnimatedBuilder(
                          animation: _mainController,
                          builder: (context, child) {
                            return SlideTransition(
                              position: _field2SlideAnimation,
                              child: FadeTransition(
                                opacity: _field2Animation,
                                child: child,
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFieldLabel("Password", showInfo: true),
                              CustomTextField(
                                controller: _passwordController,
                                hintText: "Password",
                                isPassword: true,
                                prefixIcon: Icons.lock_outline_rounded,
                              ),
                            ],
                          ),
                        ),

                        // --- Extra Confirm Password for Sign Up ---
                        AnimatedSize(
                          duration: const Duration(milliseconds: 320),
                          curve: Curves.easeInOutCubic,
                          child: _isSignUp
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildFieldLabel("Confirm Password"),
                                      CustomTextField(
                                        controller: _confirmPasswordController,
                                        hintText: "Confirm Password",
                                        isPassword: true,
                                        prefixIcon: Icons.lock_reset_rounded,
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),

                        const SizedBox(height: 10.0),

                        // --- Forgot Password Link (Right Aligned, Sign In mode) ---
                        AnimatedSize(
                          duration: const Duration(milliseconds: 250),
                          child: !_isSignUp
                              ? AnimatedBuilder(
                                  animation: _mainController,
                                  builder: (context, child) {
                                    return FadeTransition(
                                      opacity: _footerAnimation,
                                      child: child,
                                    );
                                  },
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            backgroundColor: AppTheme.primaryBlue,
                                            content: const Text(
                                              "Password reset instructions sent to your email!",
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                      },
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 4,
                                          vertical: 6,
                                        ),
                                        minimumSize: Size.zero,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: const Text(
                                        "Forgot Password",
                                        style: TextStyle(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.primaryBlue,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),

                        const SizedBox(height: 18.0),

                        // --- Sign In / Sign Up Button ---
                        AnimatedBuilder(
                          animation: _mainController,
                          builder: (context, child) {
                            return SlideTransition(
                              position: _buttonSlideAnimation,
                              child: FadeTransition(
                                opacity: _buttonAnimation,
                                child: child,
                              ),
                            );
                          },
                          child: AnimatedSignInButton(
                            text: _isSignUp ? "Sign Up" : "Sign In",
                            isLoading: _isLoading,
                            onPressed: _handleAuth,
                          ),
                        ),

                        const SizedBox(height: 22.0),

                        // --- Footer Toggle Link: New to 11Jobs? Create New Account ---
                        AnimatedBuilder(
                          animation: _mainController,
                          builder: (context, child) {
                            return FadeTransition(
                              opacity: _footerAnimation,
                              child: child,
                            );
                          },
                          child: Center(
                            child: GestureDetector(
                              onTap: _toggleMode,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                child: Text.rich(
                                  TextSpan(
                                    text: _isSignUp
                                        ? "Already have an account? "
                                        : "New to 11Jobs? ",
                                    style: const TextStyle(
                                      fontSize: 13.0,
                                      color: AppTheme.textSecondary,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Roboto',
                                    ),
                                    children: [
                                      TextSpan(
                                        text: _isSignUp
                                            ? "Sign In"
                                            : "Create New Account",
                                        style: const TextStyle(
                                          color: AppTheme.primaryBlue,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
