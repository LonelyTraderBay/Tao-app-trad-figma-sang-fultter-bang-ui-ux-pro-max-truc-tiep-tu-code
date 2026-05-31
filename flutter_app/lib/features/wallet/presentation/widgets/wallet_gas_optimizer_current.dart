part of '../pages/wallet_gas_optimizer_page.dart';

class _GasTabs extends StatelessWidget {
  const _GasTabs({required this.activeTab, required this.onChanged});

  final String activeTab;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
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
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          height: 1,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 7,
                      right: 7,
                      bottom: 0,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        height: 2,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _GasStatusCard(snapshot: snapshot),
        const SizedBox(height: 19),
        const _SectionLabel(label: 'Chon toc do giao dich'),
        const SizedBox(height: 11),
        for (var i = 0; i < snapshot.levels.length; i++) ...[
          _GasLevelCard(
            level: snapshot.levels[i],
            selected: selectedSpeed == snapshot.levels[i].speed,
            onTap: () => onSelectSpeed(snapshot.levels[i].speed),
          ),
          if (i != snapshot.levels.length - 1) const SizedBox(height: 11),
        ],
        const SizedBox(height: 18),
        _ComparisonCard(comparisons: snapshot.comparisons),
        const SizedBox(height: 17),
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

    return Container(
      height: 76,
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .07),
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: color.withValues(alpha: .22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bolt_rounded, color: color, size: 17),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
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
                  style: TextStyle(color: color, fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: ' 24h average'),
              ],
            ),
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontSize: 11,
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
          width: 4,
          height: 14,
          decoration: BoxDecoration(
            color: _gasPrimary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textMutedBlue,
            fontSize: 12,
            fontWeight: FontWeight.w900,
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
        height: 85,
        padding: const EdgeInsets.fromLTRB(16, 17, 16, 15),
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
                          Text(
                            level.label,
                            style: AppTextStyles.baseMedium.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              height: 1,
                            ),
                          ),
                          if (level.recommended) ...[
                            const SizedBox(width: 8),
                            const _RecommendedBadge(),
                          ],
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        level.timeEstimate,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                          fontSize: 11,
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
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Roboto',
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '~\$${level.usd.toStringAsFixed(2)}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        fontSize: 11,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                minHeight: 4,
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
      height: 17,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _gasGreen.withValues(alpha: .14),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'RECOMMENDED',
        style: AppTextStyles.micro.copyWith(
          color: _gasGreen,
          fontSize: 9,
          fontWeight: FontWeight.w900,
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
    return Container(
      height: 233,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 17),
      decoration: BoxDecoration(
        color: _gasPanel,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: _gasBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Transaction Type Comparison',
            style: AppTextStyles.baseMedium.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          const SizedBox(height: 17),
          for (var i = 0; i < comparisons.length; i++) ...[
            _ComparisonRow(comparison: comparisons[i]),
            if (i != comparisons.length - 1) const SizedBox(height: 15),
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
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                '${_withCommas(comparison.gas.toString())} gas',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 10,
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
            fontSize: 13,
            fontWeight: FontWeight.w900,
            fontFamily: 'Roboto',
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
        height: 41,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _gasBackground,
          borderRadius: AppRadii.inputRadius,
          border: Border.all(color: _gasBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.refresh_rounded, color: AppColors.text1, size: 15),
            const SizedBox(width: 8),
            Text(
              'Refresh Prices',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontSize: 13,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
