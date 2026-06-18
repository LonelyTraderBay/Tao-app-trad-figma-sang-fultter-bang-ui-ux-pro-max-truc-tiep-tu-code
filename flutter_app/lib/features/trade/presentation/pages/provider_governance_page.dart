import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

part '../widgets/provider_governance_page_overview.dart';
part '../widgets/provider_governance_page_details.dart';
part '../widgets/provider_governance_page_common.dart';

const _governancePrimary = AppColors.primary;
const _governanceWarningBorder = AppColors.warningBorderStrong;
const _governanceWarning = AppColors.caution;

class ProviderGovernancePage extends ConsumerStatefulWidget {
  const ProviderGovernancePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc081_provider_governance_content');
  static const requestActionKey = Key('sc081_request_strategy_modification');
  static Key tabKey(String id) => Key('sc081_tab_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ProviderGovernancePage> createState() =>
      _ProviderGovernancePageState();
}

class _ProviderGovernancePageState
    extends ConsumerState<ProviderGovernancePage> {
  late String _activeTabId;
  bool _showMessagePanel = false;
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(tradeProviderGovernanceProvider);
    if (!_initialized) {
      _activeTabId = snapshot.defaultTabId;
      _initialized = true;
    }

    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame
            ? AppSpacing.providerGovernanceBottomInsetVisualExtra
            : AppSpacing.providerGovernanceBottomInsetNativeExtra);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-081 ProviderGovernancePage',
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            VitAutoHideHeaderScaffold(
              header: VitHeader(
                title: 'Provider Governance',
                showBack: true,
                onBack: () => context.go(AppRoutePaths.tradeCopyTrading),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      key: ProviderGovernancePage.contentKey,
                      padding: AppSpacing.providerGovernanceScrollPadding(
                        bottomInset,
                      ),
                      child: VitPageContent(
                        padding: VitContentPadding.none,
                        fullBleed: true,
                        customGap: AppSpacing.providerGovernanceContentGap,
                        children: [
                          _ProviderDashboard(stats: snapshot.stats),
                          const SizedBox(
                            height: AppSpacing.providerGovernanceSectionGap,
                          ),
                          const VitHighRiskStatePanel(
                            state: VitHighRiskUiState.riskReview,
                            title: 'Provider governance review',
                            message:
                                'Review strategy change notice, follower impact, fee waterfall, compliance score, limits, and next steps before broadcasting or modifying strategy.',
                            contractId: 'SC-081 provider governance review',
                          ),
                          const SizedBox(
                            height: AppSpacing.providerGovernanceControlGap,
                          ),
                          _GovernanceTabs(
                            tabs: snapshot.tabs,
                            activeId: _activeTabId,
                            onChanged: (id) =>
                                setState(() => _activeTabId = id),
                          ),
                          const SizedBox(
                            height: AppSpacing.providerGovernanceTabBodyGap,
                          ),
                          if (_activeTabId == 'modifications')
                            _ModificationsTab(
                              snapshot: snapshot,
                              onRequest: () =>
                                  setState(() => _showMessagePanel = true),
                            )
                          else if (_activeTabId == 'communication')
                            _CommunicationTab(
                              snapshot: snapshot,
                              onBroadcast: () =>
                                  setState(() => _showMessagePanel = true),
                            )
                          else if (_activeTabId == 'fees')
                            _FeesTab(snapshot: snapshot)
                          else
                            _ComplianceTab(snapshot: snapshot),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_showMessagePanel)
              _MessagePanel(
                onClose: () => setState(() => _showMessagePanel = false),
              ),
          ],
        ),
      ),
    );
  }
}
