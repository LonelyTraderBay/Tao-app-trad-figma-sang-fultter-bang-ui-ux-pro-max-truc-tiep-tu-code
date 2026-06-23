part of '../pages/token_info_page.dart';

class _TokenTabs extends StatelessWidget {
  const _TokenTabs({required this.active, required this.onChanged});

  final _TokenInfoTab active;
  final ValueChanged<_TokenInfoTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
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
          const Divider(
            height: AppSpacing.dividerHairline,
            thickness: AppSpacing.dividerHairline,
            color: AppColors.border,
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
      child: VitCard(
        variant: VitCardVariant.ghost,
        radius: VitCardRadius.sm,
        padding: EdgeInsets.zero,
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(
                vertical: _tokenInfoTabVerticalPadding,
              ),
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
            AnimatedSize(
              duration: const Duration(milliseconds: 180),
              child: SizedBox(
                height: _tokenInfoTabIndicatorHeight,
                width: active ? _tokenInfoTabIndicatorWidth : 0,
                child: Material(
                  color: active ? _marketPrimary : AppColors.transparent,
                  borderRadius: AppRadii.xsRadius,
                ),
              ),
            ),
          ],
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
        const SizedBox(height: _tokenInfoSectionGap),
        VitSectionHeader(
          title: 'Thong ke thi truong',
          accentColor: pair.logoColor,
          variant: VitSectionHeaderVariant.accentBar,
        ),
        _InfoCard(
          key: TokenInfoPage.marketStatsCardKey,
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
        const SizedBox(height: _tokenInfoSectionGap),
        const VitSectionHeader(
          title: 'Cung token',
          accentColor: _marketPrimary,
          variant: VitSectionHeaderVariant.accentBar,
        ),
        _SupplyCard(fundamentals: fundamentals, supplyPct: supplyPct),
        const SizedBox(height: _tokenInfoSectionGap),
        const VitSectionHeader(
          title: 'Phan bo cung',
          accentColor: AppColors.accent,
          variant: VitSectionHeaderVariant.accentBar,
        ),
        _DistributionCard(distribution: fundamentals.supplyDistribution),
        const SizedBox(height: _tokenInfoSectionGap),
        const VitSectionHeader(
          title: 'Ky luc gia',
          accentColor: AppColors.warn,
          variant: VitSectionHeaderVariant.accentBar,
        ),
        _AthAtlCards(
          fundamentals: fundamentals,
          athDropPct: athDropPct,
          atlGainPct: atlGainPct,
        ),
        const SizedBox(height: _tokenInfoSectionGap),
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
    return VitCard(
      padding: _tokenInfoHeroPadding,
      borderColor: _marketPrimary.withValues(alpha: 0.22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _TokenAvatar(symbol: pair.baseAsset, color: pair.logoColor),
              const SizedBox(width: _tokenInfoHeroAvatarGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(fundamentals.name, style: AppTextStyles.sectionTitle),
                    const SizedBox(height: _tokenInfoHeroSubtitleGap),
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
          const SizedBox(height: _tokenInfoHeroPriceGap),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  _formatPrice(pair.price),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.amountMd.copyWith(
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ),
              _ChangePill(change: pair.change24h),
            ],
          ),
        ],
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
    return VitAssetAvatar(
      label: symbol,
      accentColor: color,
      size: _tokenInfoHeroAvatar,
      radius: AppRadii.cardRadius,
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
    return VitAccentPill(
      label: '${positive ? '+' : ''}${change.toStringAsFixed(2)}%',
      accentColor: color,
      semanticStatus: positive
          ? VitStatusPillStatus.success
          : VitStatusPillStatus.error,
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
  const _InfoCard({super.key, required this.rows});

  final List<_InfoRowData> rows;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: _tokenInfoInfoCardPadding,
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
    return Column(
      children: [
        Padding(
          padding: _tokenInfoInfoRowPadding,
          child: Row(
            children: [
              Icon(row.icon, size: _tokenInfoInfoIcon, color: row.iconColor),
              const SizedBox(width: _tokenInfoInfoIconGap),
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
        if (showDivider)
          const Divider(
            height: AppSpacing.dividerHairline,
            thickness: AppSpacing.dividerHairline,
            color: AppColors.divider,
          ),
      ],
    );
  }
}
