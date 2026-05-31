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
          width: 4,
          height: 14,
          decoration: BoxDecoration(
            color: walletManagerPrimary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textMutedDense,
            fontSize: 12,
            fontWeight: FontWeight.w800,
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
        width: 14,
        height: 14,
        child: Icon(icon, color: color, size: 11),
      ),
    );
  }
}

class WalletManagerDefaultBadge extends StatelessWidget {
  const WalletManagerDefaultBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 17,
      padding: const EdgeInsets.symmetric(horizontal: 7),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: walletManagerGreen.withValues(alpha: .13),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        'DEFAULT',
        style: AppTextStyles.micro.copyWith(
          color: walletManagerGreen,
          fontSize: 9,
          fontWeight: FontWeight.w900,
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
      height: 18,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.overlaySubtle,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        symbol,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.textSoftBlue,
          fontSize: 9,
          fontWeight: FontWeight.w900,
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
      height: 19,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .15),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w900,
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
            const Icon(Icons.add_rounded, color: AppColors.onAccent, size: 18),
            const SizedBox(width: 8),
            Text(
              'Add Wallet',
              style: AppTextStyles.baseMedium.copyWith(
                color: AppColors.onAccent,
                fontSize: 14,
                fontWeight: FontWeight.w900,
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
      constraints: const BoxConstraints(minHeight: 58),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: walletManagerPrimary.withValues(alpha: .08),
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: walletManagerPrimary.withValues(alpha: .20)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 1),
            child: Icon(
              Icons.shield_outlined,
              color: walletManagerPrimary,
              size: 14,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Addresses are masked by default. Click eye icon to reveal. '
              'Never share your private keys.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontSize: 11,
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
