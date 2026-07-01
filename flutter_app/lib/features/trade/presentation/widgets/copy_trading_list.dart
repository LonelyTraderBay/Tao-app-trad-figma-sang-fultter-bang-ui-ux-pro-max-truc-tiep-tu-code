part of '../pages/copy_trading_page.dart';

class _TraderList extends StatelessWidget {
  const _TraderList({required this.traders, required this.onOpen});

  final List<TradeCopyTrader> traders;
  final ValueChanged<TradeCopyTrader> onOpen;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      clip: true,
      density: VitDensity.compact,
      child: Column(
        children: [
          for (var i = 0; i < traders.length; i++) ...[
            _TraderCard(
              trader: traders[i],
              onOpen: () => onOpen(traders[i]),
              grouped: true,
            ),
            if (i < traders.length - 1)
              const Divider(
                height: AppSpacing.dividerHairline,
                thickness: AppSpacing.dividerHairline,
                color: AppColors.divider,
              ),
          ],
        ],
      ),
    );
  }
}

class _SortChips extends StatelessWidget {
  const _SortChips({
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  final List<String> options;
  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitTabBar(
      activeKey: selected,
      onChanged: onChanged,
      tabs: [
        for (final option in options)
          VitTabItem(
            key: option,
            label: option,
            widgetKey: CopyTradingPage.sortKey(option),
          ),
      ],
    );
  }
}

class _TraderCard extends StatelessWidget {
  const _TraderCard({
    required this.trader,
    required this.onOpen,
    this.grouped = false,
  });

  final TradeCopyTrader trader;
  final VoidCallback onOpen;
  final bool grouped;

  @override
  Widget build(BuildContext context) {
    final tier = _tierFor(trader.copiers);
    final risk = _riskFor(trader.riskLevel);
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _AvatarBadge(trader: trader, tier: tier),
            const SizedBox(width: _copySpace),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          trader.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                      if (trader.isFollowing) ...[
                        const SizedBox(width: AppSpacing.x1),
                        const Icon(
                          Icons.star_rounded,
                          color: AppColors.caution,
                          size: AppSpacing.tradeBotSmallIcon,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Wrap(
                    spacing: AppSpacing.x1,
                    runSpacing: AppSpacing.x1,
                    children: [
                      _MiniBadge(label: tier.label, color: tier.color),
                      for (final tag in trader.tags.take(2))
                        _MiniBadge(label: tag, color: AppColors.text2),
                      _MiniBadge(
                        label: 'Rủi ro: ${risk.label}',
                        color: risk.color,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.x1),
            _RoiBlock(trader: trader),
          ],
        ),
        const SizedBox(height: _copySpace),
        _MetricsGrid(trader: trader),
        const SizedBox(height: _copySpace),
        _WeeklyChart(values: trader.weeklyPnl),
        const SizedBox(height: _copySpace),
        _DetailsButton(traderId: trader.id, onOpen: onOpen),
      ],
    );

    if (grouped) {
      return Padding(
        key: CopyTradingPage.traderKey(trader.id),
        padding: AppSpacing.cardPaddingCompact,
        child: content,
      );
    }

    return _Panel(
      key: CopyTradingPage.traderKey(trader.id),
      child: content,
    );
  }
}

class _AvatarBadge extends StatelessWidget {
  const _AvatarBadge({required this.trader, required this.tier});

  final TradeCopyTrader trader;
  final _TierStyle tier;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSpacing.walletAssetLogoSize,
      height: AppSpacing.walletAssetLogoSize,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          VitAssetAvatar(
            label: trader.avatar,
            accentColor: AppColors.primary,
            size: AppSpacing.tradeToolIconTileMd,
            radius: AppRadii.xlRadius,
            border: true,
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: VitCard(
              width: _copyBadgeSize,
              height: _copyBadgeSize,
              variant: VitCardVariant.inner,
              radius: VitCardRadius.standard,
              density: VitDensity.compact,
              padding: AppSpacing.zeroInsets,
              borderColor: tier.color,
              alignment: Alignment.center,
              child: Icon(
                tier.icon,
                color: tier.color,
                size: AppSpacing.x3 + AppSpacing.x1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoiBlock extends StatelessWidget {
  const _RoiBlock({required this.trader});

  final TradeCopyTrader trader;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 116),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '+${trader.totalPnlPct.toStringAsFixed(1)}%',
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: AppColors.buy,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
                const SizedBox(width: AppSpacing.x1),
                Text(
                  '${trader.maxDrawdown.toStringAsFixed(1)}%',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.sell,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            'Tổng ROI  ·  Max DD',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _DetailsButton extends StatelessWidget {
  const _DetailsButton({required this.traderId, required this.onOpen});

  final String traderId;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: CopyTradingPage.detailKey(traderId),
      onPressed: onOpen,
      variant: VitCtaButtonVariant.secondary,
      height: _copyButtonHeight,
      trailing: const Icon(Icons.chevron_right_rounded),
      child: const Text('Xem chi tiết'),
    );
  }
}
