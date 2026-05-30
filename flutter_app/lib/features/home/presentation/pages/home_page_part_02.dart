part of 'home_page.dart';

class _HomeDiscoverySection extends StatelessWidget {
  const _HomeDiscoverySection({required this.onNavigate});

  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionHeader(title: 'Dự đoán & Thách đấu'),
        const SizedBox(height: AppSpacing.x4),
        _DiscoveryCard(
          title: 'Prediction Markets',
          badge: 'Prediction Market',
          subtitle: 'Thị trường xác suất, vị thế và portfolio',
          actionLabel: 'Khám phá thị trường',
          icon: Icons.adjust_rounded,
          color: AppColors.accent,
          border: AppColors.accent20,
          background: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.accent15, AppColors.primary08],
          ),
          onTap: () => onNavigate('/markets/predictions'),
        ),
        const SizedBox(height: 10),
        _DiscoveryCard(
          title: 'Open Arena',
          badge: 'Arena Points only',
          subtitle: 'Tạo mode chơi, mở room, dùng Arena Points',
          actionLabel: 'Vào Arena',
          icon: Icons.sports_esports_outlined,
          color: AppColors.warn,
          border: AppColors.warningBorder,
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
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 9,
          ),
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
        _SectionHeader(
          title: 'Thị trường',
          actionLabel: 'Xem tất cả',
          onAction: () => onNavigate('/markets'),
        ),
        const SizedBox(height: AppSpacing.x4),
        VitTabBar(
          activeKey: activeTab,
          onChanged: onTabChanged,
          tabs: const [
            VitTabItem(key: 'hot', label: '🔥 Hot'),
            VitTabItem(key: 'gainers', label: '📈 Tăng'),
            VitTabItem(key: 'losers', label: '📉 Giảm'),
            VitTabItem(key: 'new', label: '🆕 Mới'),
          ],
        ),
        const SizedBox(height: AppSpacing.x4),
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
                    height: 1,
                    thickness: 1,
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
        _SectionHeader(
          title: 'Xu hướng',
          icon: Icons.bolt_rounded,
          iconColor: AppColors.warn,
          actionLabel: 'Xem tất cả',
          onAction: () => onNavigate('/markets'),
        ),
        const SizedBox(height: AppSpacing.x4),
        SizedBox(
          height: 128,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: pairs.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final pair = pairs[index];
              return SizedBox(
                width: 148,
                child: VitCard(
                  onTap: () => onNavigate('/pair/${pair.id}'),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _CoinAvatar(
                            pair: pair,
                            size: 28,
                            radius: AppRadii.xs,
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
                      const Spacer(),
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
        _SectionHeader(
          title: title,
          icon: icon,
          iconColor: iconColor,
          actionLabel: 'Xem tất cả',
          onAction: () => onNavigate('/markets'),
        ),
        const SizedBox(height: AppSpacing.x4),
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
                    height: 1,
                    thickness: 1,
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

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    this.icon,
    this.iconColor,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final IconData? icon;
  final Color? iconColor;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            color: iconColor ?? AppColors.text1,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: 6),
        ],
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.sectionTitle.copyWith(
              fontWeight: AppTextStyles.bold,
              height: 1.2,
            ),
          ),
        ),
        if (actionLabel != null && onAction != null)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onAction,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.x3,
                vertical: AppSpacing.x2,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    actionLabel!,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: AppTextStyles.medium,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x1),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.primary,
                    size: 14,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _DiscoveryCard extends StatelessWidget {
  const _DiscoveryCard({
    required this.title,
    required this.badge,
    required this.subtitle,
    required this.actionLabel,
    required this.icon,
    required this.color,
    required this.border,
    required this.background,
    required this.onTap,
  });

  final String title;
  final String badge;
  final String subtitle;
  final String actionLabel;
  final IconData icon;
  final Color color;
  final Color border;
  final Gradient background;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      onTap: onTap,
      borderColor: border,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: background,
              borderRadius: AppRadii.mdRadius,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: AppSpacing.x3,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    VitStatusPill(
                      label: badge,
                      status: color == AppColors.warn
                          ? VitStatusPillStatus.warning
                          : VitStatusPillStatus.purple,
                      size: VitStatusPillSize.sm,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  actionLabel,
                  style: AppTextStyles.micro.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: color, size: 16),
        ],
      ),
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
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            _CoinAvatar(pair: pair),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pair.symbol,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: AppTextStyles.medium,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    'Vol \$${_formatBillions(pair.volume24h)}B',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ),
            if (showSparkline) ...[
              SizedBox(
                width: 64,
                height: 30,
                child: CustomPaint(
                  painter: _SparklinePainter(
                    values: pair.sparkline,
                    color: pair.change24h >= 0 ? AppColors.buy : AppColors.sell,
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
            SizedBox(
              width: 85,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatUsd(pair.price),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: AppTextStyles.medium,
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
          ],
        ),
      ),
    );
  }
}
