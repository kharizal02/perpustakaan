import 'package:flutter_test/flutter_test.dart';
import 'package:e_libs/main.dart';

void main() {
  testWidgets('Login and Register screen test', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(MyApp());

    // Verifikasi bahwa elemen di halaman login ada
    expect(find.text('LOGIN'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Sign Up'), findsOneWidget);

    // Simulasi tap pada tombol Sign Up untuk pindah ke halaman register
    await tester.tap(find.text('Sign Up'));
    await tester.pumpAndSettle();

    // Verifikasi bahwa elemen di halaman register ada
    expect(find.text('SIGN UP'), findsOneWidget);
    expect(find.text('NRP'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });
}
