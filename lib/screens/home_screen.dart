import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'animated_signin_screen.dart';

class HomeScreen extends StatelessWidget {
  final String username;

  const HomeScreen({
    super.key,
    this.username = "User",
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Home",
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Logout',
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: const Icon(
                Icons.logout_rounded,
                color: AppTheme.primaryBlue,
                size: 20,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 500),
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const AnimatedSignInScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ),
              );
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Glowing Icon Illustration
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF2B78FE),
                      Color(0xFF004BD6),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryBlue.withValues(alpha: 0.35),
                      blurRadius: 30,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.rocket_launch_rounded,
                  color: Colors.white,
                  size: 52,
                ),
              ),

              const SizedBox(height: 32),

              // Title
              Text(
                "Welcome, $username!",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: 12),

              // Coming Soon Banner Tag
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F1FD),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "COMING SOON",
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primaryBlue,
                    letterSpacing: 1.5,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Subtext
              const Text(
                "We are crafting something amazing for you.\nStay tuned for upcoming updates!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.5,
                  color: AppTheme.textSecondary,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
