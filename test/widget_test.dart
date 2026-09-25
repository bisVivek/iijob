import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:_11jobs/main.dart';
import 'package:_11jobs/screens/assessment_screen.dart';
import 'package:_11jobs/screens/assessment_result_screen.dart';
import 'package:_11jobs/screens/home_screen.dart';
import 'package:_11jobs/theme/app_theme.dart';
import 'package:_11jobs/widgets/brand_logo.dart';

void main() {
  testWidgets('Full User Journey: Registration -> OTP -> Creative Assessment Test (Pass Flow) -> Verified Dashboard', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // 1. Initial Sign In Screen
    expect(find.byType(BrandLogo), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.byKey(const Key('signInModePhoneTab')), findsOneWidget);
    expect(find.byKey(const Key('signInModeEmailTab')), findsOneWidget);

    // 2. Switch to Sign Up Step 1
    await tester.tap(find.byKey(const Key('switchToSignUpButton')));
    await tester.pumpAndSettle();

    expect(find.text('Step: 1'), findsOneWidget);
    expect(find.text('Create your account'), findsOneWidget);

    // Fill Step 1 Valid Fields
    final firstNameField = find.descendant(
      of: find.byKey(const Key('signUpFirstNameField')),
      matching: find.byType(TextField),
    );
    await tester.enterText(firstNameField, 'Rahul');

    final lastNameField = find.descendant(
      of: find.byKey(const Key('signUpLastNameField')),
      matching: find.byType(TextField),
    );
    await tester.enterText(lastNameField, 'Sharma');

    final emailField = find.descendant(
      of: find.byKey(const Key('signUpEmailField')),
      matching: find.byType(TextField),
    );
    await tester.enterText(emailField, 'rahul@11jobs.com');

    final phoneField = find.descendant(
      of: find.byKey(const Key('signUpPhoneField')),
      matching: find.byType(TextField),
    );
    await tester.enterText(phoneField, '9876543210');

    final passwordField = find.descendant(
      of: find.byKey(const Key('signUpPasswordField')),
      matching: find.byType(TextField),
    );
    await tester.enterText(passwordField, 'Password123');

    final confirmPasswordField = find.descendant(
      of: find.byKey(const Key('signUpConfirmPasswordField')),
      matching: find.byType(TextField),
    );
    await tester.enterText(confirmPasswordField, 'Password123');

    // Agree to terms
    await tester.tap(find.byKey(const Key('termsCheckbox')));
    await tester.pumpAndSettle();

    // Tap Continue
    await tester.tap(find.byKey(const Key('continueStep1Button')));
    await tester.pumpAndSettle();

    // 3. Step 2: OTP Verification
    expect(find.text('Step: 2'), findsOneWidget);
    expect(find.text('OTP Verification'), findsOneWidget);
    expect(find.textContaining('9876543210'), findsOneWidget);

    // Enter 6-digit OTP code into the 6 boxes
    final otpTextFields = find.byType(TextField);
    for (int i = 0; i < 6; i++) {
      await tester.enterText(otpTextFields.at(i), '${i + 1}');
    }
    await tester.pump();

    // Tap Verify OTP
    await tester.tap(find.byKey(const Key('verifyOtpButton')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1200));
    await tester.pumpAndSettle();

    // 4. Automatically enters 11Jobs Skill Assessment Screen
    expect(find.byType(AssessmentScreen), findsOneWidget);
    expect(find.text('11Jobs Assessment Test'), findsOneWidget);
    expect(find.textContaining('Question 1 of 5'), findsOneWidget);

    // Answer Question 1 (Correct: Option 1 -> B)
    await tester.ensureVisible(find.byKey(const Key('optionCard_1')));
    await tester.tap(find.byKey(const Key('optionCard_1')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('nextQuestionButton')));
    await tester.tap(find.byKey(const Key('nextQuestionButton')));
    await tester.pumpAndSettle();

    // Answer Question 2 (Correct: Option 0 -> A)
    expect(find.textContaining('Question 2 of 5'), findsOneWidget);
    await tester.ensureVisible(find.byKey(const Key('optionCard_0')));
    await tester.tap(find.byKey(const Key('optionCard_0')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('nextQuestionButton')));
    await tester.tap(find.byKey(const Key('nextQuestionButton')));
    await tester.pumpAndSettle();

    // Answer Question 3 (Correct: Option 0 -> A)
    expect(find.textContaining('Question 3 of 5'), findsOneWidget);
    await tester.ensureVisible(find.byKey(const Key('optionCard_0')));
    await tester.tap(find.byKey(const Key('optionCard_0')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('nextQuestionButton')));
    await tester.tap(find.byKey(const Key('nextQuestionButton')));
    await tester.pumpAndSettle();

    // Answer Question 4 (Correct: Option 1 -> B)
    expect(find.textContaining('Question 4 of 5'), findsOneWidget);
    await tester.ensureVisible(find.byKey(const Key('optionCard_1')));
    await tester.tap(find.byKey(const Key('optionCard_1')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('nextQuestionButton')));
    await tester.tap(find.byKey(const Key('nextQuestionButton')));
    await tester.pumpAndSettle();

    // Answer Question 5 (Correct: Option 1 -> B)
    expect(find.textContaining('Question 5 of 5'), findsOneWidget);
    await tester.ensureVisible(find.byKey(const Key('optionCard_1')));
    await tester.tap(find.byKey(const Key('optionCard_1')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('nextQuestionButton')));
    await tester.tap(find.byKey(const Key('nextQuestionButton')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    // 5. Verify Assessment Passed Screen with verified badge
    expect(find.byType(AssessmentResultScreen), findsOneWidget);
    expect(find.text('Assessment Passed! 🎉'), findsOneWidget);
    expect(find.text('100%'), findsOneWidget);
    expect(find.text('11Jobs Verified Candidate'), findsOneWidget);
    expect(find.textContaining('#11J-VERIFIED'), findsOneWidget);

    // 6. Enter Dashboard
    await tester.ensureVisible(find.byKey(const Key('enterDashboardButton')));
    await tester.tap(find.byKey(const Key('enterDashboardButton')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pumpAndSettle();

    // 7. Verify Dashboard with Candidate Name & Verified Status
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.textContaining('Welcome, Rahul Sharma!'), findsOneWidget);
    expect(find.text('VERIFIED CANDIDATE'), findsOneWidget);
    expect(find.text('Hiring Workflow Pipeline'), findsOneWidget);

    // 8. Test Right-Side Hamburger Menu Drawer Open & Theme Switch & Logout
    await tester.tap(find.byKey(const Key('hamburgerMenuButton')));
    await tester.pumpAndSettle();

    expect(find.text('Dark Mode'), findsOneWidget);
    expect(find.byKey(const Key('drawerThemeSwitch')), findsOneWidget);

    // Toggle Dark Mode in drawer
    await tester.tap(find.byKey(const Key('drawerThemeSwitch')));
    await tester.pumpAndSettle();
    expect(AppTheme.isDark, true);

    // Toggle back to Light Mode
    await tester.tap(find.byKey(const Key('drawerThemeSwitch')));
    await tester.pumpAndSettle();
    expect(AppTheme.isDark, false);

    expect(find.text('Active Pipelines'), findsOneWidget);
    expect(find.text('Logout'), findsOneWidget);

    await tester.tap(find.text('Logout'));
    await tester.pumpAndSettle();

    expect(find.text('Sign In'), findsOneWidget);

    final signInPhoneField = find.descendant(
      of: find.byKey(const Key('signInPhoneField')),
      matching: find.byType(TextField),
    );
    final signInPassField = find.descendant(
      of: find.byKey(const Key('signInPasswordField')),
      matching: find.byType(TextField),
    );
    await tester.enterText(signInPhoneField, '9876543210');
    await tester.enterText(signInPassField, 'Password123');
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('signInButton')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1200));
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.textContaining('Welcome, Rahul Sharma!'), findsOneWidget);

    // 9. Test Bottom Navigation Bar Tabs
    // Tab 1: Pipelines
    await tester.tap(find.byKey(const Key('bottomNavItem_1')));
    await tester.pumpAndSettle();
    expect(find.text('Active Hiring Pipelines'), findsOneWidget);
    expect(find.text('3 ACTIVE'), findsOneWidget);

    // Tab 2: Opportunities
    await tester.tap(find.byKey(const Key('bottomNavItem_2')));
    await tester.pumpAndSettle();
    expect(find.text('Curated Opportunities'), findsOneWidget);
    expect(find.textContaining('98% MATCH'), findsOneWidget);

    // Tab 3: MCP & Tools
    await tester.tap(find.byKey(const Key('bottomNavItem_3')));
    await tester.pumpAndSettle();
    expect(find.text('MCP & Agent Tooling'), findsOneWidget);
    expect(find.text('MCP v2.4'), findsOneWidget);

    // Tab 4: Profile
    await tester.tap(find.byKey(const Key('bottomNavItem_4')));
    await tester.pumpAndSettle();
    expect(find.text('Contact Details'), findsOneWidget);
    expect(find.text('Flutter & Dart Architecture'), findsOneWidget);

    // Return to Tab 0: Dashboard
    await tester.tap(find.byKey(const Key('bottomNavItem_0')));
    await tester.pumpAndSettle();
    expect(find.text('Hiring Workflow Pipeline'), findsOneWidget);

    // 10. Test Drawer Navigation to Tabs & Modal
    await tester.tap(find.byKey(const Key('hamburgerMenuButton')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('For Employers'));
    await tester.pumpAndSettle();
    expect(find.text('Got It'), findsOneWidget);
    await tester.tap(find.text('Got It'));
    await tester.pumpAndSettle();

    // 11. Test Ultra-Narrow Viewport (320px width) for Zero Overflows
    tester.view.physicalSize = const Size(320, 640);
    await tester.pumpAndSettle();

    for (int i = 0; i < 5; i++) {
      await tester.tap(find.byKey(Key('bottomNavItem_$i')));
      await tester.pumpAndSettle();
    }
  });

  testWidgets('Assessment Fail Flow: Retake Test & Retry', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Switch to Sign Up
    await tester.tap(find.byKey(const Key('switchToSignUpButton')));
    await tester.pumpAndSettle();

    // Register User Priya
    final firstNameField = find.descendant(
      of: find.byKey(const Key('signUpFirstNameField')),
      matching: find.byType(TextField),
    );
    await tester.enterText(firstNameField, 'Priya');

    final lastNameField = find.descendant(
      of: find.byKey(const Key('signUpLastNameField')),
      matching: find.byType(TextField),
    );
    await tester.enterText(lastNameField, 'Verma');

    final emailField = find.descendant(
      of: find.byKey(const Key('signUpEmailField')),
      matching: find.byType(TextField),
    );
    await tester.enterText(emailField, 'priya@11jobs.com');

    final phoneField = find.descendant(
      of: find.byKey(const Key('signUpPhoneField')),
      matching: find.byType(TextField),
    );
    await tester.enterText(phoneField, '8888888888');

    final passwordField = find.descendant(
      of: find.byKey(const Key('signUpPasswordField')),
      matching: find.byType(TextField),
    );
    await tester.enterText(passwordField, 'Password123');

    final confirmPasswordField = find.descendant(
      of: find.byKey(const Key('signUpConfirmPasswordField')),
      matching: find.byType(TextField),
    );
    await tester.enterText(confirmPasswordField, 'Password123');

    await tester.tap(find.byKey(const Key('termsCheckbox')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('continueStep1Button')));
    await tester.pumpAndSettle();

    // Enter OTP
    final otpTextFields = find.byType(TextField);
    for (int i = 0; i < 6; i++) {
      await tester.enterText(otpTextFields.at(i), '1');
    }
    await tester.pump();

    await tester.tap(find.byKey(const Key('verifyOtpButton')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1200));
    await tester.pumpAndSettle();

    expect(find.byType(AssessmentScreen), findsOneWidget);

    // Answer incorrectly (select option 3 for all questions)
    for (int i = 0; i < 5; i++) {
      await tester.ensureVisible(find.byKey(const Key('optionCard_3')));
      await tester.tap(find.byKey(const Key('optionCard_3')));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(const Key('nextQuestionButton')));
      await tester.tap(find.byKey(const Key('nextQuestionButton')));
      await tester.pumpAndSettle();
    }

    // Verify Incomplete / Failed Result
    expect(find.byType(AssessmentResultScreen), findsOneWidget);
    expect(find.text('Assessment Incomplete'), findsOneWidget);
    expect(find.text('Passing Requirement: 80%'), findsOneWidget);
    expect(find.byKey(const Key('retakeAssessmentButton')), findsOneWidget);

    // Tap Retake Assessment
    await tester.ensureVisible(find.byKey(const Key('retakeAssessmentButton')));
    await tester.tap(find.byKey(const Key('retakeAssessmentButton')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    // Verify we are back in Assessment Screen
    expect(find.byType(AssessmentScreen), findsOneWidget);
    expect(find.textContaining('Question 1 of 5'), findsOneWidget);
  });
}
