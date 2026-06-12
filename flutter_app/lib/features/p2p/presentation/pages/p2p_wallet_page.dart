import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
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
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/widgets/p2p_notice_widgets.dart';

part '../widgets/p2p_wallet_hero.dart';
part '../widgets/p2p_wallet_balances.dart';
part '../widgets/p2p_wallet_actions_history.dart';

class P2PWalletPage extends ConsumerStatefulWidget {
  const P2PWalletPage({super.key, this.shellRenderMode});

  static const heroKey = Key('sc264_p2p_wallet_hero');
  static const privacyKey = Key('sc264_p2p_wallet_privacy');
  static const transferFromMainKey = Key('sc264_p2p_wallet_from_main');
  static const transferToMainKey = Key('sc264_p2p_wallet_to_main');
  static const infoKey = Key('sc264_p2p_wallet_info');
  static const balancesKey = Key('sc264_p2p_wallet_balances');
  static const transactionsKey = Key('sc264_p2p_wallet_transactions');
  static const historyActionKey = Key('sc264_p2p_wallet_history_action');

  static Key balanceKey(String asset) => Key('sc264_p2p_wallet_balance_$asset');

  static Key depositKey(String asset) => Key('sc264_p2p_wallet_deposit_$asset');

  static Key withdrawKey(String asset) =>
      Key('sc264_p2p_wallet_withdraw_$asset');

  static Key escrowKey(String asset) => Key('sc264_p2p_wallet_escrow_$asset');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PWalletPage> createState() => _P2PWalletPageState();
}

class _P2PWalletPageState extends ConsumerState<P2PWalletPage> {
  bool _balanceVisible = true;
  String? _expandedAsset;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(p2pWalletProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-264 P2PWalletPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: snapshot.title,
            subtitle: snapshot.subtitle,
            showBack: true,
            onBack: () => context.go(snapshot.parentRoute),
            actions: [
              VitHeaderActionItem(
                key: P2PWalletPage.historyActionKey,
                type: VitHeaderActionType.history,
                onPressed: () => context.go(snapshot.historyRoute),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.contentPad,
                      AppSpacing.x4,
                      AppSpacing.contentPad,
                      bottomInset,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _WalletHero(
                          snapshot: snapshot,
                          balanceVisible: _balanceVisible,
                          onPrivacyToggle: () {
                            HapticFeedback.selectionClick();
                            setState(() => _balanceVisible = !_balanceVisible);
                          },
                          onTransferFromMain: () => context.go(
                            '${snapshot.transferRoute}?direction=from-main',
                          ),
                          onTransferToMain: () => context.go(
                            '${snapshot.transferRoute}?direction=to-main',
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x4),
                        _WalletInfoBanner(text: snapshot.infoNote),
                        const SizedBox(height: AppSpacing.x5),
                        _BalanceSection(
                          snapshot: snapshot,
                          expandedAsset: _expandedAsset,
                          onToggle: (asset) {
                            HapticFeedback.selectionClick();
                            setState(() {
                              _expandedAsset = _expandedAsset == asset
                                  ? null
                                  : asset;
                            });
                          },
                        ),
                        const SizedBox(height: AppSpacing.x6),
                        _RecentTransactions(snapshot: snapshot),
                        VitPageContent(
                          padding: VitContentPadding.compact,
                          customGap: 0,
                          children: const [
                            VitHighRiskStatePanel(
                              state: VitHighRiskUiState.riskReview,
                              title: 'P2P wallet state review',
                              message:
                                  'Masked balance, transfer directions, escrow balances, expanded asset actions, recent transactions, and history route remain visible before moving funds.',
                              contractId: 'SC-264',
                            ),
                          ],
                        ),
                      ],
                    ),
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
