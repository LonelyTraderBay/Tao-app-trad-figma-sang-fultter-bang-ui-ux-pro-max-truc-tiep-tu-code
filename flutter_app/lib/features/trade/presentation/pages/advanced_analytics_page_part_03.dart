part of 'advanced_analytics_page.dart';

class _RiskAnalysisTab extends StatelessWidget {
  const _RiskAnalysisTab({required this.snapshot});

  final TradeAdvancedAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final risk = snapshot.risk;
    return VitPageContent(
      padding: VitContentPadding.none,
      fullBleed: true,
      density: VitDensity.compact,
      children: [
        _Card(
          child: VitPageContent(
            padding: VitContentPadding.none,
            fullBleed: true,
            density: VitDensity.compact,
            children: [
              const _SectionHeader(
                icon: Icons.shield_outlined,
                color: _advancedAmber,
                title: 'Portfolio Risk Analyzer',
                subtitle: 'VaR, Sharpe Ratio, Max Drawdown, Beta',
              ),
              VitCard(
                variant: VitCardVariant.inner,
                density: VitDensity.compact,
                child: Row(
                  children: [
                    const Icon(
                      Icons.shield_outlined,
                      color: _advancedAmber,
                      size: AppSpacing.tradeBotClientCategoryHeroIconGlyph,
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Risk Score',
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                          Text(
                            '${risk.riskLevel} risk',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${risk.riskScore}',
                      style: AppTextStyles.heroNumber.copyWith(
                        color: _advancedAmber,
                      ),
                    ),
                    Text(
                      '/100',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: _MetricBox(
                      label: 'VaR 95%',
                      value: '${risk.var95.toStringAsFixed(1)}%',
                      valueColor: _advancedAmber,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: _MetricBox(
                      label: 'Sharpe',
                      value: risk.sharpeRatio.toStringAsFixed(2),
                      valueColor: _advancedGreen,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: _MetricBox(
                      label: 'Max DD',
                      value: '${risk.maxDrawdown.toStringAsFixed(1)}%',
                      valueColor: _advancedRed,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const _InfoCard(
          color: _advancedPrimary,
          icon: Icons.shield_outlined,
          title: 'Enterprise Risk Management',
          body:
              'VaR calculated using Monte Carlo simulation. Sharpe and Sortino ratios update daily with a 30-day rolling window.',
        ),
      ],
    );
  }
}

class _TradeJournalTab extends StatelessWidget {
  const _TradeJournalTab({required this.snapshot});

  final TradeAdvancedAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final journal = snapshot.journal;
    return VitPageContent(
      padding: VitContentPadding.none,
      fullBleed: true,
      density: VitDensity.compact,
      children: [
        _Card(
          child: VitPageContent(
            padding: VitContentPadding.none,
            fullBleed: true,
            density: VitDensity.compact,
            children: [
              const _SectionHeader(
                icon: Icons.menu_book_rounded,
                color: _advancedGreen,
                title: 'Trade Journal',
                subtitle: 'Detailed tracking and performance attribution',
              ),
              Row(
                children: [
                  Expanded(
                    child: _MetricBox(
                      label: 'Win Rate',
                      value: '${journal.winRate.toStringAsFixed(1)}%',
                      valueColor: _advancedGreen,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: _MetricBox(
                      label: 'Trades',
                      value: '${journal.totalTrades}',
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: _MetricBox(
                      label: 'Total PnL',
                      value: '+\$${_formatCompact(journal.totalPnl)}',
                      valueColor: _advancedGreen,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: _MetricBox(
                      label: 'Avg Win',
                      value: '+\$${journal.avgWin.toStringAsFixed(0)}',
                      valueColor: _advancedGreen,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: _MetricBox(
                      label: 'Avg Loss',
                      value: '-\$${journal.avgLoss.toStringAsFixed(0)}',
                      valueColor: _advancedRed,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const _InfoCard(
          color: _advancedGreen,
          icon: Icons.menu_book_rounded,
          title: 'Performance Attribution',
          body:
              'Automatic trade tagging, setup classification, pattern recognition and export-ready analytics.',
        ),
      ],
    );
  }
}

class _PositionSizingTab extends StatelessWidget {
  const _PositionSizingTab({required this.snapshot});

  final TradeAdvancedAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final sizing = snapshot.sizing;
    final riskAmount = sizing.accountBalance * sizing.recommendedRiskPct / 100;
    return VitPageContent(
      padding: VitContentPadding.none,
      fullBleed: true,
      density: VitDensity.compact,
      children: [
        _Card(
          child: VitPageContent(
            padding: VitContentPadding.none,
            fullBleed: true,
            density: VitDensity.compact,
            children: [
              const _SectionHeader(
                icon: Icons.calculate_outlined,
                color: _advancedAmber,
                title: 'Position Sizing Calculator',
                subtitle: 'Kelly Criterion optimization',
              ),
              Row(
                children: [
                  Expanded(
                    child: _MetricBox(
                      label: 'Balance',
                      value: '\$${_formatCompact(sizing.accountBalance)}',
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: _MetricBox(
                      label: 'Risk',
                      value: '${sizing.recommendedRiskPct.toStringAsFixed(0)}%',
                      valueColor: _advancedAmber,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: _MetricBox(
                      label: 'Max Loss',
                      value: '\$${riskAmount.toStringAsFixed(0)}',
                      valueColor: _advancedRed,
                    ),
                  ),
                ],
              ),
              _MetricBox(
                label: 'Suggested Position Size',
                value: '${sizing.positionSize.toStringAsFixed(2)} BTC',
                valueColor: _advancedPrimary,
                alignLeft: true,
              ),
            ],
          ),
        ),
        const _InfoCard(
          color: _advancedAmber,
          icon: Icons.calculate_outlined,
          title: 'Kelly Criterion Optimization',
          body:
              'Kelly percent is capped at half-Kelly for safety and adjusted by your actual win rate and R:R ratio.',
        ),
      ],
    );
  }
}

class _ModelInfoCard extends StatelessWidget {
  const _ModelInfoCard();

  @override
  Widget build(BuildContext context) {
    return const _InfoCard(
      color: _advancedPurple,
      icon: Icons.psychology_rounded,
      title: 'AI Model: GPT-4 + TradingView Integration',
      body:
          'Signals generated using technical indicators, on-chain data, sentiment analysis and volume profiling.',
    );
  }
}

class _FeaturesCard extends StatelessWidget {
  const _FeaturesCard({required this.features});

  final List<String> features;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: VitPageContent(
        padding: VitContentPadding.none,
        fullBleed: true,
        density: VitDensity.compact,
        children: [
          Text(
            'P3 Features Included',
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          GridView.builder(
            itemCount: features.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: AppSpacing.tradeBotGridColumns,
              mainAxisExtent:
                  AppSpacing.buttonCompact + AppSpacing.hairlineStroke * 2,
              crossAxisSpacing: AppSpacing.tradeBotSmallGap,
              mainAxisSpacing: AppSpacing.tradeBotSmallGap,
            ),
            itemBuilder: (context, index) {
              return VitCard(
                variant: VitCardVariant.inner,
                density: VitDensity.compact,
                child: Row(
                  children: [
                    const Icon(
                      Icons.circle,
                      color: _advancedGreen,
                      size: AppSpacing.x2 + AppSpacing.hairlineStroke,
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Expanded(
                      child: Text(
                        features[index],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text2,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    this.iconSize = AppSpacing.tradeBotDisputeDropdownIcon,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: AppSpacing.x4,
          backgroundColor: color.withValues(alpha: .12),
          child: Icon(icon, color: color, size: iconSize),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.baseMedium.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.color,
    required this.icon,
    required this.title,
    required this.body,
  });

  final Color color;
  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      variant: VitCardVariant.inner,
      borderColor: color.withValues(alpha: .22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: AppSpacing.ctaLoadingIcon),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  body,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
