import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';

enum VitBannerVariant { info, warning, error }

class VitOfflineBanner extends StatelessWidget {
  const VitOfflineBanner({
    super.key,
    this.variant = VitBannerVariant.warning,
    this.message = 'Offline. Showing latest cached data.',
    this.detail,
    this.reconnecting = false,
  });

  final VitBannerVariant variant;
  final String message;
  final String? detail;
  final bool reconnecting;

  @override
  Widget build(BuildContext context) {
    return VitBanner(
      variant: reconnecting ? VitBannerVariant.info : variant,
      icon: reconnecting ? Icons.wifi_rounded : Icons.wifi_off_rounded,
      message: reconnecting ? 'Reconnecting...' : message,
      detail: reconnecting ? 'Retrying automatically.' : detail,
    );
  }
}

class VitBanner extends StatelessWidget {
  const VitBanner({
    super.key,
    required this.variant,
    required this.message,
    this.icon,
    this.detail,
  });

  final VitBannerVariant variant;
  final String message;
  final IconData? icon;
  final String? detail;

  @override
  Widget build(BuildContext context) {
    final palette = switch (variant) {
      VitBannerVariant.info => _BannerPalette.info,
      VitBannerVariant.warning => _BannerPalette.warning,
      VitBannerVariant.error => _BannerPalette.error,
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: palette.background,
        border: Border.all(color: palette.border),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: detail == null
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, color: palette.foreground, size: 16),
            const SizedBox(width: AppSpacing.x3),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message,
                  style: AppTextStyles.caption.copyWith(
                    color: palette.foreground,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
                if (detail != null) ...[
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    detail!,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BannerPalette {
  const _BannerPalette({
    required this.background,
    required this.foreground,
    required this.border,
  });

  static const info = _BannerPalette(
    background: AppColors.primary08,
    foreground: AppColors.primary,
    border: AppColors.primary20,
  );

  static const warning = _BannerPalette(
    background: AppColors.warn08,
    foreground: AppColors.warn,
    border: AppColors.warningBorder,
  );

  static const error = _BannerPalette(
    background: AppColors.sell10,
    foreground: AppColors.sell,
    border: AppColors.sell20,
  );

  final Color background;
  final Color foreground;
  final Color border;
}
