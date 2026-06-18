part of '../pages/bot_risk_disclosure_page.dart';

class _HighRiskBanner extends StatelessWidget {
  const _HighRiskBanner({required this.snapshot});

  final TradeBotRiskDisclosureSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      constraints: const BoxConstraints(minHeight: 153),
      padding: AppSpacing.tradeBotCardPaddingTall,
      borderColor: _botRiskRed.withValues(alpha: .58),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: _botRiskRed,
            size: AppSpacing.tradeBotMethodTextIndent,
          ),
          const SizedBox(width: AppSpacing.tradeBotPageTopGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.highRiskTitle,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: _botRiskRed,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.tradeBotPageTopGap),
                Text(
                  snapshot.highRiskBody,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.medium,
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
    return VitCard(
      padding: AppSpacing.tradeBotCardPaddingTall,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.trending_down_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.pastPerformanceTitle,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.tradeBotSmallGap),
                Text(
                  snapshot.pastPerformanceBody,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
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
    return VitCard(
      key: BotRiskDisclosurePage.categoryKey(category.id),
      padding: AppSpacing.tradeBotCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VitCard(
                width: AppSpacing.tradeBotDisclosureIconBox,
                height: AppSpacing.tradeBotDisclosureIconBox,
                variant: VitCardVariant.ghost,
                radius: VitCardRadius.lg,
                borderColor: color.withValues(alpha: .24),
                alignment: Alignment.center,
                child: Icon(
                  _iconForKind(category.kind),
                  color: color,
                  size: AppSpacing.tradeBotCheckbox,
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.title,
                      style: AppTextStyles.body.copyWith(
                        color: color,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.tradeBotSmallGap),
                    Text(
                      category.description,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.tradeBotContentGap),
          Text(
            'REAL EXAMPLES:',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.tradeBotRowGap),
          for (final example in category.examples) ...[
            _BulletText(example, color: AppColors.text2),
            if (example != category.examples.last)
              const SizedBox(height: AppSpacing.tradeBotSmallGap),
          ],
          const SizedBox(height: AppSpacing.tradeBotPageTopGap),
          VitCard(
            width: double.infinity,
            padding: AppSpacing.tradeBotControlPadding,
            variant: VitCardVariant.inner,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'HOW TO MITIGATE:',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.tradeBotSmallGap),
                Text(
                  category.mitigation,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
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
    return VitCard(
      padding: AppSpacing.tradeBotCardPadding,
      child: Column(
        children: [
          for (final warning in warnings) ...[
            _WarningBlock(warning: warning),
            if (warning != warnings.last)
              const Divider(
                color: AppColors.borderSolid,
                height: AppSpacing.tradeBotContentGap,
              ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: _botRiskAmber,
              size: AppSpacing.tradeBotPageTopGap,
            ),
            const SizedBox(width: AppSpacing.tradeBotTinyGap),
            Expanded(
              child: Text(
                warning.title,
                style: AppTextStyles.caption.copyWith(
                  color: _botRiskRed,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.tradeBotTinyGap),
        Text(
          warning.text,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
      ],
    );
  }
}

class _RegulatoryNoticeCard extends StatelessWidget {
  const _RegulatoryNoticeCard({required this.snapshot});

  final TradeBotRiskDisclosureSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.tradeBotCardPaddingLoose,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            snapshot.regulatoryTitle,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.tradeBotSmallGap),
          Text(
            snapshot.regulatoryBody,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.tradeBotCardGap),
          for (final note in snapshot.regulatoryNotes) ...[
            _BulletText(note, color: AppColors.text3),
            if (note != snapshot.regulatoryNotes.last)
              const SizedBox(height: AppSpacing.tradeBotSmallGap),
          ],
        ],
      ),
    );
  }
}
