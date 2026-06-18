part of '../pages/margin_trading_hub_page.dart';

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.stats});

  final List<TradeMarginHubStat> stats;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.hero,
      padding: AppSpacing.zeroInsets.copyWith(
        left: AppSpacing.x5 + AppSpacing.hairlineStroke * 2,
        top: AppSpacing.x6 - AppSpacing.x2,
        right: AppSpacing.x5 + AppSpacing.hairlineStroke * 2,
        bottom: AppSpacing.x5 + AppSpacing.hairlineStroke * 2,
      ),
      borderColor: _hubHeroBorder,
      child: Column(
        children: [
          Row(
            children: [
              const VitCard(
                variant: VitCardVariant.inner,
                width: AppSpacing.launchpadBox64,
                height: AppSpacing.launchpadBox64,
                child: Icon(
                  Icons.trending_up_rounded,
                  color: AppColors.onAccent,
                  size: AppSpacing.walletAddressActionSize,
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Margin Trading Suite',
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: AppColors.onAccent,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.transferTileGap),
                    Text(
                      'Margin tools with leverage limits and compliance checks',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.onAccent.withValues(alpha: .72),
                        fontWeight: AppTextStyles.medium,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.walletTransactionStepSpacing),
          Row(
            children: [
              for (final stat in stats) ...[
                Expanded(child: _HeroStat(stat: stat)),
                if (stat != stats.last)
                  const SizedBox(width: AppSpacing.walletAssetChartBottomGap),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({required this.stat});

  final TradeMarginHubStat stat;

  @override
  Widget build(BuildContext context) {
    final color = Color(stat.colorHex);
    return VitCard(
      variant: VitCardVariant.inner,
      height: AppSpacing.marginTradingHubHeroStatHeight,
      padding: AppSpacing.zeroInsets.copyWith(
        left: AppSpacing.transferTileGap,
        top: AppSpacing.rowPy,
        right: AppSpacing.transferTileGap,
        bottom: AppSpacing.rowPy,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            stat.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.amountSm.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.walletAssetChartBottomGap),
          Text(
            stat.label,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.onAccent.withValues(alpha: .62),
              fontWeight: AppTextStyles.bold,
              height: AppSpacing.marginTradingHubLineHeightCaption,
            ),
          ),
        ],
      ),
    );
  }
}

class _NavigationCard extends StatelessWidget {
  const _NavigationCard({required this.items});

  final List<TradeMarginHubMenuItem> items;

  @override
  Widget build(BuildContext context) {
    return _HubCard(
      padding: AppSpacing.zeroInsets.copyWith(
        left: AppSpacing.contentPad,
        top: AppSpacing.contentPad,
        right: AppSpacing.contentPad,
        bottom: AppSpacing.contentPad,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.bar_chart_rounded,
                color: _hubPrimary,
                size: AppSpacing.marginTradingHubNavIconSize,
              ),
              const SizedBox(width: AppSpacing.transferCardGap),
              Expanded(
                child: Text(
                  'Margin Trading Suite',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.contentPad),
          Text(
            'Margin trading controls with risk limits, liquidation context, fee disclosure, and market intelligence.',
            style: AppTextStyles.body.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.walletTransactionProgressBottomGap),
          for (final item in items) ...[
            _MenuItem(item: item),
            if (item != items.last)
              const SizedBox(height: AppSpacing.walletAssetHeroTopGap),
          ],
          const SizedBox(height: AppSpacing.walletAssetSectionGap),
          const MarginHubComplianceInfoBanner(),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({required this.item});

  final TradeMarginHubMenuItem item;

  @override
  Widget build(BuildContext context) {
    final color = Color(item.colorHex);
    return InkWell(
      key: MarginTradingHubPage.menuKey(item.id),
      borderRadius: AppRadii.cardRadius,
      onTap: () => context.go(item.targetPath),
      child: VitCard(
        constraints: const BoxConstraints(
          minHeight: AppSpacing.marginTradingHubMenuItemMinHeight,
        ),
        padding: AppSpacing.zeroInsets.copyWith(
          left: AppSpacing.walletAssetSectionGap,
          top: AppSpacing.rowPy,
          right: AppSpacing.walletAssetSectionGap,
          bottom: AppSpacing.rowPy,
        ),
        borderColor: color.withValues(alpha: .28),
        child: Row(
          children: [
            VitCard(
              variant: VitCardVariant.inner,
              width: AppSpacing.dcaSmartStatsIconBox,
              height: AppSpacing.dcaSmartStatsIconBox,
              borderColor: color.withValues(alpha: .18),
              child: Icon(
                _menuIcon(item.id),
                color: color,
                size: AppSpacing.x5,
              ),
            ),
            const SizedBox(width: AppSpacing.walletAssetHeroTopGap),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.transferTileGap),
                      MarginHubPhaseBadge(label: item.badge, color: color),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.transferTileGap),
                  Text(
                    item.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.walletAssetChartBottomGap),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.text3,
              size: AppSpacing.marginTradingHubChevronIcon,
            ),
          ],
        ),
      ),
    );
  }
}
