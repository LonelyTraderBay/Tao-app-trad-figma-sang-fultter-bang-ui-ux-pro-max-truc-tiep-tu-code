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
            height: 1,
          ),
        ),
        const SizedBox(height: 9),
        for (final flag in flags) ...[
          VitCard(
            padding: const EdgeInsets.all(12),
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
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  flag.explanation,
                  style: AppTextStyles.micro.copyWith(
                    color: color,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          if (flag != flags.last) const SizedBox(height: 8),
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
        const SizedBox(height: 14),
        Text(
          'Verification Tiers',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: 12),
        for (final tier in tiers) ...[
          _TierCard(tier: tier),
          if (tier != tiers.last) const SizedBox(height: 12),
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
      padding: const EdgeInsets.all(14),
      borderColor: color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle_outline_rounded, color: color, size: 16),
              const SizedBox(width: 8),
              Text(
                tier.tier,
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final req in tier.requirements) ...[
            Text(
              '• $req',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                height: 1.4,
              ),
            ),
            if (req != tier.requirements.last) const SizedBox(height: 4),
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
        const SizedBox(height: 14),
        VitCard(
          padding: const EdgeInsets.all(16),
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
              const SizedBox(height: 13),
              const _ReportField(label: 'Provider ID hoặc tên'),
              const SizedBox(height: 12),
              const _ReportField(label: 'Lý do report'),
              const SizedBox(height: 12),
              const _ReportField(label: 'Mô tả chi tiết', height: 82),
              const SizedBox(height: 13),
              VitCtaButton(
                onPressed: () {},
                variant: VitCtaButtonVariant.danger,
                height: 46,
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
  const _ReportField({required this.label, this.height = 45});

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
            height: 1,
          ),
        ),
        const SizedBox(height: 7),
        SizedBox(
          height: height,
          child: const VitCardStat(
            padding: EdgeInsets.zero,
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
