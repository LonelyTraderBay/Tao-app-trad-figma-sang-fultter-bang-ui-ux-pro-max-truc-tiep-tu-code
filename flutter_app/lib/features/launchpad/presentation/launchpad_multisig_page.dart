import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_content.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/launchpad_repository.dart';

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
    final snapshot = ref.read(launchpadRepositoryProvider).getMultisig();
    _selectedSafeAddress = snapshot.defaultSafeAddress;
    _transactions = List.of(snapshot.transactions);
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(launchpadRepositoryProvider).getMultisig();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome
            : DeviceMetrics.nativeBottomChrome) +
        MediaQuery.paddingOf(context).bottom +
        AppSpacing.x7;
    final selectedSafe = snapshot.safes.firstWhere(
      (safe) => safe.address == _selectedSafeAddress,
      orElse: () => snapshot.safes.first,
    );
    final queueTxs = _queueTxs(selectedSafe.address);
    final historyTxs = _historyTxs(selectedSafe.address);

    return VitPageLayout(
      semanticLabel: 'SC-313 LaunchpadMultisigPage',
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            Column(
              children: [
                VitHeader(
                  title: snapshot.title,
                  showBack: true,
                  onBack: () => context.go(snapshot.backRoute),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    key: LaunchpadMultisigPage.contentKey,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: bottomInset),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        _StatsStrip(
                          safe: selectedSafe,
                          pending: queueTxs.length,
                        ),
                        _Tabs(
                          activeTab: _activeTab,
                          onChanged: (tab) => setState(() => _activeTab = tab),
                        ),
                        VitPageContent(
                          padding: VitContentPadding.defaultPadding,
                          customGap: AppSpacing.x4,
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
                      ],
                    ),
                  ),
                ),
              ],
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

class _SafeSelector extends StatelessWidget {
  const _SafeSelector({
    required this.safes,
    required this.selectedAddress,
    required this.onChanged,
  });

  final List<LaunchpadMultisigSafeDraft> safes;
  final String selectedAddress;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: LaunchpadMultisigPage.safeSelectorKey,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x3,
        AppSpacing.contentPad,
        AppSpacing.x2,
      ),
      child: Row(
        children: [
          for (final safe in safes) ...[
            Expanded(
              child: VitCard(
                key: LaunchpadMultisigPage.safeKey(safe.address),
                variant: selectedAddress == safe.address
                    ? VitCardVariant.standard
                    : VitCardVariant.inner,
                borderColor: selectedAddress == safe.address
                    ? safe.accent.withValues(alpha: .34)
                    : AppColors.cardBorder,
                padding: const EdgeInsets.all(AppSpacing.x3),
                onTap: () => onChanged(safe.address),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _IconBubble(
                          icon: Icons.shield_outlined,
                          color: safe.accent,
                          size: 26,
                        ),
                        const SizedBox(width: AppSpacing.x2),
                        Expanded(
                          child: Text(
                            safe.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Row(
                      children: [
                        Text(
                          safe.chain,
                          style: AppTextStyles.micro.copyWith(
                            color: safe.accent,
                            fontWeight: AppTextStyles.bold,
                            fontSize: 9,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.x2),
                        Text(
                          '${safe.threshold}/${safe.owners.length}',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      safe.balance,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (safe != safes.last) const SizedBox(width: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _StatsStrip extends StatelessWidget {
  const _StatsStrip({required this.safe, required this.pending});

  final LaunchpadMultisigSafeDraft safe;
  final int pending;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: LaunchpadMultisigPage.statsKey,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        0,
        AppSpacing.contentPad,
        AppSpacing.x2,
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatChip(
              label: 'Threshold',
              value: '${safe.threshold}/${safe.owners.length}',
              color: AppColors.accent,
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: _StatChip(
              label: 'Pending',
              value: '$pending',
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: _StatChip(
              label: 'Total Tx',
              value: '${safe.txCount}',
              color: AppColors.buy,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .08),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
        child: Column(
          children: [
            Text(
              value,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
                fontSize: 14,
              ),
            ),
            Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontSize: 9,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({required this.activeTab, required this.onChanged});

  final _MultisigTab activeTab;
  final ValueChanged<_MultisigTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: LaunchpadMultisigPage.tabsKey,
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.contentPad),
      child: VitTabBar(
        tabs: const [
          VitTabItem(key: 'queue', label: 'queue'),
          VitTabItem(key: 'history', label: 'history'),
          VitTabItem(key: 'safes', label: 'safes'),
        ],
        activeKey: activeTab.name,
        onChanged: (key) => onChanged(_MultisigTab.values.byName(key)),
        variant: VitTabBarVariant.underline,
      ),
    );
  }
}

class _CreateTxCard extends StatelessWidget {
  const _CreateTxCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadMultisigPage.createKey,
      variant: VitCardVariant.inner,
      borderColor: AppColors.accent30,
      padding: const EdgeInsets.all(AppSpacing.x3),
      onTap: onTap,
      child: Row(
        children: [
          _IconBubble(
            icon: Icons.add_rounded,
            color: AppColors.accent,
            size: 40,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tao giao dich moi',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.accent,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  'Tao tx can nhieu chu ky',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QueueSection extends StatelessWidget {
  const _QueueSection({
    required this.txs,
    required this.expandedTxId,
    required this.copiedField,
    required this.onToggle,
    required this.onCopy,
    required this.onSign,
    required this.onExecute,
  });

  final List<LaunchpadMultisigTxDraft> txs;
  final String? expandedTxId;
  final String? copiedField;
  final ValueChanged<String> onToggle;
  final void Function(String text, String field) onCopy;
  final ValueChanged<String> onSign;
  final ValueChanged<String> onExecute;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: LaunchpadMultisigPage.queueKey,
      child: VitPageSection(
        label: 'Hang doi giao dich',
        accentColor: AppColors.primary,
        children: [
          if (txs.isEmpty)
            const VitEmptyState(
              icon: Icons.group_outlined,
              title: 'Khong co giao dich cho xu ly',
              message: 'Tao giao dich moi de bat dau.',
            )
          else
            for (final tx in txs)
              _TxCard(
                tx: tx,
                expanded: expandedTxId == tx.id,
                copiedField: copiedField,
                onToggle: () => onToggle(tx.id),
                onCopy: onCopy,
                onSign: () => onSign(tx.id),
                onExecute: () => onExecute(tx.id),
              ),
        ],
      ),
    );
  }
}

class _HistorySection extends StatelessWidget {
  const _HistorySection({
    required this.txs,
    required this.expandedTxId,
    required this.copiedField,
    required this.onToggle,
    required this.onCopy,
  });

  final List<LaunchpadMultisigTxDraft> txs;
  final String? expandedTxId;
  final String? copiedField;
  final ValueChanged<String> onToggle;
  final void Function(String text, String field) onCopy;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: LaunchpadMultisigPage.historyKey,
      child: VitPageSection(
        label: 'Giao dich da hoan tat',
        accentColor: AppColors.buy,
        children: [
          if (txs.isEmpty)
            const VitEmptyState(
              icon: Icons.history_rounded,
              title: 'Chua co lich su',
              message: 'Giao dich da thuc hien se hien thi tai day.',
            )
          else
            for (final tx in txs)
              _TxCard(
                tx: tx,
                expanded: expandedTxId == tx.id,
                copiedField: copiedField,
                onToggle: () => onToggle(tx.id),
                onCopy: onCopy,
              ),
        ],
      ),
    );
  }
}

class _OwnersSection extends StatelessWidget {
  const _OwnersSection({
    required this.safe,
    required this.copiedField,
    required this.onCopy,
  });

  final LaunchpadMultisigSafeDraft safe;
  final String? copiedField;
  final void Function(String text, String field) onCopy;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: LaunchpadMultisigPage.ownersKey,
      child: VitPageSection(
        label: 'Owners & Signers',
        accentColor: AppColors.accent,
        children: [
          for (final owner in safe.owners)
            VitCard(
              padding: const EdgeInsets.all(AppSpacing.x3),
              child: Row(
                children: [
                  _IconBubble(
                    icon: owner.role == LaunchpadMultisigSignerRole.owner
                        ? Icons.verified_user_outlined
                        : Icons.group_outlined,
                    color: owner.role == LaunchpadMultisigSignerRole.owner
                        ? AppColors.accent
                        : AppColors.primary,
                    size: 36,
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: AppSpacing.x2,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              owner.label,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text1,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                            _MiniPill(
                              label: owner.role.name,
                              color:
                                  owner.role ==
                                      LaunchpadMultisigSignerRole.owner
                                  ? AppColors.accent
                                  : AppColors.primary,
                            ),
                          ],
                        ),
                        Text(
                          owner.address,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    key: LaunchpadMultisigPage.copyKey('owner', owner.label),
                    onPressed: () => onCopy(owner.address, owner.label),
                    icon: Icon(
                      copiedField == owner.label
                          ? Icons.check_rounded
                          : Icons.copy_rounded,
                      color: copiedField == owner.label
                          ? AppColors.buy
                          : AppColors.text3,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
          _SafeInfoCard(safe: safe),
        ],
      ),
    );
  }
}

class _TxCard extends StatelessWidget {
  const _TxCard({
    required this.tx,
    required this.expanded,
    required this.copiedField,
    required this.onToggle,
    required this.onCopy,
    this.onSign,
    this.onExecute,
  });

  final LaunchpadMultisigTxDraft tx;
  final bool expanded;
  final String? copiedField;
  final VoidCallback onToggle;
  final void Function(String text, String field) onCopy;
  final VoidCallback? onSign;
  final VoidCallback? onExecute;

  @override
  Widget build(BuildContext context) {
    final status = _statusView(tx.status);
    return VitCard(
      key: LaunchpadMultisigPage.txKey(tx.id),
      clip: true,
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              children: [
                Container(width: 3, color: status.color),
                Expanded(
                  child: InkWell(
                    key: LaunchpadMultisigPage.txToggleKey(tx.id),
                    onTap: onToggle,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.x3),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _IconBubble(
                            icon: status.icon,
                            color: status.color,
                            size: 34,
                          ),
                          const SizedBox(width: AppSpacing.x3),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  spacing: AppSpacing.x2,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Text(
                                      tx.label,
                                      style: AppTextStyles.caption.copyWith(
                                        color: AppColors.text1,
                                        fontWeight: AppTextStyles.bold,
                                      ),
                                    ),
                                    _MiniPill(
                                      label: status.label,
                                      color: status.color,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppSpacing.x1),
                                Row(
                                  children: [
                                    Text(
                                      '${tx.signedCount}/${tx.threshold} signed',
                                      style: AppTextStyles.micro.copyWith(
                                        color: AppColors.text3,
                                        fontSize: 10,
                                      ),
                                    ),
                                    const SizedBox(width: AppSpacing.x2),
                                    _MiniPill(
                                      label: tx.chain,
                                      color: tx.accent,
                                    ),
                                    const SizedBox(width: AppSpacing.x2),
                                    Text(
                                      '#${tx.nonce}',
                                      style: AppTextStyles.micro.copyWith(
                                        color: AppColors.text3,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppSpacing.x2),
                                _SignatureProgress(tx: tx),
                              ],
                            ),
                          ),
                          Icon(
                            expanded
                                ? Icons.keyboard_arrow_up_rounded
                                : Icons.keyboard_arrow_down_rounded,
                            color: AppColors.text3,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (expanded)
            _TxDetails(
              tx: tx,
              copiedField: copiedField,
              onCopy: onCopy,
              onSign: onSign,
              onExecute: onExecute,
            ),
        ],
      ),
    );
  }
}

class _TxDetails extends StatelessWidget {
  const _TxDetails({
    required this.tx,
    required this.copiedField,
    required this.onCopy,
    this.onSign,
    this.onExecute,
  });

  final LaunchpadMultisigTxDraft tx;
  final String? copiedField;
  final void Function(String text, String field) onCopy;
  final VoidCallback? onSign;
  final VoidCallback? onExecute;

  @override
  Widget build(BuildContext context) {
    final rows = [
      ('Function', tx.functionName),
      ('Contract', tx.contractAddress),
      ('Value', tx.value),
      ('Gas', tx.estimatedGas),
      ('Created', tx.createdAt),
      ('Expires', tx.expiresAt),
      if (tx.executedAt != null) ('Executed', tx.executedAt!),
      if (tx.executeTxHash != null) ('Tx Hash', tx.executeTxHash!),
    ];
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            tx.description,
            style: AppTextStyles.micro.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x2),
          for (final row in rows)
            _DetailRow(
              label: row.$1,
              value: row.$2,
              copied: copiedField == '${tx.id}_${row.$1}',
              onCopy: row.$1 == 'Contract' || row.$1 == 'Tx Hash'
                  ? () => onCopy(row.$2, '${tx.id}_${row.$1}')
                  : null,
            ),
          if (tx.params.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.x2),
            DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.surface2,
                borderRadius: AppRadii.inputRadius,
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.x2),
                child: Column(
                  children: [
                    for (final entry in tx.params.entries)
                      _DetailRow(label: entry.key, value: entry.value),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.x2),
          Text(
            'Signers (${tx.signedCount}/${tx.threshold} required)',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          for (final signer in tx.signers) _SignerRow(signer: signer),
          if (tx.status == LaunchpadMultisigTxStatus.pendingSignatures &&
              onSign != null) ...[
            const SizedBox(height: AppSpacing.x3),
            VitCtaButton(
              key: LaunchpadMultisigPage.signKey,
              variant: VitCtaButtonVariant.warning,
              onPressed: onSign,
              child: const Text('Ky giao dich'),
            ),
          ],
          if (tx.status == LaunchpadMultisigTxStatus.ready &&
              onExecute != null) ...[
            const SizedBox(height: AppSpacing.x3),
            VitCtaButton(
              key: LaunchpadMultisigPage.executeKey,
              variant: VitCtaButtonVariant.success,
              onPressed: onExecute,
              child: const Text('Thuc hien giao dich'),
            ),
          ],
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.copied = false,
    this.onCopy,
  });

  final String label;
  final String value;
  final bool copied;
  final VoidCallback? onCopy;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.x1),
        child: Row(
          children: [
            Text(
              label,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.medium,
                ),
              ),
            ),
            if (onCopy != null)
              IconButton(
                onPressed: onCopy,
                icon: Icon(
                  copied ? Icons.check_rounded : Icons.copy_rounded,
                  color: copied ? AppColors.buy : AppColors.text3,
                  size: 14,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SignerRow extends StatelessWidget {
  const _SignerRow({required this.signer});

  final LaunchpadMultisigSignerDraft signer;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.x1),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: signer.signed ? AppColors.buy10 : AppColors.surface2,
        borderRadius: AppRadii.inputRadius,
      ),
      child: Row(
        children: [
          Icon(
            signer.signed
                ? Icons.check_circle_outline_rounded
                : Icons.schedule_rounded,
            color: signer.signed ? AppColors.buy : AppColors.text3,
            size: 13,
          ),
          const SizedBox(width: AppSpacing.x2),
          Text(
            signer.label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              signer.address,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
          if (signer.signedAt != null)
            Text(
              signer.signedAt!,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.buy,
                fontSize: 8,
              ),
            ),
        ],
      ),
    );
  }
}

class _SafeInfoCard extends StatelessWidget {
  const _SafeInfoCard({required this.safe});

  final LaunchpadMultisigSafeDraft safe;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: AppColors.accent,
                size: 14,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Thong tin Safe',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          _DetailRow(label: 'Address', value: safe.address),
          _DetailRow(label: 'Chain', value: safe.chain),
          _DetailRow(
            label: 'Threshold',
            value: '${safe.threshold} of ${safe.owners.length}',
          ),
          _DetailRow(label: 'Balance', value: safe.balance),
          _DetailRow(label: 'Total Tx', value: '${safe.txCount}'),
        ],
      ),
    );
  }
}

class _SecurityNotice extends StatelessWidget {
  const _SecurityNotice({required this.safe});

  final LaunchpadMultisigSafeDraft safe;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: LaunchpadMultisigPage.noticeKey,
      padding: const EdgeInsets.all(AppSpacing.x3),
      decoration: BoxDecoration(
        color: AppColors.accent08,
        border: Border.all(color: AppColors.accent20),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lock_outline_rounded,
            color: AppColors.accent,
            size: 15,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              'Multi-sig yeu cau ${safe.threshold}/${safe.owners.length} chu ky truoc khi thuc hien. Moi giao dich co thoi han 7 ngay. Dam bao tat ca signers xac nhan truoc khi het han.',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CreateTxSheet extends StatefulWidget {
  const _CreateTxSheet({
    required this.safe,
    required this.onClose,
    required this.onCreate,
  });

  final LaunchpadMultisigSafeDraft safe;
  final VoidCallback onClose;
  final ValueChanged<LaunchpadMultisigTxDraft> onCreate;

  @override
  State<_CreateTxSheet> createState() => _CreateTxSheetState();
}

class _CreateTxSheetState extends State<_CreateTxSheet> {
  final _labelController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _contractController = TextEditingController();
  final _functionController = TextEditingController();
  final _valueController = TextEditingController(text: '0');

  @override
  void dispose() {
    _labelController.dispose();
    _descriptionController.dispose();
    _contractController.dispose();
    _functionController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canSubmit =
        _labelController.text.trim().isNotEmpty &&
        _contractController.text.trim().isNotEmpty &&
        _functionController.text.trim().isNotEmpty;
    return Material(
      key: LaunchpadMultisigPage.createSheetKey,
      color: Colors.black.withValues(alpha: .64),
      child: SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: DeviceMetrics.width,
              maxHeight: 760,
            ),
            decoration: const BoxDecoration(
              color: AppColors.bg,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppRadii.cardLarge),
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.contentPad,
                AppSpacing.x3,
                AppSpacing.contentPad,
                AppSpacing.x6,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: AppColors.borderSolid,
                        borderRadius: AppRadii.xsRadius,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Tao giao dich Multi-sig',
                          style: AppTextStyles.base.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        key: LaunchpadMultisigPage.cancelCreateKey,
                        onPressed: widget.onClose,
                        icon: const Icon(
                          Icons.close_rounded,
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                  _SafeSheetBadge(safe: widget.safe),
                  const SizedBox(height: AppSpacing.x3),
                  VitInput(
                    label: 'Ten giao dich',
                    hintText: 'VD: Withdraw rewards',
                    controller: _labelController,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: AppSpacing.x3),
                  VitInput(
                    label: 'Mo ta',
                    hintText: 'Chi tiet giao dich...',
                    controller: _descriptionController,
                  ),
                  const SizedBox(height: AppSpacing.x3),
                  VitInput(
                    label: 'Contract Address',
                    hintText: '0x...',
                    controller: _contractController,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: AppSpacing.x3),
                  VitInput(
                    label: 'Function Name',
                    hintText: 'VD: transfer, approve, claimRewards',
                    controller: _functionController,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: AppSpacing.x3),
                  VitInput(
                    label: 'Value (native token)',
                    hintText: '0',
                    controller: _valueController,
                  ),
                  const SizedBox(height: AppSpacing.x3),
                  _CreateWarning(safe: widget.safe),
                  const SizedBox(height: AppSpacing.x4),
                  VitCtaButton(
                    key: LaunchpadMultisigPage.submitCreateKey,
                    onPressed: canSubmit ? _submit : null,
                    child: const Text('Tao giao dich'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    widget.onCreate(
      LaunchpadMultisigTxDraft(
        id: 'mtx_new',
        label: _labelController.text.trim(),
        description: _descriptionController.text.trim(),
        contractAddress: _contractController.text.trim(),
        chain: widget.safe.chain,
        accent: widget.safe.accent,
        functionName: _functionController.text.trim(),
        params: const {},
        value: _valueController.text.trim().isEmpty
            ? '0'
            : _valueController.text.trim(),
        estimatedGas: r'$0.10',
        status: LaunchpadMultisigTxStatus.pendingSignatures,
        threshold: widget.safe.threshold,
        signers: widget.safe.owners,
        signedCount: 0,
        createdAt: '07/03/2026 10:00',
        expiresAt: '14/03/2026 10:00',
        nonce: widget.safe.txCount + 1,
        safeAddress: widget.safe.address,
      ),
    );
  }
}

class _SafeSheetBadge extends StatelessWidget {
  const _SafeSheetBadge({required this.safe});

  final LaunchpadMultisigSafeDraft safe;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.x2),
      decoration: BoxDecoration(
        color: AppColors.accent08,
        borderRadius: AppRadii.mdRadius,
      ),
      child: Row(
        children: [
          Icon(Icons.shield_outlined, color: safe.accent, size: 15),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              safe.label,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          Text(
            '${safe.threshold}/${safe.owners.length}',
            style: AppTextStyles.micro.copyWith(color: safe.accent),
          ),
        ],
      ),
    );
  }
}

class _CreateWarning extends StatelessWidget {
  const _CreateWarning({required this.safe});

  final LaunchpadMultisigSafeDraft safe;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.x3),
      decoration: BoxDecoration(
        color: AppColors.warn08,
        border: Border.all(color: AppColors.warn15),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warn,
            size: 14,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              'Can ${safe.threshold} chu ky tu ${safe.owners.length} signers. Giao dich het han sau 7 ngay.',
              style: AppTextStyles.micro.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}

class _SignatureProgress extends StatelessWidget {
  const _SignatureProgress({required this.tx});

  final LaunchpadMultisigTxDraft tx;

  @override
  Widget build(BuildContext context) {
    final ratio = tx.signers.isEmpty ? 0.0 : tx.signedCount / tx.signers.length;
    final color = tx.signedCount >= tx.threshold
        ? AppColors.buy
        : AppColors.primary;
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: LinearProgressIndicator(
        minHeight: 6,
        value: ratio.clamp(0, 1),
        backgroundColor: AppColors.surface3,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}

class _IconBubble extends StatelessWidget {
  const _IconBubble({
    required this.icon,
    required this.color,
    required this.size,
  });

  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: AppRadii.mdRadius,
      ),
      alignment: Alignment.center,
      child: Icon(icon, color: color, size: size * .45),
    );
  }
}

class _MiniPill extends StatelessWidget {
  const _MiniPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontSize: 8,
            height: 1,
          ),
        ),
      ),
    );
  }
}

final class _StatusView {
  const _StatusView(this.label, this.color, this.icon);

  final String label;
  final Color color;
  final IconData icon;
}

_StatusView _statusView(LaunchpadMultisigTxStatus status) {
  return switch (status) {
    LaunchpadMultisigTxStatus.draft => const _StatusView(
      'Draft',
      AppColors.text3,
      Icons.description_outlined,
    ),
    LaunchpadMultisigTxStatus.pendingSignatures => const _StatusView(
      'Cho ky',
      AppColors.primary,
      Icons.edit_outlined,
    ),
    LaunchpadMultisigTxStatus.ready => const _StatusView(
      'San sang',
      AppColors.buy,
      Icons.check_circle_outline_rounded,
    ),
    LaunchpadMultisigTxStatus.executing => const _StatusView(
      'Dang xu ly',
      AppColors.accent,
      Icons.bolt_rounded,
    ),
    LaunchpadMultisigTxStatus.executed => const _StatusView(
      'Da thuc hien',
      AppColors.buy,
      Icons.check_circle_outline_rounded,
    ),
    LaunchpadMultisigTxStatus.expired => const _StatusView(
      'Het han',
      AppColors.sell,
      Icons.cancel_outlined,
    ),
    LaunchpadMultisigTxStatus.cancelled => const _StatusView(
      'Da huy',
      AppColors.text3,
      Icons.cancel_outlined,
    ),
  };
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
