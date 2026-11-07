import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

/// ═══════════════════════════════════════════════════════════════════════════
/// SCREEN 1: WELCOME / ONBOARDING SCREEN (Format Fore-Style dengan Brand Kopi B)
/// Menampilkan showcase kopi & pastry, carousel 3 titik, judul hijau,
/// pemilih bahasa Indonesia, tombol pill "Masuk", dan "Lewati tahap ini".
/// ═══════════════════════════════════════════════════════════════════════════
class WelcomeOnboardingScreen extends StatefulWidget {
  const WelcomeOnboardingScreen({
    super.key,
    required this.onSkipToHome,
    required this.onLoginSuccess,
  });

  final VoidCallback onSkipToHome;
  final ValueChanged<String> onLoginSuccess;

  @override
  State<WelcomeOnboardingScreen> createState() =>
      _WelcomeOnboardingScreenState();
}

class _WelcomeOnboardingScreenState extends State<WelcomeOnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentSlide = 0;
  String _selectedLanguage = 'Indonesia';

  static const List<_OnboardingSlideData> _slides = [
    _OnboardingSlideData(
      title: 'Semua Favoritmu dalam Satu Aplikasi',
      subtitle: 'Praktis pesan kopi dan pastry di Kopi B App!',
    ),
    _OnboardingSlideData(
      title: 'Pick Up Tanpa Antre & Delivery Cepat',
      subtitle: 'Pesan dari mana saja, barista langsung menyeduh kopimu.',
    ),
    _OnboardingSlideData(
      title: 'Kumpulkan B-Beans Setiap Transaksi',
      subtitle: 'Tukarkan poinmu dengan gratis kopi Signature #kopiyangbaik.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _openPhoneLogin() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PhoneLoginScreen(
          onAuthenticated: (phone) {
            Navigator.of(context).popUntil((route) => route.isFirst);
            widget.onLoginSuccess(phone);
          },
        ),
      ),
    );
  }

  void _showLanguagePicker() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pilih Bahasa / Language', style: AppTextStyles.heading1),
                const SizedBox(height: AppSpacing.md),
                ListTile(
                  leading: const _IndonesiaFlagIcon(),
                  title: Text('Indonesia', style: AppTextStyles.bodyMedium),
                  trailing: _selectedLanguage == 'Indonesia'
                      ? const Icon(Icons.check_circle, color: AppColors.primary)
                      : null,
                  onTap: () {
                    setState(() => _selectedLanguage = 'Indonesia');
                    Navigator.pop(ctx);
                  },
                ),
                ListTile(
                  leading: Container(
                    width: 24,
                    height: 16,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E3A8A),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: const Text(
                      'EN',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text('English', style: AppTextStyles.bodyMedium),
                  trailing: _selectedLanguage == 'English'
                      ? const Icon(Icons.check_circle, color: AppColors.primary)
                      : null,
                  onTap: () {
                    setState(() => _selectedLanguage = 'English');
                    Navigator.pop(ctx);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final slide = _slides[_currentSlide];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            // 1. Area Studio Showcase Kopi & Donat/Pastry (Atas)
            Expanded(
              flex: 56,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFF1F3F5),
                      Color(0xFFF7F8F9),
                      Color(0xFFFFFFFF),
                    ],
                    stops: [0.0, 0.72, 1.0],
                  ),
                ),
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _slides.length,
                  onPageChanged: (index) =>
                      setState(() => _currentSlide = index),
                  itemBuilder: (context, index) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 36),
                        child: _StudioDrinksAndDonutsShowcase(slideIndex: index),
                      ),
                    );
                  },
                ),
              ),
            ),

            // 2. Area Bawah: Indikator Titik, Judul, Bahasa, Tombol Masuk & Lewati
            Expanded(
              flex: 44,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: AppSpacing.md,
                  ),
                  child: Column(
                    children: [
                      // 3 Dot Indicators (• • •)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(_slides.length, (i) {
                          final active = i == _currentSlide;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: active ? 7 : 6,
                            height: active ? 7 : 6,
                            decoration: BoxDecoration(
                              color: active
                                  ? AppColors.primary
                                  : const Color(0xFFBFC8C4),
                              shape: BoxShape.circle,
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 22),

                      // Judul Hijau Tebal
                      Text(
                        slide.title,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.heading1.copyWith(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Subjudul Hitam/Evergreen
                      Text(
                        slide.subtitle,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.body.copyWith(
                          fontSize: 14,
                          color: AppColors.neutralDark,
                        ),
                      ),

                      const Spacer(),

                      // Pemilih Bahasa Pill (🇮🇩 Indonesia ⌄)
                      InkWell(
                        borderRadius: AppSpacing.borderRadiusPill,
                        onTap: _showLanguagePicker,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: AppSpacing.borderRadiusPill,
                            border: Border.all(
                              color: const Color(0xFFD0D7D4),
                              width: 1.0,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const _IndonesiaFlagIcon(),
                              const SizedBox(width: 10),
                              Text(
                                _selectedLanguage,
                                style: AppTextStyles.caption.copyWith(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.neutralDark,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 18,
                                color: AppColors.neutralDark,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Tombol Pill Penuh "Masuk" (#0D6B4C)
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.background,
                            elevation: 2,
                            shadowColor:
                                AppColors.primary.withValues(alpha: 0.35),
                            shape: const StadiumBorder(),
                          ),
                          onPressed: _openPhoneLogin,
                          child: Text(
                            'Masuk',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.background,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Tombol "Lewati tahap ini"
                      TextButton(
                        onPressed: widget.onSkipToHome,
                        child: Text(
                          'Lewati tahap ini',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.w600,
                            fontSize: 13.5,
                          ),
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
    );
  }
}

class _OnboardingSlideData {
  const _OnboardingSlideData({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;
}

class _IndonesiaFlagIcon extends StatelessWidget {
  const _IndonesiaFlagIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 15,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 0.6),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: const Column(
        children: [
          Expanded(child: ColoredBox(color: Color(0xFFE11D23), child: SizedBox.expand())),
          Expanded(child: ColoredBox(color: Colors.white, child: SizedBox.expand())),
        ],
      ),
    );
  }
}

/// Ilustrasi Komposisi Studio 2 Cup Kopi B + 2 Artisanal Bomboloni Donut
/// yang merepresentasikan visual referensi Screen 1 dengan branding Kopi B.
class _StudioDrinksAndDonutsShowcase extends StatelessWidget {
  const _StudioDrinksAndDonutsShowcase({required this.slideIndex});

  final int slideIndex;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 310,
      height: 290,
      child: CustomPaint(
        painter: _StudioProductGroupPainter(slideIndex: slideIndex),
      ),
    );
  }
}

class _StudioProductGroupPainter extends CustomPainter {
  const _StudioProductGroupPainter({required this.slideIndex});

  final int slideIndex;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Contact shadows di meja studio putih
    void drawShadow(Offset center, double rx, double ry, double alpha) {
      final rect = Rect.fromCenter(center: center, width: rx * 2, height: ry * 2);
      final paint = Paint()
        ..color = Colors.black.withValues(alpha: alpha)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14);
      canvas.drawOval(rect, paint);
    }

    drawShadow(Offset(w * 0.52, h * 0.63), 46, 12, 0.16); // Back cup shadow
    drawShadow(Offset(w * 0.27, h * 0.72), 48, 13, 0.20); // Left cup shadow
    drawShadow(Offset(w * 0.77, h * 0.70), 48, 13, 0.18); // Right donut shadow
    drawShadow(Offset(w * 0.54, h * 0.80), 50, 14, 0.22); // Front donut shadow

    // ─── 1. CUP BELAKANG TENGAH: Iced Americano / Cold Brew Kopi B ──────────
    _drawIcedAmericanoCup(
      canvas,
      topCenter: Offset(w * 0.51, h * 0.14),
      topWidth: 102,
      bottomWidth: 74,
      cupHeight: 138,
    );

    // ─── 2. CUP KIRI DEPAN: Iced Butterscotch Creamy Crumble Latte ──────────
    _drawCreamyLatteCup(
      canvas,
      topCenter: Offset(w * 0.26, h * 0.26),
      topWidth: 106,
      bottomWidth: 76,
      cupHeight: 134,
    );

    // ─── 3. DONUT KANAN: Strawberry Cream Sugar Bomboloni ───────────────────
    _drawStrawberryDonut(
      canvas,
      center: Offset(w * 0.77, h * 0.58),
      rx: 46,
      ry: 35,
    );

    // ─── 4. DONUT DEPAN TENGAH: Matcha Dust & Torched Cheese Bomboloni ──────
    _drawCheeseMatchaDonut(
      canvas,
      center: Offset(w * 0.54, h * 0.69),
      rx: 48,
      ry: 37,
    );
  }

  void _drawIcedAmericanoCup(
    Canvas canvas, {
    required Offset topCenter,
    required double topWidth,
    required double bottomWidth,
    required double cupHeight,
  }) {
    final topY = topCenter.dy;
    final bottomY = topY + cupHeight;
    final cx = topCenter.dx;

    final bodyPath = Path()
      ..moveTo(cx - topWidth / 2, topY)
      ..lineTo(cx + topWidth / 2, topY)
      ..lineTo(cx + bottomWidth / 2, bottomY)
      ..quadraticBezierTo(cx, bottomY + 10, cx - bottomWidth / 2, bottomY)
      ..close();

    // Warna seduhan kopi amber gelap bergradasi
    final coffeePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: const [
          Color(0xFFB55318),
          Color(0xFF7B2811),
          Color(0xFF4F170B),
        ],
      ).createShader(Rect.fromLTWH(cx - topWidth / 2, topY, topWidth, cupHeight));
    canvas.drawPath(bodyPath, coffeePaint);

    // Permukaan es batu berkilau di atas cup
    final topOval = Rect.fromCenter(
      center: topCenter,
      width: topWidth,
      height: 24,
    );
    canvas.drawOval(
      topOval,
      Paint()..color = const Color(0xFFD97C2B),
    );

    // Kubus es di permukaan
    final icePaint = Paint()
      ..color = const Color(0xFFFFE4B5).withValues(alpha: 0.55);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: topCenter.translate(-16, 0), width: 20, height: 10),
        const Radius.circular(3),
      ),
      icePaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: topCenter.translate(12, -2), width: 22, height: 11),
        const Radius.circular(3),
      ),
      icePaint,
    );

    // Rim transparan cup
    canvas.drawOval(
      topOval,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.75)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2,
    );

    // Logo Hijau Kopi B di tengah cup
    _drawCupBrandMark(canvas, Offset(cx, topY + cupHeight * 0.52));
  }

  void _drawCreamyLatteCup(
    Canvas canvas, {
    required Offset topCenter,
    required double topWidth,
    required double bottomWidth,
    required double cupHeight,
  }) {
    final topY = topCenter.dy;
    final bottomY = topY + cupHeight;
    final cx = topCenter.dx;

    final bodyPath = Path()
      ..moveTo(cx - topWidth / 2, topY)
      ..lineTo(cx + topWidth / 2, topY)
      ..lineTo(cx + bottomWidth / 2, bottomY)
      ..quadraticBezierTo(cx, bottomY + 10, cx - bottomWidth / 2, bottomY)
      ..close();

    // Gradasi milky latte creamy ke arah caramel di bawah
    final lattePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: const [
          Color(0xFFF6EFE6),
          Color(0xFFDCC3A5),
          Color(0xFFB78E66),
        ],
        stops: const [0.0, 0.35, 1.0],
      ).createShader(Rect.fromLTWH(cx - topWidth / 2, topY, topWidth, cupHeight));
    canvas.drawPath(bodyPath, lattePaint);

    // Foam putih tebal di bagian atas
    final foamPath = Path()
      ..moveTo(cx - topWidth / 2, topY)
      ..lineTo(cx + topWidth / 2, topY)
      ..lineTo(cx + topWidth * 0.46, topY + 34)
      ..quadraticBezierTo(cx, topY + 42, cx - topWidth * 0.46, topY + 34)
      ..close();
    canvas.drawPath(foamPath, Paint()..color = const Color(0xFFF9F6F0));

    // Oval atas foam + taburan butterscotch crumble
    final topOval = Rect.fromCenter(
      center: topCenter,
      width: topWidth,
      height: 26,
    );
    canvas.drawOval(topOval, Paint()..color = const Color(0xFFFAF7F2));

    // Taburan crumble keemasan
    final crumblePaint = Paint()..color = const Color(0xFFC58435);
    final offsets = [
      const Offset(-24, -2),
      const Offset(-12, 3),
      const Offset(-4, -4),
      const Offset(8, 2),
      const Offset(20, -1),
      const Offset(14, 5),
      const Offset(-16, -5),
      const Offset(2, 5),
    ];
    for (final o in offsets) {
      canvas.drawCircle(topCenter + o, 3.2, crumblePaint);
    }

    canvas.drawOval(
      topOval,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );

    // Logo Hijau Kopi B di bagian depan cup
    _drawCupBrandMark(canvas, Offset(cx, topY + cupHeight * 0.56));
  }

  void _drawCupBrandMark(Canvas canvas, Offset center) {
    final badgeRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: 30, height: 30),
      const Radius.circular(9),
    );
    final strokePaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2;
    canvas.drawRRect(badgeRect, strokePaint);

    // Daun kopi simbolik di dalam kotak
    final leafRect = Rect.fromCenter(center: center, width: 12, height: 18);
    canvas.drawOval(leafRect, strokePaint);

    // Teks "KOPI B" kecil di bawah ikon
    final tp = TextPainter(
      text: const TextSpan(
        text: 'KOPI B',
        style: TextStyle(
          color: AppColors.primaryDark,
          fontSize: 8.5,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.6,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(center.dx - tp.width / 2, center.dy + 18));
  }

  void _drawStrawberryDonut(
    Canvas canvas, {
    required Offset center,
    required double rx,
    required double ry,
  }) {
    final bodyRect = Rect.fromCenter(center: center, width: rx * 2, height: ry * 2);
    final donutPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.2, -0.3),
        radius: 0.9,
        colors: const [
          Color(0xFFEAD4BE),
          Color(0xFFC2956B),
          Color(0xFF8F623E),
        ],
      ).createShader(bodyRect);
    canvas.drawOval(bodyRect, donutPaint);

    // Taburan gula halus
    canvas.drawOval(
      Rect.fromCenter(center: center.translate(0, -4), width: rx * 1.75, height: ry * 1.45),
      Paint()..color = Colors.white.withValues(alpha: 0.38),
    );

    // Custard cream swirl di puncak
    canvas.drawOval(
      Rect.fromCenter(center: center.translate(0, -ry * 0.68), width: 34, height: 16),
      Paint()..color = const Color(0xFFFFF0C2),
    );

    // Potongan buah stroberi merah segar di atas krim
    final strawberryPath = Path()
      ..moveTo(center.dx, center.dy - ry * 1.32)
      ..quadraticBezierTo(
        center.dx + 16,
        center.dy - ry * 0.95,
        center.dx + 11,
        center.dy - ry * 0.62,
      )
      ..quadraticBezierTo(
        center.dx,
        center.dy - ry * 0.54,
        center.dx - 11,
        center.dy - ry * 0.62,
      )
      ..quadraticBezierTo(
        center.dx - 16,
        center.dy - ry * 0.95,
        center.dx,
        center.dy - ry * 1.32,
      )
      ..close();
    canvas.drawPath(strawberryPath, Paint()..color = const Color(0xFFD9232E));
  }

  void _drawCheeseMatchaDonut(
    Canvas canvas, {
    required Offset center,
    required double rx,
    required double ry,
  }) {
    final bodyRect = Rect.fromCenter(center: center, width: rx * 2, height: ry * 2);
    final donutPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.2, -0.3),
        radius: 0.9,
        colors: const [
          Color(0xFFD5B77A),
          Color(0xFF9F844A),
          Color(0xFF6E572C),
        ],
      ).createShader(bodyRect);
    canvas.drawOval(bodyRect, donutPaint);

    // Slice keju panggang (torched cheese) berlian di atas donat
    final cheeseTop = center.translate(0, -ry * 0.42);
    final cheesePath = Path()
      ..moveTo(cheeseTop.dx, cheeseTop.dy - 15)
      ..lineTo(cheeseTop.dx + 28, cheeseTop.dy - 2)
      ..lineTo(cheeseTop.dx, cheeseTop.dy + 13)
      ..lineTo(cheeseTop.dx - 28, cheeseTop.dy - 2)
      ..close();
    canvas.drawPath(cheesePath, Paint()..color = const Color(0xFFF3B340));

    // Efek bruleed / torched caramel di tengah keju
    canvas.drawCircle(
      cheeseTop,
      10,
      Paint()
        ..color = const Color(0xFF4A2C11).withValues(alpha: 0.65)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
  }

  @override
  bool shouldRepaint(covariant _StudioProductGroupPainter oldDelegate) =>
      oldDelegate.slideIndex != slideIndex;
}

/// ═══════════════════════════════════════════════════════════════════════════
/// SCREEN 2: MASUK — INPUT NOMOR TELEPON (Sesuai gambar referensi ke-2)
/// Menampilkan tombol back lingkaran hijau, judul "Masuk", input "+62" dan
/// nomor telepon, tombol "Lanjutkan" (abu-abu saat kosong, hijau saat valid),
/// serta teks persetujuan Syarat & Ketentuan dan Kebijakan Privasi.
/// ═══════════════════════════════════════════════════════════════════════════
class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({
    super.key,
    required this.onAuthenticated,
  });

  final ValueChanged<String> onAuthenticated;

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  String _countryCode = '+62';

  bool get _isValidPhone => _phoneController.text.trim().length >= 8;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _proceedToPin() {
    if (!_isValidPhone) return;
    final fullPhone = '$_countryCode${_phoneController.text.trim()}';
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PinVerificationScreen(
          phoneNumber: fullPhone,
          onPinVerified: () => widget.onAuthenticated(fullPhone),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        leadingWidth: 56,
        leading: Padding(
          padding: const EdgeInsets.only(left: AppSpacing.lg),
          child: Center(
            child: _CircularOutlinedBackButton(
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
        ),
        title: Text(
          'Masuk',
          style: AppTextStyles.heading2.copyWith(
            color: AppColors.primaryDark,
            fontSize: 17,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Label "Masukkan no telepon"
              Text(
                'Masukkan no telepon',
                style: AppTextStyles.heading2.copyWith(
                  color: AppColors.primaryDark,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 18),

              // Baris Input: Chip "+62 v" + TextField "81234567890" dengan garis bawah
              Container(
                padding: const EdgeInsets.only(bottom: 10),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0xFF9CAEA6),
                      width: 1.0,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    // Selector Kode Negara "+62 v"
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _countryCode = _countryCode == '+62' ? '+65' : '+62';
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F2F1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _countryCode,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.primaryDark,
                                fontWeight: FontWeight.w700,
                                fontSize: 13.5,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 16,
                              color: AppColors.primaryDark,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Field Nomor Telepon
                    Expanded(
                      child: TextField(
                        controller: _phoneController,
                        autofocus: true,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(13),
                        ],
                        onChanged: (_) => setState(() {}),
                        onSubmitted: (_) => _proceedToPin(),
                        style: AppTextStyles.heading2.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.neutralDark,
                        ),
                        decoration: InputDecoration(
                          hintText: '81234567890',
                          hintStyle: AppTextStyles.heading2.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFFB7C0BC),
                          ),
                          filled: false,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 36),

              // Tombol "Lanjutkan" (Abu-abu #C5C7C6 saat belum diisi, #0D6B4C saat terisi)
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isValidPhone
                        ? AppColors.primary
                        : const Color(0xFFC5C7C6),
                    disabledBackgroundColor: const Color(0xFFC5C7C6),
                    foregroundColor: AppColors.background,
                    disabledForegroundColor: AppColors.background,
                    elevation: _isValidPhone ? 2 : 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _isValidPhone ? _proceedToPin : null,
                  child: Text(
                    'Lanjutkan',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.background,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // Disclaimer Syarat & Ketentuan dan Kebijakan Privasi
              RichText(
                text: TextSpan(
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 12.5,
                    height: 1.45,
                    color: AppColors.neutralDark,
                    fontWeight: FontWeight.w400,
                  ),
                  children: const [
                    TextSpan(
                      text:
                          'Dengan masuk aplikasi Kopi B, kamu telah menyetujui ',
                    ),
                    TextSpan(
                      text: 'Syarat & Ketentuan',
                      style: TextStyle(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(text: ' dan '),
                    TextSpan(
                      text: 'Kebijakan Privasi',
                      style: TextStyle(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ═══════════════════════════════════════════════════════════════════════════
/// SCREEN 3: PIN KOPI B (Sesuai gambar referensi ke-3)
/// Menampilkan judul "PIN Kopi B", instruksi "Masukkan PIN", 6 garis bawah
/// dengan kursor vertikal hijau berkedip, tombol "Lupa PIN", dan keypad angka
/// bergaya modern di bagian bawah layar.
/// ═══════════════════════════════════════════════════════════════════════════
class PinVerificationScreen extends StatefulWidget {
  const PinVerificationScreen({
    super.key,
    required this.phoneNumber,
    required this.onPinVerified,
  });

  final String phoneNumber;
  final VoidCallback onPinVerified;

  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  String _pin = '';
  bool _cursorVisible = true;
  Timer? _cursorTimer;

  @override
  void initState() {
    super.initState();
    _cursorTimer = Timer.periodic(const Duration(milliseconds: 520), (_) {
      if (mounted) {
        setState(() => _cursorVisible = !_cursorVisible);
      }
    });
  }

  @override
  void dispose() {
    _cursorTimer?.cancel();
    super.dispose();
  }

  void _onDigitPressed(String digit) {
    if (_pin.length >= 6) return;
    setState(() {
      _pin += digit;
    });
    if (_pin.length == 6) {
      Future<void>.delayed(const Duration(milliseconds: 240), () {
        if (mounted) {
          widget.onPinVerified();
        }
      });
    }
  }

  void _onBackspace() {
    if (_pin.isEmpty) return;
    setState(() {
      _pin = _pin.substring(0, _pin.length - 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        leadingWidth: 56,
        leading: Padding(
          padding: const EdgeInsets.only(left: AppSpacing.lg),
          child: Center(
            child: _CircularOutlinedBackButton(
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
        ),
        title: Text(
          'PIN Kopi B',
          style: AppTextStyles.heading2.copyWith(
            color: AppColors.primaryDark,
            fontSize: 17,
          ),
        ),
      ),
      body: Column(
        children: [
          // Area Atas: Judul, Subjudul, 6 Garis PIN, Lupa PIN
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Column(
                children: [
                  const SizedBox(height: 34),
                  Text(
                    'Masukkan PIN',
                    style: AppTextStyles.heading2.copyWith(
                      color: AppColors.primaryDark,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Masukkan nomor PIN yang kamu daftarkan pada aplikasi\nKopi B',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 13.5,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 44),

                  // 6 Slot Garis Bawah PIN (_ _ _ _ _ _)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) {
                      final isFilled = index < _pin.length;
                      final isCurrent = index == _pin.length;

                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 38,
                                child: Center(
                                  child: isFilled
                                      ? Container(
                                          width: 12,
                                          height: 12,
                                          decoration: const BoxDecoration(
                                            color: AppColors.primaryDark,
                                            shape: BoxShape.circle,
                                          ),
                                        )
                                      : (isCurrent && _cursorVisible)
                                          ? Container(
                                              width: 2.2,
                                              height: 32,
                                              color: AppColors.primaryDark,
                                            )
                                          : const SizedBox.shrink(),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                height: isCurrent ? 2.4 : 1.5,
                                color: AppColors.primaryDark,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 36),

                  // Tombol "Lupa PIN"
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: AppColors.primary,
                          behavior: SnackBarBehavior.floating,
                          content: Text(
                            'Kode OTP pemulihan PIN dikirim ke ${widget.phoneNumber}',
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'Lupa PIN',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 12.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Area Bawah: Custom Numpad (Sesuai Layout Keyboard Angka Referensi)
          _PinNumericKeypad(
            onDigitPressed: _onDigitPressed,
            onBackspace: _onBackspace,
            onSubmit: () {
              if (_pin.isNotEmpty) {
                widget.onPinVerified();
              }
            },
          ),
        ],
      ),
    );
  }
}

class _CircularOutlinedBackButton extends StatelessWidget {
  const _CircularOutlinedBackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.primaryDark,
            width: 1.5,
          ),
        ),
        child: const Icon(
          Icons.chevron_left_rounded,
          size: 20,
          color: AppColors.primaryDark,
        ),
      ),
    );
  }
}

class _PinNumericKeypad extends StatelessWidget {
  const _PinNumericKeypad({
    required this.onDigitPressed,
    required this.onBackspace,
    required this.onSubmit,
  });

  final ValueChanged<String> onDigitPressed;
  final VoidCallback onBackspace;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF3F7F5),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 16),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Bar atas keypad: chip "🔑 Sandi"
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Icon(
                      Icons.grid_view_rounded,
                      size: 20,
                      color: AppColors.neutralDark,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: AppSpacing.borderRadiusPill,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.vpn_key_rounded,
                          size: 15,
                          color: AppColors.neutralDark,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Sandi',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.neutralDark,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Icon(
                      Icons.mic_off_outlined,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Baris 1-2-3
            _buildRow(['1', '2', '3']),
            const SizedBox(height: 8),
            // Baris 4-5-6
            _buildRow(['4', '5', '6']),
            const SizedBox(height: 8),
            // Baris 7-8-9
            _buildRow(['7', '8', '9']),
            const SizedBox(height: 8),
            // Baris Backspace - 0 - Submit
            Row(
              children: [
                Expanded(
                  child: _KeypadActionButton(
                    icon: Icons.backspace_outlined,
                    backgroundColor: const Color(0xFFE2EFEA),
                    onTap: onBackspace,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _KeypadDigitButton(
                    digit: '0',
                    onTap: () => onDigitPressed('0'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _KeypadActionButton(
                    icon: Icons.keyboard_tab_rounded,
                    backgroundColor: const Color(0xFFE2EFEA),
                    onTap: onSubmit,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(List<String> digits) {
    return Row(
      children: [
        for (int i = 0; i < digits.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(
            child: _KeypadDigitButton(
              digit: digits[i],
              onTap: () => onDigitPressed(digits[i]),
            ),
          ),
        ],
      ],
    );
  }
}

class _KeypadDigitButton extends StatelessWidget {
  const _KeypadDigitButton({
    required this.digit,
    required this.onTap,
  });

  final String digit;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: AppSpacing.borderRadiusPill,
      child: InkWell(
        borderRadius: AppSpacing.borderRadiusPill,
        onTap: onTap,
        child: SizedBox(
          height: 50,
          child: Center(
            child: Text(
              digit,
              style: AppTextStyles.heading1.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: AppColors.neutralDark,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _KeypadActionButton extends StatelessWidget {
  const _KeypadActionButton({
    required this.icon,
    required this.backgroundColor,
    required this.onTap,
  });

  final IconData icon;
  final Color backgroundColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: AppSpacing.borderRadiusPill,
      child: InkWell(
        borderRadius: AppSpacing.borderRadiusPill,
        onTap: onTap,
        child: SizedBox(
          height: 50,
          child: Center(
            child: Icon(
              icon,
              size: 21,
              color: AppColors.neutralDark,
            ),
          ),
        ),
      ),
    );
  }
}

