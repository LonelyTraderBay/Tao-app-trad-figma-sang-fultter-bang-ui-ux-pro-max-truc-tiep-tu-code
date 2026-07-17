import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/accent_tone_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/launchpad_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/launchpad_spacing_tokens.dart';

part '../../widgets/tools/launchpad_multisig_page_chrome.dart';
part '../../widgets/tools/launchpad_multisig_queue_history.dart';
part '../../widgets/tools/launchpad_multisig_owners.dart';
part '../../widgets/tools/launchpad_multisig_tx_card.dart';
part '../../widgets/tools/launchpad_multisig_tx_details.dart';
part '../../widgets/tools/launchpad_multisig_create_sheet.dart';

enum _MultisigTab { queue, history, safes }

class LaunchpadMultisigPage extends ConsumerStatefulWidget {
  const LaunchpadMultisigPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc313_launchpad_multisig_content');
  static const safeSelectorKey = Key('sc313_launchpad_multisig_safes');
  static const statsKey = Key('sc313_launchpad_multisig_stats');
  static const tabsKey = Key('sc313_launchpad_multisig_tabs');
  static const createKey = Key('sc313_launchpad_multisig_create');
  static const queueKey = Key('sc313_launchpad_multisig_queue');
  static const historyKey = Key('sc313_launchpad_multisig_history');
  static const ownersKey = Key('sc313_launchpad_multisig_owners');
  static const noticeKey = Key('sc313_launchpad_multisig_notice');
  static const createSheetKey = Key('sc313_launchpad_multisig_create_sheet');
  static const submitCreateKey = Key('sc313_launchpad_multisig_submit');
  static const cancelCreateKey = Key('sc313_launchpad_multisig_cancel');
  static const signKey = Key('sc313_launchpad_multisig_sign');
  static const executeKey = Key('sc313_launchpad_multisig_execute');

  static Key safeKey(String address) =>
      Key('sc313_launchpad_multisig_safe_$address');
  static Key txKey(String id) => Key('sc313_launchpad_multisig_tx_$id');
  static Key txToggleKey(String id) =>
      Key('sc313_launchpad_multisig_toggle_$id');
  static Key copyKey(String id, String field) =>
      Key('sc313_launchpad_multisig_copy_${id}_$field');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<LaunchpadMultisigPage> createState() =>
      _LaunchpadMultisigPageState();
}

class _LaunchpadMultisigPageState extends ConsumerState<LaunchpadMultisigPage> {
  late String _selectedSafeAddress;
  late List<LaunchpadMultisigTxDraft> _transactions;
  var _activeTab = _MultisigTab.queue;
  String? _expandedTxId;
  String? _copiedField;
  var _showCreate = false;

  @override
  void initState() {
    super.initState();
    final snapshot = ref.read(launchpadControllerProvider).getMultisig();
    _selectedSafeAddress = snapshot.defaultSafeAddress;
    _transactions = List.of(snapshot.transactions);
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(launchpadControllerProvider).getMultisig();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollTailReserve =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome
            : DeviceMetrics.nativeBottomChrome) +
        MediaQuery.paddingOf(context).bottom +
        AppSpacing.x3;
    final selectedSafe = snapshot.safes.firstWhere(
      (safe) => safe.address == _selectedSafeAddress,
      orElse: () => snapshot.safes.first,
    );
    final queueTxs = _queueTxs(selectedSafe.address);
    final historyTxs = _historyTxs(selectedSafe.address);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Quản lý giao dịch đa chữ ký multisig',
      semanticIdentifier: 'SC-313',
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            VitAutoHideHeaderScaffold(
              bottomInset: scrollTailReserve,
              semanticLabel: 'Quản lý giao dịch đa chữ ký multisig',
              semanticIdentifier: 'SC-313',
              header: VitHeader(
                title: snapshot.title,
                subtitle: 'Hàng đợi multisig · Xác nhận đa chữ ký',
                showBack: true,
                onBack: () => context.go(snapshot.backRoute),
              ),
              child: Column(
                children: [
                  _SafeSelector(
                    safes: snapshot.safes,
                    selectedAddress: _selectedSafeAddress,
                    onChanged: (address) {
                      setState(() {
                        _selectedSafeAddress = address;
                        _expandedTxId = null;
                      });
                    },
                  ),
                  _StatsStrip(safe: selectedSafe, pending: queueTxs.length),
                  ColoredBox(
                    key: LaunchpadMultisigPage.tabsKey,
                    color: AppColors.surface,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Divider(height: AppSpacing.hairlineStroke),
                        Padding(
                          padding: LaunchpadSpacingTokens
                              .launchpadHorizontalContentPadding,
                          child: VitTabBar(
                            tabs: const [
                              VitTabItem(key: 'queue', label: 'Hàng đợi'),
                              VitTabItem(key: 'history', label: 'Lịch sử'),
                              VitTabItem(key: 'safes', label: 'Safes'),
                            ],
                            activeKey: _activeTab.name,
                            onChanged: (key) => setState(
                              () =>
                                  _activeTab = _MultisigTab.values.byName(key),
                            ),
                            variant: VitTabBarVariant.underline,
                          ),
                        ),
                        const Divider(height: AppSpacing.hairlineStroke),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(
                        context,
                      ).copyWith(scrollbars: false),
                      child: SingleChildScrollView(
                        key: LaunchpadMultisigPage.contentKey,
                        physics: const ClampingScrollPhysics(),
                        child: VitPageContent(
                          rhythm: VitPageRhythm.standard,
                          padding: VitContentPadding.compact,
                          gap: VitContentGap.tight,
                          children: [
                            if (_activeTab == _MultisigTab.queue) ...[
                              _CreateTxCard(
                                onTap: () => setState(() => _showCreate = true),
                              ),
                              _QueueSection(
                                txs: queueTxs,
                                expandedTxId: _expandedTxId,
                                copiedField: _copiedField,
                                onToggle: _toggleTx,
                                onCopy: _copyField,
                                onSign: _signTx,
                                onExecute: _executeTx,
                              ),
                            ] else if (_activeTab == _MultisigTab.history) ...[
                              _HistorySection(
                                txs: historyTxs,
                                expandedTxId: _expandedTxId,
                                copiedField: _copiedField,
                                onToggle: _toggleTx,
                                onCopy: _copyField,
                              ),
                            ] else ...[
                              _OwnersSection(
                                safe: selectedSafe,
                                copiedField: _copiedField,
                                onCopy: _copyField,
                              ),
                            ],
                            _SecurityNotice(safe: selectedSafe),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_showCreate)
              Positioned.fill(
                child: _CreateTxSheet(
                  safe: selectedSafe,
                  onClose: () => setState(() => _showCreate = false),
                  onCreate: (tx) {
                    setState(() {
                      _transactions = [tx, ..._transactions];
                      _expandedTxId = tx.id;
                      _showCreate = false;
                    });
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<LaunchpadMultisigTxDraft> _queueTxs(String safeAddress) {
    return _transactions
        .where(
          (tx) =>
              tx.safeAddress == safeAddress &&
              {
                LaunchpadMultisigTxStatus.draft,
                LaunchpadMultisigTxStatus.pendingSignatures,
                LaunchpadMultisigTxStatus.ready,
                LaunchpadMultisigTxStatus.executing,
              }.contains(tx.status),
        )
        .toList();
  }

  List<LaunchpadMultisigTxDraft> _historyTxs(String safeAddress) {
    return _transactions
        .where(
          (tx) =>
              tx.safeAddress == safeAddress &&
              {
                LaunchpadMultisigTxStatus.executed,
                LaunchpadMultisigTxStatus.expired,
                LaunchpadMultisigTxStatus.cancelled,
              }.contains(tx.status),
        )
        .toList();
  }

  void _toggleTx(String id) {
    setState(() => _expandedTxId = _expandedTxId == id ? null : id);
  }

  void _copyField(String text, String field) {
    Clipboard.setData(ClipboardData(text: text));
    setState(() => _copiedField = field);
  }

  void _signTx(String id) {
    setState(() {
      _transactions = [
        for (final tx in _transactions)
          if (tx.id != id) tx else _signedTransaction(tx),
      ];
    });
  }

  void _executeTx(String id) {
    setState(() {
      _transactions = [
        for (final tx in _transactions)
          tx.id == id
              ? tx.copyWith(
                  status: LaunchpadMultisigTxStatus.executed,
                  executedAt: '07/03/2026 10:15',
                  executeTxHash: '0xExec...313',
                )
              : tx,
      ];
    });
  }
}

LaunchpadMultisigTxDraft _signedTransaction(LaunchpadMultisigTxDraft tx) {
  var changed = false;
  final signers = [
    for (final signer in tx.signers)
      if (!changed && !signer.signed)
        (() {
          changed = true;
          return signer.copyWith(signed: true, signedAt: '07/03/2026 10:10');
        })()
      else
        signer,
  ];
  final signedCount = signers.where((signer) => signer.signed).length;
  return tx.copyWith(
    signers: signers,
    signedCount: signedCount,
    status: signedCount >= tx.threshold
        ? LaunchpadMultisigTxStatus.ready
        : LaunchpadMultisigTxStatus.pendingSignatures,
  );
}
