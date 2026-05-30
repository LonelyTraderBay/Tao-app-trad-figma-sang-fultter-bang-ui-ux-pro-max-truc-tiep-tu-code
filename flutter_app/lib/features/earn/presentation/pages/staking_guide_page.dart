import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_controller_providers.dart';

class StakingGuidePage extends ConsumerStatefulWidget {
  const StakingGuidePage({super.key, this.shellRenderMode});

  static const heroKey = Key('sc369_hero');
  static const tabsKey = Key('sc369_tabs');
  static const tutorialsKey = Key('sc369_tutorials');
  static const quickTipsKey = Key('sc369_quick_tips');
  static const mistakesKey = Key('sc369_mistakes');
  static const ctaKey = Key('sc369_cta');
  static const tutorialSheetKey = Key('sc369_tutorial_sheet');
  static const completeButtonKey = Key('sc369_complete_tutorial');

  static Key tabKey(String id) => Key('sc369_tab_$id');

  static Key tutorialKey(String id) => Key('sc369_tutorial_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingGuidePage> createState() => _StakingGuidePageState();
}

class _StakingGuidePageState extends ConsumerState<StakingGuidePage> {
  StakingGuideDifficulty _difficulty = StakingGuideDifficulty.beginner;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(stakingGuideRepositoryProvider).getGuide();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;
    final tutorials = snapshot.tutorials
        .where((tutorial) => tutorial.difficulty == _difficulty)
        .toList(growable: false);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-369 StakingGuidePage',
      child: Material(
        color: AppColors.bg,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: bottomInset),
                child: VitPageContent(
                  padding: VitContentPadding.compact,
                  gap: VitContentGap.defaultGap,
                  children: [
                    _HeroBanner(snapshot: snapshot),
                    _DifficultyTabs(
                      active: _difficulty,
                      onChanged: (difficulty) {
                        HapticFeedback.selectionClick();
                        setState(() => _difficulty = difficulty);
                      },
                    ),
                    VitPageSection(
                      key: StakingGuidePage.tutorialsKey,
                      label: 'Tutorials',
                      accentColor: AppColors.primarySoft,
                      children: [
                        for (final tutorial in tutorials)
                          _TutorialCard(
                            tutorial: tutorial,
                            onTap: () => _openTutorialSheet(tutorial),
                          ),
                      ],
                    ),
                    _QuickTipsGrid(snapshot: snapshot),
                    _CommonMistakes(snapshot: snapshot),
                    _StartStakingCard(snapshot: snapshot),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openTutorialSheet(StakingGuideTutorialDraft tutorial) async {
    HapticFeedback.selectionClick();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) {
        var stepIndex = 0;
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final step = tutorial.steps[stepIndex];
            final progress = (stepIndex + 1) / tutorial.steps.length;
            return FractionallySizedBox(
              heightFactor: 0.82,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppRadii.xl),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: SingleChildScrollView(
                    key: StakingGuidePage.tutorialSheetKey,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.contentPad,
                      AppSpacing.x5,
                      AppSpacing.contentPad,
                      AppSpacing.x6,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                tutorial.title,
                                style: AppTextStyles.baseMedium,
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.of(context).pop(),
                              icon: const Icon(
                                Icons.close_rounded,
                                color: AppColors.text3,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.x3),
                        _ProgressHeader(
                          stepIndex: stepIndex,
                          total: tutorial.steps.length,
                          progress: progress,
                        ),
                        const SizedBox(height: AppSpacing.x5),
                        _StepDetail(step: step),
                        const SizedBox(height: AppSpacing.x5),
                        _TipPanel(tips: step.tips),
                        const SizedBox(height: AppSpacing.x5),
                        Row(
                          children: [
                            Expanded(
                              child: VitCtaButton(
                                variant: VitCtaButtonVariant.secondary,
                                onPressed: stepIndex == 0
                                    ? null
                                    : () {
                                        HapticFeedback.selectionClick();
                                        setSheetState(() => stepIndex--);
                                      },
                                child: const Text('Trước'),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.x3),
                            Expanded(
                              child: VitCtaButton(
                                key: stepIndex == tutorial.steps.length - 1
                                    ? StakingGuidePage.completeButtonKey
                                    : null,
                                variant: stepIndex == tutorial.steps.length - 1
                                    ? VitCtaButtonVariant.success
                                    : VitCtaButtonVariant.primary,
                                onPressed: () {
                                  HapticFeedback.selectionClick();
                                  if (stepIndex < tutorial.steps.length - 1) {
                                    setSheetState(() => stepIndex++);
                                    return;
                                  }
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  stepIndex == tutorial.steps.length - 1
                                      ? 'Hoàn thành'
                                      : 'Tiếp theo',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({required this.snapshot});

  final StakingGuideSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingGuidePage.heroKey,
      variant: VitCardVariant.inner,
      borderColor: AppColors.primary20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.menu_book_outlined,
            color: AppColors.primarySoft,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(snapshot.heroTitle, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  snapshot.heroBody,
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

class _DifficultyTabs extends StatelessWidget {
  const _DifficultyTabs({required this.active, required this.onChanged});

  final StakingGuideDifficulty active;
  final ValueChanged<StakingGuideDifficulty> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: StakingGuidePage.tabsKey,
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x4,
        AppSpacing.contentPad,
        0,
      ),
      child: VitTabBar(
        variant: VitTabBarVariant.underline,
        activeKey: active.name,
        onChanged: (key) => onChanged(
          StakingGuideDifficulty.values.firstWhere(
            (difficulty) => difficulty.name == key,
          ),
        ),
        tabs: [
          for (final difficulty in StakingGuideDifficulty.values)
            VitTabItem(
              key: difficulty.name,
              label: _difficultyTabLabel(difficulty),
            ),
        ],
      ),
    );
  }
}

class _TutorialCard extends StatelessWidget {
  const _TutorialCard({required this.tutorial, required this.onTap});

  final StakingGuideTutorialDraft tutorial;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingGuidePage.tutorialKey(tutorial.id),
      radius: VitCardRadius.lg,
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Row(
          children: [
            _RoundIcon(
              icon: Icons.play_circle_outline_rounded,
              color: AppColors.primarySoft,
              size: AppSpacing.buttonStandard,
            ),
            const SizedBox(width: AppSpacing.x4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tutorial.title, style: AppTextStyles.baseMedium),
                  const SizedBox(height: AppSpacing.x2),
                  Wrap(
                    spacing: AppSpacing.x2,
                    runSpacing: AppSpacing.x1,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _DifficultyPill(difficulty: tutorial.difficulty),
                      Text(
                        '${tutorial.duration} - ${tutorial.steps.length} bước',
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
  const _QuickTipsGrid({required this.snapshot});

  final StakingGuideSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingGuidePage.quickTipsKey,
      label: 'Quick Tips',
      accentColor: AppColors.primarySoft,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final itemWidth = (constraints.maxWidth - AppSpacing.x3) / 2;
            return Wrap(
              spacing: AppSpacing.x3,
              runSpacing: AppSpacing.x3,
              children: [
                for (final tip in snapshot.quickTips)
                  SizedBox(
                    width: itemWidth,
                    child: _QuickTipCard(tip: tip),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _QuickTipCard extends StatelessWidget {
  const _QuickTipCard({required this.tip});

  final StakingGuideQuickTipDraft tip;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(tip.tone);
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _RoundIcon(icon: _guideIcon(tip.iconKey), color: color),
          const SizedBox(height: AppSpacing.x3),
          Text(
            tip.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            tip.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _CommonMistakes extends StatelessWidget {
  const _CommonMistakes({required this.snapshot});

  final StakingGuideSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingGuidePage.mistakesKey,
      label: 'Tránh sai lầm phổ biến',
      accentColor: AppColors.primarySoft,
      children: [
        VitCard(
          radius: VitCardRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            children: [
              for (var i = 0; i < snapshot.mistakes.length; i++) ...[
                if (i > 0) const SizedBox(height: AppSpacing.x3),
                _MistakeRow(mistake: snapshot.mistakes[i]),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _MistakeRow extends StatelessWidget {
  const _MistakeRow({required this.mistake});

  final StakingGuideMistakeDraft mistake;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(mistake.tone);
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: color,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mistake.title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  mistake.correction,
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

class _StartStakingCard extends StatelessWidget {
  const _StartStakingCard({required this.snapshot});

  final StakingGuideSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingGuidePage.ctaKey,
      variant: VitCardVariant.inner,
      borderColor: AppColors.buy20,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(snapshot.ctaTitle, style: AppTextStyles.baseMedium),
          const SizedBox(height: AppSpacing.x3),
          Text(
            snapshot.ctaBody,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x4),
          SizedBox(
            width: AppSpacing.buttonHero * 1.55,
            child: VitCtaButton(
              onPressed: () {
                HapticFeedback.selectionClick();
                context.go(snapshot.stakingRoute);
              },
              trailing: const Icon(Icons.arrow_forward_rounded),
              child: Text(snapshot.ctaLabel),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({
    required this.stepIndex,
    required this.total,
    required this.progress,
  });

  final int stepIndex;
  final int total;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              'Bước ${stepIndex + 1}/$total',
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
            const Spacer(),
            Text(
              '${(progress * 100).round()}% hoàn thành',
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        ClipRRect(
          borderRadius: AppRadii.xsRadius,
          child: LinearProgressIndicator(
            minHeight: 6,
            value: progress,
            backgroundColor: AppColors.borderSolid,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      ],
    );
  }
}

class _StepDetail extends StatelessWidget {
  const _StepDetail({required this.step});

  final StakingGuideStepDraft step;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _RoundIcon(
              icon: _guideIcon(step.iconKey),
              color: AppColors.primarySoft,
              size: AppSpacing.buttonStandard,
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(child: Text(step.title, style: AppTextStyles.baseMedium)),
          ],
        ),
        const SizedBox(height: AppSpacing.x4),
        Text(
          step.description,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            height: 1.65,
          ),
        ),
      ],
    );
  }
}

class _TipPanel extends StatelessWidget {
  const _TipPanel({required this.tips});

  final List<String> tips;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.lightbulb_outline_rounded,
                color: AppColors.warn,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Tips quan trọng',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          for (final tip in tips) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 7),
                  child: SizedBox(
                    width: 4,
                    height: 4,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.text3,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Text(
                    tip,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
            if (tip != tips.last) const SizedBox(height: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _DifficultyPill extends StatelessWidget {
  const _DifficultyPill({required this.difficulty});

  final StakingGuideDifficulty difficulty;

  @override
  Widget build(BuildContext context) {
    final color = _difficultyColor(difficulty);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          difficulty.name,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({
    required this.icon,
    required this.color,
    this.size = AppSpacing.x7,
  });

  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color.withValues(alpha: 0.28)),
        borderRadius: AppRadii.mdRadius,
      ),
      child: SizedBox(
        width: size,
        height: size,
        child: Center(
          child: Icon(icon, color: color, size: AppSpacing.iconMd),
        ),
      ),
    );
  }
}

String _difficultyTabLabel(StakingGuideDifficulty difficulty) {
  return switch (difficulty) {
    StakingGuideDifficulty.beginner => 'Beginner',
    StakingGuideDifficulty.intermediate => 'Intermediate',
    StakingGuideDifficulty.advanced => 'Advanced',
  };
}

Color _difficultyColor(StakingGuideDifficulty difficulty) {
  return switch (difficulty) {
    StakingGuideDifficulty.beginner => AppColors.buy,
    StakingGuideDifficulty.intermediate => AppColors.primarySoft,
    StakingGuideDifficulty.advanced => AppColors.warn,
  };
}

Color _toneColor(String tone) {
  return switch (tone) {
    'success' => AppColors.buy,
    'warning' => AppColors.warn,
    'danger' => AppColors.sell,
    _ => AppColors.primarySoft,
  };
}

IconData _guideIcon(String iconKey) {
  return switch (iconKey) {
    'book' => Icons.menu_book_outlined,
    'calculator' => Icons.calculate_outlined,
    'shield' => Icons.shield_outlined,
    'chart' => Icons.bar_chart_rounded,
    'lock' => Icons.lock_outline_rounded,
    'bell' => Icons.notifications_active_outlined,
    'calendar' => Icons.event_available_outlined,
    'trend' => Icons.trending_up_rounded,
    'warning' => Icons.warning_amber_rounded,
    _ => Icons.lightbulb_outline_rounded,
  };
}
