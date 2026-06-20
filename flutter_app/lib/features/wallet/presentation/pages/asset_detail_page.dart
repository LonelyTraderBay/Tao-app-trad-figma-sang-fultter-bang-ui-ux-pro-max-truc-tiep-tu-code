import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
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
const _assetNativeBottomClearance = 88.0;
const _assetVisualBottomClearance = 112.0;
const _assetHeroHeight = 204.0;
const _assetChartHeight = 172.0;
const _assetActionHeight = 80.0;
const _assetLogoSize = 44.0;
const _assetStatHeight = 44.0;
const _assetActionIconSize = 30.0;
const _assetTransactionIconSize = 32.0;
const _assetHeroStatsGap = 10.0;
const _assetActionLabelGap = 4.0;
const _assetChartGap = 8.0;
const _assetInlineGap = 10.0;
const _assetSmallGap = 5.0;
const _assetTransactionVerticalPad = 10.0;
const _assetScrollTopPad = 0.0;
const _assetStatPillPadding = EdgeInsets.symmetric(horizontal: 8, vertical: 4);
const _assetActionTilePadding = EdgeInsets.symmetric(
  horizontal: 6,
  vertical: 8,
);

double _assetScrollBottomInset(BuildContext context, ShellRenderMode mode) {
  return (mode.usesVisualQaFrame
          ? _assetVisualBottomClearance
          : _assetNativeBottomClearance) +
      MediaQuery.paddingOf(context).bottom;
}

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
    final bottomInset = _assetScrollBottomInset(context, mode);

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
                  padding: AppSpacing.contentInsets.copyWith(
                    top: _assetScrollTopPad,
                    bottom: bottomInset,
                  ),
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    density: VitDensity.compact,
                    fullBleed: true,
                    children: [
                      _AssetHero(snapshot: snapshot),
                      _AssetActionGrid(
                        actions: snapshot.actions,
                        onNavigate: (route) => context.go(route),
                      ),
                      _PriceChartCard(
                        snapshot: snapshot,
                        activePeriod: _period,
                        onPeriod: (period) => setState(() => _period = period),
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
