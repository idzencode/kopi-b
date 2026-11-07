import 'package:flutter_test/flutter_test.dart';
import 'package:kopi_b/features/auth/auth_onboarding_screens.dart';
import 'package:kopi_b/features/shared/state/kopi_app_state.dart';
import 'package:kopi_b/features/shell/main_shell.dart';
import 'package:kopi_b/features/splash/splash_screen.dart';
import 'package:kopi_b/main.dart';

void main() {
  testWidgets('Full flow: Splash -> Onboarding -> Phone -> PIN -> Home Screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const KopiBApp());

    // 1. Awalnya menampilkan SplashScreen
    expect(find.byType(SplashScreen), findsOneWidget);

    // 2. Setelah durasi otomatis (2.8 detik), berpindah ke WelcomeOnboardingScreen
    await tester.pump(const Duration(milliseconds: 2900));
    await tester.pumpAndSettle();
    expect(find.byType(WelcomeOnboardingScreen), findsOneWidget);
    expect(find.text('Semua Favoritmu dalam Satu Aplikasi'), findsOneWidget);
    expect(find.text('Masuk'), findsOneWidget);
    expect(find.text('Lewati tahap ini'), findsOneWidget);

    // 3. Klik tombol "Lewati tahap ini" menuju MainShell (Home Screen)
    await tester.tap(find.text('Lewati tahap ini'));
    await tester.pumpAndSettle();
    expect(find.byType(MainShell), findsOneWidget);
    expect(find.textContaining('B-Beans'), findsWidgets);
  });

  test('KopiAppState cart, customization, and checkout logic', () {
    final state = KopiAppState();
    expect(state.totalCartItems, 1);
    expect(state.bBeansPoints, 145);

    final order = state.checkoutOrder();
    expect(order, isNotNull);
    expect(state.totalCartItems, 0);
    expect(state.currentTabIndex, 2); // Berpindah ke tab Order setelah checkout
  });
}

