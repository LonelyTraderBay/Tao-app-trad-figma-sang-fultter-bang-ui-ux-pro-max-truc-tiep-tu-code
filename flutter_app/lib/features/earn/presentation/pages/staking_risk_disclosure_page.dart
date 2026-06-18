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

part '../widgets/staking_risk_disclosure_overview.dart';
part '../widgets/staking_risk_disclosure_categories.dart';
part '../widgets/staking_risk_disclosure_assessment_common.dart';

class StakingRiskDisclosurePage extends ConsumerStatefulWidget {
  const StakingRiskDisclosurePage({super.key, this.shellRenderMode});

  static const warningKey = Key('sc354_risk_warning');
  static const overviewKey = Key('sc354_risk_overview');
  static const assessmentCtaKey = Key('sc354_risk_assessment_cta');

  static Key tabKey(String id) => Key('sc354_risk_tab_$id');
  static Key categoryKey(String id) => Key('sc354_risk_category_$id');
  static Key productKey(String name) => Key('sc354_risk_product_$name');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingRiskDisclosurePage> createState() =>
      _StakingRiskDisclosurePageState();
}

class _StakingRiskDisclosurePageState
    extends ConsumerState<StakingRiskDisclosurePage> {
  String? _activeTab;
  String? _expandedRisk;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(stakingRiskDisclosureRepositoryProvider)
        .getDisclosure();
    final activeTab = _activeTab ?? snapshot.defaultTab;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-354 StakingRiskDisclosurePage',
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
                      _WarningBanner(snapshot: snapshot),
                      _RiskTabs(
                        tabs: snapshot.tabs,
                        active: activeTab,
                        onChanged: (tab) {
                          HapticFeedback.selectionClick();
                          setState(() => _activeTab = tab);
                        },
                      ),
                      if (activeTab == 'overview')
                        _OverviewTab(snapshot: snapshot)
                      else if (activeTab == 'categories')
                        _CategoriesTab(
                          snapshot: snapshot,
                          expandedRisk: _expandedRisk,
                          onToggle: (id) {
                            HapticFeedback.selectionClick();
                            setState(() {
                              _expandedRisk = _expandedRisk == id ? null : id;
                            });
                          },
                        )
                      else
                        _AssessmentTab(
                          snapshot: snapshot,
                          onStart: () => context.go(snapshot.assessmentRoute),
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
}
