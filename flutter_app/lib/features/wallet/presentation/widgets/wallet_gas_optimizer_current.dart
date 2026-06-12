part of '../pages/wallet_gas_optimizer_page.dart';

class _GasTabs extends StatelessWidget {
  const _GasTabs({required this.activeTab, required this.onChanged});

  final String activeTab;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSpacing.walletGasTabsHeight,
      decoration: const BoxDecoration(
        color: _gasPanel,
        border: Border(bottom: BorderSide(color: _gasBorder)),
      ),
      child: Row(
        children: [
          for (final tab in const [_tabCurrent, _tabTrends, _tabTips])
            Expanded(
              child: GestureDetector(
                key: WalletGasOptimizerPage.tabKey(tab),
                onTap: () => onChanged(tab),
                behavior: HitTestBehavior.opaque,
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        tab,
                        style: AppTextStyles.caption.copyWith(
                          color: activeTab == tab
                              ? _gasPrimary
                              : AppColors.textDisabled,
                          fontWeight: AppTextStyles.bold,
                          height: 1,
                        ),
                      ),
                    ),
                    Positioned(
                      left: AppSpacing.walletGasTabIndicatorInset,
                      right: AppSpacing.walletGasTabIndicatorInset,
                      bottom: 0,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        height: AppSpacing.walletGasTabIndicatorHeight,
                        color: activeTab == tab
                            ? _gasPrimary
                            : AppColors.transparent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CurrentGasTab extends StatelessWidget {
  const _CurrentGasTab({
    required this.snapshot,
    required this.selectedSpeed,
    required this.onSelectSpeed,
  });

  final WalletGasOptimizerSnapshot snapshot;
  final String selectedSpeed;
  final ValueChanged<String> onSelectSpeed;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      padding: VitContentPadding.none,
      fullBleed: true,
      customGap: AppSpacing.walletGasContentGap,
      children: [
        _GasStatusCard(snapshot: snapshot),
        const _SectionLabel(label: 'Chon toc do giao dich'),
        for (var i = 0; i < snapshot.levels.length; i++) ...[
          _GasLevelCard(
            level: snapshot.levels[i],
            selected: selectedSpeed == snapshot.levels[i].speed,
            onTap: () => onSelectSpeed(snapshot.levels[i].speed),
          ),
        ],
        _ComparisonCard(comparisons: snapshot.comparisons),
        const _RefreshButton(),
      ],
    );
  }
}

class _GasStatusCard extends StatelessWidget {
  const _GasStatusCard({required this.snapshot});

  final WalletGasOptimizerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final vsAverage = snapshot.vsAveragePct;
    final isLow = vsAverage < -10;
    final isHigh = vsAverage > 10;
    final color = isLow ? _gasGreen : (isHigh ? _gasRed : _gasAmber);
    final title = isLow
        ? 'Low Gas Prices - Good Time!'
        : (isHigh ? 'High Gas Prices' : 'Normal Gas Prices');

    return VitCard(
      height: AppSpacing.walletGasStatusHeight,
      padding: AppSpacing.walletGasStatusPadding,
      borderColor: color.withValues(alpha: .22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.bolt_rounded,
                color: color,
                size: AppSpacing.walletGasIcon,
              ),
              const SizedBox(width: AppSpacing.walletGasIconGap),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text.rich(
            TextSpan(
              text: 'Current gas ',
              children: [
                TextSpan(
                  text:
                      '${vsAverage.abs().toStringAsFixed(0)}% ${vsAverage < 0 ? 'below' : 'above'}',
                  style: TextStyle(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const TextSpan(text: ' 24h average'),
              ],
            ),
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: AppSpacing.walletGasSectionMarkerWidth,
          height: AppSpacing.walletGasSectionMarkerHeight,
          decoration: BoxDecoration(
            color: _gasPrimary,
            borderRadius: AppRadii.hairlineRadius,
          ),
        ),
        const SizedBox(width: AppSpacing.walletGasSectionLabelGap),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textMutedBlue,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _GasLevelCard extends StatelessWidget {
  const _GasLevelCard({
    required this.level,
    required this.selected,
    required this.onTap,
  });

  final WalletGasLevel level;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Color(level.colorHex);
    return GestureDetector(
      key: WalletGasOptimizerPage.speedKey(level.speed),
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: AppSpacing.walletGasLevelHeight,
        padding: AppSpacing.walletGasLevelPadding,
        decoration: BoxDecoration(
          color: selected ? _gasPrimary.withValues(alpha: .045) : _gasPanel,
          borderRadius: AppRadii.cardRadius,
          border: Border.all(color: selected ? _gasPrimary : _gasBorder),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              level.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.baseMedium.copyWith(
                                fontWeight: AppTextStyles.bold,
                                height: 1,
                              ),
                            ),
                          ),
                          if (level.recommended) ...[
                            const SizedBox(
                              width: AppSpacing.walletGasLevelBadgeGap,
                            ),
                            const _RecommendedBadge(),
                          ],
                        ],
                      ),
                      const SizedBox(height: AppSpacing.walletGasLevelMetaGap),
                      Text(
                        level.timeEstimate,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${level.gwei} Gwei',
                      style: AppTextStyles.sectionTitle.copyWith(
                        fontWeight: AppTextStyles.bold,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.walletGasLevelValueGap),
                    Text(
                      '~\$${level.usd.toStringAsFixed(2)}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            ClipRRect(
              borderRadius: AppRadii.hairlineRadius,
              child: LinearProgressIndicator(
                minHeight: AppSpacing.walletGasLevelProgressHeight,
                value: level.gwei / 50,
                color: color,
                backgroundColor: _gasBackground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecommendedBadge extends StatelessWidget {
  const _RecommendedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSpacing.walletGasRecommendedBadgeHeight,
      padding: AppSpacing.walletGasBadgePadding,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _gasGreen.withValues(alpha: .14),
        borderRadius: AppRadii.smRadius,
      ),
      child: Text(
        'RECOMMENDED',
        style: AppTextStyles.micro.copyWith(
          color: _gasGreen,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _ComparisonCard extends StatelessWidget {
  const _ComparisonCard({required this.comparisons});

  final List<WalletGasComparison> comparisons;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      height: AppSpacing.walletGasComparisonHeight,
      padding: AppSpacing.walletGasComparisonPadding,
      borderColor: _gasBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Transaction Type Comparison',
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
          const SizedBox(height: AppSpacing.walletGasComparisonTitleGap),
          for (var i = 0; i < comparisons.length; i++) ...[
            _ComparisonRow(comparison: comparisons[i]),
            if (i != comparisons.length - 1)
              const SizedBox(height: AppSpacing.walletGasComparisonRowGap),
          ],
        ],
      ),
    );
  }
}

class _ComparisonRow extends StatelessWidget {
  const _ComparisonRow({required this.comparison});

  final WalletGasComparison comparison;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                comparison.type,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
              const SizedBox(height: AppSpacing.walletGasComparisonTextGap),
              Text(
                '${_withCommas(comparison.gas.toString())} gas',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
        Text(
          '~\$${comparison.usd.toStringAsFixed(2)}',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _RefreshButton extends StatelessWidget {
  const _RefreshButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: WalletGasOptimizerPage.refreshKey,
      onTap: () {},
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: AppSpacing.walletGasRefreshHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _gasBackground,
          borderRadius: AppRadii.inputRadius,
          border: Border.all(color: _gasBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.refresh_rounded,
              color: AppColors.text1,
              size: AppSpacing.walletGasRefreshIcon,
            ),
            const SizedBox(width: AppSpacing.walletGasIconGap),
            Text(
              'Refresh Prices',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
