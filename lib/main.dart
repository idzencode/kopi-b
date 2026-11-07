import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/auth_onboarding_screens.dart';
import 'features/shared/state/kopi_app_state.dart';
import 'features/shell/main_shell.dart';
import 'features/splash/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const KopiBApp());
}

class KopiBApp extends StatefulWidget {
  const KopiBApp({super.key});

  @override
  State<KopiBApp> createState() => _KopiBAppState();
}

class _KopiBAppState extends State<KopiBApp> {
  final KopiAppState _appState = KopiAppState();

  @override
  void dispose() {
    _appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kopi B - #kopiyangbaik',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: _AppFlowCoordinator(appState: _appState),
    );
  }
}

/// Pengatur alur transisi otomatis:
/// 1. [SplashScreen] (Gelombang hijau zamrud + Logo putih Kopi B)
/// 2. [WelcomeOnboardingScreen] -> [PhoneLoginScreen] -> [PinVerificationScreen]
/// 3. [MainShell] (Home Screen + 5-Tab Bottom Navigation)
class _AppFlowCoordinator extends StatefulWidget {
  const _AppFlowCoordinator({required this.appState});

  final KopiAppState appState;

  @override
  State<_AppFlowCoordinator> createState() => _AppFlowCoordinatorState();
}

enum _AppStage {
  splash,
  onboardingAuth,
  mainHome,
}

class _AppFlowCoordinatorState extends State<_AppFlowCoordinator> {
  _AppStage _stage = _AppStage.splash;

  void _goToOnboarding() {
    if (!mounted || _stage != _AppStage.splash) return;
    setState(() => _stage = _AppStage.onboardingAuth);
  }

  void _goToMainHome([String? phoneNumber]) {
    if (!mounted) return;
    setState(() => _stage = _AppStage.mainHome);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 520),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      child: switch (_stage) {
        _AppStage.splash => SplashScreen(
            key: const ValueKey('splash'),
            onFinished: _goToOnboarding,
          ),
        _AppStage.onboardingAuth => WelcomeOnboardingScreen(
            key: const ValueKey('onboarding'),
            onSkipToHome: _goToMainHome,
            onLoginSuccess: _goToMainHome,
          ),
        _AppStage.mainHome => MainShell(
            key: const ValueKey('main_shell'),
            appState: widget.appState,
          ),
      },
    );
  }
}
