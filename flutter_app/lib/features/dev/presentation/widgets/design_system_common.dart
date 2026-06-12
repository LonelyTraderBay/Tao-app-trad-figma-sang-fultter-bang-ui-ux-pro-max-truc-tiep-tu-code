import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class DesignSystemCaption extends StatelessWidget {
  const DesignSystemCaption(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: AppTextStyles.micro.copyWith(
        color: AppColors.text3,
        fontWeight: AppTextStyles.medium,
      ),
    );
  }
}

class DesignSystemPositiveBadge extends StatelessWidget {
  const DesignSystemPositiveBadge({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.buy15,
        borderRadius: AppRadii.smRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.buy,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class DesignSystemAccentSample extends StatelessWidget {
  const DesignSystemAccentSample({
    super.key,
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.x3),
      child: Row(
        children: [
          Container(
            width: AppSpacing.x1,
            height: AppSpacing.iconSm,
            decoration: BoxDecoration(
              color: color,
              borderRadius: AppRadii.xsRadius,
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.medium,
            ),
          ),
        ],
      ),
    );
  }
}

class DesignSystemDivider extends StatelessWidget {
  const DesignSystemDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: AppSpacing.devDividerHeight,
      color: AppColors.divider,
    );
  }
}

VitCtaButtonVariant designSystemVariantFromString(String variant) {
  return switch (variant) {
    'success' => VitCtaButtonVariant.success,
    'danger' => VitCtaButtonVariant.danger,
    'ghost' => VitCtaButtonVariant.ghost,
    _ => VitCtaButtonVariant.primary,
  };
}

Widget? designSystemLeadingForCta(String id) {
  return switch (id) {
    'success' => const Icon(Icons.check_circle_outline_rounded),
    'danger' => const Icon(Icons.warning_amber_rounded),
    'ghost' => const Icon(Icons.account_balance_wallet_outlined),
    _ => null,
  };
}

Widget? designSystemPrefixForInput(String id) {
  return switch (id) {
    'password' => const Icon(Icons.lock_outline_rounded),
    'search' => const Icon(Icons.search_rounded),
    _ => const Icon(Icons.mail_outline_rounded),
  };
}

Widget? designSystemSuffixForInput(String id) {
  return switch (id) {
    'password' => const Icon(Icons.visibility_outlined, color: AppColors.text3),
    _ => const Icon(Icons.check_circle_outline_rounded, color: AppColors.buy),
  };
}

Color designSystemColorForSwatch(String id) {
  return switch (id) {
    'success' || 'buy' => AppColors.buy,
    'danger' || 'sell' => AppColors.sell,
    'warning' => AppColors.warn,
    'accent' => AppColors.accent,
    'bg' => AppColors.bg,
    'card' => AppColors.cardBg,
    'input' => AppColors.surface2,
    'border' => AppColors.borderSolid,
    'text' => AppColors.text1,
    'label' => AppColors.text2,
    'muted' => AppColors.text3,
    _ => AppColors.primary,
  };
}
