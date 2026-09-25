import 'package:flutter_test/flutter_test.dart';
import 'package:_11jobs/main.dart';
import 'package:_11jobs/screens/home_screen.dart';
import 'package:_11jobs/widgets/animated_sign_in_button.dart';
import 'package:_11jobs/widgets/custom_text_field.dart';

void main() {
  testWidgets('Sign In UI test: plays animation once and settles', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    // Animation settles completely after running once
    await tester.pumpAndSettle();

    expect(find.textContaining('SIGN'), findsWidgets);
    expect(find.textContaining('Welcome back!'), findsOneWidget);
    expect(find.byType(CustomTextField), findsNWidgets(2));

    // Tap SIGN IN button
    await tester.tap(find.byType(AnimatedSignInButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1200));
    await tester.pumpAndSettle();

    // Check that Home screen appears
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('COMING SOON'), findsOneWidget);
  });
}
