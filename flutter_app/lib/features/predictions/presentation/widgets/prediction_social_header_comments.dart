part of '../pages/prediction_social_page.dart';

class _SocialTabBar extends StatelessWidget {
  const _SocialTabBar({required this.activeTab, required this.onChanged});

  final _SocialTab activeTab;
  final ValueChanged<_SocialTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      (
        key: PredictionSocialPage.commentsTabKey,
        tab: _SocialTab.comments,
        label: 'Binh luan',
      ),
      (
        key: PredictionSocialPage.analysisTabKey,
        tab: _SocialTab.analysis,
        label: 'Phan tich',
      ),
      (
        key: PredictionSocialPage.shareTabKey,
        tab: _SocialTab.share,
        label: 'Chia se',
      ),
    ];

    return Material(
      color: AppColors.surface,
      child: SizedBox(
        height: VitDensity.compact.controlHeight,
        child: Stack(
          children: [
            Row(
              children: [
                for (final item in tabs)
                  Expanded(
                    child: InkWell(
                      key: item.key,
                      onTap: () => onChanged(item.tab),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                item.label,
                                style: AppTextStyles.caption.copyWith(
                                  color: activeTab == item.tab
                                      ? _predictionPrimary
                                      : AppColors.text3,
                                  fontWeight: AppTextStyles.bold,
                                ),
                              ),
                            ),
                          ),
                          AnimatedSize(
                            duration: const Duration(milliseconds: 160),
                            child: Material(
                              color: _predictionPrimary,
                              borderRadius: AppRadii.hairlineRadius,
                              child: SizedBox(
                                height: AppSpacing.dividerHairline,
                                width: activeTab == item.tab
                                    ? AppSpacing
                                          .predictionSocialTabIndicatorWidth
                                    : 0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SizedBox(
                height: AppSpacing.dividerHairline,
                child: ColoredBox(color: AppColors.border),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EventInfoCard extends StatelessWidget {
  const _EventInfoCard({required this.snapshot});

  final PredictionSocialSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            snapshot.eventTitle,
            style: AppTextStyles.body.copyWith(fontWeight: AppTextStyles.bold),
          ),
          const SizedBox(height: AppSpacing.x1),
          Row(
            children: [
              const Icon(
                Icons.mode_comment_outlined,
                color: AppColors.text3,
                size: AppSpacing.predictionSocialEventIcon,
              ),
              const SizedBox(width: AppSpacing.predictionSocialEventCommentGap),
              Text(
                '${snapshot.totalComments} comments',
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
              const SizedBox(width: AppSpacing.predictionSocialEventMetricGap),
              const Icon(
                Icons.trending_up_rounded,
                color: AppColors.buy,
                size: AppSpacing.predictionSocialEventIcon,
              ),
              const SizedBox(width: AppSpacing.predictionSocialEventBullishGap),
              Text(
                '${snapshot.bullishPercent}% Bullish',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.buy,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NewCommentCard extends StatelessWidget {
  const _NewCommentCard({
    required this.controller,
    required this.selectedStance,
    required this.onStanceChanged,
  });

  final TextEditingController controller;
  final PredictionSocialStance selectedStance;
  final ValueChanged<PredictionSocialStance> onStanceChanged;

  @override
  Widget build(BuildContext context) {
    final hasComment = controller.text.trim().isNotEmpty;
    return VitCard(
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Them binh luan',
            style: AppTextStyles.caption.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Row(
            children: [
              for (final stance in PredictionSocialStance.values) ...[
                Expanded(
                  child: _StanceButton(
                    stance: stance,
                    selected: selectedStance == stance,
                    onTap: () => onStanceChanged(stance),
                  ),
                ),
                if (stance != PredictionSocialStance.neutral)
                  const SizedBox(width: AppSpacing.predictionSocialStanceGap),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          VitInput(
            fieldKey: PredictionSocialPage.commentFieldKey,
            controller: controller,
            semanticLabel: 'Prediction comment',
            hintText: 'Chia se y kien cua ban...',
            textStyle: AppTextStyles.body,
          ),
          const SizedBox(height: AppSpacing.x2),
          VitCtaButton(
            density: VitDensity.compact,
            onPressed: hasComment ? () {} : null,
            leading: const Icon(Icons.send_outlined),
            child: const Text('Dang binh luan'),
          ),
        ],
      ),
    );
  }
}

class _StanceButton extends StatelessWidget {
  const _StanceButton({
    required this.stance,
    required this.selected,
    required this.onTap,
  });

  final PredictionSocialStance stance;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _stanceColor(stance);
    return SizedBox(
      height: VitDensity.compact.controlHeight,
      child: Material(
        color: selected ? color : AppColors.bg,
        borderRadius: AppRadii.inputRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.inputRadius,
          child: Center(
            child: Text(
              _stanceLabel(stance).toUpperCase(),
              style: AppTextStyles.micro.copyWith(
                color: selected ? AppColors.onAccent : AppColors.text2,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
