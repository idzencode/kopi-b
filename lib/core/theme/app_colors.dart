import 'package:flutter/material.dart';

/// Sistem Palet Warna "Kopi B" (#kopiyangbaik)
/// Konsep: Artisanal Botanical Coffee
/// Acuan: DESIGN_SYSTEM.md Bagian 2
abstract final class AppColors {
  // ─── Primary Colors (Brand Core) ───────────────────────────────────────────
  /// Deep Forest Green (#0D6B4C) - CTA primer, top header, active state ikon
  static const Color primary = Color(0xFF0D6B4C);

  /// Deep Evergreen (#05452E) - Sub-header gelap, pressed state, teks kontras
  static const Color primaryDark = Color(0xFF05452E);

  /// Obsidian Evergreen (#011E13) - Teks primer judul, tombol Inverted
  static const Color neutralDark = Color(0xFF011E13);

  // ─── Secondary & Accent Colors (Freshness & Highlights) ────────────────────
  /// Vibrant Mint (#28E5A7) - Badge promo, reward highlights, aksen interaktif
  static const Color secondary = Color(0xFF28E5A7);

  /// Emerald Mint (#1EB986) - Status sukses, progress bar sekunder
  static const Color secondaryDark = Color(0xFF1EB986);

  /// Soft Mint Mist (#B3FEDB) - Latar belakang badge promo, kupon, chip aktif
  static const Color softMintMist = Color(0xFFB3FEDB);

  // ─── Muted & Botanical Neutrals (Tertiary & Surfaces) ──────────────────────
  /// Sage Slate (#7CBCA4) - Border halus kartu, outlined button, ikon non-aktif
  static const Color tertiary = Color(0xFF7CBCA4);

  /// Sage Divider (#82BBAC) - Garis pembagi sekunder & border input
  static const Color sageSlate = Color(0xFF82BBAC);

  /// Muted Pine (#4A6B5D) - Teks sekunder, placeholder search, sub-label
  static const Color textSecondary = Color(0xFF4A6B5D);

  /// Soft Forest Tile (#265C4B) - Background square icon action lembut
  static const Color softForestTile = Color(0xFF265C4B);

  /// Ice Mint Container (#E2F5F2) - Card container, secondary button, search bar
  static const Color surfaceMint = Color(0xFFE2F5F2);

  /// Mint Pill Track (#D8EFE7) - Track progress bar & container nav bar
  static const Color surfaceMintTrack = Color(0xFFD8EFE7);

  /// Botanical Tint (#F4FCF9) - Background sekunder layar / section lembut
  static const Color surfaceSoft = Color(0xFFF4FCF9);

  /// Neutral White (#FFFFFF) - Background utama layar
  static const Color background = Color(0xFFFFFFFF);

  // ─── Semantic Status Colors ────────────────────────────────────────────────
  /// Crimson Berry (#C62828) - Tombol hapus/destruktif, pesan error, stok habis
  static const Color error = Color(0xFFC62828);

  /// Soft Error Surface (#FDECEA) - Background alert error
  static const Color errorSurface = Color(0xFFFDECEA);

  /// Warm Amber (#F59E0B) - Rating bintang, status menunggu pembayaran
  static const Color warning = Color(0xFFF59E0B);

  /// Soft Amber Surface (#FEF3C7) - Background badge warning
  static const Color warningSurface = Color(0xFFFEF3C7);

  /// Emerald Mint (#1EB986) - Status berhasil / Ready for Pick-up
  static const Color success = Color(0xFF1EB986);
}

