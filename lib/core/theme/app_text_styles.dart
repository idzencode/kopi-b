import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Sistem Tipografi "Kopi B" menggunakan font Plus Jakarta Sans
/// Acuan: DESIGN_SYSTEM.md Bagian 3
abstract final class AppTextStyles {
  /// Display / Hero: 28px - 32px / Bold (700)
  /// Penggunaan: Welcome headline, banner promo besar, angka poin B-Beans utama
  static TextStyle get display => GoogleFonts.plusJakartaSans(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: -0.5,
        color: AppColors.neutralDark,
      );

  /// Heading 1: 20px - 22px / SemiBold (600)
  /// Penggunaan: Judul section & nama produk detail
  static TextStyle get heading1 => GoogleFonts.plusJakartaSans(
        fontSize: 21,
        fontWeight: FontWeight.w600,
        height: 1.3,
        letterSpacing: -0.3,
        color: AppColors.neutralDark,
      );

  /// Heading 2: 16px - 18px / SemiBold (600)
  /// Penggunaan: Nama item menu & outlet store
  static TextStyle get heading2 => GoogleFonts.plusJakartaSans(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        height: 1.35,
        letterSpacing: -0.2,
        color: AppColors.neutralDark,
      );

  /// Body Text: 14px / Regular (400)
  /// Penggunaan: Deskripsi rasa, subjudul banner, review
  static TextStyle get body => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
        letterSpacing: 0.0,
        color: AppColors.primaryDark,
      );

  /// Body Medium / Button Label: 14px / Medium (500)
  /// Penggunaan: Label tombol, input aktif, tab filter
  static TextStyle get bodyMedium => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.4,
        letterSpacing: 0.1,
        color: AppColors.neutralDark,
      );

  /// Caption / Meta: 11px - 12px / Medium (500)
  /// Penggunaan: Label kategori, badge promo, harga diskon, info kalori
  static TextStyle get caption => GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.35,
        letterSpacing: 0.2,
        color: AppColors.textSecondary,
      );
}

