part of '../pages/bot_portfolio_dashboard_page.dart';

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({required this.summary});

  final TradeBotPortfolioSummary summary;

  @override
  Widget build(BuildContext context) {
    final cards = [
      _SummaryCardData(
        icon: Icons.account_balance_wallet_outlined,
        iconColor: _portfolioPrimary,
        label: 'Total Equity',
        value: _formatUsd(summary.totalEquity),
      ),
      _SummaryCardData(
        icon: Icons.trending_up_rounded,
        iconColor: _portfolioGreen,
        label: 'Total PnL',
        value: '+\$${summary.totalPnl.toStringAsFixed(0)}',
        valueColor: _portfolioGreen,
        caption: '+${summary.pnlPercent.toStringAsFixed(1)}%',
        captionColor: _portfolioGreen,
      ),
      _SummaryCardData(
        icon: Icons.show_chart_rounded,
        iconColor: _portfolioPrimary,
        label: 'Portfolio Sharpe',
        value: summary.portfolioSharpe.toStringAsFixed(2),
        caption: 'Excellent',
        captionColor: _portfolioGreen,
      ),
      _SummaryCardData(
        icon: Icons.pie_chart_outline_rounded,
        iconColor: _portfolioAmber,
        label: 'Diversification',
        value: '${summary.diversificationScore}/100',
        caption: 'Good',
        captionColor: _portfolioAmber,
      ),
    ];

    return GridView.count(
      crossAxisCount: AppSpacing.tradeBotGridColumns,
      crossAxisSpacing: AppSpacing.tradeBotCardGap,
      mainAxisSpacing: AppSpacing.tradeBotCardGap,
      childAspectRatio: AppSpacing.tradeBotPortfolioMetricAspectRatio,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [for (final card in cards) _SummaryCard(data: card)],
    );
  }
}

class _SummaryCardData {
  const _SummaryCardData({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
    this.caption,
    this.captionColor = AppColors.text3,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Color valueColor;
  final String? caption;
  final Color captionColor;
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.data});

  final _SummaryCardData data;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.tradeBotCardPaddingLoose,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(data.icon, color: data.iconColor, size: 21),
          const SizedBox(height: AppSpacing.tradeBotSmallGap),
          Text(
            data.label,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.tradeBotTinyGap),
          Text(
            data.value,
            style: AppTextStyles.baseMedium.copyWith(
              color: data.valueColor,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          if (data.caption != null) ...[
            const SizedBox(height: AppSpacing.x1),
            Text(
              data.caption!,
              style: AppTextStyles.micro.copyWith(color: data.captionColor),
            ),
          ],
        ],
      ),
    );
  }
}

class _EquityCard extends StatelessWidget {
  const _EquityCard({required this.points});

  final List<TradeBotPortfolioEquityPoint> points;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.tradeBotCardPadding,
      child: SizedBox(
        height: AppSpacing.tradeBotDashboardChartHeight,
        child: CustomPaint(
          painter: _EquityPainter(points),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _AllocationCard extends StatelessWidget {
  const _AllocationCard({required this.allocations});

  final List<TradeBotPortfolioAllocation> allocations;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.tradeBotCardPadding,
      child: Column(
        children: [
          SizedBox(
            height: AppSpacing.tradeBotDistributionChartHeight,
            child: CustomPaint(
              painter: _DonutPainter(allocations),
              size: Size.infinite,
            ),
          ),
          const SizedBox(height: AppSpacing.tradeBotTinyGap),
          GridView.count(
            crossAxisCount: AppSpacing.tradeBotGridColumns,
            childAspectRatio: AppSpacing.tradeBotAllocationLegendAspectRatio,
            crossAxisSpacing: AppSpacing.tradeBotSmallGap,
            mainAxisSpacing: AppSpacing.tradeBotSmallGap,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              for (final item in allocations) _AllocationLegend(item: item),
            ],
          ),
        ],
      ),
    );
  }
}

class _AllocationLegend extends StatelessWidget {
  const _AllocationLegend({required this.item});

  final TradeBotPortfolioAllocation item;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.circle,
          color: Color(item.colorHex),
          size: AppSpacing.tradeBotCardGap,
        ),
        const SizedBox(width: AppSpacing.tradeBotSmallGap),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                item.strategy,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.tradeBotTinyGap),
              Text(
                '\$${item.value.toStringAsFixed(0)}',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CorrelationCard extends StatelessWidget {
  const _CorrelationCard({required this.rows});

  final List<TradeBotCorrelationRow> rows;

  @override
  Widget build(BuildContext context) {
    final headers = rows.map((row) => row.bot).toList();
    return VitCard(
      padding: AppSpacing.tradeBotCardPaddingTall,
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(child: _TableHeaderText('Bot', alignLeft: true)),
              for (final header in headers)
                SizedBox(
                  width: AppSpacing.tradeBotCorrelationColumnWidth,
                  child: _TableHeaderText(header),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.tradeBotCardGap),
          for (final row in rows) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    row.bot,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                for (final header in headers)
                  SizedBox(
                    width: AppSpacing.tradeBotCorrelationColumnWidth,
                    child: Center(
                      child: _CorrelationPill(value: row.values[header] ?? 0),
                    ),
                  ),
              ],
            ),
            if (row != rows.last)
              const SizedBox(height: AppSpacing.tradeBotPageTopGap),
          ],
          const SizedBox(height: AppSpacing.tradeBotPageTopGap),
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: 'Low correlation (<0.2) = Good diversification ',
                ),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Icon(
                    Icons.circle,
                    color: _portfolioGreen,
                    size: AppSpacing.tradeBotCorrelationLegendDot,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _TableHeaderText extends StatelessWidget {
  const _TableHeaderText(this.text, {this.alignLeft = false});

  final String text;
  final bool alignLeft;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: alignLeft ? TextAlign.left : TextAlign.center,
      style: AppTextStyles.micro.copyWith(
        color: AppColors.text3,
        fontWeight: AppTextStyles.bold,
      ),
    );
  }
}

class _CorrelationPill extends StatelessWidget {
  const _CorrelationPill({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    final color = value.abs() < .2
        ? _portfolioGreen
        : value.abs() < .5
        ? _portfolioAmber
        : _portfolioRed;
    return VitAccentPill(
      label: value.toStringAsFixed(2),
      accentColor: color,
      semanticStatus: value.abs() < .2
          ? VitStatusPillStatus.success
          : VitStatusPillStatus.warning,
    );
  }
}
