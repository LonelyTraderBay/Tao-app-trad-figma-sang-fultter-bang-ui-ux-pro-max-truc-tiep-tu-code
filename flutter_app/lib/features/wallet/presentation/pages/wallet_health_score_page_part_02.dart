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
      padding: AppSpacing.walletHealthCardPadding,
      borderColor: _healthBorder,
      child: VitPageContent(
        padding: VitContentPadding.none,
        fullBleed: true,
        customGap: AppSpacing.walletHealthRecommendationGap,
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
              height: 1.45,
            ),
          ),
          VitCtaButton(
            key: WalletHealthScorePage.recommendationKey(recommendation.id),
            onPressed: onTap,
            height: AppSpacing.walletHealthActionHeight,
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
      fullBleed: true,
      customGap: AppSpacing.walletHealthContentGap,
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
      fullBleed: true,
      customGap: AppSpacing.walletHealthContentGap,
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
      padding: AppSpacing.walletHealthCardPadding,
      borderColor: _healthBorder,
      child: Row(
        children: [
          VitCard(
            width: AppSpacing.walletHealthSummaryIconBox,
            height: AppSpacing.walletHealthSummaryIconBox,
            alignment: Alignment.center,
            borderColor: iconColor.withValues(alpha: .20),
            child: Icon(
              icon,
              color: iconColor,
              size: AppSpacing.walletHealthSummaryIconGlyph,
            ),
          ),
          const SizedBox(width: AppSpacing.walletHealthSectionGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.walletHealthSummaryTextGap),
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
      padding: AppSpacing.walletHealthCompactCardPadding,
      borderColor: _healthBorder,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VitCard(
            width: AppSpacing.walletHealthChecklistIconBox,
            height: AppSpacing.walletHealthChecklistIconBox,
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
          const SizedBox(width: AppSpacing.walletHealthSectionGap),
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
                const SizedBox(height: AppSpacing.walletHealthSummaryTextGap),
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
      padding: AppSpacing.walletHealthCompactCardPadding,
      borderColor: _healthRed.withValues(alpha: .15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: _healthRed,
            size: AppSpacing.walletHealthActionIcon,
          ),
          const SizedBox(width: AppSpacing.walletHealthNoticeGap),
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
                const SizedBox(height: AppSpacing.walletHealthInlineGap),
                Text(
                  'Backup your seed phrase and enable withdrawal whitelist to improve security score.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
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
    return VitCard(
      padding: AppSpacing.walletHealthCardPadding,
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
          const SizedBox(height: AppSpacing.walletHealthSectionGap),
          SizedBox(
            height: AppSpacing.walletHealthPieHeight,
            child: CustomPaint(
              painter: _PiePainter(slices),
              child: const SizedBox.expand(),
            ),
          ),
          const SizedBox(height: AppSpacing.walletHealthSectionGap),
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
                        height: AppSpacing.walletHealthLegendSwatch,
                        radius: VitCardRadius.sm,
                        borderColor: Color(slice.colorHex),
                        background: ColoredBox(color: Color(slice.colorHex)),
                        clip: true,
                        child: const SizedBox.expand(),
                      ),
                      const SizedBox(width: AppSpacing.walletHealthInlineGap),
                      Text(
                        slice.name,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text2,
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
      padding: AppSpacing.walletHealthCardPadding,
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
              const SizedBox(width: AppSpacing.walletHealthNoticeGap),
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
                    const SizedBox(height: AppSpacing.walletHealthInlineGap),
                    Text(
                      '42% of your portfolio is in BTC. Consider rebalancing to reduce single-asset risk.',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.walletHealthConcentrationGap),
          const _AllocationRow(
            label: 'Recommended BTC allocation',
            value: '25-30%',
            color: _healthAmber,
          ),
          const SizedBox(height: AppSpacing.walletHealthAllocationGap),
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
