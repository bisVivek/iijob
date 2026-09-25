import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:_11jobs/main.dart';
import 'package:_11jobs/screens/home_screen.dart';
import 'package:_11jobs/widgets/brand_logo.dart';

void main() {
  testWidgets('Complete Auth Lifecycle: Sign Up with Phone & Password, then Sign In with Country Code', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // 1. Initial Sign In Screen
    expect(find.byType(BrandLogo), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.byKey(const Key('signInModePhoneTab')), findsOneWidget);
    expect(find.byKey(const Key('signInModeEmailTab')), findsOneWidget);

    // Test Sign In empty validation in Phone mode
    await tester.tap(find.byKey(const Key('signInButton')));
    await tester.pumpAndSettle();
    expect(find.text('Please enter your registered phone number'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);

    // Test switching to Email tab on Sign In
    await tester.tap(find.byKey(const Key('signInModeEmailTab')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('signInEmailField')), findsOneWidget);

    // Test Sign In empty validation in Email mode
    await tester.tap(find.byKey(const Key('signInButton')));
    await tester.pumpAndSettle();
    expect(find.text('Please enter your registered email address'), findsOneWidget);

    // Switch back to Phone mode
    await tester.tap(find.byKey(const Key('signInModePhoneTab')));
    await tester.pumpAndSettle();

    // 2. Switch to Sign Up Step 1
    await tester.tap(find.byKey(const Key('switchToSignUpButton')));
    await tester.pumpAndSettle();

    expect(find.text('Step: 1'), findsOneWidget);
    expect(find.text('Create your account'), findsOneWidget);

    // Test Step 1 empty validation
    await tester.tap(find.byKey(const Key('continueStep1Button')));
    await tester.pumpAndSettle();
    expect(find.text('First name is required'), findsOneWidget);
    expect(find.text('Email address is required'), findsOneWidget);
    expect(find.text('Phone number is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);

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

    // 4. Returns to Sign In with prefilled registered phone, country code & password!
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('9876543210'), findsOneWidget);

    // 5. Tap Sign In with registered credentials
    await tester.tap(find.byKey(const Key('signInButton')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1200));
    await tester.pumpAndSettle();

    // 6. Verify Home Screen opens with registered user's name
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.textContaining('Rahul Sharma'), findsOneWidget);

    // 7. Test Logout and Login again with registered phone and password
    await tester.tap(find.byTooltip('Logout'));
    await tester.pumpAndSettle();

    expect(find.text('Sign In'), findsOneWidget);

    // Test Wrong Password on Login
    final signInPhoneField = find.descendant(
      of: find.byKey(const Key('signInPhoneField')),
      matching: find.byType(TextField),
    );
    final signInPassField = find.descendant(
      of: find.byKey(const Key('signInPasswordField')),
      matching: find.byType(TextField),
    );

    await tester.enterText(signInPhoneField, '9876543210');
    await tester.enterText(signInPassField, 'WrongPassword123');
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('signInButton')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1000));
    await tester.pumpAndSettle();

    expect(find.textContaining('Incorrect password'), findsOneWidget);

    // Now enter Correct Password and login successfully
    await tester.enterText(signInPassField, 'Password123');
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('signInButton')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1200));
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.textContaining('Rahul Sharma'), findsOneWidget);
  });

  testWidgets('Duplicate Email and Phone Number Validation during Registration', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Switch to Sign Up
    await tester.tap(find.byKey(const Key('switchToSignUpButton')));
    await tester.pumpAndSettle();

    final firstNameField = find.descendant(
      of: find.byKey(const Key('signUpFirstNameField')),
      matching: find.byType(TextField),
    );
    final emailField = find.descendant(
      of: find.byKey(const Key('signUpEmailField')),
      matching: find.byType(TextField),
    );
    final phoneField = find.descendant(
      of: find.byKey(const Key('signUpPhoneField')),
      matching: find.byType(TextField),
    );
    final passwordField = find.descendant(
      of: find.byKey(const Key('signUpPasswordField')),
      matching: find.byType(TextField),
    );
    final confirmPasswordField = find.descendant(
      of: find.byKey(const Key('signUpConfirmPasswordField')),
      matching: find.byType(TextField),
    );

    // Try registering with already existing email 'demo@11jobs.com'
    await tester.enterText(firstNameField, 'Test');
    await tester.enterText(emailField, 'demo@11jobs.com');
    await tester.enterText(phoneField, '9123456789');
    await tester.enterText(passwordField, 'Password123');
    await tester.enterText(confirmPasswordField, 'Password123');
    await tester.tap(find.byKey(const Key('termsCheckbox')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('continueStep1Button')));
    await tester.pumpAndSettle();

    // Verify duplicate email error is shown
    expect(find.text('This email is already registered. Please sign in.'), findsOneWidget);

    // Change to a new email, but try existing phone '9999999999'
    await tester.enterText(emailField, 'newuser@11jobs.com');
    await tester.enterText(phoneField, '9999999999');
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('continueStep1Button')));
    await tester.pumpAndSettle();

    // Verify duplicate phone error is shown
    expect(find.text('This phone number is already registered. Please sign in.'), findsOneWidget);
  });
}
