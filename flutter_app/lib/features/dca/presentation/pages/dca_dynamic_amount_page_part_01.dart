part of 'dca_dynamic_amount_page.dart';

class _DynamicHero extends StatelessWidget {
  const _DynamicHero({
    required this.option,
    required this.adjustment,
    required this.onChangeStrategy,
  });

  final DcaDynamicStrategyOption option;
  final DcaDynamicAdjustment adjustment;
  final VoidCallback onChangeStrategy;

  @override
  Widget build(BuildContext context) {
    final accent = _accentColor(option.accent);
    final statusColor = _actionColor(adjustment.action);
    final paused =
        adjustment.action == DcaDynamicAdjustmentAction.paused ||
        adjustment.action == DcaDynamicAdjustmentAction.skipped;

    return VitCard(
      variant: VitCardVariant.hero,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Wrap(
                  spacing: AppSpacing.x2,
                  runSpacing: AppSpacing.x2,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _TinyPill(
                      label: option.title,
                      icon: _iconFor(option.icon),
                      color: accent,
                      filled: true,
                    ),
                    GestureDetector(
                      onTap: onChangeStrategy,
                      child: const _TinyPill(
                        label: 'Đổi',
                        icon: Icons.swap_horiz_rounded,
                        color: AppColors.text2,
                      ),
                    ),
                  ],
                ),
              ),
              _TinyPill(
                label: _actionLabel(adjustment.action),
                icon: _actionIcon(adjustment.action),
                color: statusColor,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            'Lần mua tiếp theo',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.portfolioTextMuted,
              height: 1.2,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          if (paused)
            Row(
              children: [
                Icon(
                  _actionIcon(adjustment.action),
                  color: statusColor,
                  size: AppSpacing.iconMd,
                ),
                const SizedBox(width: AppSpacing.x3),
                Text(
                  adjustment.action == DcaDynamicAdjustmentAction.skipped
                      ? 'Bỏ qua lần này'
                      : 'Tạm dừng',
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: statusColor,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            )
          else
            Wrap(
              spacing: AppSpacing.x4,
              crossAxisAlignment: WrapCrossAlignment.end,
              children: [
                Text(
                  _formatVnd(adjustment.adjustedAmountVnd),
                  style: AppTextStyles.heroNumber.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                if (adjustment.multiplier != 1)
                  Text(
                    _formatVnd(adjustment.originalAmountVnd),
                    style: AppTextStyles.base.copyWith(
                      color: AppColors.portfolioTextMuted,
                      decoration: TextDecoration.lineThrough,
                      decorationColor: AppColors.portfolioTextMuted,
                    ),
                  ),
              ],
            ),
          const SizedBox(height: AppSpacing.x5),
          VitCard(
            variant: VitCardVariant.inner,
            padding: const EdgeInsets.all(AppSpacing.x4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (adjustment.multiplier != 1 && !paused) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.bolt_rounded,
                            color: statusColor,
                            size: AppSpacing.iconSm,
                          ),
                          const SizedBox(width: AppSpacing.x2),
                          Text(
                            'Hệ số điều chỉnh',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.portfolioTextMuted,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'x${adjustment.multiplier.toStringAsFixed(2)}',
                        style: AppTextStyles.baseMedium.copyWith(
                          color: statusColor,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x3),
                ],
                Text(
                  adjustment.reason,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.portfolioTextDim,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TinyPill extends StatelessWidget {
  const _TinyPill({
    required this.label,
    required this.icon,
    required this.color,
    this.filled = false,
  });

  final String label;
  final IconData icon;
  final Color color;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: filled ? AppColors.portfolioBtnGhost : AppColors.hoverBg,
        borderRadius: AppRadii.inputRadius,
        border: Border.all(
          color: filled ? AppColors.portfolioBtnGhostBorder : AppColors.border,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x3,
          vertical: AppSpacing.x2,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: AppSpacing.iconSm),
            const SizedBox(width: AppSpacing.x2),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: filled ? AppColors.portfolioTextDim : color,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StrategyStrip extends StatelessWidget {
  const _StrategyStrip({
    required this.strategies,
    required this.activeStrategy,
    required this.onChanged,
  });

  final List<DcaDynamicStrategyOption> strategies;
  final DcaDynamicStrategy activeStrategy;
  final ValueChanged<DcaDynamicStrategy> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CHIẾN LƯỢC',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.sectionLabel,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x3),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              for (final option in strategies) ...[
                _StrategyChip(
                  option: option,
                  selected: option.strategy == activeStrategy,
                  onTap: () => onChanged(option.strategy),
                ),
                const SizedBox(width: AppSpacing.x3),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _StrategyChip extends StatelessWidget {
  const _StrategyChip({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final DcaDynamicStrategyOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = _accentColor(option.accent);

    return GestureDetector(
      key: DCADynamicAmount.strategyKey(option.strategy),
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: selected ? _accentSoft(option.accent) : AppColors.surface,
          borderRadius: AppRadii.inputRadius,
          border: Border.all(color: selected ? accent : AppColors.cardBorder),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x4,
            vertical: AppSpacing.x3,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _iconFor(option.icon),
                color: selected ? accent : AppColors.text3,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                option.title,
                style: AppTextStyles.caption.copyWith(
                  color: selected ? accent : AppColors.text2,
                  fontWeight: selected
                      ? AppTextStyles.bold
                      : AppTextStyles.medium,
                ),
              ),
              if (selected) ...[
                const SizedBox(width: AppSpacing.x2),
                Container(
                  width: AppSpacing.x2,
                  height: AppSpacing.x2,
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: AppRadii.deviceRadius,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StrategyVisualization extends StatelessWidget {
  const _StrategyVisualization({
    required this.strategy,
    required this.option,
    required this.volatilityHistory,
  });

  final DcaDynamicStrategy strategy;
  final DcaDynamicStrategyOption option;
  final List<DcaVolatilitySnapshot> volatilityHistory;

  @override
  Widget build(BuildContext context) {
    if (strategy != DcaDynamicStrategy.volatility) {
      return _GenericStrategyCard(option: option);
    }

    return VitCard(
      clip: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.x5,
              AppSpacing.x5,
              AppSpacing.x5,
              AppSpacing.x3,
            ),
            child: _SectionHeader(
              icon: Icons.show_chart_rounded,
              title: 'Biến động & Hệ số',
              subtitle: '30 ngày gần nhất',
              color: AppColors.accent,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.x3,
              0,
              AppSpacing.x3,
              AppSpacing.x2,
            ),
            child: SizedBox(
              height: AppSpacing.buttonHero * 2 + AppSpacing.x6,
              child: CustomPaint(
                painter: _VolatilityChartPainter(points: volatilityHistory),
                child: const SizedBox.expand(),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.x5,
              0,
              AppSpacing.x5,
              AppSpacing.x4,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Wrap(
                  spacing: AppSpacing.x4,
                  children: [
                    _LegendItem(color: AppColors.accent, label: 'Volatility'),
                    _LegendItem(color: AppColors.buy, label: 'Hệ số'),
                  ],
                ),
                Wrap(
                  spacing: AppSpacing.x3,
                  children: [
                    _LegendItem(color: AppColors.sell, label: 'High'),
                    _LegendItem(color: AppColors.primary, label: 'Low'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GenericStrategyCard extends StatelessWidget {
  const _GenericStrategyCard({required this.option});

  final DcaDynamicStrategyOption option;

  @override
  Widget build(BuildContext context) {
    final accent = _accentColor(option.accent);

    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            icon: _iconFor(option.icon),
            title: option.title,
            subtitle: option.subtitle,
            color: accent,
          ),
          const SizedBox(height: AppSpacing.x5),
          DecoratedBox(
            decoration: BoxDecoration(
              color: _accentSoft(option.accent),
              borderRadius: AppRadii.cardRadius,
              border: Border.all(color: accent.withValues(alpha: .24)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Text(
                option.description,
                style: AppTextStyles.base.copyWith(
                  color: AppColors.text2,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
