import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../data/wallet_repository.dart';

const _managerBg = Color(0xFF080C14);
const _managerSurface = Color(0xFF151A23);
const _managerSurface2 = Color(0xFF101824);
const _managerBorder = Color(0x14FFFFFF);
const _managerBlue = Color(0xFF3B82F6);
const _managerGreen = Color(0xFF10B981);
const _managerRed = Color(0xFFEF4444);

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
    final snapshot = ref.watch(walletRepositoryProvider).getMultiManager();
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
        color: _managerBg,
        child: Column(
          children: [
            VitHeader(
              title: 'Multi-Wallet Manager',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.wallet),
            ),
            _ManagerTabs(
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
    if (_tab == _tabGroups) return _GroupsTab(snapshot: snapshot);
    if (_tab == _tabActivity) return _ActivityTab(snapshot: snapshot);
    return _AllWalletsTab(
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

class _ManagerTabs extends StatelessWidget {
  const _ManagerTabs({required this.activeTab, required this.onChanged});

  final String activeTab;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      decoration: const BoxDecoration(
        color: _managerSurface,
        border: Border(bottom: BorderSide(color: _managerBorder)),
      ),
      child: Row(
        children: [
          for (final tab in const [_tabAll, _tabGroups, _tabActivity])
            Expanded(
              child: GestureDetector(
                key: WalletMultiManagerPage.tabKey(tab),
                onTap: () => onChanged(tab),
                behavior: HitTestBehavior.opaque,
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        tab,
                        style: AppTextStyles.caption.copyWith(
                          color: activeTab == tab
                              ? _managerBlue
                              : const Color(0xFF566175),
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          height: 1,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 7,
                      right: 7,
                      bottom: 0,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        height: 2,
                        color: activeTab == tab
                            ? _managerBlue
                            : Colors.transparent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _AllWalletsTab extends StatelessWidget {
  const _AllWalletsTab({
    required this.snapshot,
    required this.selectedWalletId,
    required this.revealedWalletIds,
    required this.copiedWalletId,
    required this.onSelectWallet,
    required this.onRevealWallet,
    required this.onCopyWallet,
  });

  final WalletMultiManagerSnapshot snapshot;
  final String selectedWalletId;
  final Set<String> revealedWalletIds;
  final String? copiedWalletId;
  final ValueChanged<String> onSelectWallet;
  final ValueChanged<String> onRevealWallet;
  final ValueChanged<WalletManagerItem> onCopyWallet;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _PortfolioSummaryCard(snapshot: snapshot),
        const SizedBox(height: 16),
        _DistributionCard(snapshot: snapshot),
        const SizedBox(height: 17),
        const _SectionLabel(label: 'T\u1EA5t c\u1EA3 v\u00ED'),
        const SizedBox(height: 8),
        for (var i = 0; i < snapshot.wallets.length; i++) ...[
          _WalletCard(
            wallet: snapshot.wallets[i],
            selected: selectedWalletId == snapshot.wallets[i].id,
            revealed: revealedWalletIds.contains(snapshot.wallets[i].id),
            copied: copiedWalletId == snapshot.wallets[i].id,
            onTap: () => onSelectWallet(snapshot.wallets[i].id),
            onReveal: () => onRevealWallet(snapshot.wallets[i].id),
            onCopy: () => onCopyWallet(snapshot.wallets[i]),
          ),
          if (i != snapshot.wallets.length - 1) const SizedBox(height: 14),
        ],
        const SizedBox(height: 18),
        const _AddWalletButton(),
        const SizedBox(height: 16),
        const _SecurityNotice(),
      ],
    );
  }
}

class _PortfolioSummaryCard extends StatelessWidget {
  const _PortfolioSummaryCard({required this.snapshot});

  final WalletMultiManagerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final positive = snapshot.totalChangeUsd >= 0;
    return Container(
      height: 148,
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 16),
      decoration: BoxDecoration(
        color: _managerSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _managerBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Total Portfolio Value',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 11,
              height: 1,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                _formatUsd(snapshot.totalBalance, decimals: 0),
                style: AppTextStyles.heroNumber.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Roboto',
                  height: 1,
                ),
              ),
              const SizedBox(width: 9),
              Icon(
                positive
                    ? Icons.arrow_outward_rounded
                    : Icons.south_east_rounded,
                color: positive ? _managerGreen : _managerRed,
                size: 15,
              ),
              const SizedBox(width: 4),
              Text(
                _formatPct(snapshot.totalChangePct),
                style: AppTextStyles.caption.copyWith(
                  color: positive ? _managerGreen : _managerRed,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Roboto',
                  height: 1,
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              _SummaryMetric(
                label: 'Wallets',
                value: '${snapshot.wallets.length}',
              ),
              _SummaryMetric(
                label: '24h Change',
                value: _formatSignedUsd(snapshot.totalChangeUsd, decimals: 0),
                valueColor: positive ? _managerGreen : _managerRed,
              ),
              _SummaryMetric(
                label: 'Groups',
                value: '${snapshot.groups.length}',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 10,
              height: 1,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: valueColor,
              fontSize: 15,
              fontWeight: FontWeight.w900,
              fontFamily: 'Roboto',
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _DistributionCard extends StatelessWidget {
  const _DistributionCard({required this.snapshot});

  final WalletMultiManagerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 245,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      decoration: BoxDecoration(
        color: _managerSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _managerBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Portfolio Distribution',
            style: AppTextStyles.baseMedium.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: CustomPaint(
              painter: _DistributionPainter(wallets: _chartWallets(snapshot)),
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 14,
          decoration: BoxDecoration(
            color: _managerBlue,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: const Color(0xFF7B8497),
            fontSize: 12,
            fontWeight: FontWeight.w800,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _WalletCard extends StatelessWidget {
  const _WalletCard({
    required this.wallet,
    required this.selected,
    required this.revealed,
    required this.copied,
    required this.onTap,
    required this.onReveal,
    required this.onCopy,
  });

  final WalletManagerItem wallet;
  final bool selected;
  final bool revealed;
  final bool copied;
  final VoidCallback onTap;
  final VoidCallback onReveal;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    final accent = Color(wallet.accentColorHex);
    final typeColor = Color(wallet.typeColorHex);
    final positive = wallet.change24hPct >= 0;
    return GestureDetector(
      key: WalletMultiManagerPage.walletKey(wallet.id),
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 200,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
        decoration: BoxDecoration(
          color: selected ? accent.withValues(alpha: .045) : _managerSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? accent : _managerBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _WalletTypeIcon(wallet: wallet),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              wallet.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.baseMedium.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                height: 1,
                              ),
                            ),
                          ),
                          if (wallet.isDefault) ...[
                            const SizedBox(width: 7),
                            const _DefaultBadge(),
                          ],
                          if (wallet.isFavorite) ...[
                            const SizedBox(width: 7),
                            const Icon(
                              Icons.star_rounded,
                              color: Color(0xFFF59E0B),
                              size: 13,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 9),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              revealed ? wallet.address : wallet.maskedAddress,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.text3,
                                fontSize: 10,
                                fontFamily: 'Roboto',
                                height: 1,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          _TinyIconButton(
                            buttonKey: WalletMultiManagerPage.revealKey(
                              wallet.id,
                            ),
                            icon: revealed
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.text3,
                            onTap: onReveal,
                          ),
                          const SizedBox(width: 7),
                          _TinyIconButton(
                            buttonKey: WalletMultiManagerPage.copyKey(
                              wallet.id,
                            ),
                            icon: copied
                                ? Icons.check_circle_outline_rounded
                                : Icons.copy_rounded,
                            color: copied ? _managerGreen : AppColors.text3,
                            onTap: onCopy,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.more_vert_rounded,
                  color: AppColors.text3,
                  size: 18,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Balance',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontSize: 10,
                height: 1,
              ),
            ),
            const SizedBox(height: 9),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  _formatUsd(wallet.balanceUsd, decimals: 0),
                  style: AppTextStyles.heroNumber.copyWith(
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Roboto',
                    height: 1,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  positive
                      ? Icons.trending_up_rounded
                      : Icons.south_east_rounded,
                  color: positive ? _managerGreen : _managerRed,
                  size: 13,
                ),
                const SizedBox(width: 3),
                Text(
                  _formatPct(wallet.change24hPct, decimals: 1),
                  style: AppTextStyles.micro.copyWith(
                    color: positive ? _managerGreen : _managerRed,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Roboto',
                    height: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 17),
            Row(
              children: [
                for (final asset in wallet.assets.take(3)) ...[
                  _AssetChip(symbol: asset.symbol),
                  const SizedBox(width: 8),
                ],
              ],
            ),
            const Spacer(),
            Container(height: 1, color: const Color(0x0FFFFFFF)),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(
                  Icons.access_time_rounded,
                  color: AppColors.text3,
                  size: 11,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    wallet.lastActiveLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontSize: 10,
                      height: 1,
                    ),
                  ),
                ),
                _TypeBadge(label: wallet.type.toUpperCase(), color: typeColor),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WalletTypeIcon extends StatelessWidget {
  const _WalletTypeIcon({required this.wallet});

  final WalletManagerItem wallet;

  @override
  Widget build(BuildContext context) {
    final color = Color(wallet.typeColorHex);
    final icon = wallet.type == 'hot'
        ? Icons.account_balance_wallet_outlined
        : Icons.shield_outlined;
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .16),
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Icon(icon, color: color, size: 18),
    );
  }
}

class _TinyIconButton extends StatelessWidget {
  const _TinyIconButton({
    required this.buttonKey,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final Key buttonKey;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: buttonKey,
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 14,
        height: 14,
        child: Icon(icon, color: color, size: 11),
      ),
    );
  }
}

class _DefaultBadge extends StatelessWidget {
  const _DefaultBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 17,
      padding: const EdgeInsets.symmetric(horizontal: 7),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _managerGreen.withValues(alpha: .13),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        'DEFAULT',
        style: AppTextStyles.micro.copyWith(
          color: _managerGreen,
          fontSize: 9,
          fontWeight: FontWeight.w900,
          height: 1,
        ),
      ),
    );
  }
}

class _AssetChip extends StatelessWidget {
  const _AssetChip({required this.symbol});

  final String symbol;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 18,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0x0AFFFFFF),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        symbol,
        style: AppTextStyles.micro.copyWith(
          color: const Color(0xFF9AA4B8),
          fontSize: 9,
          fontWeight: FontWeight.w900,
          height: 1,
        ),
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 19,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .15),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w900,
          height: 1,
        ),
      ),
    );
  }
}

class _AddWalletButton extends StatelessWidget {
  const _AddWalletButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: WalletMultiManagerPage.addWalletKey,
      onTap: () {},
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _managerBlue,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add_rounded, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              'Add Wallet',
              style: AppTextStyles.baseMedium.copyWith(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SecurityNotice extends StatelessWidget {
  const _SecurityNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: WalletMultiManagerPage.securityNoteKey,
      constraints: const BoxConstraints(minHeight: 58),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: _managerBlue.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _managerBlue.withValues(alpha: .20)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 1),
            child: Icon(Icons.shield_outlined, color: _managerBlue, size: 14),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Addresses are masked by default. Click eye icon to reveal. '
              'Never share your private keys.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontSize: 11,
                height: 1.48,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupsTab extends StatelessWidget {
  const _GroupsTab({required this.snapshot});

  final WalletMultiManagerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel(label: 'Wallet Groups'),
        const SizedBox(height: 10),
        for (var i = 0; i < snapshot.groups.length; i++) ...[
          _GroupCard(
            group: snapshot.groups[i],
            wallets: snapshot.wallets
                .where((wallet) => wallet.groupId == snapshot.groups[i].id)
                .toList(),
          ),
          if (i != snapshot.groups.length - 1) const SizedBox(height: 12),
        ],
        const SizedBox(height: 14),
        Container(
          height: 46,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _managerSurface2,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: _managerBorder),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.folder_outlined,
                color: AppColors.text2,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Create Group',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GroupCard extends StatelessWidget {
  const _GroupCard({required this.group, required this.wallets});

  final WalletManagerGroup group;
  final List<WalletManagerItem> wallets;

  @override
  Widget build(BuildContext context) {
    final color = Color(group.colorHex);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _managerSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _managerBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  group.name,
                  style: AppTextStyles.baseMedium.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
              ),
              const Icon(
                Icons.more_vert_rounded,
                color: AppColors.text3,
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 13),
          Text(
            '${wallets.length} wallets',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              fontSize: 11,
              height: 1,
            ),
          ),
          const SizedBox(height: 13),
          Text(
            'Total Value',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 10,
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _formatUsd(group.totalValueUsd, decimals: 0),
            style: AppTextStyles.heroNumber.copyWith(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.w900,
              fontFamily: 'Roboto',
              height: 1,
            ),
          ),
          const SizedBox(height: 13),
          for (final wallet in wallets) ...[
            _GroupWalletRow(wallet: wallet),
            if (wallet != wallets.last) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _GroupWalletRow extends StatelessWidget {
  const _GroupWalletRow({required this.wallet});

  final WalletManagerItem wallet;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: _managerBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  wallet.name,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  wallet.maskedAddress,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 10,
                    fontFamily: 'Roboto',
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          Text(
            _formatUsd(wallet.balanceUsd, decimals: 0),
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontSize: 13,
              fontWeight: FontWeight.w900,
              fontFamily: 'Roboto',
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityTab extends StatelessWidget {
  const _ActivityTab({required this.snapshot});

  final WalletMultiManagerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel(label: 'Recent Activity'),
        const SizedBox(height: 10),
        for (var i = 0; i < snapshot.wallets.length; i++) ...[
          _ActivityRow(wallet: snapshot.wallets[i]),
          if (i != snapshot.wallets.length - 1) const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.wallet});

  final WalletManagerItem wallet;

  @override
  Widget build(BuildContext context) {
    final color = Color(wallet.typeColorHex);
    final parts = wallet.lastActiveLabel.split(' ');
    final time = parts.isNotEmpty ? parts.first : wallet.lastActiveLabel;
    final date = parts.length > 1 ? parts.skip(1).join(' ') : '';
    return Container(
      height: 62,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: _managerSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _managerBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .16),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.account_balance_wallet_outlined,
              color: color,
              size: 16,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  wallet.name,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  wallet.maskedAddress,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 10,
                    fontFamily: 'Roboto',
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                date,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  fontSize: 11,
                  height: 1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                time,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 10,
                  height: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DistributionPainter extends CustomPainter {
  const _DistributionPainter({required this.wallets});

  final List<WalletManagerItem> wallets;

  @override
  void paint(Canvas canvas, Size size) {
    if (wallets.isEmpty) return;
    final total = wallets.fold<double>(
      0,
      (sum, wallet) => sum + wallet.balanceUsd,
    );
    if (total <= 0) return;

    final center = Offset(size.width / 2, size.height * .54);
    final radius = math.min(size.width, size.height) * .315;
    const strokeWidth = 27.0;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final gapPaint = Paint()
      ..color = Colors.white.withValues(alpha: .92)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;
    canvas.drawCircle(center, radius, gapPaint);

    var start = -math.pi / 2;
    const gap = .033;
    for (final wallet in wallets) {
      final sweep = (wallet.balanceUsd / total) * math.pi * 2;
      final paint = Paint()
        ..color = Color(wallet.distributionColorHex)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(
        rect,
        start + gap / 2,
        math.max(0, sweep - gap),
        false,
        paint,
      );
      start += sweep;
    }

    final centerPaint = Paint()..color = _managerSurface;
    canvas.drawCircle(center, radius - strokeWidth / 2, centerPaint);
  }

  @override
  bool shouldRepaint(covariant _DistributionPainter oldDelegate) {
    return oldDelegate.wallets != wallets;
  }
}

List<WalletManagerItem> _chartWallets(WalletMultiManagerSnapshot snapshot) {
  WalletManagerItem byId(String id) =>
      snapshot.wallets.firstWhere((wallet) => wallet.id == id);
  return [byId('w2'), byId('w1'), byId('w4'), byId('w3')];
}

String _formatUsd(double value, {int decimals = 2}) {
  return '\$${_withCommas(value.toStringAsFixed(decimals))}';
}

String _formatSignedUsd(double value, {int decimals = 2}) {
  final sign = value >= 0 ? '+' : '-';
  return '$sign\$${_withCommas(value.abs().toStringAsFixed(decimals))}';
}

String _formatPct(double value, {int decimals = 2}) {
  final sign = value >= 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(decimals)}%';
}

String _withCommas(String value) {
  final parts = value.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final remaining = whole.length - i;
    buffer.write(whole[i]);
    if (remaining > 1 && remaining % 3 == 1) {
      buffer.write(',');
    }
  }
  if (parts.length > 1 && int.tryParse(parts[1]) != 0) {
    buffer.write('.');
    buffer.write(parts[1]);
  }
  return buffer.toString();
}
