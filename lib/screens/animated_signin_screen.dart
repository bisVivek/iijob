import 'package:flutter/material.dart';
import 'package:country_flags/country_flags.dart';
import '../models/user_account.dart';
import '../services/auth_storage_service.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_corner_shapes.dart';
import '../widgets/animated_sign_in_button.dart';
import '../widgets/brand_logo.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/otp_input_field.dart';
import 'assessment_screen.dart';
import 'home_screen.dart';

export '../models/user_account.dart';

enum AuthScreenState {
  signIn,
  signUpStep1,
  signUpStep2,
}

enum SignInMode {
  phone,
  email,
}

class AnimatedSignInScreen extends StatefulWidget {
  const AnimatedSignInScreen({super.key});

  @override
  State<AnimatedSignInScreen> createState() => _AnimatedSignInScreenState();
}

class _AnimatedSignInScreenState extends State<AnimatedSignInScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _mainController;

  // Staggered Entrance Animations (Runs once on launch)
  late Animation<double> _cornerShapesAnimation;
  late Animation<double> _cardScaleAnimation;
  late Animation<double> _cardFadeAnimation;
  late Animation<Offset> _cardSlideAnimation;

  // Screen State
  AuthScreenState _currentScreen = AuthScreenState.signIn;
  bool _isLoading = false;

  // Sign In Mode (Phone with Country Code OR Email)
  SignInMode _signInMode = SignInMode.phone;
  String _signInCountryCode = "+1";
  String _signInCountryFlag = "US";

  // Sign In Controllers & Keys
  final _signInFormKey = GlobalKey<FormState>();
  final _signInPhoneController = TextEditingController();
  final _signInEmailController = TextEditingController();
  final _signInPasswordController = TextEditingController();

  // Sign Up Step 1 Controllers & Keys
  final _step1FormKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _signUpEmailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _signUpPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _termsAgreed = false;
  String _selectedCountryCode = "+1";
  String _selectedCountryFlag = "US";

  // Step 2: OTP State
  String _enteredOtp = "";

  @override
  void initState() {
    super.initState();
    // One-time smooth entrance animation on initial app open
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _cornerShapesAnimation = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.0, 0.55, curve: Curves.easeOutBack),
    );

    _cardScaleAnimation = Tween<double>(begin: 0.92, end: 1.0).animate(
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
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.15, 0.65, curve: Curves.easeOutCubic),
      ),
    );

    _mainController.forward();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _signInPhoneController.dispose();
    _signInEmailController.dispose();
    _signInPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _signUpEmailController.dispose();
    _phoneController.dispose();
    _signUpPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _goToScreen(AuthScreenState screen) {
    // Clear OTP state whenever we leave the OTP verification step
    if (_currentScreen == AuthScreenState.signUpStep2) {
      _enteredOtp = "";
    }
    setState(() {
      _currentScreen = screen;
    });
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppTheme.errorColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          children: [
            const Icon(Icons.error_outline_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // SIGN IN VALIDATION & SUBMISSION
  // ==========================================
  void _handleSignIn() async {
    FocusScope.of(context).unfocus();

    if (!_signInFormKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;

    final inputPassword = _signInPasswordController.text;
    UserAccount? matchedUser;
    bool foundIdentifier = false;

    if (_signInMode == SignInMode.phone) {
      final rawPhone = _signInPhoneController.text.trim();
      matchedUser = AuthStorageService.findUserByPhone(rawPhone);
      if (matchedUser != null) {
        foundIdentifier = true;
        if (matchedUser.password != inputPassword) {
          matchedUser = null;
        }
      }
    } else {
      final inputEmail = _signInEmailController.text.trim();
      matchedUser = AuthStorageService.findUserByEmail(inputEmail);
      if (matchedUser != null) {
        foundIdentifier = true;
        if (matchedUser.password != inputPassword) {
          matchedUser = null;
        }
      }
    }

    setState(() {
      _isLoading = false;
    });

    if (matchedUser != null) {
      await AuthStorageService.saveCurrentSession(matchedUser);
      if (!mounted) return;
      if (matchedUser.isVerified) {
        _navigateToHome(matchedUser.fullName, score: matchedUser.assessmentScore);
      } else {
        _showErrorSnackBar("Please complete and pass your skill assessment to unlock the dashboard.");
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 550),
            pageBuilder: (context, animation, secondaryAnimation) =>
                AssessmentScreen(
              candidateName: matchedUser!.fullName,
              userAccount: matchedUser,
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    } else if (foundIdentifier) {
      _showErrorSnackBar("Incorrect password. Please verify your password and try again.");
    } else {
      if (_signInMode == SignInMode.phone) {
        _showErrorSnackBar("No account found with phone $_signInCountryCode ${_signInPhoneController.text.trim()}. Please sign up first.");
      } else {
        _showErrorSnackBar("No account found with email ${_signInEmailController.text.trim()}. Please sign up first.");
      }
    }
  }

  // ==========================================
  // STEP 1 VALIDATION & CONTINUE
  // ==========================================
  void _handleContinueStep1() {
    FocusScope.of(context).unfocus();

    if (!_step1FormKey.currentState!.validate()) {
      return;
    }

    final inputEmail = _signUpEmailController.text.trim().toLowerCase();
    final cleanPhone = _phoneController.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Duplicate Email Check via Hive
    final emailExists = AuthStorageService.emailExists(inputEmail);
    if (emailExists) {
      _showErrorSnackBar("This email ($inputEmail) is already registered. Please sign in instead.");
      return;
    }

    // Duplicate Phone Check via Hive
    final phoneExists = AuthStorageService.phoneExists(cleanPhone);
    if (phoneExists) {
      _showErrorSnackBar("This phone number is already registered. Please sign in instead.");
      return;
    }

    if (!_termsAgreed) {
      _showErrorSnackBar("Please agree to the Terms & Conditions to continue.");
      return;
    }

    _goToScreen(AuthScreenState.signUpStep2);
  }

  // ==========================================
  // STEP 2: OTP VERIFICATION & DIRECT ASSESSMENT TEST
  // ==========================================
  void _handleVerifyOtp() async {
    FocusScope.of(context).unfocus();

    final otp = _enteredOtp.trim();
    if (otp.length < 6) {
      _showErrorSnackBar("Please enter the complete 6-digit OTP verification code.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;

    // 1. Create and save new candidate account to Hive persistent storage
    final newAccount = UserAccount(
      firstName: _firstNameController.text.trim().isNotEmpty
          ? _firstNameController.text.trim()
          : "User",
      lastName: _lastNameController.text.trim(),
      email: _signUpEmailController.text.trim(),
      phone: _phoneController.text.trim(),
      countryCode: _selectedCountryCode,
      password: _signUpPasswordController.text,
      isVerified: false,
      assessmentScore: 0,
    );
    await AuthStorageService.saveUser(newAccount);
    await AuthStorageService.saveCurrentSession(newAccount);

    if (!mounted) return;

    // 2. Pre-fill Sign In with registered credentials for future logins
    _signInMode = SignInMode.phone;
    _signInCountryCode = newAccount.countryCode;
    _updateCountryFlag(_signInCountryCode, isSignIn: true);

    _signInPhoneController.text = newAccount.phone;
    _signInEmailController.text = newAccount.email;
    _signInPasswordController.text = newAccount.password;

    setState(() {
      _isLoading = false;
    });

    _showSuccessSnackBar("OTP verified! Starting your 11Jobs Skill Assessment.");

    // 3. Navigate directly to the 11Jobs Skill Assessment Test
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 550),
        pageBuilder: (context, animation, secondaryAnimation) =>
            AssessmentScreen(
          candidateName: newAccount.fullName,
          userAccount: newAccount,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  void _updateCountryFlag(String code, {bool isSignIn = false}) {
    const flagMap = {
      "+1":   "US",
      "+91":  "IN",
      "+44":  "GB",
      "+61":  "AU",
      "+49":  "DE",
      "+971": "AE",
      "+65":  "SG",
    };
    final flag = flagMap[code] ?? "US";

    if (isSignIn) {
      _signInCountryFlag = flag;
    } else {
      _selectedCountryFlag = flag;
    }
  }

  void _navigateToHome(String name, {int score = 100}) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 550),
        pageBuilder: (context, animation, secondaryAnimation) =>
            HomeScreen(username: name, isVerified: true, score: score),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  Widget _buildFieldLabel(
    String label, {
    bool isRequired = false,
    String? optionalText,
    bool showInfo = false,
    String? infoMessage,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
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
          if (isRequired) ...[
            const SizedBox(width: 3),
            const Text(
              "*",
              style: TextStyle(
                color: AppTheme.errorColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
          if (optionalText != null) ...[
            const SizedBox(width: 4),
            Text(
              "($optionalText)",
              style: const TextStyle(
                fontSize: 12.0,
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
          if (showInfo) ...[
            const SizedBox(width: 4),
            Tooltip(
              message: infoMessage ?? "Minimum 8 characters required",
              child: const Icon(
                Icons.info_outline_rounded,
                size: 15,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Country Code Picker Widget
  Widget _buildCountryPicker({
    required String selectedCode,
    required String selectedFlag,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFEBF2FD),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: CountryFlag.fromCountryCode(
              selectedFlag,
              width: 20,
              height: 14,
            ),
          ),
          const SizedBox(width: 6),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedCode,
              isDense: true,
              icon: const Icon(
                Icons.unfold_more_rounded,
                size: 16,
                color: AppTheme.primaryBlue,
              ),
              items: [
                DropdownMenuItem(
                  value: "+1",
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: CountryFlag.fromCountryCode('US', width: 18, height: 13),
                      ),
                      const SizedBox(width: 6),
                      const Text("+1 (US)", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: "+91",
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: CountryFlag.fromCountryCode('IN', width: 18, height: 13),
                      ),
                      const SizedBox(width: 6),
                      const Text("+91 (IN)", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: "+44",
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: CountryFlag.fromCountryCode('GB', width: 18, height: 13),
                      ),
                      const SizedBox(width: 6),
                      const Text("+44 (UK)", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: "+61",
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: CountryFlag.fromCountryCode('AU', width: 18, height: 13),
                      ),
                      const SizedBox(width: 6),
                      const Text("+61 (AU)", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: "+49",
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: CountryFlag.fromCountryCode('DE', width: 18, height: 13),
                      ),
                      const SizedBox(width: 6),
                      const Text("+49 (DE)", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: "+971",
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: CountryFlag.fromCountryCode('AE', width: 18, height: 13),
                      ),
                      const SizedBox(width: 6),
                      const Text("+971 (AE)", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: "+65",
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: CountryFlag.fromCountryCode('SG', width: 18, height: 13),
                      ),
                      const SizedBox(width: 6),
                      const Text("+65 (SG)", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                    ],
                  ),
                ),
              ],
              onChanged: (val) {
                if (val != null) {
                  onChanged(val);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // Sign In Mode Switcher (Phone with Country Code vs Email)
  Widget _buildSignInModeSwitcher() {
    return Container(
      height: 44,
      padding: const EdgeInsets.all(3.5),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF4FB),
        borderRadius: BorderRadius.circular(22),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tabWidth = (constraints.maxWidth - 2) / 2;
          return Stack(
            children: [
              // Smooth Gliding Pill Indicator
              AnimatedAlign(
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeInOutCubic,
                alignment: _signInMode == SignInMode.phone
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: Container(
                  width: tabWidth,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(19),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF005BFF).withValues(alpha: 0.12),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),

              // Tab Buttons (Phone & Gmail)
              Row(
                children: [
                  // Phone Tab
                  Expanded(
                    child: GestureDetector(
                      key: const Key('signInModePhoneTab'),
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        if (_signInMode != SignInMode.phone) {
                          setState(() {
                            _signInMode = SignInMode.phone;
                          });
                        }
                      },
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.phone_iphone_rounded,
                                  size: 16,
                                  color: _signInMode == SignInMode.phone
                                      ? AppTheme.primaryBlue
                                      : AppTheme.textSecondary,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  "Phone Number",
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontFamily: 'Roboto',
                                    fontWeight: _signInMode == SignInMode.phone
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: _signInMode == SignInMode.phone
                                        ? AppTheme.primaryBlue
                                        : AppTheme.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Gmail Tab
                  Expanded(
                    child: GestureDetector(
                      key: const Key('signInModeEmailTab'),
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        if (_signInMode != SignInMode.email) {
                          setState(() {
                            _signInMode = SignInMode.email;
                          });
                        }
                      },
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.mail_outline_rounded,
                                  size: 16,
                                  color: _signInMode == SignInMode.email
                                      ? AppTheme.primaryBlue
                                      : AppTheme.textSecondary,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  "Gmail / Email",
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontFamily: 'Roboto',
                                    fontWeight: _signInMode == SignInMode.email
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: _signInMode == SignInMode.email
                                        ? AppTheme.primaryBlue
                                        : AppTheme.textSecondary,
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
            ],
          );
        },
      ),
    );
  }

  // ==========================================
  // VIEW: 1. SIGN IN (With Country Code & Full Validation)
  // ==========================================
  Widget _buildSignInView() {
    return Form(
      key: _signInFormKey,
      child: Column(
        key: const ValueKey('SignInView'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 11Jobs Logo
          const Align(
            alignment: Alignment.centerLeft,
            child: BrandLogo(height: 28),
          ),

          const SizedBox(height: 20.0),

          // Title & Subtitle
          const Text(
            "Sign In",
            style: TextStyle(
              fontSize: 26.0,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 6.0),
          const Text(
            "Login to access your 11Jobs dashboard",
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w400,
              color: AppTheme.textSecondary,
            ),
          ),

          const SizedBox(height: 20.0),

          // Login Mode Switcher (Phone / Email)
          _buildSignInModeSwitcher(),

          const SizedBox(height: 18.0),

          // Smooth Animated Field Transition between Phone and Gmail
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 280),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (Widget child, Animation<double> animation) {
              final isPhone = child.key == const ValueKey('phoneInputSection');
              final offsetBegin = isPhone ? const Offset(-0.06, 0) : const Offset(0.06, 0);
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: offsetBegin,
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: _signInMode == SignInMode.phone
                ? Column(
                    key: const ValueKey('phoneInputSection'),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFieldLabel("Phone Number", isRequired: true),
                      CustomTextField(
                        fieldKey: const Key('signInPhoneField'),
                        controller: _signInPhoneController,
                        hintText: "00000 00000",
                        prefixWidget: _buildCountryPicker(
                          selectedCode: _signInCountryCode,
                          selectedFlag: _signInCountryFlag,
                          onChanged: (code) {
                            setState(() {
                              _signInCountryCode = code;
                              _updateCountryFlag(code, isSignIn: true);
                            });
                          },
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter your registered phone number";
                          }
                          final cleanDigits = value.replaceAll(RegExp(r'[^0-9]'), '');
                          if (cleanDigits.length < 7 || cleanDigits.length > 15) {
                            return "Enter a valid phone number (7-15 digits)";
                          }
                          return null;
                        },
                      ),
                    ],
                  )
                : Column(
                    key: const ValueKey('emailInputSection'),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFieldLabel("Gmail", isRequired: true),
                      CustomTextField(
                        fieldKey: const Key('signInEmailField'),
                        controller: _signInEmailController,
                        hintText: "name@company.com",
                        prefixIcon: Icons.mail_outline_rounded,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter your registered email address";
                          }
                          final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
                          if (!emailRegex.hasMatch(value.trim())) {
                            return "Please enter a valid email address";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
          ),

          const SizedBox(height: 16.0),

          // Password
          _buildFieldLabel(
            "Password",
            isRequired: true,
            showInfo: true,
            infoMessage: "Enter your account password",
          ),
          CustomTextField(
            fieldKey: const Key('signInPasswordField'),
            controller: _signInPasswordController,
            hintText: "Password",
            isPassword: true,
            prefixIcon: Icons.lock_outline_rounded,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter your password";
              }
              if (value.length < 6) {
                return "Password must be at least 6 characters";
              }
              return null;
            },
          ),

          const SizedBox(height: 10.0),

          // Forgot Password Link
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppTheme.primaryBlue,
                    content: const Text("Password reset instructions sent to your email/phone!"),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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

          const SizedBox(height: 18.0),

          // Sign In Button
          AnimatedSignInButton(
            key: const Key('signInButton'),
            text: "Sign In",
            isLoading: _isLoading,
            onPressed: _handleSignIn,
          ),

          const SizedBox(height: 22.0),

          // Switch to Register Step 1
          Center(
            child: GestureDetector(
              key: const Key('switchToSignUpButton'),
              onTap: () => _goToScreen(AuthScreenState.signUpStep1),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text.rich(
                  const TextSpan(
                    text: "New to 11Jobs? ",
                    style: TextStyle(
                      fontSize: 13.0,
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Roboto',
                    ),
                    children: [
                      TextSpan(
                        text: "Create New Account",
                        style: TextStyle(
                          color: AppTheme.primaryBlue,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // VIEW: 2. REGISTRATION STEP 1 (With Full Validation & Duplicate Checks)
  // ==========================================
  Widget _buildSignUpStep1View() {
    return Form(
      key: _step1FormKey,
      child: Column(
        key: const ValueKey('SignUpStep1View'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 11Jobs Logo & Step Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BrandLogo(height: 26),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F1FD),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "STEP 1 OF 2",
                  style: TextStyle(
                    fontSize: 11.0,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primaryBlue,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16.0),

          // Title & Subtitle
          const Text(
            "Step: 1",
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4.0),
          const Text(
            "Create your account",
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w400,
              color: AppTheme.textSecondary,
            ),
          ),

          const SizedBox(height: 18.0),

          // First Name
          _buildFieldLabel("First Name", isRequired: true),
          CustomTextField(
            fieldKey: const Key('signUpFirstNameField'),
            controller: _firstNameController,
            hintText: "First Name",
            prefixIcon: Icons.person_outline_rounded,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "First name is required";
              }
              if (value.trim().length < 2) {
                return "First name must be at least 2 characters";
              }
              if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value.trim())) {
                return "First name must contain only letters";
              }
              return null;
            },
          ),

          const SizedBox(height: 14.0),

          // Last Name (optional)
          _buildFieldLabel("Last Name", optionalText: "optional"),
          CustomTextField(
            fieldKey: const Key('signUpLastNameField'),
            controller: _lastNameController,
            hintText: "Last Name",
            prefixIcon: Icons.badge_outlined,
            validator: (value) {
              if (value != null && value.trim().isNotEmpty) {
                if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value.trim())) {
                  return "Last name must contain only letters";
                }
              }
              return null;
            },
          ),

          const SizedBox(height: 14.0),

          // Email (With Duplicate Check)
          _buildFieldLabel("Email", isRequired: true),
          CustomTextField(
            fieldKey: const Key('signUpEmailField'),
            controller: _signUpEmailController,
            hintText: "Email",
            prefixIcon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Email address is required";
              }
              final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
              if (!emailRegex.hasMatch(value.trim())) {
                return "Please enter a valid email (e.g. name@domain.com)";
              }
              final isDuplicate = AuthStorageService.emailExists(value.trim());
              if (isDuplicate) {
                return "This email is already registered. Please sign in.";
              }
              return null;
            },
          ),

          const SizedBox(height: 14.0),

          // Phone (With Country Picker & Duplicate Check)
          _buildFieldLabel("Phone", isRequired: true),
          CustomTextField(
            fieldKey: const Key('signUpPhoneField'),
            controller: _phoneController,
            hintText: "00000 00000",
            prefixWidget: _buildCountryPicker(
              selectedCode: _selectedCountryCode,
              selectedFlag: _selectedCountryFlag,
              onChanged: (code) {
                setState(() {
                  _selectedCountryCode = code;
                  _updateCountryFlag(code, isSignIn: false);
                });
              },
            ),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Phone number is required";
              }
              final cleanDigits = value.replaceAll(RegExp(r'[^0-9]'), '');
              if (cleanDigits.length < 7 || cleanDigits.length > 15) {
                return "Enter a valid phone number (7-15 digits)";
              }
              final isDuplicate = AuthStorageService.phoneExists(cleanDigits);
              if (isDuplicate) {
                return "This phone number is already registered. Please sign in.";
              }
              return null;
            },
          ),

          const SizedBox(height: 14.0),

          // Password
          _buildFieldLabel(
            "Password",
            isRequired: true,
            showInfo: true,
            infoMessage: "Minimum 8 characters with letters & numbers",
          ),
          CustomTextField(
            fieldKey: const Key('signUpPasswordField'),
            controller: _signUpPasswordController,
            hintText: "Password",
            isPassword: true,
            prefixIcon: Icons.lock_outline_rounded,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Password is required";
              }
              if (value.length < 8) {
                return "Password must be at least 8 characters";
              }
              if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d).+$').hasMatch(value)) {
                return "Password must contain at least one letter and one number";
              }
              return null;
            },
          ),
          const Padding(
            padding: EdgeInsets.only(top: 4.0, left: 2.0),
            child: Text(
              "Minimum 8 characters (letters + numbers)",
              style: TextStyle(fontSize: 11.5, color: AppTheme.textSecondary),
            ),
          ),

          const SizedBox(height: 14.0),

          // Confirm Password
          _buildFieldLabel("Confirm Password", isRequired: true),
          CustomTextField(
            fieldKey: const Key('signUpConfirmPasswordField'),
            controller: _confirmPasswordController,
            hintText: "Confirm Password",
            isPassword: true,
            prefixIcon: Icons.lock_reset_rounded,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please confirm your password";
              }
              if (value != _signUpPasswordController.text) {
                return "Passwords do not match";
              }
              return null;
            },
          ),

          const SizedBox(height: 14.0),

          // Terms Checkbox
          InkWell(
            key: const Key('termsCheckbox'),
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              setState(() {
                _termsAgreed = !_termsAgreed;
              });
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 22,
                  height: 22,
                  child: IgnorePointer(
                    child: Checkbox(
                      value: _termsAgreed,
                      activeColor: AppTheme.primaryBlue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      onChanged: (_) {},
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      text: "I agree to the ",
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: AppTheme.textSecondary,
                      ),
                      children: [
                        TextSpan(
                          text: "Terms & Conditions",
                          style: const TextStyle(
                            color: AppTheme.primaryBlue,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20.0),

          // Action Buttons: Back & Continue
          Row(
            children: [
              // Back Button
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () => _goToScreen(AuthScreenState.signIn),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      side: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
                    ),
                    child: const Text(
                      "Back",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 14),

              // Continue Button
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    key: const Key('continueStep1Button'),
                    onPressed: _handleContinueStep1,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      elevation: 4,
                      shadowColor: AppTheme.primaryBlue.withValues(alpha: 0.4),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    ),
                    child: const Text(
                      "Continue",
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16.0),

          // Bottom Toggle
          Center(
            child: GestureDetector(
              key: const Key('switchToSignInButton'),
              onTap: () => _goToScreen(AuthScreenState.signIn),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0),
                child: Text.rich(
                  TextSpan(
                    text: "Already have an account? ",
                    style: TextStyle(fontSize: 12.5, color: AppTheme.textSecondary),
                    children: [
                      TextSpan(
                        text: "Sign In",
                        style: TextStyle(color: AppTheme.primaryBlue, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // VIEW: 3. REGISTRATION STEP 2 (OTP ONLY)
  // ==========================================
  Widget _buildSignUpStep2View() {
    final targetDestination = _phoneController.text.trim().isNotEmpty
        ? "$_selectedCountryCode ${_phoneController.text.trim()}"
        : _signUpEmailController.text.trim();

    return Column(
      key: const ValueKey('SignUpStep2OtpView'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 11Jobs Logo & Step Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const BrandLogo(height: 26),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F1FD),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "STEP 2 OF 2",
                style: TextStyle(
                  fontSize: 11.0,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.primaryBlue,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 18.0),

        // Title: Step: 2 & OTP Verification
        const Text(
          "Step: 2",
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w800,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 4.0),
        const Text(
          "OTP Verification",
          style: TextStyle(
            fontSize: 17.0,
            fontWeight: FontWeight.w700,
            color: AppTheme.primaryBlue,
          ),
        ),
        const SizedBox(height: 6.0),
        Text(
          "We have sent a 6-digit verification code to $targetDestination",
          style: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w400,
            color: AppTheme.textSecondary,
            height: 1.4,
          ),
        ),

        const SizedBox(height: 26.0),

        // 6-Box Pin Input Field
        OtpInputField(
          length: 6,
          onChanged: (val) {
            _enteredOtp = val;
          },
          onCompleted: (otp) {
            _enteredOtp = otp;
          },
        ),

        const SizedBox(height: 20.0),

        // Resend Code Button / Text
        Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Didn't receive code? ",
                  style: TextStyle(
                    fontSize: 13.0,
                    color: AppTheme.textSecondary,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: AppTheme.primaryBlue,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        content: const Row(
                          children: [
                            Icon(Icons.mark_email_read_rounded, color: Colors.white, size: 18),
                            SizedBox(width: 10),
                            Text("A new OTP code has been sent!"),
                          ],
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    "Resend OTP",
                    style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryBlue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 26.0),

        // Action Buttons: Back & Verify OTP
        Row(
          children: [
            // Back Button to Step 1
            Expanded(
              flex: 1,
              child: SizedBox(
                height: 48,
                child: OutlinedButton(
                  onPressed: () => _goToScreen(AuthScreenState.signUpStep1),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    side: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
                  ),
                  child: const Text(
                    "Back",
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 14),

            // Verify & Complete Registration Button
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  key: const Key('verifyOtpButton'),
                  onPressed: _isLoading ? null : _handleVerifyOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    elevation: 4,
                    shadowColor: AppTheme.primaryBlue.withValues(alpha: 0.4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          "Verify OTP",
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16.0),

        // Bottom Toggle
        Center(
          child: GestureDetector(
            onTap: () => _goToScreen(AuthScreenState.signIn),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0),
              child: Text.rich(
                TextSpan(
                  text: "Already have an account? ",
                  style: TextStyle(fontSize: 12.5, color: AppTheme.textSecondary),
                  children: [
                    TextSpan(
                      text: "Sign In",
                      style: TextStyle(color: AppTheme.primaryBlue, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF0D1527) : Colors.white;
    final cardBorder = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF060919) : AppTheme.lightBackground,
      body: Stack(
        children: [
          // Background Gradient Orbs (Runs single entrance animation only)
          AnimatedCornerShapes(
            entranceProgress: _cornerShapesAnimation,
          ),

          // Main Responsive Card Area
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
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
                    constraints: const BoxConstraints(maxWidth: 440),
                    padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 30.0),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: cardBorder),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0038A8).withValues(alpha: isDark ? 0.3 : 0.09),
                          blurRadius: 36,
                          offset: const Offset(0, 16),
                          spreadRadius: 2,
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 320),
                      switchInCurve: Curves.easeInOut,
                      switchOutCurve: Curves.easeInOut,
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.04, 0.0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: _currentScreen == AuthScreenState.signIn
                          ? _buildSignInView()
                          : _currentScreen == AuthScreenState.signUpStep1
                              ? _buildSignUpStep1View()
                              : _buildSignUpStep2View(),
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
