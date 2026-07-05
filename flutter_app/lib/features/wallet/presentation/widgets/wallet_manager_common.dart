import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

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
  const WalletManagerSectionLabel({
    super.key,
    required this.label,
    this.icon = Icons.account_balance_wallet_outlined,
  });

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return VitSectionHeader(
      title: label,
      icon: icon,
      density: VitDensity.compact,
    );
  }
}

class WalletManagerTinyIconButton extends StatelessWidget {
  const WalletManagerTinyIconButton({
    super.key,
    required this.buttonKey,
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onTap,
  });

  final Key buttonKey;
  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitIconButton(
      key: buttonKey,
      icon: icon,
      tooltip: tooltip,
      onPressed: onTap,
      size: VitIconButtonSize.sm,
      variant: color == walletManagerGreen
          ? VitIconButtonVariant.success
          : VitIconButtonVariant.transparent,
    );
  }
}

class WalletManagerDefaultBadge extends StatelessWidget {
  const WalletManagerDefaultBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return _WalletManagerCompactPill(
      height: AppSpacing.walletManagerDefaultBadgeHeight,
      label: 'DEFAULT',
      textColor: walletManagerGreen,
      backgroundColor: walletManagerGreen.withValues(alpha: .13),
      padding: AppSpacing.walletManagerCompactBadgePadding,
      borderRadius: AppRadii.walletHistoryStatusBadgeRadius,
    );
  }
}

class WalletManagerAssetChip extends StatelessWidget {
  const WalletManagerAssetChip({super.key, required this.symbol});

  final String symbol;

  @override
  Widget build(BuildContext context) {
    return _WalletManagerCompactPill(
      height: AppSpacing.walletManagerAssetChipHeight,
      label: symbol,
      textColor: AppColors.textSoftBlue,
      backgroundColor: AppColors.overlaySubtle,
      padding: AppSpacing.walletManagerBadgePadding,
      borderRadius: AppRadii.badgeRadius,
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
    return _WalletManagerCompactPill(
      height: AppSpacing.walletManagerTypeBadgeHeight,
      label: label,
      textColor: color,
      backgroundColor: color.withValues(alpha: .15),
      padding: AppSpacing.walletManagerBadgePadding,
      borderRadius: AppRadii.pillRadius,
    );
  }
}

class _WalletManagerCompactPill extends StatelessWidget {
  const _WalletManagerCompactPill({
    required this.height,
    required this.label,
    required this.textColor,
    required this.backgroundColor,
    required this.padding,
    required this.borderRadius,
  });

  final double height;
  final String label;
  final Color textColor;
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: ColoredBox(
          color: backgroundColor,
          child: Padding(
            padding: padding,
            child: Center(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(
                  color: textColor,
                  fontWeight: AppTextStyles.bold,
                  height: AppSpacing.tradeBotLineHeightTight,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class WalletManagerAddWalletButton extends StatelessWidget {
  const WalletManagerAddWalletButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: const Key('sc148_multi_manager_add_wallet'),
      onPressed: onPressed,
      height: AppSpacing.inputHeight,
      leading: const Icon(Icons.add_rounded),
      child: const Text('Thêm ví'),
    );
  }
}

class WalletManagerSecurityNotice extends StatelessWidget {
  const WalletManagerSecurityNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: const Key('sc148_multi_manager_security_note'),
      constraints: const BoxConstraints(
        minHeight: AppSpacing.walletManagerSecurityMinHeight,
      ),
      padding: AppSpacing.walletManagerSecurityPadding,
      variant: VitCardVariant.ghost,
      borderColor: walletManagerPrimary.withValues(alpha: .20),
      background: ColoredBox(
        color: walletManagerPrimary.withValues(alpha: .08),
      ),
      clip: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: walletManagerPrimary,
            size: AppSpacing.walletManagerSecurityIcon,
          ),
          const SizedBox(width: AppSpacing.walletManagerSecurityGap),
          Expanded(
            child: Text(
              'Địa chỉ được ẩn mặc định. Nhấn biểu tượng mắt để hiện. '
              'Không chia sẻ private key.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                height: AppSpacing.tradeBotLineHeightReadable,
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
