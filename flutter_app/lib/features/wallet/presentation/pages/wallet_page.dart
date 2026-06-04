import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/wallet_page_sections.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/wallet_unavailable_banner.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';

const _walletBackground = AppColors.bg;

class WalletPage extends ConsumerStatefulWidget {
  const WalletPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc135_wallet_content');
  static const balanceToggleKey = Key('sc135_wallet_balance_toggle');
  static const searchKey = Key('sc135_wallet_search');
  static const filterKey = Key('sc135_wallet_filter');
  static Key actionKey(String id) => Key('sc135_wallet_action_$id');
  static Key tabKey(String id) => Key('sc135_wallet_tab_$id');
  static Key assetKey(String id) => Key('sc135_wallet_asset_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends ConsumerState<WalletPage> {
  late final TextEditingController _searchController;
  bool _balanceHidden = false;
  bool _hideSmallBalances = false;
  String _tab = 'assets';
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(walletSnapshotProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 92
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;
    final assets = _filteredAssets(snapshot.assets);
    final showBack = context.canPop();

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-135 WalletPage',
      child: Material(
        color: _walletBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitTopChrome(
            type: VitTopChromeType.rootModule,
            title: 'V\u00ED t\u00E0i s\u1EA3n',
            showBack: showBack,
            onBack: showBack
                ? () => goBackOrFallback(
                    context,
                    fallbackPath: AppRoutePaths.home,
                    mode: BackNavigationMode.historyThenFallback,
                  )
                : null,
          ),
          child: SingleChildScrollView(
            key: WalletPage.contentKey,
            padding: EdgeInsets.fromLTRB(20, 13, 20, bottomInset),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (snapshot.supportedStates.contains(
                  WalletScreenState.error,
                )) ...[
                  WalletUnavailableBanner(message: snapshot.actionDraft),
                  const SizedBox(height: 12),
                ],
                WalletBalanceHero(
                  snapshot: snapshot,
                  hidden: _balanceHidden,
                  onToggle: () =>
                      setState(() => _balanceHidden = !_balanceHidden),
                  onNavigate: _navigate,
                ),
                const SizedBox(height: 18),
                WalletDcaCard(dca: snapshot.dca),
                const SizedBox(height: 18),
                WalletToolGrid(tools: snapshot.tools, onNavigate: _navigate),
                const SizedBox(height: 18),
                WalletSegmentedTabs(active: _tab, onChanged: _setTab),
                const SizedBox(height: 17),
                if (_tab == 'assets') ...[
                  WalletSearchAndFilter(
                    controller: _searchController,
                    filterActive: _hideSmallBalances,
                    onChanged: (value) => setState(() => _query = value),
                    onFilter: () => setState(
                      () => _hideSmallBalances = !_hideSmallBalances,
                    ),
                  ),
                  const SizedBox(height: 18),
                  WalletAssetHeader(
                    count: assets.length,
                    onNavigate: _navigate,
                  ),
                  const SizedBox(height: 10),
                  WalletAssetList(
                    assets: assets,
                    hidden: _balanceHidden,
                    onNavigate: _navigate,
                  ),
                ] else
                  WalletAllocationCard(assets: snapshot.assets),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<WalletAsset> _filteredAssets(List<WalletAsset> assets) {
    final query = _query.trim().toLowerCase();
    return assets.where((asset) {
      if (_hideSmallBalances && asset.usdValue < 1) return false;
      if (query.isEmpty) return true;
      return asset.symbol.toLowerCase().contains(query) ||
          asset.name.toLowerCase().contains(query);
    }).toList();
  }

  void _setTab(String tab) {
    setState(() => _tab = tab);
  }

  void _navigate(String route) {
    context.go(route);
  }
}
