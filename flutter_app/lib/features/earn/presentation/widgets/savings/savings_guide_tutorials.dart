import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/savings/savings_guide_common.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

class SavingsGuideTutorialsTab extends StatelessWidget {
  const SavingsGuideTutorialsTab({
    super.key,
    required this.snapshot,
    required this.completedTutorials,
    required this.onTutorialTap,
  });

  final SavingsGuideSnapshot snapshot;
  final Set<String> completedTutorials;
  final ValueChanged<SavingsGuideTutorialDraft> onTutorialTap;

  @override
  Widget build(BuildContext context) {
    final progress = snapshot.tutorials.isEmpty
        ? 0.0
        : completedTutorials.length / snapshot.tutorials.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _HeroCard(snapshot: snapshot),
        const SizedBox(height: AppSpacing.pageRhythmFormSectionGap),
        _LearningProgressCard(
          completed: completedTutorials.length,
          total: snapshot.tutorials.length,
          progress: progress,
        ),
        const SizedBox(height: AppSpacing.pageRhythmFormSectionGap),
        VitPageSection(
          label: 'Bài hướng dẫn',
          accentColor: AppColors.buy,
          children: [
            Column(
              key: SavingsGuideKeys.tutorialList,
              children: [
                for (final tutorial in snapshot.tutorials) ...[
                  _TutorialCard(
                    key: tutorial == snapshot.tutorials.first
                        ? SavingsGuideKeys.firstTutorial
                        : null,
                    tutorial: tutorial,
                    completed: completedTutorials.contains(tutorial.id),
                    onTap: () => onTutorialTap(tutorial),
                  ),
                  if (tutorial != snapshot.tutorials.last)
                    const SizedBox(
                      height: AppSpacing.pageRhythmStandardInnerGap,
                    ),
                ],
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmFormSectionGap),
        VitPageSection(
          label: 'Mẹo nhanh',
          accentColor: AppColors.warn,
          children: [_QuickTipsGrid(tips: snapshot.quickTips)],
        ),
        const SizedBox(height: AppSpacing.pageRhythmFormSectionGap),
        _StartSavingsCard(snapshot: snapshot),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.snapshot});

  final SavingsGuideSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.buy10,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.cardLargeRadius,
          side: BorderSide(color: AppColors.buy20),
        ),
      ),
      child: Padding(
        padding: EarnSpacingTokens.earnCardPaddingX4,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.menu_book_outlined,
              color: AppColors.buy,
              size: AppSpacing.iconMd,
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.heroTitle,
                    style: AppTextStyles.baseMedium.copyWith(
                      color: AppColors.text1,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                  Text(
                    snapshot.heroSubtitle,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height: EarnSpacingTokens.earnGuideHeroLineHeight,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LearningProgressCard extends StatelessWidget {
  const _LearningProgressCard({
    required this.completed,
    required this.total,
    required this.progress,
  });

  final int completed;
  final int total;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Tiến trình học',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Text(
                '$completed/$total',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          ClipRRect(
            borderRadius: AppRadii.xsRadius,
            child: LinearProgressIndicator(
              minHeight: AppSpacing.x2,
              value: progress,
              backgroundColor: AppColors.borderSolid,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.buy),
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Icon(
                progress >= 1
                    ? Icons.check_circle_rounded
                    : Icons.check_circle_outline_rounded,
                color: progress >= 1 ? AppColors.buy : AppColors.text3,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  progress >= 1
                      ? 'Bạn đã hoàn thành tất cả hướng dẫn!'
                      : 'Còn ${total - completed} bài chưa hoàn thành',
                  style: AppTextStyles.caption.copyWith(
                    color: progress >= 1 ? AppColors.buy : AppColors.text3,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TutorialCard extends StatelessWidget {
  const _TutorialCard({
    super.key,
    required this.tutorial,
    required this.completed,
    required this.onTap,
  });

  final SavingsGuideTutorialDraft tutorial;
  final bool completed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = completed ? AppColors.buy : AppColors.primary;
    return VitCard(
      radius: VitCardRadius.large,
      padding: AppSpacing.zeroInsets,
      onTap: onTap,
      child: Padding(
        padding: EarnSpacingTokens.earnCardPaddingX3,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SavingsGuideRoundIcon(
              icon: completed
                  ? Icons.check_circle_outline_rounded
                  : Icons.play_circle_outline_rounded,
              color: color,
              size: AppSpacing.buttonStandard,
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tutorial.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.baseMedium.copyWith(
                      color: AppColors.text1,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    tutorial.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                      height: EarnSpacingTokens.earnGuideCardLineHeight,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                  Wrap(
                    spacing: AppSpacing.x2,
                    runSpacing: AppSpacing.x1,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SavingsGuideDifficultyPill(
                        difficulty: tutorial.difficulty,
                      ),
                      Text(
                        '${tutorial.duration} · ${tutorial.steps.length} bước',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.text3,
              size: AppSpacing.iconMd,
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickTipsGrid extends StatelessWidget {
  const _QuickTipsGrid({required this.tips});

  final List<SavingsGuideQuickTipDraft> tips;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.hasBoundedWidth && constraints.maxWidth > 0
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width - (AppSpacing.contentPad * 2);
        if (maxWidth <= AppSpacing.x2) {
          return const SizedBox.shrink();
        }
        final itemWidth = (maxWidth - AppSpacing.x2) / 2;
        return Wrap(
          spacing: AppSpacing.x2,
          runSpacing: AppSpacing.x2,
          children: [
            for (final tip in tips)
              SizedBox(
                width: itemWidth,
                child: _QuickTipCard(tip: tip),
              ),
          ],
        );
      },
    );
  }
}

class _QuickTipCard extends StatelessWidget {
  const _QuickTipCard({required this.tip});

  final SavingsGuideQuickTipDraft tip;

  @override
  Widget build(BuildContext context) {
    final color = savingsGuideRiskColor(tip.tone);
    return VitCard(
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SavingsGuideRoundIcon(
            icon: savingsGuideIcon(tip.iconKey),
            color: color,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            tip.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            tip.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: EarnSpacingTokens.earnGuideBodyLineHeight,
            ),
          ),
        ],
      ),
    );
  }
}

class _StartSavingsCard extends StatelessWidget {
  const _StartSavingsCard({required this.snapshot});

  final SavingsGuideSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Sẵn sàng bắt đầu?', style: AppTextStyles.baseMedium),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            'Khám phá các sản phẩm tiết kiệm đang có lãi suất hấp dẫn.',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              height: EarnSpacingTokens.earnGuideTipLineHeight,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          VitCtaButton(
            key: SavingsGuideKeys.startButton,
            onPressed: () {
              HapticFeedback.selectionClick();
              context.go(snapshot.savingsRoute);
            },
            trailing: const Icon(Icons.arrow_forward_rounded),
            child: const Text('Khám phá sản phẩm'),
          ),
        ],
      ),
    );
  }
}
