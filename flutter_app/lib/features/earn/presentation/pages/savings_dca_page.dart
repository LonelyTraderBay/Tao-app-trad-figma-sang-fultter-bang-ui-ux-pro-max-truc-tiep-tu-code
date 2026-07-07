import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
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
import 'package:vit_trade_flutter/features/earn/presentation/widgets/earn_custody_risk_banner.dart';
part '../widgets/savings_dca_summary.dart';
part '../widgets/savings_dca_plans.dart';
part '../widgets/savings_dca_history_sheet.dart';
part '../widgets/savings_dca_common.dart';

TextStyle get _captionBold =>
    AppTextStyles.caption.copyWith(fontWeight: AppTextStyles.bold);
TextStyle get _microBold =>
    AppTextStyles.micro.copyWith(fontWeight: AppTextStyles.bold);

class SavingsDCAPage extends ConsumerStatefulWidget {
  const SavingsDCAPage({super.key, this.shellRenderMode});

  static const summaryKey = Key('sc346_summary');
  static const plansListKey = Key('sc346_plans_list');
  static const historyListKey = Key('sc346_history_list');
  static const createPlanKey = Key('sc346_create_plan');
  static const createSheetKey = Key('sc346_create_sheet');

  static Key tabKey(String tab) => Key('sc346_tab_$tab');
  static Key planKey(String id) => Key('sc346_plan_$id');
  static Key executionKey(String id) => Key('sc346_execution_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SavingsDCAPage> createState() => _SavingsDCAPageState();
}

class _SavingsDCAPageState extends ConsumerState<SavingsDCAPage> {
  String? _tab;
  final Set<String> _locallyPaused = {};

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(savingsDcaRepositoryProvider).getDca();
    final activeTab = _tab ?? snapshot.defaultTab;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-346 SavingsDCAPage',
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
              ColoredBox(
                color: AppColors.surface,
                child: Padding(
                  padding: AppSpacing.earnSurfaceTabsPadding,
                  child: _DcaTabs(
                    tabs: snapshot.tabs,
                    active: activeTab,
                    onChanged: (tab) {
                      HapticFeedback.selectionClick();
                      setState(() => _tab = tab);
                    },
                  ),
                ),
              ),
              const Divider(
                height: AppSpacing.dividerHairline,
                thickness: AppSpacing.dividerHairline,
                color: AppColors.divider,
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: AppSpacing.earnBottomInsetPadding(bottomInset),
                  child: VitPageContent(
 rhythm: VitPageRhythm.standard,
                    padding: VitContentPadding.compact,
                    gap: VitContentGap.defaultGap,
                    children: [
                      _DcaSummaryCard(
                        snapshot: snapshot,
                        onCreate: () => _openCreateSheet(snapshot),
                        onPlans: () => setState(() => _tab = 'plans'),
                        onHistory: () => setState(() => _tab = 'history'),
                      ),
                      EarnInfoBanner(text: snapshot.infoText),
                      if (activeTab == 'plans')
                        _PlansList(
                          plans: snapshot.plans,
                          locallyPaused: _locallyPaused,
                          onToggle: _togglePlan,
                        )
                      else
                        _HistoryList(executions: snapshot.executions),
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

  void _togglePlan(SavingsDcaPlanDraft plan) {
    HapticFeedback.selectionClick();
    setState(() {
      if (_locallyPaused.contains(plan.id)) {
        _locallyPaused.remove(plan.id);
      } else {
        _locallyPaused.add(plan.id);
      }
    });
  }

  Future<void> _openCreateSheet(SavingsDcaSnapshot snapshot) async {
    HapticFeedback.selectionClick();
    await showVitBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) => _CreatePlanSheet(snapshot: snapshot),
    );
  }
}
