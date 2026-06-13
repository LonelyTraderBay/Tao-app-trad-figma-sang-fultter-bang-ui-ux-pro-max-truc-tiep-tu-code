part of 'launchpad_multisig_page.dart';

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
            VitAutoHideHeaderScaffold(
              bottomInset: bottomInset,
              semanticLabel: 'SC-313 LaunchpadMultisigPage scroll surface',
              header: VitHeader(
                title: snapshot.title,
                showBack: true,
                onBack: () => context.go(snapshot.backRoute),
              ),
              child: SingleChildScrollView(
                key: LaunchpadMultisigPage.contentKey,
                physics: const BouncingScrollPhysics(),
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
                    _StatsStrip(safe: selectedSafe, pending: queueTxs.length),
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
                          size: AppSpacing.launchpadIcon5xl,
                        ),
                        const SizedBox(width: AppSpacing.x2),
                        Expanded(
                          child: Text(
                            safe.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
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
                          ),
                        ),
                        const SizedBox(width: AppSpacing.x2),
                        Text(
                          '${safe.threshold}/${safe.owners.length}',
                          style: AppTextStyles.numericMicro.copyWith(
                            color: AppColors.text3,
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
              style: AppTextStyles.numericCode.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            Text(
              label,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
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
            size: AppSpacing.launchpadBox40,
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
