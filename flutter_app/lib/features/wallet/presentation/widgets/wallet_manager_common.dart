import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';

const walletManagerBackground = AppColors.bg;
const walletManagerPanel = AppColors.surface;
const walletManagerPanel2 = AppColors.surface2;
const walletManagerBorder = AppColors.overlayStroke;
const walletManagerPrimary = AppColors.primary;
const walletManagerGreen = AppColors.buy;
const walletManagerRed = AppColors.sell;

const walletManagerTabAll = 'T\u1EA5t c\u1EA3';
const walletManagerTabGroups = 'Nh\u00F3m';
const walletManagerTabActivity = 'Ho\u1EA1t \u0111\u1ED9ng';

class WalletManagerSectionLabel extends StatelessWidget {
  const WalletManagerSectionLabel({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: AppSpacing.walletManagerSectionMarkerWidth,
          height: AppSpacing.walletManagerSectionMarkerHeight,
          decoration: BoxDecoration(
            color: walletManagerPrimary,
            borderRadius: AppRadii.hairlineRadius,
          ),
        ),
        const SizedBox(width: AppSpacing.walletManagerSectionLabelGap),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textMutedDense,
            fontWeight: AppTextStyles.medium,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class WalletManagerTinyIconButton extends StatelessWidget {
  const WalletManagerTinyIconButton({
    super.key,
    required this.buttonKey,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final Key buttonKey;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: buttonKey,
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: AppSpacing.walletManagerTinyButton,
        height: AppSpacing.walletManagerTinyButton,
        child: Icon(icon, color: color, size: AppSpacing.walletManagerTinyIcon),
      ),
    );
  }
}

class WalletManagerDefaultBadge extends StatelessWidget {
  const WalletManagerDefaultBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSpacing.walletManagerDefaultBadgeHeight,
      padding: AppSpacing.walletManagerCompactBadgePadding,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: walletManagerGreen.withValues(alpha: .13),
        borderRadius: AppRadii.walletHistoryStatusBadgeRadius,
      ),
      child: Text(
        'DEFAULT',
        style: AppTextStyles.micro.copyWith(
          color: walletManagerGreen,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class WalletManagerAssetChip extends StatelessWidget {
  const WalletManagerAssetChip({super.key, required this.symbol});

  final String symbol;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSpacing.walletManagerAssetChipHeight,
      padding: AppSpacing.walletManagerBadgePadding,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.overlaySubtle,
        borderRadius: AppRadii.badgeRadius,
      ),
      child: Text(
        symbol,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.textSoftBlue,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class WalletManagerTypeBadge extends StatelessWidget {
  const WalletManagerTypeBadge({
    super.key,
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSpacing.walletManagerTypeBadgeHeight,
      padding: AppSpacing.walletManagerBadgePadding,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .15),
        borderRadius: AppRadii.pillRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class WalletManagerAddWalletButton extends StatelessWidget {
  const WalletManagerAddWalletButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: const Key('sc148_multi_manager_add_wallet'),
      onTap: () {},
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: AppSpacing.inputHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: walletManagerPrimary,
          borderRadius: AppRadii.inputRadius,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.add_rounded,
              color: AppColors.onAccent,
              size: AppSpacing.walletManagerButtonIcon,
            ),
            const SizedBox(width: AppSpacing.walletManagerButtonIconGap),
            Text(
              'Add Wallet',
              style: AppTextStyles.baseMedium.copyWith(
                color: AppColors.onAccent,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WalletManagerSecurityNotice extends StatelessWidget {
  const WalletManagerSecurityNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('sc148_multi_manager_security_note'),
      constraints: const BoxConstraints(
        minHeight: AppSpacing.walletManagerSecurityMinHeight,
      ),
      padding: AppSpacing.walletManagerSecurityPadding,
      decoration: BoxDecoration(
        color: walletManagerPrimary.withValues(alpha: .08),
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: walletManagerPrimary.withValues(alpha: .20)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(
              top: AppSpacing.walletManagerSecurityIconTop,
            ),
            child: Icon(
              Icons.shield_outlined,
              color: walletManagerPrimary,
              size: AppSpacing.walletManagerSecurityIcon,
            ),
          ),
          const SizedBox(width: AppSpacing.walletManagerSecurityGap),
          Expanded(
            child: Text(
              'Addresses are masked by default. Click eye icon to reveal. '
              'Never share your private keys.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                height: 1.48,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String formatWalletManagerUsd(double value, {int decimals = 2}) {
  return '\$${_withCommas(value.toStringAsFixed(decimals))}';
}

String formatWalletManagerSignedUsd(double value, {int decimals = 2}) {
  final sign = value >= 0 ? '+' : '-';
  return '$sign\$${_withCommas(value.abs().toStringAsFixed(decimals))}';
}

String formatWalletManagerPct(double value, {int decimals = 2}) {
  final sign = value >= 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(decimals)}%';
}

String _withCommas(String value) {
  final parts = value.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final remaining = whole.length - i;
    buffer.write(whole[i]);
    if (remaining > 1 && remaining % 3 == 1) {
      buffer.write(',');
    }
  }
  if (parts.length > 1 && int.tryParse(parts[1]) != 0) {
    buffer.write('.');
    buffer.write(parts[1]);
  }
  return buffer.toString();
}
