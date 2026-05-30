part of 'market_overview_page.dart';

class _FearGreedHistory extends StatelessWidget {
  const _FearGreedHistory({required this.points});

  final List<FearGreedPoint> points;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Lịch sử Fear & Greed (7 ngày)',
      accentColor: AppColors.primarySoft,
      children: [
        VitCard(
          height: 128,
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (var i = 0; i < points.length; i++) ...[
                      Expanded(
                        child: _HistoryBar(
                          point: points[i],
                          active: i == points.length - 1,
                        ),
                      ),
                      if (i < points.length - 1) const SizedBox(width: 4),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '7 ngày trước',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontSize: 8,
                      height: 1,
                    ),
                  ),
                  Text(
                    'Hôm nay',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontSize: 8,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HistoryBar extends StatelessWidget {
  const _HistoryBar({required this.point, required this.active});

  final FearGreedPoint point;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final height = point.value / 100 * 64;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '${point.value}',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 8,
            fontFeatures: AppTextStyles.tabularFigures,
            height: 1,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: height,
          decoration: BoxDecoration(
            color: _fearGreedColor(
              point.value,
            ).withValues(alpha: active ? 1 : 0.62),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
          ),
        ),
      ],
    );
  }
}

class _MarketTools extends StatelessWidget {
  const _MarketTools();

  @override
  Widget build(BuildContext context) {
    const tools = [
      _MarketTool(
        buttonKey: MarketOverviewPage.watchlistToolKey,
        label: 'Danh sách theo dõi',
        icon: Icons.star_rounded,
        color: AppColors.primarySoft,
        route: '/markets/watchlist',
      ),
      _MarketTool(
        buttonKey: MarketOverviewPage.alertsToolKey,
        label: 'Cảnh báo giá',
        icon: Icons.notifications_rounded,
        color: AppColors.primarySoft,
        route: '/markets/alerts',
      ),
      _MarketTool(
        buttonKey: MarketOverviewPage.heatmapToolKey,
        label: 'Biểu đồ nhiệt',
        icon: Icons.map_rounded,
        color: AppAssetColors.cyanChain,
        route: '/markets/heatmap',
      ),
      _MarketTool(
        buttonKey: MarketOverviewPage.marketListToolKey,
        label: 'Danh sách thị trường',
        icon: Icons.article_rounded,
        color: AppColors.caution,
        route: AppRoutePaths.markets,
      ),
    ];

    return VitPageSection(
      label: 'Công cụ thị trường',
      accentColor: _marketPrimary,
      children: [
        Column(
          children: [
            Row(
              children: [
                Expanded(child: tools[0]),
                const SizedBox(width: 8),
                Expanded(child: tools[1]),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: tools[2]),
                const SizedBox(width: 8),
                Expanded(child: tools[3]),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _MarketTool extends StatelessWidget {
  const _MarketTool({
    required this.buttonKey,
    required this.label,
    required this.icon,
    required this.color,
    required this.route,
  }) : super(key: buttonKey);

  final Key buttonKey;
  final String label;
  final IconData icon;
  final Color color;
  final String route;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      onTap: () => context.go(route),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body.copyWith(
                fontWeight: AppTextStyles.bold,
                height: 1.15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniHeader extends StatelessWidget {
  const _MiniHeader({
    required this.icon,
    required this.color,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 14),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontSize: 12,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
        ),
      ],
    );
  }
}

class _IconBubble extends StatelessWidget {
  const _IconBubble({
    required this.icon,
    required this.color,
    required this.size,
    required this.iconSize,
  });

  final IconData icon;
  final Color color;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(size / 3.2),
      ),
      alignment: Alignment.center,
      child: Icon(icon, color: color, size: iconSize),
    );
  }
}

class _ChangePill extends StatelessWidget {
  const _ChangePill({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    final positive = value >= 0;
    final color = positive ? AppColors.buy : AppColors.sell;
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(
        '${positive ? '▲' : '▼'} ${value.abs().toStringAsFixed(2)}%',
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontSize: 12,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

Color _fearGreedColor(int value) {
  if (value <= 25) return AppColors.sell;
  if (value <= 45) return AppColors.primarySoft;
  if (value <= 55) return AppAssetColors.neutralChain;
  if (value <= 75) return AppColors.buy;
  return AppColors.buyDark;
}

String _formatCompact(double value, {String prefix = ''}) {
  if (value >= 1000000000) {
    return '$prefix${_formatFixed(value / 1000000000, 2)}B';
  }
  if (value >= 1000000) {
    return '$prefix${_formatFixed(value / 1000000, 2)}M';
  }
  if (value >= 1000) {
    return '$prefix${_formatFixed(value / 1000, 2)}K';
  }
  return '$prefix${_formatFixed(value, 2)}';
}

String _formatPrice(double value) {
  if (value >= 1) {
    return _formatFixed(value, 2);
  }
  if (value >= 0.01) {
    return _formatFixed(value, 4);
  }
  return _formatFixed(value, 6);
}

String _formatFixed(double value, int decimals) {
  final fixed = value.toStringAsFixed(decimals);
  final parts = fixed.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final fromEnd = whole.length - i;
    buffer.write(whole[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
  }
  return '${buffer.toString()}.${parts.last}';
}

String _formatSignedPercent(double value) {
  final sign = value > 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(2)}%';
}

String _formatInt(int value) {
  final raw = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final fromEnd = raw.length - i;
    buffer.write(raw[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
  }
  return buffer.toString();
}
