import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/wallet_multi_manager_sections.dart';

const _managerBackground = AppColors.bg;

const _tabAll = 'T\u1EA5t c\u1EA3';
const _tabGroups = 'Nh\u00F3m';
const _tabActivity = 'Ho\u1EA1t \u0111\u1ED9ng';

class WalletMultiManagerPage extends ConsumerStatefulWidget {
  const WalletMultiManagerPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc148_multi_manager_content');
  static const addWalletKey = Key('sc148_multi_manager_add_wallet');
  static const securityNoteKey = Key('sc148_multi_manager_security_note');
  static Key tabKey(String label) => Key('sc148_multi_manager_tab_$label');
  static Key walletKey(String id) => Key('sc148_multi_manager_wallet_$id');
  static Key revealKey(String id) => Key('sc148_multi_manager_reveal_$id');
  static Key copyKey(String id) => Key('sc148_multi_manager_copy_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<WalletMultiManagerPage> createState() =>
      _WalletMultiManagerPageState();
}

class _WalletMultiManagerPageState
    extends ConsumerState<WalletMultiManagerPage> {
  String _tab = _tabAll;
  String _selectedWalletId = 'w1';
  final Set<String> _revealedWalletIds = <String>{};
  String? _copiedWalletId;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(walletMultiManagerProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 92
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-148 WalletMultiManagerPage',
      child: Material(
        color: _managerBackground,
        child: Column(
          children: [
            VitHeader(
              title: 'Multi-Wallet Manager',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.wallet),
            ),
            WalletManagerTabs(
              activeTab: _tab,
              onChanged: (tab) => setState(() => _tab = tab),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: WalletMultiManagerPage.contentKey,
                padding: EdgeInsets.fromLTRB(20, 12, 20, bottomInset),
                child: _contentForTab(snapshot),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _contentForTab(WalletMultiManagerSnapshot snapshot) {
    if (_tab == _tabGroups) return WalletGroupsTab(snapshot: snapshot);
    if (_tab == _tabActivity) return WalletActivityTab(snapshot: snapshot);
    return WalletAllWalletsTab(
      snapshot: snapshot,
      selectedWalletId: _selectedWalletId,
      revealedWalletIds: _revealedWalletIds,
      copiedWalletId: _copiedWalletId,
      onSelectWallet: (walletId) =>
          setState(() => _selectedWalletId = walletId),
      onRevealWallet: _toggleReveal,
      onCopyWallet: _copyWallet,
    );
  }

  void _toggleReveal(String walletId) {
    setState(() {
      if (_revealedWalletIds.contains(walletId)) {
        _revealedWalletIds.remove(walletId);
      } else {
        _revealedWalletIds.add(walletId);
      }
    });
  }

  Future<void> _copyWallet(WalletManagerItem wallet) async {
    await Clipboard.setData(ClipboardData(text: wallet.address));
    if (!mounted) return;
    setState(() => _copiedWalletId = wallet.id);
  }
}
