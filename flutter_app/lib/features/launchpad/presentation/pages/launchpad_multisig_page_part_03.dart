part of 'launchpad_multisig_page.dart';

class _SafeInfoCard extends StatelessWidget {
  const _SafeInfoCard({required this.safe});

  final LaunchpadMultisigSafeDraft safe;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.launchpadPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: AppColors.accent,
                size: AppSpacing.launchpadIconMd,
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
    return DecoratedBox(
      key: LaunchpadMultisigPage.noticeKey,
      decoration: const ShapeDecoration(
        color: AppColors.accent08,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.cardRadius,
          side: BorderSide(color: AppColors.accent20),
        ),
      ),
      child: Padding(
        padding: AppSpacing.launchpadPaddingX3,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.lock_outline_rounded,
              color: AppColors.accent,
              size: AppSpacing.launchpadIconLg,
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Text(
                'Multi-sig yeu cau ${safe.threshold}/${safe.owners.length} chu ky truoc khi thuc hien. Moi giao dich co thoi han 7 ngay. Dam bao tat ca signers xac nhan truoc khi het han.',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  height: AppSpacing.launchpadLineHeightLong,
                ),
              ),
            ),
          ],
        ),
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
      color: AppColors.dynamicIslandBg.withValues(alpha: .64),
      child: SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: DeviceMetrics.width,
              maxHeight: 760,
            ),
            child: DecoratedBox(
              decoration: const ShapeDecoration(
                color: AppColors.bg,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadii.sheetTopLargeRadius,
                ),
              ),
              child: SingleChildScrollView(
                padding: AppSpacing.launchpadCreateSheetPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(
                      child: SizedBox(
                        width: AppSpacing.launchpadBox40,
                        height: AppSpacing.launchpadSheetHandleHeight,
                        child: DecoratedBox(
                          decoration: ShapeDecoration(
                            color: AppColors.borderSolid,
                            shape: RoundedRectangleBorder(
                              borderRadius: AppRadii.xsRadius,
                            ),
                          ),
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
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.accent08,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
      ),
      child: Padding(
        padding: AppSpacing.launchpadPaddingX2,
        child: Row(
          children: [
            Icon(
              Icons.shield_outlined,
              color: safe.accent,
              size: AppSpacing.launchpadIconLg,
            ),
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
      ),
    );
  }
}

class _CreateWarning extends StatelessWidget {
  const _CreateWarning({required this.safe});

  final LaunchpadMultisigSafeDraft safe;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.warn08,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.cardRadius,
          side: BorderSide(color: AppColors.warn15),
        ),
      ),
      child: Padding(
        padding: AppSpacing.launchpadPaddingX3,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.warn,
              size: AppSpacing.launchpadIconMd,
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
      borderRadius: AppRadii.pillRadius,
      child: LinearProgressIndicator(
        minHeight: AppSpacing.launchpadDotSm,
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
    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: color.withValues(alpha: .14),
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
        ),
        child: Center(
          child: Icon(icon, color: color, size: size * .45),
        ),
      ),
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
      decoration: ShapeDecoration(
        color: color.withValues(alpha: .12),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.xsRadius),
      ),
      child: Padding(
        padding: AppSpacing.launchpadTinyChipPadding,
        child: Text(
          label,
          style: AppTextStyles.chartLabelTiny.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            height: AppSpacing.launchpadLineHeightTight,
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
