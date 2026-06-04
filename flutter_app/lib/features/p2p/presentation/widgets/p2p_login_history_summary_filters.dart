part of '../pages/p2p_login_history_page.dart';

class _LoginStats extends StatelessWidget {
  const _LoginStats({required this.snapshot});

  final P2PLoginHistorySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Row(
      key: P2PLoginHistoryPage.statsKey,
      children: [
        Expanded(
          child: _StatTile(
            icon: Icons.shield_outlined,
            value: '${snapshot.events.length}',
            label: 'Tổng số',
            color: AppModuleAccents.p2p,
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: _StatTile(
            icon: Icons.check_circle_outline_rounded,
            value: '${snapshot.successCount}',
            label: 'Thành công',
            color: AppColors.buy,
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: _StatTile(
            icon: Icons.warning_amber_rounded,
            value: '${snapshot.riskEventCount}',
            label: 'Đáng ngờ',
            color: AppColors.warn,
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x3,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: AppSpacing.inputHeight,
            height: AppSpacing.inputHeight,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .12),
              borderRadius: AppRadii.lgRadius,
            ),
            child: Icon(icon, color: color, size: AppSpacing.iconMd),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            value,
            style: AppTextStyles.baseMedium.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _FilterTabs extends StatelessWidget {
  const _FilterTabs({required this.activeFilter, required this.onChanged});

  final String activeFilter;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    const filters = [
      ('all', 'Tất cả'),
      ('success', 'Thành công'),
      ('suspicious', 'Đáng ngờ'),
    ];

    return Wrap(
      key: P2PLoginHistoryPage.filtersKey,
      spacing: AppSpacing.x2,
      runSpacing: AppSpacing.x2,
      children: [
        for (final filter in filters)
          _FilterPill(
            key: P2PLoginHistoryPage.filterKey(filter.$1),
            label: filter.$2,
            selected: activeFilter == filter.$1,
            onTap: () => onChanged(filter.$1),
          ),
      ],
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppModuleAccents.p2p : AppColors.surface2,
      borderRadius: AppRadii.xlRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.xlRadius,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x4,
            vertical: AppSpacing.x2,
          ),
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: selected ? AppColors.onAccent : AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _RiskWarning extends StatelessWidget {
  const _RiskWarning({required this.snapshot});

  final P2PLoginHistorySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      key: P2PLoginHistoryPage.warningKey,
      decoration: BoxDecoration(
        color: AppColors.warn10,
        borderRadius: AppRadii.lgRadius,
        border: Border.all(color: AppColors.warningBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.warn,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Phát hiện ${snapshot.riskEventCount} đăng nhập đáng ngờ',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.warn,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    snapshot.warningBody,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text2,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
