part of '../pages/margin_trading_hub_page.dart';

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.stats});

  final List<TradeMarginHubStat> stats;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.hero,
      padding: const EdgeInsets.fromLTRB(25, 29, 25, 25),
      borderColor: _hubHeroBorder,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.onAccent.withValues(alpha: .10),
                  borderRadius: AppRadii.cardRadius,
                ),
                child: const Icon(
                  Icons.trending_up_rounded,
                  color: AppColors.onAccent,
                  size: 36,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Margin Trading Suite',
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: AppColors.onAccent,
                        fontSize: 24,
                        fontWeight: AppTextStyles.bold,
                        height: 1.16,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      'Margin tools with leverage limits and compliance checks',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.onAccent.withValues(alpha: .72),
                        fontSize: 14,
                        fontWeight: AppTextStyles.medium,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 23),
          Row(
            children: [
              for (final stat in stats) ...[
                Expanded(child: _HeroStat(stat: stat)),
                if (stat != stats.last) const SizedBox(width: 10),
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
    return Container(
      height: 85,
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.onAccent.withValues(alpha: .10),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            stat.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.baseMedium.copyWith(
              color: color,
              fontSize: 18,
              fontWeight: AppTextStyles.bold,
              fontFamily: 'monospace',
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            stat.label,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.onAccent.withValues(alpha: .62),
              fontSize: 10,
              fontWeight: AppTextStyles.bold,
              height: 1.2,
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
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.bar_chart_rounded, color: _hubPrimary, size: 22),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  'Margin Trading Suite',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: AppColors.text1,
                    fontSize: 22,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Margin trading controls with risk limits, liquidation context, fee disclosure, and market intelligence.',
            style: AppTextStyles.body.copyWith(
              color: AppColors.text3,
              fontSize: 14,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 17),
          for (final item in items) ...[
            _MenuItem(item: item),
            if (item != items.last) const SizedBox(height: 12),
          ],
          const SizedBox(height: 16),
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
        constraints: const BoxConstraints(minHeight: 92),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        borderColor: color.withValues(alpha: .28),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .10),
                borderRadius: AppRadii.cardRadius,
              ),
              child: Icon(_menuIcon(item.id), color: color, size: 24),
            ),
            const SizedBox(width: 12),
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
                            fontSize: 14,
                            fontWeight: AppTextStyles.bold,
                            height: 1.1,
                          ),
                        ),
                      ),
                      const SizedBox(width: 7),
                      MarginHubPhaseBadge(label: item.badge, color: color),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Text(
                    item.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                      fontSize: 12,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.text3,
              size: 23,
            ),
          ],
        ),
      ),
    );
  }
}
