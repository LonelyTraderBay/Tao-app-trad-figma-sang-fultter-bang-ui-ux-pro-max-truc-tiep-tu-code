part of 'margin_trading_page.dart';

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.zeroInsets.copyWith(
        left: AppSpacing.searchBarHorizontalPadding,
        top: AppSpacing.rowGapRegular,
        right: AppSpacing.searchBarHorizontalPadding,
        bottom: AppSpacing.rowGapRegular,
      ),
      variant: VitCardVariant.inner,
      borderColor: _marginPrimary.withValues(alpha: .28),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: _marginPrimary,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: _marginPrimary,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({
    required this.child,
    this.color = _marginCard,
    this.borderColor = AppColors.cardBorder,
    this.padding,
    this.minHeight,
  });

  final Widget child;
  final Color color;
  final Color borderColor;
  final EdgeInsetsGeometry? padding;
  final double? minHeight;

  @override
  Widget build(BuildContext context) {
    final usesCustomColor = color != _marginCard && color != _marginPanel;
    return VitCard(
      constraints: minHeight == null
          ? null
          : BoxConstraints(minHeight: minHeight!),
      padding: padding,
      variant: usesCustomColor
          ? VitCardVariant.ghost
          : color == _marginPanel
          ? VitCardVariant.inner
          : VitCardVariant.standard,
      background: usesCustomColor ? ColoredBox(color: color) : null,
      clip: usesCustomColor,
      borderColor: borderColor,
      child: child,
    );
  }
}

class _MiniBadge extends StatelessWidget {
  const _MiniBadge({
    required this.label,
    required this.color,
    this.large = false,
  });

  final String label;
  final Color color;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final status = color == _marginGreen
        ? VitStatusPillStatus.success
        : color == _marginRed
        ? VitStatusPillStatus.error
        : color == _marginAmber
        ? VitStatusPillStatus.warning
        : VitStatusPillStatus.info;
    return VitStatusPill(
      label: label,
      status: status,
      size: large ? VitStatusPillSize.md : VitStatusPillSize.sm,
    );
  }
}

class _MarginIconSurface extends StatelessWidget {
  const _MarginIconSurface({
    required this.icon,
    required this.color,
    this.size = AppSpacing.walletDepositCopyButtonHeight,
    this.iconSize = AppSpacing.walletAssetActionIconInner,
  });

  final IconData icon;
  final Color color;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      width: size,
      height: size,
      alignment: Alignment.center,
      variant: VitCardVariant.ghost,
      background: ColoredBox(color: color.withValues(alpha: .13)),
      clip: true,
      child: Icon(icon, color: color, size: iconSize),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.circle, color: color, size: AppSpacing.x2),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
        ),
      ],
    );
  }
}

class _ValueText extends StatelessWidget {
  const _ValueText(this.label, this.value, this.color);

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _NoticeSheet extends StatelessWidget {
  const _NoticeSheet({required this.text, required this.onClose});

  final String text;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ColoredBox(
        color: AppColors.modalScrim,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: VitCard(
            padding: AppSpacing.zeroInsets.copyWith(
              left: AppSpacing.contentPad,
              top: AppSpacing.contentPad,
              right: AppSpacing.contentPad,
              bottom: AppSpacing.contentPad,
            ),
            radius: VitCardRadius.lg,
            child: VitPageContent(
              padding: VitContentPadding.none,
              customGap: AppSpacing.walletAssetHeroTopGap,
              children: [
                Text('Margin trading', style: AppTextStyles.baseMedium),
                Text(
                  text,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
                VitCtaButton(
                  height: AppSpacing.searchBarCompactHeight,
                  onPressed: onClose,
                  child: const Text('Done'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _formatMoney(double value) {
  return '\$${value.toStringAsFixed(2).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',')}';
}

String _formatMoneyCompact(double value) => _formatMoney(value);

String _signedMoney(double value) {
  final sign = value >= 0 ? '+' : '-';
  return '$sign${_formatMoney(value.abs())}';
}

String _formatPriceWithDollar(double value) => '\$${_formatPrice(value)}';

String _formatPrice(double value) {
  return value
      .toStringAsFixed(2)
      .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');
}
