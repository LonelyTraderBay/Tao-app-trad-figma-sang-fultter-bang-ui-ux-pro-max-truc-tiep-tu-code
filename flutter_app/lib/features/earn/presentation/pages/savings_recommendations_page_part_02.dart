part of 'savings_recommendations_page.dart';

class _StrategyCard extends StatelessWidget {
  const _StrategyCard({
    super.key,
    required this.strategy,
    required this.amount,
    required this.onTap,
  });

  final SavingsStrategyDraft strategy;
  final double amount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: AppSpacing.earnPaddingX3,
      borderColor: strategy.recommended ? AppColors.primary : null,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (strategy.recommended) ...[
            Row(
              children: [
                const Icon(
                  Icons.auto_awesome_rounded,
                  color: AppColors.primary,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: AppSpacing.x2),
                _SmallPill(
                  label: 'Phù hợp nhất với bạn',
                  color: AppColors.primary,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x3),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(strategy.title, style: AppTextStyles.baseMedium),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      strategy.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatPercent(strategy.expectedApy),
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: AppColors.buy,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  Text(
                    'APY ước tính',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          _AllocationBar(allocation: strategy.allocation),
          const SizedBox(height: AppSpacing.x3),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              for (final item in strategy.allocation)
                _AllocationChip(item: item),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              _SmallPill(
                label: 'Match ${strategy.matchScore}%',
                color: strategy.matchScore >= 80
                    ? AppColors.buy
                    : AppColors.primary,
              ),
              const SizedBox(width: AppSpacing.x2),
              _SmallPill(
                label: _strategyRiskLabel(strategy.riskLevel),
                color: _strategyRiskColor(strategy.riskLevel),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  '+${_formatUsd(amount * strategy.expectedApy / 100)}/năm',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.text3,
                size: AppSpacing.iconMd,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AllocationBar extends StatelessWidget {
  const _AllocationBar({required this.allocation});

  final List<SavingsStrategyAllocationDraft> allocation;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadii.xsRadius,
      child: Row(
        children: [
          for (final item in allocation)
            Expanded(
              flex: item.percentage,
              child: ColoredBox(
                color: _assetColor(item.asset),
                child: const SizedBox(height: AppSpacing.x2),
              ),
            ),
        ],
      ),
    );
  }
}

class _AllocationChip extends StatelessWidget {
  const _AllocationChip({required this.item});

  final SavingsStrategyAllocationDraft item;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.surface2,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
      ),
      child: Padding(
        padding: AppSpacing.earnSmallPillPadding,
        child: Text(
          '${item.asset} ${item.percentage}%',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({required this.insight});

  final SavingsRecommendationInsightDraft insight;

  @override
  Widget build(BuildContext context) {
    final color = _insightColor(insight.tone);
    return VitCard(
      radius: VitCardRadius.large,
      padding: AppSpacing.earnPaddingX4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _RoundIcon(icon: _insightIcon(insight.iconKey), color: color),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  insight.title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  insight.description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    height: AppTextStyles.caption.height,
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

class _QuickLinks extends StatelessWidget {
  const _QuickLinks({required this.snapshot});

  final SavingsRecommendationsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: VitCtaButton(
            key: SavingsRecommendationsPage.riskButtonKey,
            variant: VitCtaButtonVariant.warning,
            height: AppSpacing.buttonCompact,
            onPressed: () {
              HapticFeedback.selectionClick();
              context.go(snapshot.riskAssessmentRoute);
            },
            leading: const Icon(Icons.shield_outlined),
            child: const Text('Đánh giá rủi ro'),
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: VitCtaButton(
            key: SavingsRecommendationsPage.productsButtonKey,
            variant: VitCtaButtonVariant.success,
            height: AppSpacing.buttonCompact,
            onPressed: () {
              HapticFeedback.selectionClick();
              context.go(snapshot.savingsRoute);
            },
            leading: const Icon(Icons.savings_outlined),
            child: const Text('Tất cả sản phẩm'),
          ),
        ),
      ],
    );
  }
}

class _StrategyDetailSheet extends StatelessWidget {
  const _StrategyDetailSheet({
    required this.strategy,
    required this.amount,
    required this.savingsRoute,
  });

  final SavingsStrategyDraft strategy;
  final double amount;
  final String savingsRoute;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(strategy.title, style: AppTextStyles.sectionTitle),
            ),
            VitIconButton(
              icon: Icons.close_rounded,
              tooltip: 'Đóng',
              onPressed: () => Navigator.of(context).pop(),
              variant: VitIconButtonVariant.transparent,
              size: VitIconButtonSize.md,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        Wrap(
          spacing: AppSpacing.x2,
          runSpacing: AppSpacing.x2,
          children: [
            _SmallPill(
              label: 'Match ${strategy.matchScore}%',
              color: strategy.matchScore >= 80
                  ? AppColors.buy
                  : AppColors.primary,
            ),
            _SmallPill(
              label: 'Rủi ro ${_strategyRiskLabel(strategy.riskLevel)}',
              color: _strategyRiskColor(strategy.riskLevel),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x4),
        VitCard(
          variant: VitCardVariant.inner,
          padding: AppSpacing.earnPaddingX3,
          child: Column(
            children: [
              _SheetMetric(
                label: 'APY ước tính TB',
                value: _formatPercent(strategy.expectedApy),
                color: AppColors.buy,
              ),
              _SheetMetric(
                label: 'Thanh khoản tức thì',
                value: '${strategy.liquidityRatio}%',
                color: strategy.liquidityRatio >= 50
                    ? AppColors.buy
                    : AppColors.warn,
              ),
              _SheetMetric(
                label: 'Ước tính lãi/năm (${_formatUsd(amount)})',
                value: '+${_formatUsd(amount * strategy.expectedApy / 100)}',
                color: AppColors.buy,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        Text(
          'Phân bổ chi tiết',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x3),
        for (final item in strategy.allocation) ...[
          _AllocationDetailRow(item: item, amount: amount),
          if (item != strategy.allocation.last)
            const SizedBox(height: AppSpacing.x3),
        ],
        const SizedBox(height: AppSpacing.x3),
        _AllocationBar(allocation: strategy.allocation),
        const SizedBox(height: AppSpacing.x5),
        _BulletSection(
          title: 'Ưu điểm',
          items: strategy.pros,
          color: AppColors.buy,
        ),
        const SizedBox(height: AppSpacing.x4),
        _BulletSection(
          title: 'Lưu ý / Nhược điểm',
          items: strategy.cons,
          color: AppColors.sell,
        ),
        const SizedBox(height: AppSpacing.x4),
        _BulletSection(
          title: 'Phù hợp với',
          items: strategy.bestFor,
          color: AppColors.primary,
        ),
        const SizedBox(height: AppSpacing.x5),
        VitCtaButton(
          key: SavingsRecommendationsPage.detailCtaKey,
          onPressed: () {
            HapticFeedback.selectionClick();
            Navigator.of(context).pop();
            context.go(savingsRoute);
          },
          trailing: const Icon(Icons.arrow_forward_rounded),
          child: const Text('Đăng ký sản phẩm theo chiến lược'),
        ),
      ],
    );
  }
}

class _CompareSheet extends StatelessWidget {
  const _CompareSheet({required this.strategies, required this.amount});

  final List<SavingsStrategyDraft> strategies;
  final double amount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'So sánh Chiến lược',
                style: AppTextStyles.sectionTitle,
              ),
            ),
            VitIconButton(
              icon: Icons.close_rounded,
              tooltip: 'Đóng',
              onPressed: () => Navigator.of(context).pop(),
              variant: VitIconButtonVariant.transparent,
              size: VitIconButtonSize.md,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x4),
        _CompareRow(
          label: '',
          values: [for (final strategy in strategies) strategy.title],
          header: true,
        ),
        _CompareRow(
          label: 'APY ước tính',
          values: [
            for (final strategy in strategies)
              _formatPercent(strategy.expectedApy),
          ],
          color: AppColors.buy,
        ),
        _CompareRow(
          label: 'Thanh khoản',
          values: [
            for (final strategy in strategies) '${strategy.liquidityRatio}%',
          ],
          color: AppColors.primary,
        ),
        _CompareRow(
          label: 'Match',
          values: [
            for (final strategy in strategies) '${strategy.matchScore}%',
          ],
          color: AppColors.accent,
        ),
        _CompareRow(
          label: 'Rủi ro',
          values: [
            for (final strategy in strategies)
              _strategyRiskLabel(strategy.riskLevel),
          ],
        ),
        _CompareRow(
          label: 'Lãi/năm',
          values: [
            for (final strategy in strategies)
              '+${_formatUsd(amount * strategy.expectedApy / 100)}',
          ],
          color: AppColors.buy,
        ),
      ],
    );
  }
}
