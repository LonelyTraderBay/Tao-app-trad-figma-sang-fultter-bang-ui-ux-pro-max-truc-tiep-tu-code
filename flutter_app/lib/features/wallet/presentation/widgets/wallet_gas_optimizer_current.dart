part of '../pages/wallet_gas_optimizer_page.dart';

class _GasTabs extends StatelessWidget {
  const _GasTabs({required this.activeTab, required this.onChanged});

  final String activeTab;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      for (final tab in const [_tabCurrent, _tabTrends, _tabTips])
        VitTabItem(
          key: tab,
          label: tab,
          widgetKey: WalletGasOptimizerPage.tabKey(tab),
        ),
    ];

    return Material(
      color: _gasPanel,
      child: SizedBox(
        height: AppSpacing.walletGasTabsHeight,
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: VitTabBar(
                  tabs: tabs,
                  activeKey: activeTab,
                  onChanged: onChanged,
                  variant: VitTabBarVariant.underline,
                ),
              ),
            ),
            const Divider(
              height: AppSpacing.dividerHairline,
              color: _gasBorder,
            ),
          ],
        ),
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
                  style: AppTextStyles.control.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
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
                  style: AppTextStyles.control.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const TextSpan(text: ' 24h average'),
              ],
            ),
            style: AppTextStyles.control.copyWith(color: AppColors.text2),
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
    return VitSectionHeader(
      title: label,
      variant: VitSectionHeaderVariant.accentBar,
      accentColor: _gasPrimary,
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
    return VitCard(
      key: WalletGasOptimizerPage.speedKey(level.speed),
      onTap: onTap,
      height: AppSpacing.walletGasLevelHeight,
      padding: AppSpacing.walletGasLevelPadding,
      borderColor: selected ? _gasPrimary : _gasBorder,
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
                            style: AppTextStyles.control.copyWith(
                              fontWeight: AppTextStyles.bold,
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
                      style: AppTextStyles.badge.copyWith(
                        color: AppColors.text3,
                        fontWeight: AppTextStyles.normal,
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
                    style: AppTextStyles.control.copyWith(
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.walletGasLevelValueGap),
                  Text(
                    '~\$${level.usd.toStringAsFixed(2)}',
                    style: AppTextStyles.badge.copyWith(
                      color: AppColors.text3,
                      fontWeight: AppTextStyles.normal,
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
    );
  }
}

class _RecommendedBadge extends StatelessWidget {
  const _RecommendedBadge();

  @override
  Widget build(BuildContext context) {
    return Text(
      'RECOMMENDED',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyles.badge.copyWith(
        color: _gasGreen,
        fontWeight: AppTextStyles.bold,
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
            style: AppTextStyles.control.copyWith(
              fontWeight: AppTextStyles.bold,
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
                style: AppTextStyles.control.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.walletGasComparisonTextGap),
              Text(
                '${_withCommas(comparison.gas.toString())} gas',
                style: AppTextStyles.badge.copyWith(
                  color: AppColors.text3,
                  fontWeight: AppTextStyles.normal,
                ),
              ),
            ],
          ),
        ),
        Text(
          '~\$${comparison.usd.toStringAsFixed(2)}',
          style: AppTextStyles.control.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
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
    return VitCtaButton(
      key: WalletGasOptimizerPage.refreshKey,
      onPressed: () {},
      variant: VitCtaButtonVariant.ghost,
      height: AppSpacing.walletGasRefreshHeight,
      leading: const Icon(Icons.refresh_rounded),
      child: Text(
        'Refresh Prices',
        style: AppTextStyles.control.copyWith(
          color: AppColors.text1,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}
