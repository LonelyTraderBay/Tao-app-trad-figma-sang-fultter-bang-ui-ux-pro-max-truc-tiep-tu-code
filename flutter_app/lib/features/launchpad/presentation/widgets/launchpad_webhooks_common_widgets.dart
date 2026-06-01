part of '../pages/launchpad_webhooks_page.dart';

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color, this.icon});

  final String label;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, color: color, size: 9),
              const SizedBox(width: 3),
            ],
            Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
                fontSize: 9,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniPill extends StatelessWidget {
  const _MiniPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontSize: 9,
            height: 1,
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
    this.size = 22,
  });

  final bool active;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      visualDensity: VisualDensity.compact,
      constraints: BoxConstraints.tightFor(width: size, height: size),
      padding: EdgeInsets.zero,
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
      padding: const EdgeInsets.all(AppSpacing.x6),
      child: Column(
        children: [
          const Icon(Icons.hub_outlined, color: AppColors.text3, size: 32),
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
