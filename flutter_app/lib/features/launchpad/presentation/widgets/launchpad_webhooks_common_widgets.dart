part of '../pages/launchpad_webhooks_page.dart';

class _MiniPill extends StatelessWidget {
  const _MiniPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: .14),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.xsRadius),
      ),
      child: Padding(
        padding: AppSpacing.launchpadCompactChipPadding,
        child: Text(
          label,
          style: AppTextStyles.chartLabelXs.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            height: _launchpadWebhooksLineHeightTight,
          ),
        ),
      ),
    );
  }
}

class _CopyButton extends StatelessWidget {
  const _CopyButton({
    super.key,
    required this.active,
    required this.onTap,
    this.size = _launchpadWebhooksCopyButtonExtent,
  });

  final bool active;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      visualDensity: VisualDensity.compact,
      constraints: BoxConstraints.tightFor(width: size, height: size),
      padding: AppSpacing.zeroInsets,
      onPressed: onTap,
      icon: Icon(
        active ? Icons.check_rounded : Icons.copy_rounded,
        color: active ? AppColors.buy : AppColors.text3,
        size: size * .55,
      ),
    );
  }
}

class _EmptySubscriptions extends StatelessWidget {
  const _EmptySubscriptions();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: _launchpadWebhooksCardPadding,
      child: Column(
        children: [
          const Icon(
            Icons.hub_outlined,
            color: AppColors.text3,
            size: _launchpadWebhooksEmptyIcon,
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            'Chua co webhook nao',
            style: AppTextStyles.body.copyWith(fontWeight: AppTextStyles.bold),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            'Tao webhook de nhan thong bao event tu contract',
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}
