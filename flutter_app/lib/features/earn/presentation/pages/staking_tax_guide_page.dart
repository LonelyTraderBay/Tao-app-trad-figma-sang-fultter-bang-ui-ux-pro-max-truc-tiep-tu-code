import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/earn_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_tax_guide_calculator.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_tax_guide_common.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_tax_guide_header.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_tax_guide_jurisdictions.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_tax_guide_overview.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';

class StakingTaxGuidePage extends ConsumerStatefulWidget {
  const StakingTaxGuidePage({super.key, this.shellRenderMode});

  static const disclaimerKey = StakingTaxGuideKeys.disclaimer;
  static const overviewKey = StakingTaxGuideKeys.overview;
  static const summaryKey = StakingTaxGuideKeys.summary;
  static const historyToolKey = StakingTaxGuideKeys.historyTool;
  static const taxReportsToolKey = StakingTaxGuideKeys.taxReportsTool;
  static const calculatorResultKey = StakingTaxGuideKeys.calculatorResult;

  static Key jurisdictionKey(String id) => StakingTaxGuideKeys.jurisdiction(id);

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingTaxGuidePage> createState() =>
      _StakingTaxGuidePageState();
}

class _StakingTaxGuidePageState extends ConsumerState<StakingTaxGuidePage> {
  final _rewardsController = TextEditingController();
  final _rateController = TextEditingController();
  String? _activeTab;
  String _selectedJurisdiction = 'us';

  @override
  void dispose() {
    _rewardsController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(stakingTaxGuideRepositoryProvider).getGuide();
    final activeTab = _activeTab ?? snapshot.defaultTab;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-356 StakingTaxGuidePage',
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
                    StakingTaxDisclaimerBanner(snapshot: snapshot),
                    StakingTaxTabs(
                      tabs: snapshot.tabs,
                      active: activeTab,
                      onChanged: (tab) {
                        HapticFeedback.selectionClick();
                        setState(() => _activeTab = tab);
                      },
                    ),
                    if (activeTab == 'overview')
                      StakingTaxOverviewTab(snapshot: snapshot)
                    else if (activeTab == 'jurisdictions')
                      StakingTaxJurisdictionTab(
                        snapshot: snapshot,
                        selectedId: _selectedJurisdiction,
                        onChanged: (id) {
                          HapticFeedback.selectionClick();
                          setState(() => _selectedJurisdiction = id);
                        },
                      )
                    else
                      StakingTaxCalculatorTab(
                        snapshot: snapshot,
                        rewardsController: _rewardsController,
                        rateController: _rateController,
                        onChanged: () => setState(() {}),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
