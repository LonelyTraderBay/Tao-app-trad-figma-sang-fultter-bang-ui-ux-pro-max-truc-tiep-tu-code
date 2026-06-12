part of 'dca_multi_asset_page.dart';

class _RebalancingCard extends StatelessWidget {
  const _RebalancingCard({
    required this.enabled,
    required this.controller,
    required this.onToggle,
  });

  final bool enabled;
  final TextEditingController controller;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.settings_outlined,
                color: AppColors.text1,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  'Auto Rebalancing',
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              _TokenSwitch(enabled: enabled, onToggle: onToggle),
            ],
          ),
          if (enabled) ...[
            const SizedBox(height: AppSpacing.x4),
            VitInput(
              controller: controller,
              fieldKey: DCAMultiAssetPage.thresholdFieldKey,
              label: 'Rebalance Threshold (%)',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: AppSpacing.x2),
            Text(
              'Rebalance when allocation deviates by this %',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ],
      ),
    );
  }
}

class _TokenSwitch extends StatelessWidget {
  const _TokenSwitch({required this.enabled, required this.onToggle});

  final bool enabled;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: DCAMultiAssetPage.rebalanceToggleKey,
      onTap: onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: AppSpacing.dcaMultiToggleWidth,
        height: AppSpacing.dcaMultiToggleHeight,
        padding: const EdgeInsets.all(AppSpacing.dcaMultiTogglePadding),
        decoration: BoxDecoration(
          color: enabled ? AppColors.primary : AppColors.surface3,
          borderRadius: AppRadii.xlRadius,
          border: Border.all(
            color: enabled ? AppColors.primary : AppColors.borderSolid,
          ),
        ),
        alignment: enabled ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: AppSpacing.dcaMultiToggleThumb,
          height: AppSpacing.dcaMultiToggleThumb,
          decoration: const BoxDecoration(
            color: AppColors.onAccent,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _PortfolioOverviewCard extends StatelessWidget {
  const _PortfolioOverviewCard({required this.snapshot});

  final DcaMultiAssetSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardTitle('Portfolio Overview'),
          const SizedBox(height: AppSpacing.x5),
          Row(
            children: [
              Expanded(
                child: _MetricText(
                  label: 'Total Invested',
                  value: _formatUsd(snapshot.totalInvestedUsd),
                  large: true,
                ),
              ),
              Expanded(
                child: _MetricText(
                  label: 'Current Value',
                  value: _formatUsd(snapshot.currentValueUsd),
                  color: AppColors.buy,
                  large: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          Row(
            children: [
              Expanded(
                child: _MetricText(
                  label: 'Total Return',
                  value: '+${_formatUsd(snapshot.totalReturnUsd)}',
                  color: AppColors.buy,
                ),
              ),
              Expanded(
                child: _MetricText(
                  label: 'Return %',
                  value: '+${snapshot.totalReturnPercent.toStringAsFixed(2)}%',
                  color: AppColors.buy,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          SizedBox(
            height: AppSpacing.dcaMultiAllocationChartHeight,
            child: CustomPaint(
              painter: _AllocationDonutPainter(
                allocations: snapshot.allocations,
              ),
              child: Center(
                child: Text(
                  'Portfolio',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AssetDetailCard extends StatelessWidget {
  const _AssetDetailCard({required this.asset, required this.accent});

  final DcaMultiAssetAllocation asset;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: AppSpacing.dcaMultiLegendMarker,
                height: AppSpacing.dcaMultiLegendMarker,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: AppRadii.xsRadius,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      asset.symbol,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      asset.assetName,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          Row(
            children: [
              Expanded(
                child: _MetricText(
                  label: 'Invested',
                  value: _formatUsd(asset.totalInvestedUsd),
                ),
              ),
              Expanded(
                child: _MetricText(
                  label: 'Value',
                  value: _formatUsd(asset.currentValueUsd),
                  color: AppColors.buy,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _MetricText(
                  label: 'Shares',
                  value: asset.shares.toStringAsFixed(4),
                ),
              ),
              Expanded(
                child: _MetricText(
                  label: 'Avg Price',
                  value: _formatUsd(asset.averagePriceUsd),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GrowthCard extends StatelessWidget {
  const _GrowthCard({required this.points});

  final List<DcaMultiAssetPerformancePoint> points;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardTitle('Investment Growth by Asset'),
          const SizedBox(height: AppSpacing.x5),
          SizedBox(
            height: AppSpacing.dcaMultiGrowthChartHeight,
            width: double.infinity,
            child: CustomPaint(painter: _StackedBarsPainter(points: points)),
          ),
          const SizedBox(height: AppSpacing.x4),
          Wrap(
            spacing: AppSpacing.x4,
            runSpacing: AppSpacing.x3,
            children: const [
              _LegendItem(label: 'BTC', color: AppColors.primary),
              _LegendItem(label: 'ETH', color: AppColors.buy),
              _LegendItem(label: 'BNB', color: AppColors.warn),
              _LegendItem(label: 'SOL', color: AppColors.accent),
            ],
          ),
        ],
      ),
    );
  }
}

class _PerformanceRankRow extends StatelessWidget {
  const _PerformanceRankRow({
    required this.rank,
    required this.asset,
    required this.accent,
  });

  final int rank;
  final DcaMultiAssetAllocation asset;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.sm,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          SizedBox(
            width: AppSpacing.iconLg,
            child: rank == 1
                ? Icon(
                    Icons.trending_up_rounded,
                    color: accent,
                    size: AppSpacing.iconMd,
                  )
                : Text(
                    '#$rank',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  asset.symbol,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  asset.assetName,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '+${asset.returnPercent.toStringAsFixed(2)}%',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.buy,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              Text(
                '+${_formatUsd(asset.returnUsd)}',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DiversificationCard extends StatelessWidget {
  const _DiversificationCard({required this.assetCount});

  final int assetCount;

  @override
  Widget build(BuildContext context) {
    return _SuccessCallout(
      icon: Icons.check_circle_outline_rounded,
      title: 'Diversification Score',
      score: '8.5',
      text: 'Portfolio well diversified across $assetCount assets',
    );
  }
}

class _InfoCallout extends StatelessWidget {
  const _InfoCallout({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.sm,
      borderColor: AppColors.primary20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: AppSpacing.dcaMultiIcon),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}

class _WarningCallout extends StatelessWidget {
  const _WarningCallout({
    required this.icon,
    required this.title,
    required this.text,
  });

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.warningBorder,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.warn, size: AppSpacing.iconMd),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  text,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
