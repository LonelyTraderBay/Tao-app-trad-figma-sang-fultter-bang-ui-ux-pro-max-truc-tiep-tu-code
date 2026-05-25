import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_content.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/earn_repository.dart';

class SavingsGuidePage extends ConsumerStatefulWidget {
  const SavingsGuidePage({super.key, this.shellRenderMode});

  static const tutorialListKey = Key('sc335_tutorial_list');
  static const glossaryListKey = Key('sc335_glossary_list');
  static const firstTutorialKey = Key('sc335_first_tutorial');
  static const startButtonKey = Key('sc335_start_button');
  static const completeButtonKey = Key('sc335_complete_tutorial_button');

  static Key tabKey(String id) => Key('sc335_tab_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SavingsGuidePage> createState() => _SavingsGuidePageState();
}

class _SavingsGuidePageState extends ConsumerState<SavingsGuidePage> {
  String? _activeTab;
  final Set<String> _completedTutorials = <String>{};

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(savingsGuideRepositoryProvider).getGuide();
    _activeTab ??= snapshot.defaultTab;

    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-335 SavingsGuidePage',
      child: Material(
        color: AppColors.bg,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
            ),
            _GuideTabs(
              tabs: snapshot.tabs,
              active: _activeTab!,
              onChanged: (tab) {
                HapticFeedback.selectionClick();
                setState(() => _activeTab = tab);
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: bottomInset),
                child: VitPageContent(
                  padding: VitContentPadding.defaultPadding,
                  gap: VitContentGap.defaultGap,
                  children: [
                    if (_activeTab == 'tutorials')
                      _TutorialsTab(
                        snapshot: snapshot,
                        completedTutorials: _completedTutorials,
                        onTutorialTap: _openTutorialSheet,
                      )
                    else
                      _GlossaryTab(snapshot: snapshot),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openTutorialSheet(SavingsGuideTutorialDraft tutorial) async {
    HapticFeedback.selectionClick();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
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
                                style: AppTextStyles.baseMedium.copyWith(
                                  color: AppColors.text1,
                                ),
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
                                    ? SavingsGuidePage.completeButtonKey
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
                                  setState(() {
                                    _completedTutorials.add(tutorial.id);
                                  });
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

class _GuideTabs extends StatelessWidget {
  const _GuideTabs({
    required this.tabs,
    required this.active,
    required this.onChanged,
  });

  final List<SavingsGuideTabDraft> tabs;
  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x4,
        AppSpacing.contentPad,
        0,
      ),
      child: VitTabBar(
        variant: VitTabBarVariant.underline,
        activeKey: active,
        onChanged: onChanged,
        tabs: [
          for (final tab in tabs) VitTabItem(key: tab.id, label: tab.label),
        ],
      ),
    );
  }
}

class _TutorialsTab extends StatelessWidget {
  const _TutorialsTab({
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
        const SizedBox(height: AppSpacing.x5),
        _LearningProgressCard(
          completed: completedTutorials.length,
          total: snapshot.tutorials.length,
          progress: progress,
        ),
        const SizedBox(height: AppSpacing.x5),
        VitPageSection(
          label: 'Bài hướng dẫn',
          accentColor: AppColors.buy,
          children: [
            Column(
              key: SavingsGuidePage.tutorialListKey,
              children: [
                for (final tutorial in snapshot.tutorials) ...[
                  _TutorialCard(
                    key: tutorial == snapshot.tutorials.first
                        ? SavingsGuidePage.firstTutorialKey
                        : null,
                    tutorial: tutorial,
                    completed: completedTutorials.contains(tutorial.id),
                    onTap: () => onTutorialTap(tutorial),
                  ),
                  if (tutorial != snapshot.tutorials.last)
                    const SizedBox(height: AppSpacing.x3),
                ],
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x5),
        VitPageSection(
          label: 'Mẹo nhanh',
          accentColor: AppColors.warn,
          children: [_QuickTipsGrid(tips: snapshot.quickTips)],
        ),
        const SizedBox(height: AppSpacing.x5),
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
      decoration: BoxDecoration(
        color: AppColors.buy10,
        border: Border.all(color: AppColors.buy20),
        borderRadius: AppRadii.cardLargeRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x4),
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
                  const SizedBox(height: AppSpacing.x2),
                  Text(
                    snapshot.heroSubtitle,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height: 1.55,
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
      padding: const EdgeInsets.all(AppSpacing.x4),
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
          const SizedBox(height: AppSpacing.x3),
          ClipRRect(
            borderRadius: AppRadii.xsRadius,
            child: LinearProgressIndicator(
              minHeight: AppSpacing.x2,
              value: progress,
              backgroundColor: AppColors.borderSolid,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.buy),
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
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
      radius: VitCardRadius.lg,
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _RoundIcon(
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
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  Wrap(
                    spacing: AppSpacing.x2,
                    runSpacing: AppSpacing.x1,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _DifficultyPill(difficulty: tutorial.difficulty),
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
        final itemWidth = (constraints.maxWidth - AppSpacing.x2) / 2;
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
    final color = _riskColor(tip.tone);
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
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1.45,
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
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sẵn sàng bắt đầu?', style: AppTextStyles.baseMedium),
          const SizedBox(height: AppSpacing.x2),
          Text(
            'Khám phá các sản phẩm tiết kiệm đang có lãi suất hấp dẫn.',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          VitCtaButton(
            key: SavingsGuidePage.startButtonKey,
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

class _GlossaryTab extends StatelessWidget {
  const _GlossaryTab({required this.snapshot});

  final SavingsGuideSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: SavingsGuidePage.glossaryListKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Icon(
              Icons.help_outline_rounded,
              color: AppColors.primary,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x2),
            Text(
              '${snapshot.terms.length} thuật ngữ',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x4),
        for (final term in snapshot.terms) ...[
          _TermCard(term: term),
          if (term != snapshot.terms.last)
            const SizedBox(height: AppSpacing.x3),
        ],
        const SizedBox(height: AppSpacing.x4),
        VitCard(
          variant: VitCardVariant.inner,
          borderColor: AppColors.primary20,
          padding: const EdgeInsets.all(AppSpacing.x3),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.shield_outlined,
                color: AppColors.primary,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  snapshot.disclaimer,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.primary,
                    height: 1.45,
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

class _TermCard extends StatelessWidget {
  const _TermCard({required this.term});

  final SavingsGuideTermDraft term;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _RoundIcon(
            icon: Icons.text_fields_rounded,
            color: AppColors.primary,
            label: term.term.length < 2 ? term.term : term.term.substring(0, 2),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  term.term,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  term.definition,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
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

  final SavingsGuideStepDraft step;

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
              color: AppColors.buy,
              size: AppSpacing.buttonStandard,
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Text(
                step.title,
                style: AppTextStyles.baseMedium.copyWith(
                  color: AppColors.text1,
                ),
              ),
            ),
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

  final SavingsGuideDifficulty difficulty;

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
          _difficultyLabel(difficulty),
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
    this.label,
  });

  final IconData icon;
  final Color color;
  final double size;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color.withValues(alpha: 0.22)),
        borderRadius: AppRadii.mdRadius,
      ),
      child: SizedBox(
        width: size,
        height: size,
        child: Center(
          child: label == null
              ? Icon(icon, color: color, size: AppSpacing.iconSm)
              : Text(
                  label!,
                  style: AppTextStyles.micro.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
        ),
      ),
    );
  }
}

IconData _guideIcon(String iconKey) {
  return switch (iconKey) {
    'piggy' => Icons.savings_outlined,
    'trend' => Icons.trending_up_rounded,
    'shield' => Icons.shield_outlined,
    'zap' => Icons.bolt_rounded,
    'lock' => Icons.lock_outline_rounded,
    'calculator' => Icons.calculate_outlined,
    'alert' => Icons.warning_amber_rounded,
    'check' => Icons.check_circle_outline_rounded,
    _ => Icons.menu_book_outlined,
  };
}

String _difficultyLabel(SavingsGuideDifficulty difficulty) {
  return switch (difficulty) {
    SavingsGuideDifficulty.beginner => 'Cơ bản',
    SavingsGuideDifficulty.intermediate => 'Trung bình',
    SavingsGuideDifficulty.advanced => 'Nâng cao',
  };
}

Color _difficultyColor(SavingsGuideDifficulty difficulty) {
  return switch (difficulty) {
    SavingsGuideDifficulty.beginner => AppColors.buy,
    SavingsGuideDifficulty.intermediate => AppColors.primary,
    SavingsGuideDifficulty.advanced => AppColors.warn,
  };
}

Color _riskColor(EarnRiskLevel tone) {
  return switch (tone) {
    EarnRiskLevel.low => AppColors.buy,
    EarnRiskLevel.medium => AppColors.primary,
    EarnRiskLevel.high => AppColors.sell,
  };
}
