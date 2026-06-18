part of 'launchpad_multisig_page.dart';

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
    return KeyedSubtree(
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
    return KeyedSubtree(
      key: LaunchpadMultisigPage.ownersKey,
      child: VitPageSection(
        label: 'Owners & Signers',
        accentColor: AppColors.accent,
        children: [
          for (final owner in safe.owners)
            VitCard(
              padding: AppSpacing.launchpadPaddingX3,
              child: Row(
                children: [
                  _IconBubble(
                    icon: owner.role == LaunchpadMultisigSignerRole.owner
                        ? Icons.verified_user_outlined
                        : Icons.group_outlined,
                    color: owner.role == LaunchpadMultisigSignerRole.owner
                        ? AppColors.accent
                        : AppColors.primary,
                    size: AppSpacing.launchpadBox36,
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
                      size: AppSpacing.launchpadIconXl,
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
                SizedBox(
                  width: AppSpacing.launchpadVerticalMarkerWidth,
                  child: ColoredBox(color: status.color),
                ),
                Expanded(
                  child: InkWell(
                    key: LaunchpadMultisigPage.txToggleKey(tx.id),
                    onTap: onToggle,
                    child: Padding(
                      padding: AppSpacing.launchpadPaddingX3,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _IconBubble(
                            icon: status.icon,
                            color: status.color,
                            size: AppSpacing.launchpadIcon7xl,
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
                                      style: AppTextStyles.numericMicro
                                          .copyWith(color: AppColors.text3),
                                    ),
                                    const SizedBox(width: AppSpacing.x2),
                                    _MiniPill(
                                      label: tx.chain,
                                      color: tx.accent,
                                    ),
                                    const SizedBox(width: AppSpacing.x2),
                                    Text(
                                      '#${tx.nonce}',
                                      style: AppTextStyles.numericMicro
                                          .copyWith(color: AppColors.text3),
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
                            size: AppSpacing.launchpadIcon2xl,
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
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Divider(
            height: AppSpacing.launchpadDividerHeight,
            color: AppColors.divider,
          ),
          Padding(
            padding: AppSpacing.launchpadPaddingX3,
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
                    decoration: const ShapeDecoration(
                      color: AppColors.surface2,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadii.inputRadius,
                      ),
                    ),
                    child: Padding(
                      padding: AppSpacing.launchpadPaddingX2,
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
          ),
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
    return Column(
      children: [
        Padding(
          padding: AppSpacing.launchpadVerticalPaddingX1,
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
                    size: AppSpacing.launchpadIconMd,
                  ),
                ),
            ],
          ),
        ),
        const Divider(
          height: AppSpacing.launchpadDividerHeight,
          color: AppColors.divider,
        ),
      ],
    );
  }
}

class _SignerRow extends StatelessWidget {
  const _SignerRow({required this.signer});

  final LaunchpadMultisigSignerDraft signer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.launchpadTopPaddingX1,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: signer.signed ? AppColors.buy10 : AppColors.surface2,
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadii.inputRadius,
          ),
        ),
        child: Padding(
          padding: AppSpacing.launchpadInlinePillPadding,
          child: Row(
            children: [
              Icon(
                signer.signed
                    ? Icons.check_circle_outline_rounded
                    : Icons.schedule_rounded,
                color: signer.signed ? AppColors.buy : AppColors.text3,
                size: AppSpacing.launchpadIconSm,
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
                  style: AppTextStyles.micro.copyWith(color: AppColors.buy),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
