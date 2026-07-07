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
      child: VitTabBar(
        variant: VitTabBarVariant.underline,
        activeKey: activeTab.name,
        onChanged: (key) => onChanged(_SocialTab.values.byName(key)),
        tabs: [
          for (final item in tabs)
            VitTabItem(
              key: item.tab.name,
              label: item.label,
              widgetKey: item.key,
            ),
        ],
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
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
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
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          VitInput(
            fieldKey: PredictionSocialPage.commentFieldKey,
            controller: controller,
            semanticLabel: 'Prediction comment',
            hintText: 'Chia se y kien cua ban...',
            textStyle: AppTextStyles.body,
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
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
    return VitChoicePill(
      label: _stanceLabel(stance).toUpperCase(),
      selected: selected,
      onTap: onTap,
      accentColor: color,
      fullWidth: true,
      height: VitDensity.compact.controlHeight,
      padding: const EdgeInsetsDirectional.symmetric(horizontal: AppSpacing.x2),
    );
  }
}
