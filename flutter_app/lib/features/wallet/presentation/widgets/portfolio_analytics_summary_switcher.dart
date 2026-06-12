part of '../pages/portfolio_analytics_page.dart';

class _ValueSummary extends StatelessWidget {
  const _ValueSummary({required this.snapshot});

  final WalletPortfolioAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSpacing.walletAnalyticsSummaryHeight,
      padding: AppSpacing.walletAnalyticsSummaryPadding,
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
            'T\u1ED5ng gi\u00E1 tr\u1ECB danh m\u1EE5c',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.walletAnalyticsSummaryGap),
          SizedBox(
            width: double.infinity,
            child: FittedBox(
              alignment: Alignment.centerLeft,
              fit: BoxFit.scaleDown,
              child: Text(
                _formatUsd(snapshot.totalUsd),
                maxLines: 1,
                style: AppTextStyles.heroNumber.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.walletAnalyticsSummaryGap),
          Row(
            children: [
              SizedBox(
                width: AppSpacing.walletAnalyticsReturnPillWidth,
                child: Container(
                  height: AppSpacing.walletAnalyticsReturnPillHeight,
                  padding: AppSpacing.walletAnalyticsReturnPillPadding,
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
                        size: AppSpacing.walletAnalyticsReturnPillIcon,
                      ),
                      const SizedBox(
                        width: AppSpacing.walletAnalyticsReturnPillGap,
                      ),
                      Expanded(
                        child: Text(
                          '+${_formatUsd(snapshot.totalReturnUsd, symbol: false)} (+${snapshot.totalReturnPct.toStringAsFixed(2)}%)',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.micro.copyWith(
                            color: _analyticsGreen,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.walletAnalyticsReturnMetaGap),
              Expanded(
                child: Text(
                  'so v\u1EDBi \u0111\u1EA7u k\u1EF3',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: _QuickStat(
                  label: 'L\u1EE3i nhu\u1EADn t\u1ED1t nh\u1EA5t',
                  value: '+\$${_formatCompactMoney(snapshot.bestProfitUsd)}',
                  sub: snapshot.bestProfitAsset,
                  color: _analyticsGreen,
                ),
              ),
              const SizedBox(width: AppSpacing.walletAnalyticsQuickStatGap),
              Expanded(
                child: _QuickStat(
                  label: 'Thua l\u1ED7 nh\u1EA5t',
                  value:
                      '-\$${_formatCompactMoney(snapshot.worstLossUsd.abs())}',
                  sub: snapshot.worstLossAsset,
                  color: _analyticsRed,
                ),
              ),
              const SizedBox(width: AppSpacing.walletAnalyticsQuickStatGap),
              Expanded(
                child: _QuickStat(
                  label: 'T\u00E0i s\u1EA3n',
                  value: '${snapshot.assets.length}',
                  sub: 'lo\u1EA1i coin',
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
      height: AppSpacing.walletAnalyticsQuickStatHeight,
      padding: AppSpacing.walletAnalyticsQuickStatPadding,
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
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.walletAnalyticsQuickStatTextGap),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.walletAnalyticsQuickStatTextGap),
          Text(
            sub,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text2),
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
      _ViewItem('overview', 'T\u1ED5ng quan', Icons.bar_chart_rounded),
      _ViewItem(
        'allocation',
        'Ph\u00E2n b\u1ED5',
        Icons.pie_chart_outline_rounded,
      ),
      _ViewItem('pnl', 'L\u00E3i/L\u1ED7', Icons.trending_up_rounded),
    ];

    return Container(
      height: AppSpacing.walletAnalyticsSwitcherHeight,
      padding: AppSpacing.walletAnalyticsSwitcherPadding,
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
                        size: AppSpacing.walletAnalyticsSwitcherIcon,
                      ),
                      const SizedBox(
                        width: AppSpacing.walletAnalyticsSwitcherIconGap,
                      ),
                      Flexible(
                        child: Text(
                          item.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.micro.copyWith(
                            color: active == item.id
                                ? _analyticsPrimary
                                : AppColors.text2,
                            fontWeight: AppTextStyles.bold,
                          ),
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
