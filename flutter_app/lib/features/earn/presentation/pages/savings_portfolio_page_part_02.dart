part of 'savings_portfolio_page.dart';

class _AllocationCard extends StatelessWidget {
  const _AllocationCard({required this.positions, required this.total});

  final List<SavingsPortfolioPositionDraft> positions;
  final String total;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        children: [
          SizedBox(
            height: AppSpacing.savingsPortfolioDonutHeight,
            child: CustomPaint(
              painter: _DonutPainter(
                segments: [
                  for (final position in positions)
                    _DonutSegment(
                      value: _allocationValue(position.allocationLabel),
                      color: _assetColor(position.asset),
                    ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Tổng',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    Text(
                      total,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          for (final position in positions) ...[
            _AllocationRow(position: position),
            if (position != positions.last)
              const SizedBox(height: AppSpacing.x3),
          ],
        ],
      ),
    );
  }
}

class _AllocationRow extends StatelessWidget {
  const _AllocationRow({required this.position});

  final SavingsPortfolioPositionDraft position;

  @override
  Widget build(BuildContext context) {
    final color = _assetColor(position.asset);
    return Column(
      children: [
        Row(
          children: [
            _TinyDot(
              color: color,
              size: AppSpacing.savingsPortfolioAllocationDot,
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Text(
                position.asset,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            Text(
              position.usdValue,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            SizedBox(
              width: AppSpacing.savingsPortfolioAllocationPercentWidth,
              child: Text(
                position.allocationLabel,
                textAlign: TextAlign.right,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        _ProgressBar(
          progress: _allocationValue(position.allocationLabel),
          color: color,
        ),
      ],
    );
  }
}

class _IncomeProjectionRow extends StatelessWidget {
  const _IncomeProjectionRow({required this.items});

  final List<SavingsIncomeProjectionDraft> items;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final item in items) ...[
          Expanded(child: _IncomeProjectionCard(item: item)),
          if (item != items.last) const SizedBox(width: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _IncomeProjectionCard extends StatelessWidget {
  const _IncomeProjectionCard({required this.item});

  final SavingsIncomeProjectionDraft item;

  @override
  Widget build(BuildContext context) {
    final icon = switch (item.icon) {
      'month' => Icons.calendar_month_outlined,
      'year' => Icons.bar_chart_rounded,
      _ => Icons.wb_sunny_outlined,
    };
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          DecoratedBox(
            decoration: const BoxDecoration(
              color: AppColors.primary12,
              borderRadius: AppRadii.mdRadius,
            ),
            child: SizedBox(
              width: AppSpacing.x7,
              height: AppSpacing.x7,
              child: Icon(
                icon,
                color: AppColors.primary,
                size: AppSpacing.iconSm,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            item.label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            item.value,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.buy,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _MaturitySummary extends StatelessWidget {
  const _MaturitySummary({required this.events});

  final List<SavingsMaturityEventDraft> events;

  @override
  Widget build(BuildContext context) {
    final total = events.length;
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          DecoratedBox(
            decoration: const BoxDecoration(
              color: AppColors.warn10,
              borderRadius: AppRadii.mdRadius,
            ),
            child: const SizedBox(
              width: AppSpacing.x7,
              height: AppSpacing.x7,
              child: Icon(
                Icons.calendar_month_rounded,
                color: AppColors.warn,
                size: AppSpacing.iconSm,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sắp đáo hạn',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                Text(
                  '$total khoản',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Tổng giá trị',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              Text(
                '\$6,000.86',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MaturityCard extends StatelessWidget {
  const _MaturityCard({required this.event});

  final SavingsMaturityEventDraft event;

  @override
  Widget build(BuildContext context) {
    final color = _riskColor(event.tone);
    return VitCard(
      radius: VitCardRadius.lg,
      borderColor: color.withValues(alpha: 0.45),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _AssetBadge(asset: event.asset, color: color),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.product,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Row(
                      children: [
                        _StatusPill(
                          label: _statusLabel(event.tone),
                          color: color,
                        ),
                        const SizedBox(width: AppSpacing.x2),
                        Text(
                          event.apy,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _DaysPill(days: event.daysLeft, color: color),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          DecoratedBox(
            decoration: const BoxDecoration(
              color: AppColors.surface3,
              borderRadius: AppRadii.lgRadius,
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Row(
                children: [
                  Expanded(
                    child: _MiniMetric(label: 'Số lượng', value: event.amount),
                  ),
                  Expanded(
                    child: _MiniMetric(
                      label: 'Giá trị',
                      value: event.usdValue,
                      alignEnd: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Text(
                'Hoàn thành ${(event.progress * 100).round()}%',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const Spacer(),
              Text(
                event.elapsedLabel,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          _ProgressBar(progress: event.progress, color: color),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              const Icon(
                Icons.calendar_month_outlined,
                color: AppColors.text3,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Đáo hạn: ${event.date}',
                style: AppTextStyles.micro.copyWith(color: AppColors.text2),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _SecondaryButton(
                  label: 'Gia hạn',
                  icon: Icons.refresh_rounded,
                  onTap: () => HapticFeedback.selectionClick(),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _SecondaryButton(
                  label: 'Rút khi đáo hạn',
                  icon: Icons.arrow_upward_rounded,
                  color: color,
                  onTap: () => HapticFeedback.selectionClick(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PositionsTab extends StatelessWidget {
  const _PositionsTab({
    required this.snapshot,
    required this.activeFilter,
    required this.onFilterChanged,
  });

  final SavingsPortfolioSnapshot snapshot;
  final _PositionFilter activeFilter;
  final ValueChanged<_PositionFilter> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    final positions = snapshot.positions.where((position) {
      return switch (activeFilter) {
        _PositionFilter.all => true,
        _PositionFilter.flexible =>
          position.type == SavingsProductType.flexible,
        _PositionFilter.locked => position.type == SavingsProductType.locked,
      };
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitTabBar(
          activeKey: activeFilter.name,
          onChanged: (key) =>
              onFilterChanged(_PositionFilter.values.byName(key)),
          tabs: const [
            VitTabItem(key: 'all', label: 'Tất cả'),
            VitTabItem(key: 'flexible', label: 'Linh hoạt'),
            VitTabItem(key: 'locked', label: 'Cố định'),
          ],
        ),
        const SizedBox(height: AppSpacing.x4),
        for (final position in positions) ...[
          _PositionCard(position: position),
          if (position != positions.last) const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _PositionCard extends StatelessWidget {
  const _PositionCard({required this.position});

  final SavingsPortfolioPositionDraft position;

  @override
  Widget build(BuildContext context) {
    final color = _assetColor(position.asset);
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          _AssetBadge(asset: position.asset, color: color),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  position.product,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  '${position.amount} - ${position.apy} APY',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                position.earned,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.buy,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              Text(
                position.usdValue,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
