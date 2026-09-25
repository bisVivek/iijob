import 'package:flutter/material.dart';
import '../services/auth_storage_service.dart';
import '../theme/app_theme.dart';
import '../widgets/brand_logo.dart';
import '../widgets/theme_switcher_button.dart';
import '../widgets/fade_slide_transition.dart';
import '../widgets/animated_counter.dart';
import '../widgets/pulsing_badge.dart';
import 'home_screen.dart';
import 'animated_signin_screen.dart';
import 'assessment_screen.dart';

class AssessmentResultScreen extends StatelessWidget {
  final String candidateName;
  final int totalQuestions;
  final int correctCount;
  final UserAccount? userAccount;

  const AssessmentResultScreen({
    super.key,
    required this.candidateName,
    required this.totalQuestions,
    required this.correctCount,
    this.userAccount,
  });

  bool get isPassed => (correctCount / totalQuestions) >= 0.8;
  int get scorePercentage => ((correctCount / totalQuestions) * 100).round();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final verifiedId = "11J-VERIFIED-${(candidateName.hashCode.abs() % 9000 + 1000)}";

    final bgColor = isDark ? const Color(0xFF060919) : AppTheme.lightBackground;
    final cardBg = isDark ? const Color(0xFF0D1527) : Colors.white;
    final borderColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);
    final txtPrimary = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
    final txtSecondary = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: const BrandLogo(height: 24),
        automaticallyImplyLeading: false,
        actions: const [
          ThemeSwitcherButton(),
          SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: FadeSlideTransition(
              delayMs: 100,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 460),
                padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 32.0),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: borderColor),
                  boxShadow: [
                    BoxShadow(
                      color: isPassed
                          ? const Color(0xFF005BFF).withValues(alpha: isDark ? 0.25 : 0.12)
                          : const Color(0xFFEF4444).withValues(alpha: isDark ? 0.25 : 0.08),
                      blurRadius: 36,
                      offset: const Offset(0, 14),
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Status Icon with Radial Halo
                    Center(
                      child: PulsingBadge(
                        glowColor: isPassed ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                        child: Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: isPassed
                                  ? [const Color(0xFF10B981), const Color(0xFF059669)]
                                  : [const Color(0xFFF59E0B), const Color(0xFFD97706)],
                            ),
                          ),
                          child: Icon(
                            isPassed ? Icons.verified_rounded : Icons.replay_rounded,
                            color: Colors.white,
                            size: 48,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    // Title
                    Text(
                      isPassed ? "Assessment Passed! 🎉" : "Assessment Incomplete",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: txtPrimary,
                        letterSpacing: 0.3,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Candidate Greeting & Subtitle
                    Text(
                      isPassed
                          ? "Congratulations, $candidateName! You have successfully verified your profile."
                          : "Nice try, $candidateName! An 80% passing score is required to unlock full access.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: txtSecondary,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 22),

                    // Score Metric Banner
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                      decoration: BoxDecoration(
                        color: isPassed
                            ? (isDark ? const Color(0xFF064E3B).withValues(alpha: 0.4) : const Color(0xFFECFDF5))
                            : (isDark ? const Color(0xFF78350F).withValues(alpha: 0.3) : const Color(0xFFFFFBEB)),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isPassed
                              ? (isDark ? const Color(0xFF059669) : const Color(0xFFA7F3D0))
                              : (isDark ? const Color(0xFFD97706) : const Color(0xFFFDE68A)),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                "SCORE",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.8,
                                  color: txtSecondary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              AnimatedCounter(
                                value: scorePercentage.toDouble(),
                                suffix: "%",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: txtPrimary,
                                ),
                              ),
                            ],
                          ),
                          Container(width: 1, height: 36, color: borderColor),
                          _buildMetric("CORRECT", "$correctCount / $totalQuestions", txtPrimary, txtSecondary),
                          Container(width: 1, height: 36, color: borderColor),
                          _buildMetric("STATUS", isPassed ? "VERIFIED" : "PENDING", txtPrimary, txtSecondary),
                        ],
                      ),
                    ),

                  const SizedBox(height: 20),

                  // Verified Candidate Badge Card (Only if Passed)
                  if (isPassed) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF0F1D38) : const Color(0xFFF0F6FF),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isDark ? const Color(0xFF2563EB).withValues(alpha: 0.4) : const Color(0xFFBFDBFE),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.workspace_premium_rounded,
                                color: AppTheme.primaryBlue,
                                size: 22,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "11Jobs Verified Candidate",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? const Color(0xFF38BDF8) : AppTheme.primaryBlue,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "#$verifiedId",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: txtSecondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          _buildUnlockItem("Verified badge displayed on your recruiter profile", txtPrimary),
                          _buildUnlockItem("Unlocked access to 11Jobs Dashboard & job applications", txtPrimary),
                          _buildUnlockItem("Priority AI pipeline placement for high-match roles", txtPrimary),
                        ],
                      ),
                    ),
                    const SizedBox(height: 26),
                  ] else ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF450A0A).withValues(alpha: 0.4) : const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isDark ? const Color(0xFF991B1B) : const Color(0xFFFECACA),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.info_outline_rounded, color: AppTheme.errorColor, size: 20),
                              SizedBox(width: 8),
                              Text(
                                "Passing Requirement: 80%",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.errorColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Top companies on 11Jobs seek candidates with demonstrated logic & engineering problem solving. Review your answers and try again!",
                            style: TextStyle(
                              fontSize: 12.5,
                              color: isDark ? const Color(0xFFFCA5A5) : const Color(0xFF7F1D1D),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 26),
                  ],

                  // Action Buttons
                  if (isPassed) ...[
                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        key: const Key('enterDashboardButton'),
                        onPressed: () {
                          // Update user account verification state in Hive
                          if (userAccount != null) {
                            userAccount!.isVerified = true;
                            userAccount!.assessmentScore = scorePercentage;
                            AuthStorageService.updateUser(userAccount!);
                            AuthStorageService.saveCurrentSession(userAccount!);
                          }
                          Navigator.of(context).pushReplacement(
                            PageRouteBuilder(
                              transitionDuration: const Duration(milliseconds: 550),
                              pageBuilder: (context, animation, secondaryAnimation) =>
                                  HomeScreen(
                                username: candidateName,
                                isVerified: true,
                                score: scorePercentage,
                              ),
                              transitionsBuilder:
                                  (context, animation, secondaryAnimation, child) {
                                return FadeTransition(opacity: animation, child: child);
                              },
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryBlue,
                          elevation: 4,
                          shadowColor: AppTheme.primaryBlue.withValues(alpha: 0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                        ),
                        child: const FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "ENTER 11JOBS DASHBOARD",
                                style: TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 0.6,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    // Retake Assessment Button
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        key: const Key('retakeAssessmentButton'),
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            PageRouteBuilder(
                              transitionDuration: const Duration(milliseconds: 400),
                              pageBuilder: (context, animation, secondaryAnimation) =>
                                  AssessmentScreen(
                                candidateName: candidateName,
                                userAccount: userAccount,
                              ),
                              transitionsBuilder:
                                  (context, animation, secondaryAnimation, child) {
                                return FadeTransition(opacity: animation, child: child);
                              },
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.refresh_rounded, color: Colors.white, size: 18),
                            SizedBox(width: 8),
                            Text(
                              "RETAKE ASSESSMENT",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Back to Sign In Button
                    SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        key: const Key('backToSignInFromFailedTestButton'),
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            PageRouteBuilder(
                              transitionDuration: const Duration(milliseconds: 400),
                              pageBuilder: (context, animation, secondaryAnimation) =>
                                  const AnimatedSignInScreen(),
                              transitionsBuilder:
                                  (context, animation, secondaryAnimation, child) {
                                return FadeTransition(opacity: animation, child: child);
                              },
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          side: BorderSide(
                            color: isDark ? const Color(0xFF334155) : Colors.grey.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          "Back to Sign In",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: txtPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

  Widget _buildMetric(String label, String value, Color txtPrimary, Color txtSecondary) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: txtPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            color: txtSecondary,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildUnlockItem(String text, Color txtPrimary) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2.0),
            child: Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 15),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 12.5, color: txtPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
