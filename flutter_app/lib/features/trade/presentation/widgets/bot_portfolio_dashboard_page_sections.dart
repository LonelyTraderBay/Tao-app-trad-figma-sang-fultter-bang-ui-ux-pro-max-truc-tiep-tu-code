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
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.53,
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
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(data.icon, color: data.iconColor, size: 21),
          const SizedBox(height: 8),
          Text(
            data.label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              fontSize: 11,
              height: 1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            data.value,
            style: AppTextStyles.baseMedium.copyWith(
              color: data.valueColor,
              fontSize: 20,
              fontFamily: 'Roboto',
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1,
            ),
          ),
          if (data.caption != null) ...[
            const SizedBox(height: 4),
            Text(
              data.caption!,
              style: AppTextStyles.micro.copyWith(
                color: data.captionColor,
                fontSize: 11,
                fontFamily: 'Roboto',
                height: 1,
              ),
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
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: SizedBox(
        height: 180,
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
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 9),
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: CustomPaint(
              painter: _DonutPainter(allocations),
              size: Size.infinite,
            ),
          ),
          const SizedBox(height: 6),
          GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 4.8,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
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
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: Color(item.colorHex),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
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
                  fontSize: 11,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '\$${item.value.toStringAsFixed(0)}',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 9,
                  fontFamily: 'Roboto',
                  height: 1,
                ),
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
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 17),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(child: _TableHeaderText('Bot', alignLeft: true)),
              for (final header in headers)
                SizedBox(width: 74, child: _TableHeaderText(header)),
            ],
          ),
          const SizedBox(height: 13),
          for (final row in rows) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    row.bot,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text1,
                      fontSize: 11,
                      fontWeight: AppTextStyles.bold,
                      height: 1,
                    ),
                  ),
                ),
                for (final header in headers)
                  SizedBox(
                    width: 74,
                    child: Center(
                      child: _CorrelationPill(value: row.values[header] ?? 0),
                    ),
                  ),
              ],
            ),
            if (row != rows.last) const SizedBox(height: 14),
          ],
          const SizedBox(height: 15),
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: 'Low correlation (<0.2) = Good diversification ',
                ),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: const BoxDecoration(
                      color: _portfolioGreen,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 10,
              height: 1,
            ),
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
        fontSize: 10,
        fontWeight: AppTextStyles.bold,
        height: 1,
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        value.toStringAsFixed(2),
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 12,
          fontWeight: AppTextStyles.bold,
          fontFamily: 'Roboto',
          height: 1,
        ),
      ),
    );
  }
}
