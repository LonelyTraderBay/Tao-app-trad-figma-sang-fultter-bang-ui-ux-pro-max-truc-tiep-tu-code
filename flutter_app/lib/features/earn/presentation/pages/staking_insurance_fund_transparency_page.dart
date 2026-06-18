import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/earn_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_insurance_fund_claims.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_insurance_fund_common.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_insurance_fund_history.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_insurance_fund_overview.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';

class StakingInsuranceFundTransparencyPage extends ConsumerStatefulWidget {
  const StakingInsuranceFundTransparencyPage({super.key, this.shellRenderMode});

  static const infoKey = StakingInsuranceFundKeys.info;
  static const tabsKey = StakingInsuranceFundKeys.tabs;
  static const fundStatusKey = StakingInsuranceFundKeys.fundStatus;
  static const assetBreakdownKey = StakingInsuranceFundKeys.assetBreakdown;
  static const contributionKey = StakingInsuranceFundKeys.contribution;
  static const claimsKey = StakingInsuranceFundKeys.claims;
  static const historyKey = StakingInsuranceFundKeys.history;
  static const auditsKey = StakingInsuranceFundKeys.audits;
  static const footerKey = StakingInsuranceFundKeys.footer;

  static Key tabKey(String id) => StakingInsuranceFundKeys.tab(id);

  static Key claimKey(String id) => StakingInsuranceFundKeys.claim(id);

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingInsuranceFundTransparencyPage> createState() =>
      _StakingInsuranceFundTransparencyPageState();
}

class _StakingInsuranceFundTransparencyPageState
    extends ConsumerState<StakingInsuranceFundTransparencyPage> {
  StakingInsuranceFundTab _tab = StakingInsuranceFundTab.overview;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(stakingInsuranceFundTransparencyRepositoryProvider)
        .getTransparency();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-377 StakingInsuranceFundTransparencyPage',
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
                      VitCard(
                        variant: VitCardVariant.standard,
                        radius: VitCardRadius.md,
                        padding: AppSpacing.zeroInsets,
                        child: StakingInsuranceFundInfoBanner(
                          snapshot: snapshot,
                        ),
                      ),
                      StakingInsuranceFundTabs(
                        active: _tab,
                        onChanged: (tab) {
                          HapticFeedback.selectionClick();
                          setState(() => _tab = tab);
                        },
                      ),
                      if (_tab == StakingInsuranceFundTab.overview)
                        StakingInsuranceFundOverviewTab(snapshot: snapshot)
                      else if (_tab == StakingInsuranceFundTab.claims)
                        StakingInsuranceFundClaimsTab(snapshot: snapshot)
                      else
                        StakingInsuranceFundHistoryTab(snapshot: snapshot),
                      StakingInsuranceFundFooterNote(note: snapshot.footerNote),
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
