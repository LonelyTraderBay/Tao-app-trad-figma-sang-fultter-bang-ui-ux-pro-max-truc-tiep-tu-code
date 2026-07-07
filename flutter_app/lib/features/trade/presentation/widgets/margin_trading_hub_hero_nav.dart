part of '../pages/margin_trading_hub_page.dart';

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.stats});

  final List<TradeMarginHubStat> stats;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.hero,
      density: VitDensity.compact,
      padding: AppSpacing.cardPaddingCompact,
      borderColor: _hubHeroBorder,
      child: Column(
        children: [
          Row(
            children: [
              // card-tile: allow-start — fixed surface, not horizontal strip tile
              const VitCard(
                variant: VitCardVariant.inner,
                width: _hubHeroIconTile,
                height: _hubHeroIconTile,
                density: VitDensity.compact,
                padding: AppSpacing.zeroInsets,
                child: Icon(
                  Icons.trending_up_rounded,
                  color: AppColors.onAccent,
                  size: AppSpacing.x5,
                ),
              ),
              const SizedBox(width: _hubSpace),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bộ công cụ ký quỹ',
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: AppColors.onAccent,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: _hubTinySpace),
                    Text(
                      'Công cụ ký quỹ với hạn đòn bẩy và kiểm tra tuân thủ',
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
          const SizedBox(height: _hubSpace),
          Row(
            children: [
              for (final stat in stats) ...[
                Expanded(child: _HeroStat(stat: stat)),
                if (stat != stats.last) const SizedBox(width: _hubTinySpace),
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
      density: VitDensity.compact,
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x1,
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
          const SizedBox(height: _hubTinySpace),
          Text(
            stat.label,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.onAccent.withValues(alpha: .62),
              fontWeight: AppTextStyles.bold,
              height: _hubLineTight,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.bar_chart_rounded,
                color: _hubPrimary,
                size: AppSpacing.x4,
              ),
              const SizedBox(width: _hubSpace),
              Expanded(
                child: Text(
                  'Bộ công cụ ký quỹ',
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
          const SizedBox(height: _hubSpace),
          Text(
            'Điều khiển ký quỹ với hạn rủi ro, ngữ cảnh thanh lý, công bố phí và thông tin thị trường.',
            style: AppTextStyles.body.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: _hubSpace),
          for (final item in items) ...[
            _MenuItem(item: item),
            if (item != items.last) const SizedBox(height: _hubSpace),
          ],
          const SizedBox(height: _hubSpace),
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
    return VitCard(
      key: MarginTradingHubPage.menuKey(item.id),
      onTap: () => context.go(item.targetPath),
      density: VitDensity.compact,
      padding: AppSpacing.cardPaddingCompact,
      borderColor: color.withValues(alpha: .28),
      child: Row(
        children: [
          // card-tile: allow-start — fixed surface, not horizontal strip tile
          VitCard(
            variant: VitCardVariant.inner,
            width: _hubIconTile,
            height: _hubIconTile,
            density: VitDensity.compact,
            padding: AppSpacing.zeroInsets,
            borderColor: color.withValues(alpha: .18),
            child: Icon(_menuIcon(item.id), color: color, size: AppSpacing.x5),
          ),
          const SizedBox(width: _hubSpace),
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
                    const SizedBox(width: _hubTinySpace),
                    MarginHubPhaseBadge(label: item.badge, color: color),
                  ],
                ),
                const SizedBox(height: _hubTinySpace),
                Text(
                  item.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const SizedBox(width: _hubTinySpace),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text3,
            size: AppSpacing.x4,
          ),
        ],
      ),
    );
  }
}
