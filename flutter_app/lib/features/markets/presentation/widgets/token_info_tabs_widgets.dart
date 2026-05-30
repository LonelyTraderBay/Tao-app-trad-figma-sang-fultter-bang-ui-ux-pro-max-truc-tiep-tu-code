part of '../pages/token_info_page.dart';

class _TokenTabs extends StatelessWidget {
  const _TokenTabs({required this.active, required this.onChanged});

  final _TokenInfoTab active;
  final ValueChanged<_TokenInfoTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface2,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          _TabButton(
            key: TokenInfoPage.overviewTabKey,
            label: 'Tong quan',
            active: active == _TokenInfoTab.overview,
            onTap: () => onChanged(_TokenInfoTab.overview),
          ),
          _TabButton(
            key: TokenInfoPage.onchainTabKey,
            label: 'On-chain',
            active: active == _TokenInfoTab.onchain,
            onTap: () => onChanged(_TokenInfoTab.onchain),
          ),
          _TabButton(
            key: TokenInfoPage.projectTabKey,
            label: 'Du an',
            active: active == _TokenInfoTab.project,
            onTap: () => onChanged(_TokenInfoTab.project),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: active ? _marketPrimary : AppColors.text3,
                    fontWeight: active
                        ? AppTextStyles.bold
                        : AppTextStyles.medium,
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                height: 2,
                width: active ? 116 : 0,
                decoration: BoxDecoration(
                  color: _marketPrimary,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({required this.snapshot});

  final MarketTokenInfoSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final pair = snapshot.pair;
    final fundamentals = snapshot.fundamentals;
    final supplyPct = fundamentals.maxSupply == null
        ? null
        : (fundamentals.circulatingSupply / fundamentals.maxSupply!) * 100;
    final athDropPct =
        ((pair.price - fundamentals.allTimeHigh) / fundamentals.allTimeHigh) *
        100;
    final atlGainPct =
        ((pair.price - fundamentals.allTimeLow) / fundamentals.allTimeLow) *
        100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _HeroCard(snapshot: snapshot),
        const SizedBox(height: 14),
        _SectionHeader(
          label: 'Thong ke thi truong',
          accentColor: pair.logoColor,
        ),
        _InfoCard(
          rows: [
            _InfoRowData(
              icon: Icons.bar_chart_rounded,
              iconColor: _marketPrimary,
              label: 'Von hoa thi truong',
              value: _formatCompact(fundamentalsMarketCap(pair), prefix: r'$'),
            ),
            _InfoRowData(
              icon: Icons.layers_rounded,
              iconColor: AppColors.accent,
              label: 'FDV',
              value: _formatCompact(
                fundamentals.fullyDilutedValuation,
                prefix: r'$',
              ),
            ),
            _InfoRowData(
              icon: Icons.show_chart_rounded,
              iconColor: AppColors.buy,
              label: 'Khoi luong 24h',
              value: _formatCompact(pair.volume24h, prefix: r'$'),
            ),
            _InfoRowData(
              icon: Icons.trending_up_rounded,
              iconColor: AppColors.warn,
              label: 'Vol/MCap',
              value:
                  '${((pair.volume24h / pair.marketCap) * 100).toStringAsFixed(2)}%',
            ),
            _InfoRowData(
              icon: Icons.arrow_outward_rounded,
              iconColor: AppColors.buy,
              label: 'ROI 1 nam',
              value: '+${fundamentals.roi1y.toStringAsFixed(2)}%',
              valueColor: AppColors.buy,
            ),
          ],
        ),
        const SizedBox(height: 14),
        const _SectionHeader(label: 'Cung token', accentColor: _marketPrimary),
        _SupplyCard(fundamentals: fundamentals, supplyPct: supplyPct),
        const SizedBox(height: 14),
        const _SectionHeader(
          label: 'Phan bo cung',
          accentColor: AppColors.accent,
        ),
        _DistributionCard(distribution: fundamentals.supplyDistribution),
        const SizedBox(height: 14),
        const _SectionHeader(label: 'Ky luc gia', accentColor: AppColors.warn),
        _AthAtlCards(
          fundamentals: fundamentals,
          athDropPct: athDropPct,
          atlGainPct: atlGainPct,
        ),
        const SizedBox(height: 14),
        _ChartLink(pairId: pair.id),
      ],
    );
  }
}

double fundamentalsMarketCap(MarketPair pair) => pair.marketCap;

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.snapshot});

  final MarketTokenInfoSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final pair = snapshot.pair;
    final fundamentals = snapshot.fundamentals;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: _marketPrimary.withValues(alpha: 0.22)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _TokenAvatar(symbol: pair.baseAsset, color: pair.logoColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fundamentals.name,
                        style: AppTextStyles.sectionTitle.copyWith(
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        fundamentals.consensus,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    _formatPrice(pair.price),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.pageTitle.copyWith(
                      fontSize: 28,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ),
                _ChangePill(change: pair.change24h),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TokenAvatar extends StatelessWidget {
  const _TokenAvatar({required this.symbol, required this.color});

  final String symbol;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.20),
        borderRadius: AppRadii.cardRadius,
      ),
      alignment: Alignment.center,
      child: Text(
        symbol,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _ChangePill extends StatelessWidget {
  const _ChangePill({required this.change});

  final double change;

  @override
  Widget build(BuildContext context) {
    final positive = change >= 0;
    final color = positive ? AppColors.buy : AppColors.sell;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: AppRadii.smRadius,
      ),
      child: Text(
        '${positive ? '+' : ''}${change.toStringAsFixed(2)}%',
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label, required this.accentColor});

  final String label;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 14,
          decoration: BoxDecoration(
            color: accentColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _InfoRowData {
  const _InfoRowData({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Color? valueColor;
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.rows});

  final List<_InfoRowData> rows;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i += 1)
            _InfoRow(row: rows[i], showDivider: i != rows.length - 1),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.row, required this.showDivider});

  final _InfoRowData row;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(bottom: BorderSide(color: AppColors.divider))
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 11),
        child: Row(
          children: [
            Icon(row.icon, size: 13, color: row.iconColor),
            const SizedBox(width: 9),
            Expanded(
              child: Text(
                row.label,
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
            ),
            Text(
              row.value,
              textAlign: TextAlign.right,
              style: AppTextStyles.caption.copyWith(
                color: row.valueColor ?? AppColors.text1,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
