part of '../pages/arena_flow_map_page.dart';

class _QaChecklist extends StatelessWidget {
  const _QaChecklist({
    required this.items,
    required this.checkedIds,
    required this.onToggle,
    required this.onCheckAll,
  });

  final List<ArenaFlowQaDraft> items;
  final Set<String> checkedIds;
  final ValueChanged<String> onToggle;
  final VoidCallback onCheckAll;

  @override
  Widget build(BuildContext context) {
    final grouped = <String, List<ArenaFlowQaDraft>>{};
    for (final item in items) {
      grouped.putIfAbsent(item.category, () => []).add(item);
    }
    final percent = items.isEmpty ? 0.0 : checkedIds.length / items.length;

    return Column(
      children: [
        VitCard(
          padding: AppSpacing.arenaFlowMapCardPadding,
          borderColor: checkedIds.length == items.length
              ? AppColors.buy20
              : AppColors.cardBorder,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Tiến độ QA',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                  Text(
                    '${(percent * 100).round()}%',
                    style: AppTextStyles.baseMedium.copyWith(
                      color: checkedIds.length == items.length
                          ? AppColors.buy
                          : AppColors.primary,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x3),
              _MiniProgress(value: percent, color: AppColors.buy),
              const SizedBox(height: AppSpacing.x3),
              VitCard(
                key: ArenaFlowMapPage.checkAllKey,
                variant: VitCardVariant.inner,
                radius: VitCardRadius.sm,
                onTap: onCheckAll,
                padding: AppSpacing.arenaFlowMapInnerPadding,
                child: Center(
                  child: Text(
                    'Check tất cả',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.buy,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        for (final entry in grouped.entries) ...[
          _QaCategory(
            category: entry.key,
            items: entry.value,
            checkedIds: checkedIds,
            onToggle: onToggle,
          ),
          const SizedBox(height: AppSpacing.x4),
        ],
      ],
    );
  }
}

class _QaCategory extends StatelessWidget {
  const _QaCategory({
    required this.category,
    required this.items,
    required this.checkedIds,
    required this.onToggle,
  });

  final String category;
  final List<ArenaFlowQaDraft> items;
  final Set<String> checkedIds;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    final checked = items.where((item) => checkedIds.contains(item.id)).length;
    return Column(
      children: [
        _SectionLabel(
          title: category,
          subtitle: '$checked/${items.length}',
          color: checked == items.length ? AppColors.buy : AppColors.text3,
        ),
        const SizedBox(height: AppSpacing.x2),
        VitCard(
          clip: true,
          padding: AppSpacing.zeroInsets,
          child: Column(
            children: [
              for (final item in items) ...[
                _QaRow(
                  item: item,
                  checked: checkedIds.contains(item.id),
                  onTap: () => onToggle(item.id),
                ),
                if (item != items.last)
                  const Divider(
                    height: AppSpacing.arenaFlowMapDividerHeight,
                    color: AppColors.divider,
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _QaRow extends StatelessWidget {
  const _QaRow({
    required this.item,
    required this.checked,
    required this.onTap,
  });

  final ArenaFlowQaDraft item;
  final bool checked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        key: ArenaFlowMapPage.qaKey(item.id),
        onTap: onTap,
        child: Padding(
          padding: AppSpacing.arenaFlowMapCardPadding,
          child: Row(
            children: [
              Icon(
                checked ? Icons.check_circle_rounded : Icons.circle_outlined,
                color: checked ? AppColors.buy : AppColors.text3,
                size: AppSpacing.arenaFlowMapInlineIcon,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  item.label,
                  style: AppTextStyles.caption.copyWith(
                    color: checked ? AppColors.text1 : AppColors.text2,
                    height: AppSpacing.arenaFlowMapQaLineHeight,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FlowDisclaimer extends StatelessWidget {
  const _FlowDisclaimer({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.arenaFlowMapCardPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.accent,
            size: AppSpacing.arenaFlowMapSectionIcon,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                height: AppSpacing.arenaFlowMapQaLineHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({
    required this.title,
    required this.color,
    this.subtitle,
  });

  final String title;
  final Color color;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: AppSpacing.arenaFlowMapMarkerWidth,
          height: AppSpacing.arenaFlowMapMarkerHeight,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              color: color,
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadii.xsRadius,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.baseMedium.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FlowIcon extends StatelessWidget {
  const _FlowIcon({required this.kind});

  final ArenaFlowKind kind;

  @override
  Widget build(BuildContext context) {
    final color = _flowColor(kind);
    return SizedBox(
      width: AppSpacing.buttonCompact,
      height: AppSpacing.buttonCompact,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: color.withValues(alpha: .13),
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
        ),
        child: Center(
          child: Icon(_flowIcon(kind), color: color, size: AppSpacing.iconMd),
        ),
      ),
    );
  }
}

class _MiniProgress extends StatelessWidget {
  const _MiniProgress({required this.value, required this.color});

  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadii.xsRadius,
      child: SizedBox(
        height: AppSpacing.x3,
        child: ColoredBox(
          color: AppColors.surface3,
          child: Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: value.clamp(0.0, 1.0).toDouble(),
              child: ColoredBox(color: color),
            ),
          ),
        ),
      ),
    );
  }
}

Color _flowColor(ArenaFlowKind kind) {
  return switch (kind) {
    ArenaFlowKind.core => AppColors.primary,
    ArenaFlowKind.discovery => AppColors.primary,
    ArenaFlowKind.creator => AppColors.buy,
    ArenaFlowKind.participant => AppColors.buy,
    ArenaFlowKind.owner => AppColors.sell,
    ArenaFlowKind.points => AppColors.warn,
    ArenaFlowKind.verified => AppColors.accent,
    ArenaFlowKind.safety => AppColors.sell,
    ArenaFlowKind.neutral => AppColors.text2,
  };
}

IconData _flowIcon(ArenaFlowKind kind) {
  return switch (kind) {
    ArenaFlowKind.core => Icons.home_outlined,
    ArenaFlowKind.discovery => Icons.search_outlined,
    ArenaFlowKind.creator => Icons.auto_awesome_outlined,
    ArenaFlowKind.participant => Icons.play_arrow_outlined,
    ArenaFlowKind.owner => Icons.star_outline_rounded,
    ArenaFlowKind.points => Icons.card_giftcard_outlined,
    ArenaFlowKind.verified => Icons.verified_outlined,
    ArenaFlowKind.safety => Icons.shield_outlined,
    ArenaFlowKind.neutral => Icons.circle_outlined,
  };
}
