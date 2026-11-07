import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Search Field Kopi B sesuai kanan atas UI Kit Board
class KopiSearchBar extends StatelessWidget {
  const KopiSearchBar({
    super.key,
    this.controller,
    this.hintText = 'Cari kopi, oat series, atau pastry...',
    this.onChanged,
    this.onClear,
  });

  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: AppTextStyles.body.copyWith(color: AppColors.neutralDark),
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.textSecondary,
            size: 20,
          ),
          suffixIcon: controller != null && controller!.text.isNotEmpty
              ? IconButton(
                  onPressed: onClear,
                  icon: const Icon(
                    Icons.close_rounded,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                )
              : null,
          filled: true,
          fillColor: AppColors.surfaceMintTrack,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: 10,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppSpacing.borderRadiusMd,
            borderSide: const BorderSide(
              color: AppColors.sageSlate,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppSpacing.borderRadiusMd,
            borderSide: const BorderSide(
              color: AppColors.primary,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}

