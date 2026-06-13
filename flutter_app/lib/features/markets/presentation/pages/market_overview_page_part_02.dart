part of 'market_overview_page.dart';

class _FearGreedGaugePainter extends CustomPainter {
  const _FearGreedGaugePainter({required this.value});

  final int value;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height - 4);
    final radius = size.width / 2 - 10;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final shader = const SweepGradient(
      startAngle: math.pi,
      endAngle: math.pi * 2,
      colors: [
        AppColors.sell,
        AppColors.primarySoft,
        AppAssetColors.neutralChain,
        AppColors.buy,
        AppColors.buyDark,
      ],
    ).createShader(rect);

    final basePaint = Paint()
      ..shader = shader
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..color = AppColors.onAccent.withValues(alpha: 0.25);
    final progressPaint = Paint()
      ..shader = shader
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, math.pi, math.pi, false, basePaint);
    canvas.drawArc(
      rect,
      math.pi,
      math.pi * (value.clamp(0, 100) / 100),
      false,
      progressPaint,
    );

    final needleColor = _fearGreedColor(value);
    final angle = ((value.clamp(0, 100) / 100) * 180 - 90) * math.pi / 180;
    final needleEnd = Offset(
      center.dx + math.cos(angle) * (radius - 12),
      center.dy + math.sin(angle) * (radius - 12),
    );
    final needlePaint = Paint()
      ..color = needleColor
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(center, needleEnd, needlePaint);
    canvas.drawCircle(center, 4, Paint()..color = needleColor);
  }

  @override
  bool shouldRepaint(covariant _FearGreedGaugePainter oldDelegate) {
    return oldDelegate.value != value;
  }
}

class _QuickNavigation extends StatelessWidget {
  const _QuickNavigation();

  @override
  Widget build(BuildContext context) {
    const items = [
      _QuickNavItem(
        buttonKey: MarketOverviewPage.quickMoversKey,
        label: 'Biến động',
        icon: Icons.trending_up_rounded,
        color: AppColors.buy,
        route: AppRoutePaths.marketsMovers,
      ),
      _QuickNavItem(
        buttonKey: MarketOverviewPage.quickSectorsKey,
        label: 'Ngành',
        icon: Icons.layers_rounded,
        color: _sectorPurple,
        route: AppRoutePaths.marketsSectors,
      ),
      _QuickNavItem(
        buttonKey: MarketOverviewPage.quickHeatmapKey,
        label: 'Heatmap',
        icon: Icons.bar_chart_rounded,
        color: _marketPrimary,
        route: AppRoutePaths.marketsHeatmap,
      ),
    ];

    return Row(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          Expanded(child: items[i]),
          if (i < items.length - 1) const SizedBox(width: 8),
        ],
      ],
    );
  }
}

class _QuickNavItem extends StatelessWidget {
  const _QuickNavItem({
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
      height: 90,
      padding: const EdgeInsets.all(12),
      onTap: () => context.go(route),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _IconBubble(icon: icon, color: color, size: 40, iconSize: 18),
          const SizedBox(height: 10),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _MoversGrid extends StatelessWidget {
  const _MoversGrid({required this.movers});

  final List<MarketMover> movers;

  @override
  Widget build(BuildContext context) {
    final gainers = movers.where((mover) => mover.change24h > 0).toList()
      ..sort((a, b) => b.change24h.compareTo(a.change24h));
    final losers = movers.where((mover) => mover.change24h < 0).toList()
      ..sort((a, b) => a.change24h.compareTo(b.change24h));

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _MoverListCard(
            title: 'Tăng mạnh',
            icon: Icons.trending_up_rounded,
            color: AppColors.buy,
            movers: gainers.take(5).toList(),
            headerKey: MarketOverviewPage.topGainersKey,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MoverListCard(
            title: 'Giảm mạnh',
            icon: Icons.trending_down_rounded,
            color: AppColors.sell,
            movers: losers.take(5).toList(),
            headerKey: MarketOverviewPage.topLosersKey,
          ),
        ),
      ],
    );
  }
}

class _MoverListCard extends StatelessWidget {
  const _MoverListCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.movers,
    required this.headerKey,
  });

  final String title;
  final IconData icon;
  final Color color;
  final List<MarketMover> movers;
  final Key headerKey;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      height: 272,
      padding: const EdgeInsets.fromLTRB(12, 12, 8, 11),
      child: Column(
        children: [
          InkWell(
            key: headerKey,
            onTap: () => context.go(AppRoutePaths.marketsMovers),
            borderRadius: AppRadii.smRadius,
            child: Padding(
              padding: const EdgeInsets.only(right: 2),
              child: Row(
                children: [
                  Icon(icon, color: color, size: 14),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      title,
                      style: AppTextStyles.caption.copyWith(
                        color: color,
                        fontWeight: AppTextStyles.bold,
                        height: 1,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.text3,
                    size: 15,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          for (final mover in movers) ...[
            _QuickMoverRow(mover: mover),
            if (mover != movers.last) const SizedBox(height: 9),
          ],
        ],
      ),
    );
  }
}

class _QuickMoverRow extends StatelessWidget {
  const _QuickMoverRow({required this.mover});

  final MarketMover mover;

  @override
  Widget build(BuildContext context) {
    final positive = mover.change24h >= 0;
    final color = positive ? AppColors.buy : AppColors.sell;
    return Row(
      children: [
        Container(
          width: 25,
          height: 25,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: mover.color.withValues(alpha: 0.18),
            borderRadius: AppRadii.smRadius,
          ),
          child: Text(
            mover.symbol.substring(0, math.min(3, mover.symbol.length)),
            style: AppTextStyles.micro.copyWith(
              color: mover.color,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            mover.symbol,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body.copyWith(
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
        ),
        const SizedBox(width: 3),
        SizedBox(
          width: 34,
          child: Text(
            _formatPrice(mover.price),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1,
            ),
          ),
        ),
        const SizedBox(width: 4),
        Container(
          width: 58,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: positive ? AppColors.buy15 : AppColors.sell15,
            borderRadius: AppRadii.smRadius,
          ),
          child: Text(
            _formatSignedPercent(mover.change24h),
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
        ),
      ],
    );
  }
}

class _SectorPerformance extends StatelessWidget {
  const _SectorPerformance({required this.sectors});

  final List<MarketSector> sectors;

  @override
  Widget build(BuildContext context) {
    final topSectors = [...sectors]
      ..sort((a, b) => b.change24h.compareTo(a.change24h));

    return VitPageSection(
      label: 'Hiệu suất ngành',
      accentColor: _sectorPurple,
      children: [
        VitCard(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              for (final sector in topSectors.take(5))
                _SectorRow(
                  key: Key('sc009_sector_${sector.id}'),
                  sector: sector,
                  onTap: () => context.go(
                    '${AppRoutePaths.marketsSectors}?id=${sector.id}',
                  ),
                ),
              InkWell(
                key: MarketOverviewPage.allSectorsKey,
                onTap: () => context.go(AppRoutePaths.marketsSectors),
                borderRadius: AppRadii.smRadius,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Xem tất cả ngành',
                        style: AppTextStyles.caption.copyWith(
                          color: _marketPrimary,
                          fontWeight: AppTextStyles.bold,
                          height: 1,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: _marketPrimary,
                        size: 14,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectorRow extends StatelessWidget {
  const _SectorRow({super.key, required this.sector, required this.onTap});

  final MarketSector sector;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final positive = sector.change24h >= 0;
    final color = positive ? AppColors.buy : AppColors.sell;
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 61,
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.divider)),
        ),
        child: Row(
          children: [
            _IconBubble(
              icon: sector.icon,
              color: sector.color,
              size: 36,
              iconSize: 18,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sector.nameVi,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: AppTextStyles.bold,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${sector.coinCount} coins',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatSignedPercent(sector.change24h),
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _formatCompact(sector.totalMarketCap, prefix: r'$'),
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 7),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.text3,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
