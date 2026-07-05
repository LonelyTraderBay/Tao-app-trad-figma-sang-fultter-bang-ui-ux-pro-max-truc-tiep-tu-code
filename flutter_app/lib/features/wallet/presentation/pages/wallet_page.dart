import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/wallet_page_sections.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/wallet_unavailable_banner.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class WalletPage extends ConsumerStatefulWidget {
  const WalletPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc135_wallet_content');
  static const balanceToggleKey = Key('sc135_wallet_balance_toggle');
  static const moreActionsKey = Key('sc135_wallet_more_actions');
  static const moreActionsSheetKey = Key('sc135_wallet_more_actions_sheet');
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
    final pendingDeposits = ref.watch(walletPendingDepositsProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome +
                  AppSpacing.walletBottomInsetVisualChrome
            : DeviceMetrics.nativeBottomChrome +
                  AppSpacing.walletBottomInsetNativeChrome) +
        MediaQuery.paddingOf(context).bottom +
        AppSpacing.searchBarCompactHeight;
    final assets = _filteredAssets(snapshot.assets);
    final showBack = context.canPop();

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-135 WalletPage',
      child: Material(
        color: AppColors.bg,
        child: VitAutoHideHeaderScaffold(
          header: VitTopChrome(
            type: VitTopChromeType.rootModule,
            title: 'V\u00ED',
            subtitle:
                'S\u1ED1 d\u01B0 minh b\u1EA1ch \u00B7 b\u1EA3o m\u1EADt \u0111a l\u1EDBp',
            showBack: showBack,
            onBack: showBack
                ? () => goBackOrFallback(
                    context,
                    fallbackPath: AppRoutePaths.home,
                    mode: BackNavigationMode.historyThenFallback,
                  )
                : null,
          ),
          child: VitInsetScrollView(
            key: WalletPage.contentKey,
            bottomInset: bottomInset,
            child: VitPageContent(
              padding: VitContentPadding.compact,
              density: VitDensity.compact,
              children: [
                if (snapshot.supportedStates.contains(WalletScreenState.error))
                  WalletUnavailableBanner(message: snapshot.actionDraft),
                WalletBalanceHero(
                  snapshot: snapshot,
                  change24hPct: walletPortfolioChange24h(snapshot.assets),
                  hidden: _balanceHidden,
                  onToggle: () =>
                      setState(() => _balanceHidden = !_balanceHidden),
                  onNavigate: _navigate,
                  onShowMore: () => _showMoreActions(snapshot.actions),
                ),
                if (snapshot.actions.isNotEmpty &&
                    pendingDeposits.pendingCount > 0)
                  WalletPendingDepositStatusCard(
                    pendingDeposits: pendingDeposits,
                    onNavigate: _navigate,
                  ),
                VitSectionHeader(
                  title: 'T\u00E0i s\u1EA3n',
                  icon: Icons.account_balance_wallet_outlined,
                  iconColor: AppModuleAccents.wallet,
                  accentColor: AppModuleAccents.wallet,
                  actionLabel: 'Ph\u00E2n t\u00EDch',
                  onAction: () => _navigate('/wallet/portfolio-analytics'),
                ),
                if (_tab == 'assets')
                  WalletSearchAndFilter(
                    controller: _searchController,
                    filterActive: _hideSmallBalances,
                    onChanged: (value) => setState(() => _query = value),
                    onFilter: () => setState(
                      () => _hideSmallBalances = !_hideSmallBalances,
                    ),
                  ),
                WalletSegmentedTabs(active: _tab, onChanged: _setTab),
                if (_tab == 'assets') ...[
                  WalletAssetHeader(
                    count: assets.length,
                    onNavigate: _navigate,
                  ),
                  WalletAssetList(
                    assets: assets,
                    hidden: _balanceHidden,
                    onNavigate: _navigate,
                  ),
                ] else
                  WalletAllocationCard(assets: snapshot.assets),
                WalletPortfolioHint(onNavigate: _navigate),
                const VitSectionHeader(
                  title: 'C\u00F4ng c\u1EE5 v\u00ED',
                  icon: Icons.grid_view_rounded,
                  iconColor: AppModuleAccents.wallet,
                  accentColor: AppModuleAccents.wallet,
                ),
                WalletToolGrid(tools: snapshot.tools, onNavigate: _navigate),
                const VitSectionHeader(
                  title: 'Mua \u0111\u1ECBnh k\u1EF3',
                  icon: Icons.sync_alt_rounded,
                  iconColor: AppColors.accent,
                ),
                WalletDcaCard(dca: snapshot.dca),
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

  void _showMoreActions(List<WalletAction> actions) {
    const primaryIds = {'deposit', 'withdraw'};
    final overflowActions = actions
        .where((action) => !primaryIds.contains(action.id))
        .toList(growable: false);
    if (overflowActions.isEmpty) return;

    final rootContext = context;
    showVitBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bg,
      barrierColor: AppColors.modalScrim,
      builder: (sheetContext) {
        return VitSheetPanel(
          key: WalletPage.moreActionsSheetKey,
          title: 'Th\u00EAm thao t\u00E1c',
          child: VitActionTileGrid(
            density: VitDensity.compact,
            crossAxisSpacing: AppSpacing.x3,
            mainAxisSpacing: AppSpacing.x3,
            physics: const ClampingScrollPhysics(),
            itemCount: overflowActions.length,
            itemBuilder: (context, index, density) {
              final action = overflowActions[index];
              return VitServiceTile(
                key: WalletPage.actionKey(action.id),
                density: density,
                icon: _walletOverflowActionIcon(action.iconKey),
                label: action.label,
                accentColor: Color(action.colorHex),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  rootContext.go(action.route);
                },
              );
            },
          ),
        );
      },
    );
  }
}

IconData _walletOverflowActionIcon(String key) => switch (key) {
  'deposit' => Icons.file_download_outlined,
  'withdraw' => Icons.file_upload_outlined,
  'buy' => Icons.shopping_cart_outlined,
  'transfer' => Icons.swap_vert_rounded,
  'history' => Icons.schedule_rounded,
  _ => Icons.account_balance_wallet_outlined,
};
