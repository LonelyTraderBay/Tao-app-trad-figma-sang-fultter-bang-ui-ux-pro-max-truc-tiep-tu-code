part of '../pages/safety_education_page.dart';

class _SeveritySection extends StatelessWidget {
  const _SeveritySection({
    required this.title,
    required this.color,
    required this.flags,
  });

  final String title;
  final Color color;
  final List<TradeSafetyRedFlag> flags;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            height: AppSpacing.tradeBotLineHeightTight,
          ),
        ),
        const SizedBox(height: AppSpacing.tradeBotDisclosureGap),
        for (final flag in flags) ...[
          VitCard(
            padding: AppSpacing.tradeBotInnerPanelPadding,
            variant: VitCardVariant.ghost,
            radius: VitCardRadius.sm,
            borderColor: color.withValues(alpha: .65),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  flag.flag,
                  style: AppTextStyles.micro.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                    height: AppSpacing.tradeBotLineHeightBody,
                  ),
                ),
                const SizedBox(height: AppSpacing.tradeBotLabelGap),
                Text(
                  flag.explanation,
                  style: AppTextStyles.micro.copyWith(
                    color: color,
                    height: AppSpacing.tradeBotLineHeightBody,
                  ),
                ),
              ],
            ),
          ),
          if (flag != flags.last) const SizedBox(height: AppSpacing.x2),
        ],
      ],
    );
  }
}

class _VerificationTab extends StatelessWidget {
  const _VerificationTab({required this.tiers});

  final List<TradeSafetyVerificationTier> tiers;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _InfoPanel(
          text:
              'Verification là cơ chế bảo vệ user. Provider verified đã qua kiểm tra KYC và performance audit.',
          color: _safetyPrimary,
        ),
        const SizedBox(height: AppSpacing.tradeBotStatusGap),
        Text(
          'Verification Tiers',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.tradeBotCardGap),
        for (final tier in tiers) ...[
          _TierCard(tier: tier),
          if (tier != tiers.last)
            const SizedBox(height: AppSpacing.tradeBotCardGap),
        ],
      ],
    );
  }
}

class _TierCard extends StatelessWidget {
  const _TierCard({required this.tier});

  final TradeSafetyVerificationTier tier;

  @override
  Widget build(BuildContext context) {
    final color = Color(tier.colorHex);
    return VitCard(
      padding: AppSpacing.tradeBotCompactCardPadding,
      borderColor: color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.check_circle_outline_rounded,
                color: color,
                size: AppSpacing.tradeBotSmallIcon,
              ),
              const SizedBox(width: AppSpacing.tradeBotSmallGap),
              Text(
                tier.tier,
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                  height: AppSpacing.tradeBotLineHeightTight,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.tradeBotCardGap),
          for (final req in tier.requirements) ...[
            Text(
              '• $req',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                height: AppSpacing.tradeBotLineHeightMedium,
              ),
            ),
            if (req != tier.requirements.last)
              const SizedBox(height: AppSpacing.x1),
          ],
        ],
      ),
    );
  }
}

class _ReportTab extends StatelessWidget {
  const _ReportTab({required this.reasons});

  final List<String> reasons;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _InfoPanel(
          text:
              'Khi nào nên report?\n${reasons.map((item) => '• $item').join('\n')}',
          color: AppColors.sell,
        ),
        const SizedBox(height: AppSpacing.tradeBotStatusGap),
        VitCard(
          padding: AppSpacing.tradeBotCardPadding,
          borderColor: AppColors.cardBorder,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Report Provider',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.tradeBotStatusGap),
              const _ReportField(label: 'Provider ID hoặc tên'),
              const SizedBox(height: AppSpacing.tradeBotCardGap),
              const _ReportField(label: 'Lý do report'),
              const SizedBox(height: AppSpacing.tradeBotCardGap),
              const _ReportField(
                label: 'Mô tả chi tiết',
                height: AppSpacing.tradeBotControlTall,
              ),
              const SizedBox(height: AppSpacing.tradeBotStatusGap),
              VitCtaButton(
                onPressed: () {},
                variant: VitCtaButtonVariant.danger,
                height: AppSpacing.tradeBotControlHeight,
                child: Text(
                  'Submit Report',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.onAccent,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReportField extends StatelessWidget {
  const _ReportField({
    required this.label,
    this.height = AppSpacing.tradeBotDisputeEvidenceHeight,
  });

  final String label;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            height: AppSpacing.tradeBotLineHeightTight,
          ),
        ),
        const SizedBox(height: AppSpacing.tradeBotLabelGap),
        SizedBox(
          height: height,
          child: const VitCardStat(
            padding: AppSpacing.zeroInsets,
            child: SizedBox.expand(),
          ),
        ),
      ],
    );
  }
}

class _InfoPanel extends StatelessWidget {
  const _InfoPanel({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitHighRiskStatePanel(
      state: VitHighRiskUiState.riskReview,
      title: 'Review safety guidance',
      message: text,
    );
  }
}

String _severityTitle(String severity) {
  switch (severity) {
    case 'critical':
      return 'Critical (Tuyệt đối không copy)';
    case 'warning':
      return 'Warning (Cần thận trọng)';
    default:
      return 'Caution (Kiểm tra kỹ)';
  }
}

Color _severityColor(String severity) {
  switch (severity) {
    case 'critical':
      return AppColors.sell;
    case 'warning':
      return AppColors.warn;
    default:
      return _safetyPrimary;
  }
}
