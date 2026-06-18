part of 'p2p_home_page.dart';

class _HubStat extends StatelessWidget {
  const _HubStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.caption,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final String caption;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: AppSpacing.p2pHomeTinyIcon),
            const SizedBox(width: AppSpacing.x1),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
        Text(
          caption,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _AccentIcon extends StatelessWidget {
  const _AccentIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSpacing.iconLg,
      height: AppSpacing.iconLg,
      child: Material(
        color: color.withValues(alpha: .16),
        borderRadius: AppRadii.mdRadius,
        child: Icon(icon, color: color, size: AppSpacing.p2pHomeAccentIcon),
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSpacing.buttonCompact,
      height: AppSpacing.buttonCompact,
      child: Material(
        color: color.withValues(alpha: .18),
        borderRadius: AppRadii.mdRadius,
        child: Icon(icon, color: color, size: AppSpacing.p2pHomeActionIcon),
      ),
    );
  }
}

class _SmallIconBox extends StatelessWidget {
  const _SmallIconBox({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSpacing.x5,
      height: AppSpacing.x5,
      child: Material(
        color: color.withValues(alpha: .14),
        borderRadius: AppRadii.xsRadius,
        child: Icon(icon, color: color, size: AppSpacing.p2pHomeSmallIcon),
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.p2pHomeDividerMargin,
      child: const SizedBox(
        width: AppSpacing.dividerHairline,
        height: AppSpacing.x7,
        child: ColoredBox(color: AppColors.divider),
      ),
    );
  }
}

class _LivePill extends StatelessWidget {
  const _LivePill();

  @override
  Widget build(BuildContext context) {
    return const VitAccentPill(label: 'Live', accentColor: AppColors.buy);
  }
}

class _EscrowPill extends StatelessWidget {
  const _EscrowPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.buy10,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadii.inputRadius,
        side: const BorderSide(color: AppColors.buy20),
      ),
      child: Padding(
        padding: AppSpacing.p2pHomePillPadding,
        child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppColors.buy,
            size: AppSpacing.p2pHomeTinyIcon,
          ),
          const SizedBox(width: AppSpacing.x1),
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.buy,
              fontWeight: AppTextStyles.bold,
              height: AppSpacing.p2pHomeTextTightLineHeight,
            ),
          ),
        ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, this.color = AppColors.warn});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitAccentPill(label: label, accentColor: color);
  }
}

class _PaymentPill extends StatelessWidget {
  const _PaymentPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface2,
      borderRadius: AppRadii.xsRadius,
      child: Padding(
        padding: AppSpacing.p2pHomeSmallPillPadding,
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
            height: AppSpacing.p2pHomeTextTightLineHeight,
          ),
        ),
      ),
    );
  }
}

String _formatVnd(num value) {
  final whole = value.round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    if (i > 0 && (whole.length - i) % 3 == 0) buffer.write('.');
    buffer.write(whole[i]);
  }
  return buffer.toString();
}

String _formatInt(int value) => _formatVnd(value);

String _compactVnd(int value) {
  if (value >= 1000000000) {
    return '₫${(value / 1000000000).toStringAsFixed(2)}B';
  }
  if (value >= 1000000) return '₫${(value / 1000000).toStringAsFixed(2)}M';
  return '₫${_formatVnd(value)}';
}

String _formatAmount(double value) {
  if (value == value.roundToDouble()) {
    return _formatVnd(value.round());
  }
  return value.toStringAsFixed(4);
}
