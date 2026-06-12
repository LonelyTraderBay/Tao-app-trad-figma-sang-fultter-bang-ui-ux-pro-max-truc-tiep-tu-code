part of 'margin_trading_page.dart';

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.fromLTRB(12, 11, 12, 11),
      variant: VitCardVariant.inner,
      borderColor: _marginPrimary.withValues(alpha: .28),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: _marginPrimary,
            size: 13,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: _marginPrimary,
                height: 1.45,
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
    return VitCard(
      constraints: minHeight == null
          ? null
          : BoxConstraints(minHeight: minHeight!),
      padding: padding,
      variant: color == _marginPanel
          ? VitCardVariant.inner
          : VitCardVariant.standard,
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

class _Bullet extends StatelessWidget {
  const _Bullet({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '•',
          style: AppTextStyles.micro.copyWith(color: color, height: 1.45),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: 1.45,
            ),
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
      child: DecoratedBox(
        decoration: const BoxDecoration(color: AppColors.modalScrim),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: VitCard(
            padding: const EdgeInsets.all(20),
            radius: VitCardRadius.lg,
            child: VitPageContent(
              padding: VitContentPadding.none,
              customGap: 12,
              children: [
                Text('Margin trading', style: AppTextStyles.baseMedium),
                Text(
                  text,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
                VitCtaButton(
                  height: 44,
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
