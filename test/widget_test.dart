import 'package:flutter_test/flutter_test.dart';
import 'package:_11jobs/main.dart';
import 'package:_11jobs/screens/home_screen.dart';
import 'package:_11jobs/widgets/animated_sign_in_button.dart';
import 'package:_11jobs/widgets/brand_logo.dart';
import 'package:_11jobs/widgets/custom_text_field.dart';

void main() {
  testWidgets('11Jobs Sign In UI test and navigation to Home', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    // Animation settles after running once
    await tester.pumpAndSettle();

    expect(find.byType(BrandLogo), findsOneWidget);
    expect(find.text('Sign In'), findsWidgets);
    expect(find.text('Company Email'), findsOneWidget);
    expect(find.byType(CustomTextField), findsNWidgets(2));

    // Tap Sign In button
    await tester.tap(find.byType(AnimatedSignInButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1200));
    await tester.pumpAndSettle();

    // Verify Coming Soon HomeScreen appears
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.textContaining('COMING SOON'), findsOneWidget);
  });
}
