import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

part '../widgets/staking_insurance_common.dart';
part '../widgets/staking_insurance_overview.dart';
part '../widgets/staking_insurance_plans.dart';
part '../widgets/staking_insurance_positions.dart';
part '../widgets/staking_insurance_claims.dart';
part '../widgets/staking_insurance_sheets.dart';

enum _InsuranceTab { overview, plans, positions, claims }

class StakingInsurancePage extends ConsumerStatefulWidget {
  const StakingInsurancePage({super.key, this.shellRenderMode});

  static const infoKey = Key('sc365_info_banner');
  static const tabsKey = Key('sc365_tabs');
  static const overviewSummaryKey = Key('sc365_overview_summary');
  static const benefitsKey = Key('sc365_benefits');
  static const warningKey = Key('sc365_warning');
  static const planSheetKey = Key('sc365_plan_sheet');
  static const claimSheetKey = Key('sc365_claim_sheet');
  static const positionsKey = Key('sc365_positions');
  static const claimsKey = Key('sc365_claims');

  static Key tabKey(String id) => Key('sc365_tab_$id');

  static Key planKey(String id) => Key('sc365_plan_$id');

  static Key positionKey(String id) => Key('sc365_position_$id');

  static Key claimKey(String id) => Key('sc365_claim_$id');

  static Key addInsuranceKey(String id) => Key('sc365_add_insurance_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingInsurancePage> createState() =>
      _StakingInsurancePageState();
}

class _StakingInsurancePageState extends ConsumerState<StakingInsurancePage> {
  _InsuranceTab _tab = _InsuranceTab.overview;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(stakingInsuranceRepositoryProvider)
        .getInsurance();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-365 StakingInsurancePage',
      child: Material(
        color: AppColors.bg,
        child: VitAutoHideHeaderScaffold(
          header: VitTopChrome(
            type: VitTopChromeType.detail,
            title: snapshot.title,
            subtitle: snapshot.infoTitle,
            showBack: true,
            onBack: () => context.go(snapshot.backRoute),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: EarnSpacingTokens.earnBottomInsetPadding(
                    bottomInset,
                  ),
                  child: VitPageContent(
                    rhythm: VitPageRhythm.standard,
                    padding: VitContentPadding.compact,
                    gap: VitContentGap.defaultGap,
                    children: [
                      _InfoBanner(snapshot: snapshot),
                      _InsuranceTabs(
                        active: _tab,
                        onChanged: (tab) {
                          HapticFeedback.selectionClick();
                          setState(() => _tab = tab);
                        },
                      ),
                      if (_tab == _InsuranceTab.overview)
                        _OverviewTab(snapshot: snapshot),
                      if (_tab == _InsuranceTab.plans)
                        _PlansTab(snapshot: snapshot, onOpenPlan: _showPlan),
                      if (_tab == _InsuranceTab.positions)
                        _PositionsTab(
                          snapshot: snapshot,
                          onAddInsurance: (position) {
                            HapticFeedback.lightImpact();
                            setState(() => _tab = _InsuranceTab.plans);
                          },
                        ),
                      if (_tab == _InsuranceTab.claims)
                        _ClaimsTab(
                          snapshot: snapshot,
                          onFileClaim: () => _showClaimForm(snapshot),
                        ),
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

  Future<void> _showPlan(StakingInsurancePlanDraft plan) async {
    HapticFeedback.selectionClick();
    await showVitBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) => _SheetFrame(child: _PlanSheet(plan: plan)),
    );
  }

  Future<void> _showClaimForm(StakingInsuranceSnapshot snapshot) async {
    HapticFeedback.selectionClick();
    await showVitBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) => _SheetFrame(child: _ClaimSheet(snapshot: snapshot)),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.snapshot});

  final StakingInsuranceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingInsurancePage.infoKey,
      variant: VitCardVariant.inner,
      borderColor: AppModuleAccents.earn.withValues(alpha: 0.2),
      padding: EarnSpacingTokens.earnPaddingX4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppModuleAccents.earn,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              snapshot.infoBody,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}

class _InsuranceTabs extends StatelessWidget {
  const _InsuranceTabs({required this.active, required this.onChanged});

  final _InsuranceTab active;
  final ValueChanged<_InsuranceTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitTabBar(
      key: StakingInsurancePage.tabsKey,
      variant: VitTabBarVariant.segment,
      activeKey: active.name,
      onChanged: (key) => onChanged(_InsuranceTab.values.byName(key)),
      tabs: [
        for (final tab in _InsuranceTab.values)
          VitTabItem(
            key: tab.name,
            label: _tabLabel(tab),
            widgetKey: StakingInsurancePage.tabKey(tab.name),
          ),
      ],
    );
  }
}

String _tabLabel(_InsuranceTab tab) {
  return switch (tab) {
    _InsuranceTab.overview => 'Tổng quan',
    _InsuranceTab.plans => 'Plans',
    _InsuranceTab.positions => 'Vị thế',
    _InsuranceTab.claims => 'Claims',
  };
}
