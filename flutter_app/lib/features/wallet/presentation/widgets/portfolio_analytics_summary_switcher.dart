part of '../pages/portfolio_analytics_page.dart';

class _ValueSummary extends StatelessWidget {
  const _ValueSummary({required this.snapshot});

  final WalletPortfolioAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      variant: VitCardVariant.hero,
      radius: VitCardRadius.lg,
      borderColor: _analyticsPrimary.withValues(alpha: .32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'T\u1ED5ng gi\u00E1 tr\u1ECB danh m\u1EE5c',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x2),
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
          const SizedBox(height: AppSpacing.x2),
          Row(
            children: [
              SizedBox(
                width: AppSpacing.walletAnalyticsReturnPillWidth,
                child: VitMetricDeltaPill(
                  label:
                      '+${_formatUsd(snapshot.totalReturnUsd, symbol: false)} (+${snapshot.totalReturnPct.toStringAsFixed(2)}%)',
                  tone: VitMetricDeltaTone.positive,
                  icon: Icons.trending_up_rounded,
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
          const SizedBox(height: AppSpacing.x2),
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
    return VitCard(
      density: VitDensity.compact,
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.sm,
      background: ColoredBox(color: AppColors.onAccent.withValues(alpha: .055)),
      clip: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
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

    return VitCard(
      padding: const EdgeInsetsDirectional.all(AppSpacing.x1),
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      child: Row(
        children: [
          for (final item in items)
            Expanded(
              child: VitCard(
                key: PortfolioAnalyticsPage.viewKey(item.id),
                onTap: () => onChanged(item.id),
                alignment: Alignment.center,
                variant: VitCardVariant.ghost,
                radius: VitCardRadius.md,
                padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: AppSpacing.x2,
                  vertical: AppSpacing.x2,
                ),
                background: ColoredBox(
                  color: active == item.id
                      ? _analyticsPrimary.withValues(alpha: .18)
                      : AppColors.transparent,
                ),
                clip: true,
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
        ],
      ),
    );
  }
}
