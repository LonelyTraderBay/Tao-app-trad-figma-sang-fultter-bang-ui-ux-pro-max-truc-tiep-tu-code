part of 'home_page.dart';

class _HomeDiscoverySection extends StatelessWidget {
  const _HomeDiscoverySection({required this.onNavigate});

  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitSectionHeader(title: 'Dự đoán & Thách đấu'),
        const SizedBox(height: AppSpacing.x3),
        VitDiscoveryActionCard(
          title: 'Prediction Markets',
          badgeLabel: 'Prediction Market',
          subtitle: 'Thị trường xác suất, vị thế và portfolio',
          actionLabel: 'Khám phá thị trường',
          icon: Icons.adjust_rounded,
          accentColor: AppColors.accent,
          borderColor: AppColors.accent20,
          variant: VitDiscoveryActionCardVariant.compact,
          background: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.accent15, AppColors.primary08],
          ),
          onTap: () => onNavigate('/markets/predictions'),
        ),
        const SizedBox(height: AppSpacing.x2),
        VitDiscoveryActionCard(
          title: 'Open Arena',
          badgeLabel: 'Arena Points only',
          subtitle: 'Tạo mode chơi, mở room, dùng Arena Points',
          actionLabel: 'Vào Arena',
          icon: Icons.sports_esports_outlined,
          accentColor: AppColors.warn,
          borderColor: AppColors.warningBorder,
          badgeStatus: VitStatusPillStatus.warning,
          variant: VitDiscoveryActionCardVariant.compact,
          background: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.warn15, AppColors.warn10],
          ),
          onTap: () => onNavigate('/arena'),
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          'Predictions sử dụng vị thế thực. Arena sử dụng Points (không phải tiền thật).',
          textAlign: TextAlign.center,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _MarketSection extends StatelessWidget {
  const _MarketSection({
    required this.activeTab,
    required this.pairs,
    required this.onTabChanged,
    required this.onNavigate,
  });

  final String activeTab;
  final List<HomeCryptoPair> pairs;
  final ValueChanged<String> onTabChanged;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitSectionHeader(
          title: 'Thị trường',
          actionLabel: 'Xem tất cả',
          onAction: () => onNavigate('/markets'),
        ),
        const SizedBox(height: AppSpacing.x3),
        VitTabBar(
          activeKey: activeTab,
          onChanged: onTabChanged,
          tabs: const [
            VitTabItem(
              key: 'hot',
              label: 'Hot',
              icon: Icons.local_fire_department_rounded,
            ),
            VitTabItem(
              key: 'gainers',
              label: 'Tăng',
              icon: Icons.trending_up_rounded,
            ),
            VitTabItem(
              key: 'losers',
              label: 'Giảm',
              icon: Icons.trending_down_rounded,
            ),
            VitTabItem(key: 'new', label: 'Mới', icon: Icons.fiber_new_rounded),
          ],
        ),
        const SizedBox(height: AppSpacing.x3),
        VitCard(
          clip: true,
          child: Column(
            children: [
              for (var i = 0; i < pairs.length; i++) ...[
                _MarketRow(
                  pair: pairs[i],
                  showSparkline: true,
                  onTap: () => onNavigate('/pair/${pairs[i].id}'),
                ),
                if (i < pairs.length - 1)
                  const Divider(
                    height: AppSpacing.dividerHairline,
                    thickness: AppSpacing.dividerHairline,
                    color: AppColors.divider,
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _TrendingSection extends StatelessWidget {
  const _TrendingSection({required this.pairs, required this.onNavigate});

  final List<HomeCryptoPair> pairs;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitSectionHeader(
          title: 'Xu hướng',
          icon: Icons.bolt_rounded,
          iconColor: AppColors.warn,
          actionLabel: 'Xem tất cả',
          onAction: () => onNavigate('/markets'),
        ),
        const SizedBox(height: AppSpacing.x3),
        SizedBox(
          height: _trendCardExtent,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: pairs.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.x3),
            itemBuilder: (context, index) {
              final pair = pairs[index];
              return SizedBox(
                width: _trendCardWidth,
                child: VitCard(
                  onTap: () => onNavigate('/pair/${pair.id}'),
                  padding: AppSpacing.cardPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          VitAssetAvatar(
                            label: pair.baseAsset,
                            accentColor: pair.logoColor,
                            size: _assetAvatarExtent,
                            radius: AppRadii.xsRadius,
                          ),
                          const SizedBox(width: AppSpacing.x3),
                          Expanded(
                            child: Text(
                              pair.baseAsset,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.body.copyWith(
                                fontWeight: AppTextStyles.medium,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.x3),
                      Text(
                        _formatUsd(pair.price),
                        style: AppTextStyles.base.copyWith(
                          fontWeight: AppTextStyles.bold,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        _formatPct(pair.change24h),
                        style: AppTextStyles.micro.copyWith(
                          color: pair.change24h >= 0
                              ? AppColors.buy
                              : AppColors.sell,
                          fontWeight: AppTextStyles.medium,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _RankedListSection extends StatelessWidget {
  const _RankedListSection({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.pairs,
    required this.positive,
    required this.onNavigate,
  });

  final String title;
  final IconData icon;
  final Color iconColor;
  final List<HomeCryptoPair> pairs;
  final bool positive;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitSectionHeader(
          title: title,
          icon: icon,
          iconColor: iconColor,
          actionLabel: 'Xem tất cả',
          onAction: () => onNavigate('/markets'),
        ),
        const SizedBox(height: AppSpacing.x3),
        VitCard(
          clip: true,
          child: Column(
            children: [
              for (var i = 0; i < pairs.length; i++) ...[
                _RankedRow(
                  rank: i + 1,
                  pair: pairs[i],
                  positive: positive,
                  onTap: () => onNavigate('/pair/${pairs[i].id}'),
                ),
                if (i < pairs.length - 1)
                  const Divider(
                    height: AppSpacing.dividerHairline,
                    thickness: AppSpacing.dividerHairline,
                    color: AppColors.divider,
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _MarketRow extends StatelessWidget {
  const _MarketRow({
    required this.pair,
    required this.showSparkline,
    required this.onTap,
  });

  final HomeCryptoPair pair;
  final bool showSparkline;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final trend = pair.change24h >= 0
        ? VitTrendDirection.positive
        : VitTrendDirection.negative;

    return VitMarketPairRow(
      leading: VitAssetAvatar(
        label: pair.baseAsset,
        accentColor: pair.logoColor,
      ),
      title: pair.symbol,
      subtitle: 'Vol \$${_formatBillions(pair.volume24h)}B',
      price: _formatUsd(pair.price),
      changeLabel: _formatPct(pair.change24h),
      trend: trend,
      sparkline: pair.sparkline,
      showSparkline: showSparkline,
      onTap: onTap,
    );
  }
}
