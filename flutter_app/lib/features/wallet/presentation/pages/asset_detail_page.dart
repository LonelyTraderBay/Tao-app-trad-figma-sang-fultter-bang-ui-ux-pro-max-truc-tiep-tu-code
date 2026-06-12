import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';

part '../widgets/asset_detail_page_sections.dart';
part '../widgets/asset_detail_page_common.dart';

const _assetBackground = AppColors.bg;
const _assetGreen = AppColors.buy;
const _assetRed = AppColors.sell;
const _assetPrimary = AppColors.primary;

class AssetDetailPage extends ConsumerStatefulWidget {
  const AssetDetailPage({
    super.key,
    required this.assetId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc147_asset_detail_content');
  static Key actionKey(String id) => Key('sc147_asset_action_$id');
  static Key periodKey(String id) => Key('sc147_asset_period_$id');
  static Key transactionKey(String id) => Key('sc147_asset_tx_$id');

  final String assetId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<AssetDetailPage> createState() => _AssetDetailPageState();
}

class _AssetDetailPageState extends ConsumerState<AssetDetailPage> {
  String _period = '1M';

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(walletAssetDetailProvider(widget.assetId));
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome +
                  AppSpacing.walletBottomInsetVisualChrome
            : DeviceMetrics.nativeBottomChrome +
                  AppSpacing.walletBottomInsetNativeChrome) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-147 AssetDetailPage',
      child: Material(
        color: _assetBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: snapshot.symbol,
            subtitle: 'Chi tiết · Wallet',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.wallet),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: AssetDetailPage.contentKey,
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.pageHorizontalPadding,
                    AppSpacing.rowPy,
                    AppSpacing.pageHorizontalPadding,
                    bottomInset,
                  ),
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    customGap: 0,
                    fullBleed: true,
                    children: [
                      _AssetHero(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.walletAssetSectionGap),
                      _AssetActionGrid(
                        actions: snapshot.actions,
                        onNavigate: (route) => context.go(route),
                      ),
                      const SizedBox(height: AppSpacing.walletAssetSectionGap),
                      _PriceChartCard(
                        snapshot: snapshot,
                        activePeriod: _period,
                        onPeriod: (period) => setState(() => _period = period),
                      ),
                      const SizedBox(
                        height: AppSpacing.walletAssetTransactionsTopPad,
                      ),
                      _AssetTransactions(
                        transactions: snapshot.transactions,
                        onNavigate: (route) => context.go(route),
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
