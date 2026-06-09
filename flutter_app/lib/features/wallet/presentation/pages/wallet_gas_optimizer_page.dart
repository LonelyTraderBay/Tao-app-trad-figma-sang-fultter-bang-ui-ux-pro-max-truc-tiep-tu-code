import 'dart:math' as math;

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
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';

part '../widgets/wallet_gas_optimizer_current.dart';
part '../widgets/wallet_gas_optimizer_trends.dart';
part '../widgets/wallet_gas_optimizer_tips.dart';

const _gasBackground = AppColors.bg;
const _gasPanel = AppColors.surface;
const _gasBorder = AppColors.overlayStroke;
const _gasPrimary = AppColors.primary;
const _gasGreen = AppColors.buy;
const _gasAmber = AppColors.caution;
const _gasRed = AppColors.sell;

const _tabCurrent = 'Hien tai';
const _tabTrends = 'Xu huong';
const _tabTips = 'Meo tiet kiem';

class WalletGasOptimizerPage extends ConsumerStatefulWidget {
  const WalletGasOptimizerPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc149_gas_optimizer_content');
  static const refreshKey = Key('sc149_gas_optimizer_refresh');
  static Key tabKey(String label) => Key('sc149_gas_optimizer_tab_$label');
  static Key speedKey(String speed) => Key('sc149_gas_optimizer_speed_$speed');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<WalletGasOptimizerPage> createState() =>
      _WalletGasOptimizerPageState();
}

class _WalletGasOptimizerPageState
    extends ConsumerState<WalletGasOptimizerPage> {
  String _tab = _tabCurrent;
  String _selectedSpeed = 'standard';

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(walletGasOptimizerProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 92
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-149 WalletGasOptimizerPage',
      child: Material(
        color: _gasBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Gas Optimizer',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.wallet),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _GasTabs(
                activeTab: _tab,
                onChanged: (tab) => setState(() => _tab = tab),
              ),
              Expanded(
                child: SingleChildScrollView(
                  key: WalletGasOptimizerPage.contentKey,
                  padding: EdgeInsets.fromLTRB(20, 13, 20, bottomInset),
                  child: _contentForTab(snapshot),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _contentForTab(WalletGasOptimizerSnapshot snapshot) {
    final tabContent = switch (_tab) {
      _tabTrends => _TrendsTab(snapshot: snapshot),
      _tabTips => _TipsTab(snapshot: snapshot),
      _ => _CurrentGasTab(
        snapshot: snapshot,
        selectedSpeed: _selectedSpeed,
        onSelectSpeed: (speed) => setState(() => _selectedSpeed = speed),
      ),
    };

    return VitPageContent(
      padding: VitContentPadding.none,
      customGap: 0,
      fullBleed: true,
      children: [tabContent],
    );
  }
}
