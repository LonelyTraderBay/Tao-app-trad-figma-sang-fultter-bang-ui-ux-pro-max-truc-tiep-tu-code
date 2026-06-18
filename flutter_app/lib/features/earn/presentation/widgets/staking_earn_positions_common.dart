part of '../pages/staking_earn_page.dart';

class _PositionsList extends StatelessWidget {
  const _PositionsList({required this.snapshot});

  final StakingEarnSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final position in snapshot.positions) ...[
          _PositionCard(position: position),
          if (position != snapshot.positions.last)
            const SizedBox(height: AppSpacing.x3),
        ],
        const SizedBox(height: AppSpacing.x3),
        VitCard(
          radius: VitCardRadius.lg,
          padding: AppSpacing.earnCardPaddingX4,
          borderColor: AppColors.buy20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.trending_up_rounded,
                    color: AppColors.buy,
                    size: AppSpacing.iconMd,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Text(
                    'Tong thu nhap uoc tinh',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.buy,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x3),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (final item in snapshot.estimatedIncome)
                    _IncomeEstimate(item: item),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PositionCard extends StatelessWidget {
  const _PositionCard({required this.position});

  final EarnPositionDraft position;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: AppSpacing.earnCardPaddingX4,
      child: Column(
        children: [
          Row(
            children: [
              _AssetBadge(
                asset: position.asset,
                color: _productTypeColor(position.type),
              ),
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
                      _productTypeLabel(position.type),
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${position.apy} APY',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.buy,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          GridView.count(
            crossAxisCount: AppSpacing.stakingCommunityGridColumns,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: AppSpacing.x2,
            crossAxisSpacing: AppSpacing.x2,
            childAspectRatio: AppSpacing.stakingCommunityPositionsGridAspect,
            children: [
              _PositionMetric(label: 'Dang staking', value: position.amount),
              _PositionMetric(
                label: 'Da nhan',
                value: position.earned,
                valueColor: AppColors.buy,
              ),
              _PositionMetric(label: 'Bat dau', value: position.startDate),
              _PositionMetric(
                label: position.endDate == null ? 'Trang thai' : 'Ket thuc',
                value: position.endDate ?? 'Dang hoat dong',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PositionMetric extends StatelessWidget {
  const _PositionMetric({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.surface2,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
      ),
      child: Padding(
        padding: AppSpacing.earnSmallPillPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(
                color: valueColor,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IncomeEstimate extends StatelessWidget {
  const _IncomeEstimate({required this.item});

  final EarnIncomeEstimateDraft item;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        Text(
          item.value,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.buy,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _AssetBadge extends StatelessWidget {
  const _AssetBadge({required this.asset, required this.color});

  final String asset;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: AppColors.surface2,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: color.withValues(alpha: 0.4)),
          borderRadius: AppRadii.mdRadius,
        ),
      ),
      child: SizedBox(
        width: AppSpacing.x7,
        height: AppSpacing.x7,
        child: Center(
          child: Text(
            asset.length > 4 ? asset.substring(0, 4) : asset,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.label,
    required this.color,
    required this.background,
  });

  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: background,
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.xsRadius),
      ),
      child: Padding(
        padding: AppSpacing.earnSmallPillPadding,
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadii.xlRadius,
      child: SizedBox(
        height: AppSpacing.x2,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const ColoredBox(color: AppColors.surface3),
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress.clamp(0, 1),
              child: ColoredBox(color: color),
            ),
          ],
        ),
      ),
    );
  }
}

List<EarnProductDraft> _filteredProducts(
  List<EarnProductDraft> products,
  _EarnFilter filter,
) {
  return switch (filter) {
    _EarnFilter.all => products,
    _EarnFilter.fixed =>
      products
          .where((product) => product.type == EarnProductType.fixed)
          .toList(),
    _EarnFilter.flexible =>
      products
          .where((product) => product.type == EarnProductType.flexible)
          .toList(),
    _EarnFilter.defi =>
      products
          .where((product) => product.type == EarnProductType.defi)
          .toList(),
  };
}

String _filterLabel(_EarnFilter filter) {
  return switch (filter) {
    _EarnFilter.all => 'Tat ca',
    _EarnFilter.fixed => 'Co dinh',
    _EarnFilter.flexible => 'Linh hoat',
    _EarnFilter.defi => 'DeFi',
  };
}

IconData? _filterIcon(_EarnFilter filter) {
  return switch (filter) {
    _EarnFilter.all => null,
    _EarnFilter.fixed => Icons.lock_outline_rounded,
    _EarnFilter.flexible => Icons.lock_open_rounded,
    _EarnFilter.defi => Icons.bolt_rounded,
  };
}

IconData _productTypeIcon(EarnProductType type) {
  return switch (type) {
    EarnProductType.fixed => Icons.lock_outline_rounded,
    EarnProductType.flexible => Icons.lock_open_rounded,
    EarnProductType.defi => Icons.bolt_rounded,
  };
}

Color _productTypeColor(EarnProductType type) {
  return switch (type) {
    EarnProductType.fixed => AppColors.warn,
    EarnProductType.flexible => AppColors.buy,
    EarnProductType.defi => AppColors.primary,
  };
}

String _productTypeLabel(EarnProductType type) {
  return switch (type) {
    EarnProductType.fixed => 'Co dinh',
    EarnProductType.flexible => 'Linh hoat',
    EarnProductType.defi => 'DeFi Pool',
  };
}

Color _productAccent(EarnProductDraft product) {
  return switch (product.riskLevel) {
    EarnRiskLevel.low => AppColors.buy,
    EarnRiskLevel.medium => AppColors.warn,
    EarnRiskLevel.high => AppColors.sell,
  };
}

Color _riskColor(EarnRiskLevel riskLevel) {
  return switch (riskLevel) {
    EarnRiskLevel.low => AppColors.buy,
    EarnRiskLevel.medium => AppColors.warn,
    EarnRiskLevel.high => AppColors.sell,
  };
}

String _riskLabel(EarnRiskLevel riskLevel) {
  return switch (riskLevel) {
    EarnRiskLevel.low => 'Thap',
    EarnRiskLevel.medium => 'Trung binh',
    EarnRiskLevel.high => 'Cao',
  };
}
