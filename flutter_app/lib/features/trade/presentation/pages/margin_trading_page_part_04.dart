part of 'margin_trading_page.dart';

class _Panel extends StatelessWidget {
  const _Panel({required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: padding,
      density: padding == null ? VitDensity.compact : null,
      child: child,
    );
  }
}

class _MiniBadge extends StatelessWidget {
  const _MiniBadge({required this.label, required this.color});

  final String label;
  final Color color;

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
      size: VitStatusPillSize.sm,
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
            radius: VitCardRadius.large,
            child: VitPageContent(
              padding: VitContentPadding.none,
              density: VitDensity.compact,
              children: [
                Text('Margin trading', style: AppTextStyles.baseMedium),
                Text(
                  text,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
                VitCtaButton(
                  density: VitDensity.compact,
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

String _signedMoney(double value) {
  final sign = value >= 0 ? '+' : '-';
  return '$sign${_formatMoney(value.abs())}';
}

String _formatPrice(double value) => formatTradePrice(value);
