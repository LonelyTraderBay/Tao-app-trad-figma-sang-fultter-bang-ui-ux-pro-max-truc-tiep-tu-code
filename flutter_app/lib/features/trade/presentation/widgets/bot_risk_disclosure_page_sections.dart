part of '../pages/bot_risk_disclosure_page.dart';

class _HighRiskBanner extends StatelessWidget {
  const _HighRiskBanner({required this.snapshot});

  final TradeBotRiskDisclosureSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      constraints: const BoxConstraints(minHeight: 153),
      padding: const EdgeInsets.fromLTRB(16, 19, 16, 17),
      borderColor: _botRiskRed.withValues(alpha: .58),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.warning_amber_rounded,
              color: _botRiskRed,
              size: 25,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.highRiskTitle,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: _botRiskRed,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  snapshot.highRiskBody,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.medium,
                    height: 1.7,
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

class _PastPerformanceCard extends StatelessWidget {
  const _PastPerformanceCard({required this.snapshot});

  final TradeBotRiskDisclosureSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Icon(
              Icons.trending_down_rounded,
              color: AppColors.text3,
              size: 21,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.pastPerformanceTitle,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  snapshot.pastPerformanceBody,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.62,
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

class _RiskCategoryCard extends StatelessWidget {
  const _RiskCategoryCard({required this.category});

  final TradeBotRiskCategory category;

  @override
  Widget build(BuildContext context) {
    final color = _colorForKind(category.kind);
    return _Card(
      key: BotRiskDisclosurePage.categoryKey(category.id),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VitCard(
                width: 48,
                height: 48,
                variant: VitCardVariant.ghost,
                radius: VitCardRadius.lg,
                borderColor: color.withValues(alpha: .24),
                alignment: Alignment.center,
                child: Icon(
                  _iconForKind(category.kind),
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.title,
                      style: AppTextStyles.body.copyWith(
                        color: color,
                        fontWeight: AppTextStyles.bold,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      category.description,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'REAL EXAMPLES:',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
          const SizedBox(height: 11),
          for (final example in category.examples) ...[
            _BulletText(example, color: AppColors.text2),
            if (example != category.examples.last) const SizedBox(height: 8),
          ],
          const SizedBox(height: 15),
          VitCard(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 13),
            variant: VitCardVariant.inner,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'HOW TO MITIGATE:',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  category.mitigation,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.5,
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

class _AdditionalWarningsCard extends StatelessWidget {
  const _AdditionalWarningsCard({required this.warnings});

  final List<TradeBotRiskWarning> warnings;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 7),
      child: Column(
        children: [
          for (final warning in warnings) ...[
            _WarningBlock(warning: warning),
            if (warning != warnings.last)
              const Divider(color: AppColors.borderSolid, height: 19),
          ],
        ],
      ),
    );
  }
}

class _WarningBlock extends StatelessWidget {
  const _WarningBlock({required this.warning});

  final TradeBotRiskWarning warning;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: _botRiskAmber,
                size: 14,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  warning.title,
                  style: AppTextStyles.caption.copyWith(
                    color: _botRiskRed,
                    fontWeight: AppTextStyles.bold,
                    height: 1.18,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            warning.text,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}

class _RegulatoryNoticeCard extends StatelessWidget {
  const _RegulatoryNoticeCard({required this.snapshot});

  final TradeBotRiskDisclosureSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            snapshot.regulatoryTitle,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            snapshot.regulatoryBody,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 12),
          for (final note in snapshot.regulatoryNotes) ...[
            _BulletText(note, color: AppColors.text3),
            if (note != snapshot.regulatoryNotes.last)
              const SizedBox(height: 7),
          ],
        ],
      ),
    );
  }
}
