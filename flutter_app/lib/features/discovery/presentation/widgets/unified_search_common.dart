part of '../pages/unified_search_page.dart';

class _UnifiedSearchBody extends StatelessWidget {
  const _UnifiedSearchBody({
    required this.snapshot,
    required this.onQuerySelected,
    required this.onRetry,
  });

  final UnifiedSearchSnapshot snapshot;
  final ValueChanged<String> onQuerySelected;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return switch (snapshot.currentState) {
      DiscoveryScreenState.loading => const VitSkeletonList(
        key: UnifiedSearchPage.loadingKey,
        rows: 4,
      ),
      DiscoveryScreenState.error => VitErrorState(
        key: UnifiedSearchPage.errorKey,
        title: 'Không tải được dữ liệu khám phá',
        message: snapshot.staleMessage,
        actionLabel: 'Thử lại',
        onAction: onRetry,
      ),
      DiscoveryScreenState.empty when !snapshot.hasCachedContent =>
        const VitEmptyState(
          icon: Icons.explore_rounded,
          title: 'Chưa có gợi ý khám phá',
          message: 'Hãy thử lại sau hoặc tìm kiếm trực tiếp.',
        ),
      _ when snapshot.hasQuery => _ResultsState(snapshot: snapshot),
      _ => _NoQueryState(
        snapshot: snapshot,
        onQuerySelected: onQuerySelected,
      ),
    };
  }
}

class _BoundaryDisclosure extends StatelessWidget {
  const _BoundaryDisclosure({required this.notes});

  final String notes;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: UnifiedSearchPage.disclosureKey,
      variant: VitCardVariant.inner,
      padding: AppSpacing.discoveryCardPadding,
      child: Text(
        'Lưu ý: Prediction Markets sử dụng USDT thật. Arena Challenges chỉ dùng Arena Points (không liên quan ví). Đây là trang khám phá, không phải trang giao dịch.\n$notes',
        textAlign: TextAlign.center,
        style: AppTextStyles.micro.copyWith(color: AppColors.text3),
      ),
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
      width: AppSpacing.discoveryAccentIconBox,
      height: AppSpacing.discoveryAccentIconBox,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: color.withValues(alpha: .13),
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadii.cardRadius,
          ),
        ),
        child: Center(child: Icon(icon, color: color, size: 19)),
      ),
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
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: .12),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: color.withValues(alpha: .24)),
          borderRadius: AppRadii.smRadius,
        ),
      ),
      child: Padding(
        padding: AppSpacing.discoveryBadgePadding,
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
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.surface2,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
      ),
      child: Padding(
        padding: AppSpacing.discoveryBadgePadding,
        child: Text(
          '$count',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontWeight: AppTextStyles.bold,
          ),
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
    return SizedBox(
      width: AppSpacing.ctaHeight,
      height: AppSpacing.ctaHeight,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: AppModuleAccents.arena.withValues(alpha: .12),
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadii.cardRadius,
          ),
        ),
        child: Center(
          child: Text(
            initials,
            style: AppTextStyles.body.copyWith(
              color: AppModuleAccents.arena,
              fontWeight: AppTextStyles.bold,
            ),
          ),
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
