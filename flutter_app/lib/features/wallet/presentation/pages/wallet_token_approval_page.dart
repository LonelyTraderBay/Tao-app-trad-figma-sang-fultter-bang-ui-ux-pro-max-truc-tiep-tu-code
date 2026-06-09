import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/wallet_token_active_approvals_tab.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/wallet_token_approval_common.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/wallet_token_approval_history_tab.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/wallet_token_approval_settings_tab.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/wallet_token_approval_tabs.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/wallet_token_revoke_sheet.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_bottom_sheet.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_high_risk_state_panel.dart';

class WalletTokenApprovalPage extends ConsumerStatefulWidget {
  const WalletTokenApprovalPage({super.key, this.shellRenderMode});

  static const contentKey = walletTokenApprovalContentKey;
  static const revokeAllKey = walletTokenApprovalRevokeAllKey;
  static const revokeSheetCancelKey = walletTokenApprovalRevokeSheetCancelKey;
  static const revokeSheetConfirmKey = walletTokenApprovalRevokeSheetConfirmKey;

  static Key tabKey(String label) => walletTokenApprovalTabKey(label);
  static Key approvalKey(String id) => walletTokenApprovalApprovalKey(id);
  static Key revokeKey(String id) => walletTokenApprovalRevokeKey(id);

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<WalletTokenApprovalPage> createState() =>
      _WalletTokenApprovalPageState();
}

class _WalletTokenApprovalPageState
    extends ConsumerState<WalletTokenApprovalPage> {
  String _tab = walletTokenApprovalTabActive;
  bool _autoRevokeUnused = true;
  bool _warnUnlimited = true;

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(tokenApprovalControllerProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 92
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-150 WalletTokenApprovalPage',
      child: Material(
        color: walletTokenApprovalBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Token Approvals',
            showBack: true,
            onBack: () =>
                goBackOrFallback(context, fallbackPath: AppRoutePaths.wallet),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              WalletTokenApprovalTabs(
                activeTab: _tab,
                onChanged: (tab) => setState(() => _tab = tab),
              ),
              Expanded(
                child: SingleChildScrollView(
                  key: WalletTokenApprovalPage.contentKey,
                  padding: EdgeInsets.fromLTRB(20, 13, 20, bottomInset),
                  child: _contentForTab(controller),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _contentForTab(TokenApprovalController controller) {
    final snapshot = controller.state.snapshot;
    if (_tab == walletTokenApprovalTabHistory) {
      return VitPageContent(
        padding: VitContentPadding.none,
        customGap: 0,
        fullBleed: true,
        children: [WalletTokenApprovalHistoryTab(snapshot: snapshot)],
      );
    }
    if (_tab == walletTokenApprovalTabSettings) {
      return VitPageContent(
        padding: VitContentPadding.none,
        customGap: 0,
        fullBleed: true,
        children: [
          WalletTokenApprovalSettingsTab(
            autoRevokeUnused: _autoRevokeUnused,
            warnUnlimited: _warnUnlimited,
            onAutoRevoke: () =>
                setState(() => _autoRevokeUnused = !_autoRevokeUnused),
            onWarnUnlimited: () =>
                setState(() => _warnUnlimited = !_warnUnlimited),
          ),
        ],
      );
    }
    return VitPageContent(
      padding: VitContentPadding.none,
      customGap: 16,
      fullBleed: true,
      children: [
        VitHighRiskStatePanel(
          state: VitHighRiskUiState.riskReview,
          title: 'Review token approval risk',
          message:
              'Prioritize critical, unlimited, and unused approvals before revoking permissions.',
          contractId:
              '${snapshot.criticalCount} critical / ${snapshot.unlimitedCount} unlimited',
        ),
        WalletTokenActiveApprovalsTab(
          snapshot: snapshot,
          onRevoke: (approval) => _showRevokeSheet(controller, approval),
          onRevokeAll: () => _showRevokeSheet(controller, null),
        ),
      ],
    );
  }

  void _showRevokeSheet(
    TokenApprovalController controller,
    WalletTokenApproval? approval,
  ) {
    final preview = controller.revokePreview(approval);
    showVitBottomSheet<void>(
      context: context,
      backgroundColor: walletTokenApprovalPanel,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) => WalletTokenRevokeSheet(preview: preview),
    );
  }
}
