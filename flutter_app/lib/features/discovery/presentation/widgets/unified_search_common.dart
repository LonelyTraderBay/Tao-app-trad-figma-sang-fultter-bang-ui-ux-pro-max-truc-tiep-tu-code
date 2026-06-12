part of '../pages/unified_search_page.dart';

class _BoundaryDisclosure extends StatelessWidget {
  const _BoundaryDisclosure({required this.notes});

  final String notes;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: UnifiedSearchPage.disclosureKey,
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Text(
        'Lưu ý: Prediction Markets sử dụng USDT thật. Arena Challenges chỉ dùng Arena Points (không liên quan ví). Đây là trang khám phá, không phải trang giao dịch.\n$notes',
        textAlign: TextAlign.center,
        style: AppTextStyles.micro.copyWith(color: AppColors.text3),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.icon,
    required this.iconColor,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 15),
        const SizedBox(width: AppSpacing.x2),
        Text(
          label,
          style: AppTextStyles.body.copyWith(
            color: AppColors.text1,
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
    return Container(
      width: 42,
      height: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .13),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Icon(icon, color: color, size: 19),
    );
  }
}

class _ModuleBadge extends StatelessWidget {
  const _ModuleBadge({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        border: Border.all(color: color.withValues(alpha: .24)),
        borderRadius: AppRadii.smRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 10),
          const SizedBox(width: AppSpacing.x1),
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x1,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.smRadius,
      ),
      child: Text(
        '$count',
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _InlineCta extends StatelessWidget {
  const _InlineCta({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(width: AppSpacing.x1),
        Icon(Icons.arrow_forward_rounded, color: color, size: 11),
      ],
    );
  }
}

class _InitialsAvatar extends StatelessWidget {
  const _InitialsAvatar({required this.initials});

  final String initials;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.ctaHeight,
      height: AppSpacing.ctaHeight,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppModuleAccents.arena.withValues(alpha: .12),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Text(
        initials,
        style: AppTextStyles.body.copyWith(
          color: AppModuleAccents.arena,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

IconData _iconForKey(String key) {
  return switch (key) {
    'coin' => Icons.currency_exchange_rounded,
    'price' => Icons.swap_vert_rounded,
    'bank' => Icons.account_balance_rounded,
    'arena' => Icons.bolt_rounded,
    'fire' => Icons.local_fire_department_rounded,
    'news' => Icons.article_rounded,
    'prediction' => Icons.track_changes_rounded,
    'topic' => Icons.auto_awesome_rounded,
    _ => Icons.search_rounded,
  };
}

Color _accentForKey(String key) {
  return switch (key) {
    'bank' || 'topic' => AppColors.buy,
    'arena' || 'fire' => AppModuleAccents.arena,
    'prediction' || 'coin' || 'price' => AppModuleAccents.predictions,
    'news' => AppColors.text2,
    _ => AppColors.primary,
  };
}

Color _accentForModule(DiscoveryModuleKind kind) {
  return switch (kind) {
    DiscoveryModuleKind.prediction => AppModuleAccents.predictions,
    DiscoveryModuleKind.arena => AppModuleAccents.arena,
    DiscoveryModuleKind.topic => AppColors.buy,
  };
}
