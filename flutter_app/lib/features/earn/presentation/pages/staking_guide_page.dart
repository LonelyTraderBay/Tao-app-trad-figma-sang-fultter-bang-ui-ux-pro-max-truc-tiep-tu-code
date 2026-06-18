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
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_controller_providers.dart';

part '../widgets/staking_guide_page_sections.dart';
part '../widgets/staking_guide_page_common.dart';

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
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: snapshot.title,
            showBack: true,
            onBack: () => context.go(snapshot.backRoute),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: AppSpacing.earnBottomInsetPadding(bottomInset),
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
      ),
    );
  }

  Future<void> _openTutorialSheet(StakingGuideTutorialDraft tutorial) async {
    HapticFeedback.selectionClick();
    await showVitBottomSheet<void>(
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
                decoration: const ShapeDecoration(
                  color: AppColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadii.sheetTopLargeRadius,
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: SingleChildScrollView(
                    key: StakingGuidePage.tutorialSheetKey,
                    physics: const BouncingScrollPhysics(),
                    padding: AppSpacing.earnSheetContentPadding,
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
