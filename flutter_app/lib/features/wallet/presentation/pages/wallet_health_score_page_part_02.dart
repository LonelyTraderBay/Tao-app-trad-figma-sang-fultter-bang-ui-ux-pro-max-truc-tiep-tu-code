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
    return VitCard(
      density: VitDensity.compact,
      borderColor: _healthBorder,
      child: VitPageContent(
        density: VitDensity.compact,
        fullBleed: true,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  recommendation.title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              _StatusBadge(
                label: '${recommendation.impact} impact',
                color: impactColor,
              ),
            ],
          ),
          Text(
            recommendation.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1.28,
            ),
          ),
          VitCtaButton(
            key: WalletHealthScorePage.recommendationKey(recommendation.id),
            onPressed: onTap,
            height: VitDensity.compact.controlHeight,
            trailing: const Icon(Icons.arrow_forward_rounded),
            child: Text(
              recommendation.actionLabel,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.onAccent,
                fontWeight: AppTextStyles.bold,
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
    return VitPageContent(
      padding: VitContentPadding.none,
      gap: VitContentGap.tight,
      density: VitDensity.compact,
      children: [
        _ScoreSummaryCard(
          icon: Icons.shield_outlined,
          iconColor: _healthPrimary,
          title: 'Security Score',
          subtitle: 'Based on 8 security factors',
          score: metric.score,
          status: 'Good',
        ),
        const _SectionLabel(label: 'Security Checklist'),
        for (final item in snapshot.securityChecklist) ...[
          _ChecklistCard(item: item),
        ],
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
    return VitPageContent(
      padding: VitContentPadding.none,
      gap: VitContentGap.tight,
      density: VitDensity.compact,
      children: [
        _ScoreSummaryCard(
          icon: Icons.track_changes_rounded,
          iconColor: _healthAmber,
          title: 'Diversification',
          subtitle: 'Portfolio balance analysis',
          score: metric.score,
          status: 'Moderate',
        ),
        _AssetDistributionCard(slices: snapshot.diversification),
        const _ConcentrationRiskCard(),
        const _SectionLabel(label: 'Diversification Tips'),
        for (final tip in const [
          'Maintain 15-25% in stablecoins for liquidity',
          'Limit single asset to max 30% of portfolio',
          'Spread across 5-10 quality assets',
          'Rebalance quarterly to maintain targets',
        ]) ...[_TipCard(tip: tip)],
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
    return VitCard(
      density: VitDensity.compact,
      borderColor: _healthBorder,
      child: Row(
        children: [
          VitCard(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            borderColor: iconColor.withValues(alpha: .20),
            child: Icon(
              icon,
              color: iconColor,
              size: AppSpacing.walletHealthSummaryIconGlyph,
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  subtitle,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$score',
                style: AppTextStyles.sectionTitle.copyWith(color: iconColor),
              ),
              Text(
                status,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
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
    return VitCard(
      radius: VitCardRadius.sm,
      density: VitDensity.compact,
      borderColor: _healthBorder,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VitCard(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            radius: VitCardRadius.sm,
            borderColor: color.withValues(alpha: .20),
            child: Icon(
              item.enabled
                  ? Icons.check_circle_outline_rounded
                  : Icons.warning_amber_rounded,
              color: color,
              size: AppSpacing.walletHealthChecklistIconGlyph,
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.item,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  item.description,
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

class _ActionRequiredCard extends StatelessWidget {
  const _ActionRequiredCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.sm,
      density: VitDensity.compact,
      borderColor: _healthRed.withValues(alpha: .15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: _healthRed,
            size: AppSpacing.walletHealthActionIcon,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Action Required',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Backup your seed phrase and enable withdrawal whitelist to improve security score.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    height: 1.28,
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
    return VitCard(
      density: VitDensity.compact,
      borderColor: _healthBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Asset Distribution',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          SizedBox(
            height: VitDensity.compact.controlHeight * 2.8,
            child: CustomPaint(
              painter: _PiePainter(slices),
              child: const SizedBox.expand(),
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Wrap(
            spacing: AppSpacing.walletHealthLegendSpacing,
            runSpacing: AppSpacing.walletHealthLegendRunSpacing,
            children: [
              for (final slice in slices)
                SizedBox(
                  width: AppSpacing.walletHealthLegendWidth,
                  child: Row(
                    children: [
                      VitCard(
                        width: AppSpacing.walletHealthLegendSwatch,
                        height: _healthLegendSwatchHeight,
                        radius: VitCardRadius.sm,
                        borderColor: Color(slice.colorHex),
                        background: ColoredBox(color: Color(slice.colorHex)),
                        clip: true,
                        child: const SizedBox.expand(),
                      ),
                      const SizedBox(width: AppSpacing.x1),
                      Expanded(
                        child: Text(
                          '${slice.name} ${slice.value}%',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text2,
                          ),
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
    return VitCard(
      density: VitDensity.compact,
      borderColor: _healthAmber.withValues(alpha: .15),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: _healthAmber,
                size: AppSpacing.walletHealthActionIcon,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Concentration Risk',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '42% of your portfolio is in BTC. Consider rebalancing to reduce single-asset risk.',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                        height: 1.28,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          const _AllocationRow(
            label: 'Recommended BTC allocation',
            value: '25-30%',
            color: _healthAmber,
          ),
          const SizedBox(height: AppSpacing.x1),
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
