part of '../pages/portfolio_analytics_page.dart';

class _ValueSummary extends StatelessWidget {
  const _ValueSummary({required this.snapshot});

  final WalletPortfolioAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 222,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.surface, AppColors.surface2],
        ),
        border: Border.all(color: _analyticsPrimary.withValues(alpha: .32)),
        borderRadius: AppRadii.cardLargeRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tổng giá trị danh mục',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontSize: 12,
              height: 1,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _formatUsd(snapshot.totalUsd),
            style: AppTextStyles.heroNumber.copyWith(
              color: AppColors.text1,
              fontSize: 27,
              fontWeight: FontWeight.w800,
              fontFamily: 'Roboto',
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              SizedBox(
                width: 164,
                child: Container(
                  height: 23,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: _analyticsGreen.withValues(alpha: .16),
                    borderRadius: AppRadii.mdRadius,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.trending_up_rounded,
                        color: _analyticsGreen,
                        size: 13,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '+${_formatUsd(snapshot.totalReturnUsd, symbol: false)} (+${snapshot.totalReturnPct.toStringAsFixed(2)}%)',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.micro.copyWith(
                            color: _analyticsGreen,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Roboto',
                            height: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 9),
              Text(
                'so với đầu kỳ',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 11,
                  height: 1,
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: _QuickStat(
                  label: 'Lợi nhuận tốt nhất',
                  value: '+\$${_formatCompactMoney(snapshot.bestProfitUsd)}',
                  sub: snapshot.bestProfitAsset,
                  color: _analyticsGreen,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _QuickStat(
                  label: 'Thua lỗ nhất',
                  value:
                      '-\$${_formatCompactMoney(snapshot.worstLossUsd.abs())}',
                  sub: snapshot.worstLossAsset,
                  color: _analyticsRed,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _QuickStat(
                  label: 'Tài sản',
                  value: '${snapshot.assets.length}',
                  sub: 'loại coin',
                  color: _analyticsPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickStat extends StatelessWidget {
  const _QuickStat({
    required this.label,
    required this.value,
    required this.sub,
    required this.color,
  });

  final String label;
  final String value;
  final String sub;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 74,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 7),
      decoration: BoxDecoration(
        color: AppColors.onAccent.withValues(alpha: .055),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 9,
              height: 1,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w800,
              fontFamily: 'Roboto',
              height: 1,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            sub,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              fontSize: 10,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _ViewSwitcher extends StatelessWidget {
  const _ViewSwitcher({required this.active, required this.onChanged});

  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    const items = [
      _ViewItem('overview', 'Tổng quan', Icons.bar_chart_rounded),
      _ViewItem('allocation', 'Phân bổ', Icons.pie_chart_outline_rounded),
      _ViewItem('pnl', 'Lãi/Lỗ', Icons.trending_up_rounded),
    ];

    return Container(
      height: 46,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _analyticsPanel2,
        borderRadius: AppRadii.lgRadius,
      ),
      child: Row(
        children: [
          for (final item in items)
            Expanded(
              child: GestureDetector(
                key: PortfolioAnalyticsPage.viewKey(item.id),
                onTap: () => onChanged(item.id),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: active == item.id
                        ? _analyticsPrimary.withValues(alpha: .18)
                        : AppColors.transparent,
                    borderRadius: AppRadii.cardRadius,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item.icon,
                        color: active == item.id
                            ? _analyticsPrimary
                            : AppColors.text2,
                        size: 14,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        item.label,
                        style: AppTextStyles.micro.copyWith(
                          color: active == item.id
                              ? _analyticsPrimary
                              : AppColors.text2,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
