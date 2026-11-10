import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

/// Splash Screen "Kopi B" (#kopiyangbaik)
/// Mengadopsi estetika organik Fore Coffee dengan gelombang cahaya diagonal
/// Deep Forest Green (#0D6B4C), Logo B, dan tulisan #kopiyangbaik di bawahnya.
/// Animasi bergerak dari kecil (0.60x) ke besar (1.0x).
class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
    this.onFinished,
    this.autoNavigateDuration = const Duration(milliseconds: 2800),
  });

  /// Callback opsional setelah durasi splash selesai atau saat layar disentuh.
  final VoidCallback? onFinished;
  final Duration autoNavigateDuration;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.70, curve: Curves.easeOut),
    );

    // Animasi logo & teks dari kecil (0.60x) ke ukuran penuh (1.0x) dengan kurva melambat halus
    _scaleAnimation = Tween<double>(
      begin: 0.60,
      end: 1.30,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();

    if (widget.onFinished != null) {
      _navigationTimer = Timer(widget.autoNavigateDuration, () {
        if (mounted) {
          widget.onFinished?.call();
        }
      });
    }
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final logoWidth = (screenWidth * 0.46).clamp(160.0, 210.0);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xFF074C35),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onFinished,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 1. Latar Belakang Gelombang Silky Diagonal khas Fore / Kopi B
              const CustomPaint(painter: _SilkyForestWavePainter()),

              // 2. Logo B & Tulisan #kopiyangbaik di Tengah Layar (Animasi Kecil -> Besar)
              Center(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          width: logoWidth,
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.high,
                        ),
                        const SizedBox(height: 0.1),
                        Text(
                          '#kopiyangbaik',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 26,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Painter untuk menghasilkan efek gelombang gradasi hijau zamrud/hutan
/// diagonal lembut yang identik dengan referensi Splash Screen.
class _SilkyForestWavePainter extends CustomPainter {
  const _SilkyForestWavePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // 1. Base Diagonal Linear Gradient
    final basePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF0A5C40), // Top-left deep forest
          Color(0xFF0D6B4C), // Primary brand core
          Color(0xFF0F7A57), // Mid-screen warm botanical sheen
          Color(0xFF084C35), // Bottom-right deep evergreen shadow
        ],
        stops: [0.0, 0.38, 0.68, 1.0],
      ).createShader(rect);

    canvas.drawRect(rect, basePaint);

    // 2. Gelombang Cahaya Diagonal Atas-Tengah (Soft Emerald Highlight Ribbon 1)
    final highlightPath1 = Path()
      ..moveTo(-size.width * 0.2, size.height * 0.12)
      ..cubicTo(
        size.width * 0.25,
        size.height * 0.28,
        size.width * 0.55,
        size.height * 0.52,
        size.width * 1.2,
        size.height * 0.78,
      )
      ..lineTo(size.width * 1.2, size.height * 0.45)
      ..cubicTo(
        size.width * 0.65,
        size.height * 0.25,
        size.width * 0.30,
        size.height * 0.05,
        -size.width * 0.2,
        -size.height * 0.08,
      )
      ..close();

    final highlightPaint1 = Paint()
      ..color = const Color(0xFF1A966D).withValues(alpha: 0.42)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 55);
    canvas.drawPath(highlightPath1, highlightPaint1);

    // 3. Gelombang Cahaya Diagonal Bawah-Kiri ke Tengah (Soft Emerald Ribbon 2)
    final highlightPath2 = Path()
      ..moveTo(-size.width * 0.25, size.height * 0.52)
      ..cubicTo(
        size.width * 0.15,
        size.height * 0.68,
        size.width * 0.48,
        size.height * 0.85,
        size.width * 0.95,
        size.height * 1.12,
      )
      ..lineTo(size.width * 0.45, size.height * 1.15)
      ..cubicTo(
        size.width * 0.15,
        size.height * 0.92,
        -size.width * 0.05,
        size.height * 0.78,
        -size.width * 0.25,
        size.height * 0.68,
      )
      ..close();

    final highlightPaint2 = Paint()
      ..color = const Color(0xFF1B9A70).withValues(alpha: 0.38)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 50);
    canvas.drawPath(highlightPath2, highlightPaint2);

    // 4. Gelombang Bayangan Dalam Diagonal (Deep Evergreen Contour)
    final shadowWavePath = Path()
      ..moveTo(-size.width * 0.1, size.height * 0.28)
      ..cubicTo(
        size.width * 0.30,
        size.height * 0.46,
        size.width * 0.62,
        size.height * 0.72,
        size.width * 1.15,
        size.height * 0.96,
      )
      ..lineTo(size.width * 1.15, size.height * 1.1)
      ..cubicTo(
        size.width * 0.52,
        size.height * 0.84,
        size.width * 0.20,
        size.height * 0.58,
        -size.width * 0.15,
        size.height * 0.42,
      )
      ..close();

    final shadowWavePaint = Paint()
      ..color = const Color(0xFF043825).withValues(alpha: 0.48)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 48);
    canvas.drawPath(shadowWavePath, shadowWavePaint);

    // 5. Soft Ambient Glow di belakang Logo Tengah
    final centerGlowPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.0, -0.04),
        radius: 0.58,
        colors: [
          const Color(0xFF188C65).withValues(alpha: 0.28),
          Colors.transparent,
        ],
      ).createShader(rect);
    canvas.drawRect(rect, centerGlowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
