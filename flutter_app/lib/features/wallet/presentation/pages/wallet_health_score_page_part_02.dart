part of 'wallet_health_score_page.dart';

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({
    required this.recommendation,
    required this.onTap,
  });

  final WalletHealthRecommendation recommendation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final impactColor = _impactColor(recommendation.impact);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _healthPanel,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: _healthBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  recommendation.title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
              ),
              _StatusBadge(
                label: '${recommendation.impact} impact',
                color: impactColor,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            recommendation.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 11,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            key: WalletHealthScorePage.recommendationKey(recommendation.id),
            onTap: onTap,
            behavior: HitTestBehavior.opaque,
            child: Container(
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _healthPrimary,
                borderRadius: AppRadii.cardRadius,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    recommendation.actionLabel,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.onAccent,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: AppColors.onAccent,
                    size: 14,
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

class _SecurityTab extends StatelessWidget {
  const _SecurityTab({required this.snapshot});

  final WalletHealthScoreSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final metric = snapshot.metricByCategory('Security');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ScoreSummaryCard(
          icon: Icons.shield_outlined,
          iconColor: _healthPrimary,
          title: 'Security Score',
          subtitle: 'Based on 8 security factors',
          score: metric.score,
          status: 'Good',
        ),
        const SizedBox(height: 16),
        const _SectionLabel(label: 'Security Checklist'),
        const SizedBox(height: 10),
        for (final item in snapshot.securityChecklist) ...[
          _ChecklistCard(item: item),
          if (item != snapshot.securityChecklist.last)
            const SizedBox(height: 8),
        ],
        const SizedBox(height: 16),
        const _ActionRequiredCard(),
      ],
    );
  }
}

class _DiversificationTab extends StatelessWidget {
  const _DiversificationTab({required this.snapshot});

  final WalletHealthScoreSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final metric = snapshot.metricByCategory('Diversification');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ScoreSummaryCard(
          icon: Icons.track_changes_rounded,
          iconColor: _healthAmber,
          title: 'Diversification',
          subtitle: 'Portfolio balance analysis',
          score: metric.score,
          status: 'Moderate',
        ),
        const SizedBox(height: 16),
        _AssetDistributionCard(slices: snapshot.diversification),
        const SizedBox(height: 16),
        const _ConcentrationRiskCard(),
        const SizedBox(height: 16),
        const _SectionLabel(label: 'Diversification Tips'),
        const SizedBox(height: 10),
        for (final tip in const [
          'Maintain 15-25% in stablecoins for liquidity',
          'Limit single asset to max 30% of portfolio',
          'Spread across 5-10 quality assets',
          'Rebalance quarterly to maintain targets',
        ]) ...[
          _TipCard(tip: tip),
          if (tip != 'Rebalance quarterly to maintain targets')
            const SizedBox(height: 8),
        ],
        const SizedBox(height: 16),
        const _InfoCard(
          text:
              'Diversification reduces portfolio volatility. Aim for balance across asset types and risk levels.',
        ),
      ],
    );
  }
}

class _ScoreSummaryCard extends StatelessWidget {
  const _ScoreSummaryCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.score,
    required this.status,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final int score;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _healthPanel,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: _healthBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: .08),
              borderRadius: AppRadii.inputRadius,
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.sectionTitle.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$score',
                style: AppTextStyles.sectionTitle.copyWith(
                  color: iconColor,
                  fontSize: 24,
                  fontFamily: 'Roboto',
                ),
              ),
              Text(
                status,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChecklistCard extends StatelessWidget {
  const _ChecklistCard({required this.item});

  final WalletSecurityChecklistItem item;

  @override
  Widget build(BuildContext context) {
    final color = item.enabled ? _healthGreen : _healthRed;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _healthPanel,
        borderRadius: AppRadii.mdRadius,
        border: Border.all(color: _healthBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .10),
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.center,
            child: Icon(
              item.enabled
                  ? Icons.check_circle_outline_rounded
                  : Icons.warning_amber_rounded,
              color: color,
              size: 14,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.item,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item.description,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 10,
                    height: 1,
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

class _ActionRequiredCard extends StatelessWidget {
  const _ActionRequiredCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _healthRed.withValues(alpha: .06),
        borderRadius: AppRadii.mdRadius,
        border: Border.all(color: _healthRed.withValues(alpha: .15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded, color: _healthRed, size: 14),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Action Required',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Backup your seed phrase and enable withdrawal whitelist to improve security score.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontSize: 11,
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

class _AssetDistributionCard extends StatelessWidget {
  const _AssetDistributionCard({required this.slices});

  final List<WalletDiversificationSlice> slices;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _healthPanel,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: _healthBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Asset Distribution',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: CustomPaint(
              painter: _PiePainter(slices),
              child: const SizedBox.expand(),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 20,
            runSpacing: 10,
            children: [
              for (final slice in slices)
                SizedBox(
                  width: 156,
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Color(slice.colorHex),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        slice.name,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text2,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ConcentrationRiskCard extends StatelessWidget {
  const _ConcentrationRiskCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _healthAmber.withValues(alpha: .06),
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: _healthAmber.withValues(alpha: .15)),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: _healthAmber,
                size: 16,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Concentration Risk',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '42% of your portfolio is in BTC. Consider rebalancing to reduce single-asset risk.',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                        fontSize: 11,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const _AllocationRow(
            label: 'Recommended BTC allocation',
            value: '25-30%',
            color: _healthAmber,
          ),
          const SizedBox(height: 10),
          const _AllocationRow(
            label: 'Current BTC allocation',
            value: '42%',
            color: _healthRed,
          ),
        ],
      ),
    );
  }
}
