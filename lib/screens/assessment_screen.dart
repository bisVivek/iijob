import 'dart:async';
import 'package:flutter/material.dart';
import '../models/assessment_question.dart';
import '../theme/app_theme.dart';
import '../widgets/brand_logo.dart';
import '../widgets/theme_switcher_button.dart';
import 'animated_signin_screen.dart';
import 'assessment_result_screen.dart';

class AssessmentScreen extends StatefulWidget {
  final String candidateName;
  final UserAccount? userAccount;

  const AssessmentScreen({
    super.key,
    required this.candidateName,
    this.userAccount,
  });

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  late List<AssessmentQuestion> _questions;
  int _currentIndex = 0;
  final Map<int, int> _selectedAnswers = {}; // questionIndex -> selectedOptionIndex

  // Countdown timer for creative test engagement
  int _secondsRemaining = 120; // 2 minutes
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _questions = AssessmentBank.getQuestions();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer?.cancel();
        _submitAssessment();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _selectOption(int optionIndex) {
    setState(() {
      _selectedAnswers[_currentIndex] = optionIndex;
    });
  }

  void _nextQuestion() {
    if (_selectedAnswers[_currentIndex] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppTheme.errorColor,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: const Row(
            children: [
              Icon(Icons.info_outline_rounded, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Text("Please select an answer to proceed."),
            ],
          ),
        ),
      );
      return;
    }

    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      _submitAssessment();
    }
  }

  void _previousQuestion() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
    }
  }

  void _submitAssessment() {
    _timer?.cancel();

    int correctCount = 0;
    for (int i = 0; i < _questions.length; i++) {
      if (_selectedAnswers[i] == _questions[i].correctIndex) {
        correctCount++;
      }
    }

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) => AssessmentResultScreen(
          candidateName: widget.candidateName,
          totalQuestions: _questions.length,
          correctCount: correctCount,
          userAccount: widget.userAccount,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  String _formatTimer(int seconds) {
    final mins = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$mins:$secs";
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentQ = _questions[_currentIndex];
    final progress = (_currentIndex + 1) / _questions.length;
    final selectedOption = _selectedAnswers[_currentIndex];

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
        actions: [
          // 11Jobs Theme Switcher Button
          const ThemeSwitcherButton(),
          const SizedBox(width: 8),

          // Timer chip
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _secondsRemaining < 30
                  ? (isDark ? const Color(0xFF450A0A) : const Color(0xFFFEE2E2))
                  : (isDark ? const Color(0xFF132240) : const Color(0xFFEFF6FF)),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _secondsRemaining < 30
                    ? (isDark ? const Color(0xFF991B1B) : const Color(0xFFFCA5A5))
                    : (isDark ? const Color(0xFF2563EB).withValues(alpha: 0.5) : const Color(0xFFBFDBFE)),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.timer_outlined,
                  size: 16,
                  color: _secondsRemaining < 30 ? AppTheme.errorColor : (isDark ? const Color(0xFF38BDF8) : AppTheme.primaryBlue),
                ),
                const SizedBox(width: 5),
                Text(
                  _formatTimer(_secondsRemaining),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _secondsRemaining < 30 ? AppTheme.errorColor : (isDark ? const Color(0xFF38BDF8) : AppTheme.primaryBlue),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 12.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 480),
              padding: const EdgeInsets.all(26.0),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: borderColor),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0038A8).withValues(alpha: isDark ? 0.3 : 0.08),
                    blurRadius: 36,
                    offset: const Offset(0, 14),
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Progress Bar & Step Label
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          "11Jobs Assessment Test",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w700,
                            color: isDark ? const Color(0xFF38BDF8) : AppTheme.primaryBlue,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Question ${_currentIndex + 1} of ${_questions.length}",
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w700,
                          color: txtSecondary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Linear Progress Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      tween: Tween<double>(begin: 0, end: progress),
                      builder: (context, value, child) {
                        return LinearProgressIndicator(
                          value: value,
                          minHeight: 6,
                          backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                          valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 22),

                  // Category Tag Chip
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF132240) : const Color(0xFFE8F1FD),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(currentQ.iconEmoji, style: const TextStyle(fontSize: 14)),
                          const SizedBox(width: 6),
                          Text(
                            currentQ.category.toUpperCase(),
                            style: TextStyle(
                              fontSize: 11.0,
                              fontWeight: FontWeight.w800,
                              color: isDark ? const Color(0xFF38BDF8) : AppTheme.primaryBlue,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Question Text
                  Text(
                    currentQ.question,
                    style: TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.w700,
                      color: txtPrimary,
                      height: 1.45,
                    ),
                  ),

                  const SizedBox(height: 22),

                  // Options List
                  ...List.generate(currentQ.options.length, (optIndex) {
                    final isSelected = selectedOption == optIndex;
                    final optionLetter = String.fromCharCode(65 + optIndex); // A, B, C, D

                    final optBg = isSelected
                        ? (isDark ? const Color(0xFF172554) : const Color(0xFFEFF6FF))
                        : (isDark ? const Color(0xFF0F1A30) : const Color(0xFFF8FAFC));

                    final optBorder = isSelected
                        ? (isDark ? const Color(0xFF3B82F6) : AppTheme.primaryBlue)
                        : (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0));

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: InkWell(
                        key: Key('optionCard_$optIndex'),
                        borderRadius: BorderRadius.circular(18),
                        onTap: () => _selectOption(optIndex),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: optBg,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: optBorder,
                              width: isSelected ? 1.8 : 1.2,
                            ),
                            boxShadow: [
                              if (isSelected)
                                BoxShadow(
                                  color: AppTheme.primaryBlue.withValues(alpha: isDark ? 0.25 : 0.08),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Letter Badge
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected
                                      ? AppTheme.primaryBlue
                                      : (isDark ? const Color(0xFF1E293B) : Colors.white),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppTheme.primaryBlue
                                        : (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    optionLetter,
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w800,
                                      color: isSelected
                                          ? Colors.white
                                          : (isDark ? const Color(0xFF94A3B8) : AppTheme.textSecondary),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 12),

                              // Option Text
                              Expanded(
                                child: Text(
                                  currentQ.options[optIndex],
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                    color: isSelected
                                        ? (isDark ? const Color(0xFF60A5FA) : AppTheme.primaryBlue)
                                        : txtPrimary,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 18),

                  // Bottom Action Buttons (Previous & Next/Submit)
                  Row(
                    children: [
                      if (_currentIndex > 0) ...[
                        Expanded(
                          flex: 1,
                          child: SizedBox(
                            height: 48,
                            child: OutlinedButton(
                              onPressed: _previousQuestion,
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                side: BorderSide(
                                  color: isDark ? const Color(0xFF334155) : Colors.grey.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Text(
                                "Previous",
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                  color: txtPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],

                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            key: const Key('nextQuestionButton'),
                            onPressed: _nextQuestion,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryBlue,
                              elevation: 4,
                              shadowColor: AppTheme.primaryBlue.withValues(alpha: 0.4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: Text(
                              _currentIndex == _questions.length - 1
                                  ? "SUBMIT ASSESSMENT"
                                  : "NEXT QUESTION",
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
