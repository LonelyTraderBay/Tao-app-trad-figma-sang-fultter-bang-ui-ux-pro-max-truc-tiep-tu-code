part of 'advanced_analytics_page.dart';

class _RiskAnalysisTab extends StatelessWidget {
  const _RiskAnalysisTab({required this.snapshot});

  final TradeAdvancedAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final risk = snapshot.risk;
    return Column(
      children: [
        _Card(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _SectionHeader(
                icon: Icons.shield_outlined,
                color: _advancedAmber,
                title: 'Portfolio Risk Analyzer',
                subtitle: 'VaR, Sharpe Ratio, Max Drawdown, Beta',
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _advancedPanel2,
                  borderRadius: AppRadii.cardRadius,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.shield_outlined,
                      color: _advancedAmber,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
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
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${risk.riskScore}',
                      style: AppTextStyles.heroNumber.copyWith(
                        color: _advancedAmber,
                        fontSize: 34,
                        height: 1,
                      ),
                    ),
                    Text(
                      '/100',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _MetricBox(
                      label: 'VaR 95%',
                      value: '${risk.var95.toStringAsFixed(1)}%',
                      valueColor: _advancedAmber,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _MetricBox(
                      label: 'Sharpe',
                      value: risk.sharpeRatio.toStringAsFixed(2),
                      valueColor: _advancedGreen,
                    ),
                  ),
                  const SizedBox(width: 8),
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
        const SizedBox(height: 12),
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
    return Column(
      children: [
        _Card(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _SectionHeader(
                icon: Icons.menu_book_rounded,
                color: _advancedGreen,
                title: 'Trade Journal',
                subtitle: 'Detailed tracking and performance attribution',
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _MetricBox(
                      label: 'Win Rate',
                      value: '${journal.winRate.toStringAsFixed(1)}%',
                      valueColor: _advancedGreen,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _MetricBox(
                      label: 'Trades',
                      value: '${journal.totalTrades}',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _MetricBox(
                      label: 'Total PnL',
                      value: '+\$${_formatCompact(journal.totalPnl)}',
                      valueColor: _advancedGreen,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _MetricBox(
                      label: 'Avg Win',
                      value: '+\$${journal.avgWin.toStringAsFixed(0)}',
                      valueColor: _advancedGreen,
                    ),
                  ),
                  const SizedBox(width: 8),
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
        const SizedBox(height: 12),
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
    return Column(
      children: [
        _Card(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _SectionHeader(
                icon: Icons.calculate_outlined,
                color: _advancedAmber,
                title: 'Position Sizing Calculator',
                subtitle: 'Kelly Criterion optimization',
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _MetricBox(
                      label: 'Balance',
                      value: '\$${_formatCompact(sizing.accountBalance)}',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _MetricBox(
                      label: 'Risk',
                      value: '${sizing.recommendedRiskPct.toStringAsFixed(0)}%',
                      valueColor: _advancedAmber,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _MetricBox(
                      label: 'Max Loss',
                      value: '\$${riskAmount.toStringAsFixed(0)}',
                      valueColor: _advancedRed,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _MetricBox(
                label: 'Suggested Position Size',
                value: '${sizing.positionSize.toStringAsFixed(2)} BTC',
                valueColor: _advancedPrimary,
                alignLeft: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
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
      padding: const EdgeInsets.fromLTRB(20, 19, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'P3 Features Included',
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
          const SizedBox(height: 14),
          GridView.builder(
            itemCount: features.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 38,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 9),
                decoration: BoxDecoration(
                  color: _advancedPanel2,
                  borderRadius: AppRadii.cardRadius,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: _advancedGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        features[index],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text2,
                          fontSize: 10,
                          height: 1.2,
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
    this.iconSize = 22,
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
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withValues(alpha: .12),
            borderRadius: AppRadii.cardRadius,
          ),
          child: Icon(icon, color: color, size: iconSize),
        ),
        const SizedBox(width: 12),
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
                  fontSize: 18,
                  fontWeight: AppTextStyles.bold,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text3,
                  fontSize: 12,
                  height: 1.25,
                ),
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
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .09),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontSize: 12,
                    fontWeight: AppTextStyles.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  body,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 10,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
