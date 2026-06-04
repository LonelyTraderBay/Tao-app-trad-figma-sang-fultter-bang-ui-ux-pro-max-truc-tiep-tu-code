import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/widgets/p2p_notice_widgets.dart';

part '../widgets/p2p_escrow_balance_page_sections.dart';
part '../widgets/p2p_escrow_balance_page_common.dart';

class P2PEscrowBalancePage extends ConsumerStatefulWidget {
  const P2PEscrowBalancePage({
    super.key,
    this.initialAsset = 'USDT',
    this.shellRenderMode,
  });

  static const heroKey = Key('sc245_p2p_escrow_hero');
  static const infoKey = Key('sc245_p2p_escrow_info');
  static const tabsKey = Key('sc245_p2p_escrow_tabs');
  static const ordersKey = Key('sc245_p2p_escrow_orders');
  static const helpKey = Key('sc245_p2p_escrow_help');
  static const emptyKey = Key('sc245_p2p_escrow_empty');

  final String initialAsset;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PEscrowBalancePage> createState() =>
      _P2PEscrowBalancePageState();
}

class _P2PEscrowBalancePageState extends ConsumerState<P2PEscrowBalancePage> {
  late String _asset;

  @override
  void initState() {
    super.initState();
    _asset = widget.initialAsset;
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(p2pEscrowBalanceProvider(_asset));
    final selectedAsset = snapshot.selectedAsset;
    final selectedBalance = snapshot.assetBalance(selectedAsset);
    final orders = snapshot.ordersFor(selectedAsset);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    if (_asset != selectedAsset) {
      _asset = selectedAsset;
    }

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-245 P2PEscrowBalancePage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: snapshot.title,
            subtitle: snapshot.subtitle,
            showBack: true,
            onBack: () => context.go(snapshot.parentRoute),
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
                        _EscrowHeroCard(balance: selectedBalance),
                        const SizedBox(height: AppSpacing.x4),
                        _EscrowInfoCard(snapshot: snapshot),
                        const SizedBox(height: AppSpacing.x5),
                        _AssetTabs(
                          assets: snapshot.assets,
                          selectedAsset: selectedAsset,
                          onChanged: (asset) {
                            HapticFeedback.selectionClick();
                            setState(() => _asset = asset);
                          },
                        ),
                        const SizedBox(height: AppSpacing.x4),
                        if (orders.isEmpty)
                          _EscrowEmptyState(snapshot: snapshot)
                        else
                          _OrdersList(orders: orders),
                        if (orders.isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.x5),
                          _EscrowHelpCard(snapshot: snapshot),
                        ],
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
