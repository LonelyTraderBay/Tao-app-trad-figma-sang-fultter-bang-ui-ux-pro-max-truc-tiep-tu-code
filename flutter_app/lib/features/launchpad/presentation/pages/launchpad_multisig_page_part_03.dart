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
                'Thông tin Safe',
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
    return VitCard(
      key: LaunchpadMultisigPage.noticeKey,
      variant: VitCardVariant.inner,
      borderColor: AppModuleAccents.launchpad.withValues(alpha: .24),
      background: const ColoredBox(color: AppColors.accent08),
      padding: AppSpacing.launchpadPaddingX3,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lock_outline_rounded,
            color: AppModuleAccents.launchpad,
            size: AppSpacing.launchpadIconLg,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              'Multi-sig yêu cầu ${safe.threshold}/${safe.owners.length} chữ ký trước khi thực hiện. Mỗi giao dịch có thời hạn 7 ngày. Đảm bảo tất cả signers xác nhận trước khi hết hạn.',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                height: AppSpacing.launchpadLineHeightShort,
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
                        height: AppSpacing.x1,
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
                            'Tạo giao dịch Multi-sig',
                            style: AppTextStyles.base.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                        VitIconButton(
                          key: LaunchpadMultisigPage.cancelCreateKey,
                          onPressed: widget.onClose,
                          icon: Icons.close_rounded,
                          tooltip: 'Dong tao giao dich Multi-sig',
                          variant: VitIconButtonVariant.transparent,
                          size: VitIconButtonSize.md,
                        ),
                      ],
                    ),
                    _SafeSheetBadge(safe: widget.safe),
                    const SizedBox(height: AppSpacing.x3),
                    VitInput(
                      label: 'Tên giao dịch',
                      hintText: 'VD: Withdraw rewards',
                      controller: _labelController,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: AppSpacing.x3),
                    VitInput(
                      label: 'Mô tả',
                      hintText: 'Chi tiết giao dịch...',
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
                      child: const Text('Tạo giao dịch'),
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
      decoration: ShapeDecoration(
        color: AppModuleAccents.launchpad.withValues(alpha: .08),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.inputRadius),
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
                'Cần ${safe.threshold} chữ ký từ ${safe.owners.length} signers. Giao dịch hết hạn sau 7 ngày.',
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
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
        ),
        child: Center(
          child: Icon(icon, color: color, size: size * .45),
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
      'Chờ ký',
      AppColors.primary,
      Icons.edit_outlined,
    ),
    LaunchpadMultisigTxStatus.ready => const _StatusView(
      'Sẵn sàng',
      AppColors.buy,
      Icons.check_circle_outline_rounded,
    ),
    LaunchpadMultisigTxStatus.executing => const _StatusView(
      'Đang xử lý',
      AppModuleAccents.launchpad,
      Icons.bolt_rounded,
    ),
    LaunchpadMultisigTxStatus.executed => const _StatusView(
      'Đã thực hiện',
      AppColors.buy,
      Icons.check_circle_outline_rounded,
    ),
    LaunchpadMultisigTxStatus.expired => const _StatusView(
      'Hết hạn',
      AppColors.sell,
      Icons.cancel_outlined,
    ),
    LaunchpadMultisigTxStatus.cancelled => const _StatusView(
      'Đã hủy',
      AppColors.text3,
      Icons.cancel_outlined,
    ),
  };
}

VitStatusPillStatus _statusPillStatus(LaunchpadMultisigTxStatus status) {
  return switch (status) {
    LaunchpadMultisigTxStatus.draft => VitStatusPillStatus.neutral,
    LaunchpadMultisigTxStatus.pendingSignatures => VitStatusPillStatus.info,
    LaunchpadMultisigTxStatus.ready => VitStatusPillStatus.success,
    LaunchpadMultisigTxStatus.executing => VitStatusPillStatus.purple,
    LaunchpadMultisigTxStatus.executed => VitStatusPillStatus.success,
    LaunchpadMultisigTxStatus.expired => VitStatusPillStatus.error,
    LaunchpadMultisigTxStatus.cancelled => VitStatusPillStatus.neutral,
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
