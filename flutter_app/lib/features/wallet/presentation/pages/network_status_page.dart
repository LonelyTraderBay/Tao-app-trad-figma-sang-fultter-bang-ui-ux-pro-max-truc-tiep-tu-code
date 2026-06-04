import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';

part '../widgets/network_status_summary.dart';
part '../widgets/network_status_cards_stats.dart';
part '../widgets/network_status_legend_common.dart';

const _networkBackground = AppColors.bg;
const _networkPanel = AppColors.surface;
const _networkPanel2 = AppColors.surface2;
const _networkBorder = AppColors.overlayStroke;
const _networkPrimary = AppColors.primary;
const _networkGreen = AppColors.buy;
const _networkAmber = AppColors.caution;
const _networkOrange = AppColors.riskHigh;
const _networkRed = AppColors.sell;
const _networkMuted = AppColors.text3;

class NetworkStatusPage extends ConsumerWidget {
  const NetworkStatusPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc155_network_status_content');
  static const refreshKey = Key('sc155_network_status_refresh');
  static Key networkKey(String id) => Key('sc155_network_status_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(walletNetworkStatusProvider);
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 92
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-155 NetworkStatusPage',
      child: Material(
        color: _networkBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Tr\u1EA1ng th\u00E1i m\u1EA1ng',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.wallet),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: NetworkStatusPage.contentKey,
                  padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _SummaryCard(snapshot: snapshot),
                      const SizedBox(height: 18),
                      for (final network in snapshot.networks) ...[
                        _NetworkCard(network: network),
                        if (network != snapshot.networks.last)
                          const SizedBox(height: 14),
                      ],
                      const SizedBox(height: 18),
                      const _LegendCard(),
                      const SizedBox(height: 18),
                      const _DisclaimerCard(),
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
