import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/earn_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/earn_custody_risk_banner.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/savings_guide_common.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/savings_guide_glossary.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/savings_guide_tabs.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/savings_guide_tutorials.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

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
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: snapshot.title,
            subtitle: kSavingsToolsHeaderSubtitle,
            showBack: true,
            onBack: () => context.go(snapshot.backRoute),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SavingsGuideTabs(
                tabs: snapshot.tabs,
                active: _activeTab!,
                onChanged: (tab) {
                  HapticFeedback.selectionClick();
                  setState(() => _activeTab = tab);
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: AppSpacing.earnBottomInsetPadding(bottomInset),
                  child: VitPageContent(
                    rhythm: VitPageRhythm.standard,
                    padding: VitContentPadding.defaultPadding,
                    gap: VitContentGap.defaultGap,
                    children: [
                      if (_activeTab == 'tutorials')
                        VitCard(
                          variant: VitCardVariant.standard,
                          radius: VitCardRadius.standard,
                          padding: AppSpacing.zeroInsets,
                          child: SavingsGuideTutorialsTab(
                            snapshot: snapshot,
                            completedTutorials: _completedTutorials,
                            onTutorialTap: _openTutorialSheet,
                          ),
                        )
                      else
                        VitCard(
                          variant: VitCardVariant.standard,
                          radius: VitCardRadius.standard,
                          padding: AppSpacing.zeroInsets,
                          child: SavingsGuideGlossaryTab(snapshot: snapshot),
                        ),
                      const SavingsToolsYieldFooter(),
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

  Future<void> _openTutorialSheet(SavingsGuideTutorialDraft tutorial) async {
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
                    borderRadius: AppRadii.sheetTopRadius,
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    padding: AppSpacing.earnSheetContentPadding,
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
                            VitIconButton(
                              icon: Icons.close_rounded,
                              tooltip: 'Close tutorial',
                              variant: VitIconButtonVariant.transparent,
                              size: VitIconButtonSize.md,
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                        SavingsGuideProgressHeader(
                          stepIndex: stepIndex,
                          total: tutorial.steps.length,
                          progress: progress,
                        ),
                        const SizedBox(height: AppSpacing.pageRhythmFormSectionGap),
                        SavingsGuideStepDetail(step: step),
                        const SizedBox(height: AppSpacing.pageRhythmFormSectionGap),
                        SavingsGuideTipPanel(tips: step.tips),
                        const SizedBox(height: AppSpacing.pageRhythmFormSectionGap),
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
                                    ? SavingsGuideKeys.completeButton
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
