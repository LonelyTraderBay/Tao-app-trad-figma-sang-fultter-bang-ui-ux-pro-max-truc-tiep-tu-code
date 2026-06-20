part of '../pages/pending_deposits_page.dart';

class _StatusNotice extends StatelessWidget {
  const _StatusNotice({
    required this.color,
    required this.icon,
    required this.text,
  });

  final Color color;
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.sm,
      constraints: const BoxConstraints(minHeight: _pendingNoticeMinHeight),
      padding: _pendingNoticePadding,
      borderColor: color.withValues(alpha: .22),
      child: Row(
        children: [
          Icon(icon, color: color, size: AppSpacing.walletPendingNoticeIcon),
          const SizedBox(width: _pendingInlineGap),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DepositDetails extends StatelessWidget {
  const _DepositDetails({
    required this.deposit,
    required this.copied,
    required this.onCopy,
  });

  final WalletPendingDeposit deposit;
  final bool copied;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.sm,
      padding: _pendingDetailsPadding,
      child: Column(
        children: [
          _DetailRow(label: 'M\u1EA1ng', value: deposit.network),
          const SizedBox(height: _pendingTinyGap),
          _DetailRow(
            label: 'Th\u1EDDi gian d\u1EF1 ki\u1EBFn',
            value: deposit.estimatedArrival,
          ),
          const SizedBox(height: _pendingTinyGap),
          _DetailRow(
            label: 'T\u1EEB \u0111\u1ECBa ch\u1EC9',
            value: deposit.fromAddress,
          ),
          const SizedBox(height: _pendingTinyGap),
          Row(
            children: [
              Text(
                'TxHash',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const SizedBox(width: _pendingInlineGap),
              Flexible(
                child: Text(
                  deposit.txHash,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: AppTextStyles.micro.copyWith(color: _pendingPrimary),
                ),
              ),
              const SizedBox(width: _pendingTinyGap),
              VitStatusPill(
                key: PendingDepositsPage.copyKey(deposit.id),
                label: copied ? '\u0110\u00E3 ch\u00E9p' : 'Copy',
                icon: copied ? Icons.check_rounded : Icons.content_copy_rounded,
                status: copied
                    ? VitStatusPillStatus.success
                    : VitStatusPillStatus.neutral,
                size: VitStatusPillSize.sm,
                onTap: onCopy,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ),
        Flexible(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: AppTextStyles.micro.copyWith(color: AppColors.text2),
          ),
        ),
      ],
    );
  }
}

class _EmptyDeposits extends StatelessWidget {
  const _EmptyDeposits();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _pendingCardPadding,
      child: Column(
        children: [
          VitCard(
            variant: VitCardVariant.inner,
            radius: VitCardRadius.sm,
            width: _pendingIconBox,
            height: _pendingIconBox,
            alignment: Alignment.center,
            child: const Icon(
              Icons.inbox_outlined,
              color: AppColors.text3,
              size: AppSpacing.walletPendingEmptyIconGlyph,
            ),
          ),
          const SizedBox(height: _pendingGap),
          Text(
            'Kh\u00F4ng c\u00F3 giao d\u1ECBch n\u1EA1p n\u00E0o',
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _InfoNotice extends StatelessWidget {
  const _InfoNotice();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: _pendingNoticePadding,
      borderColor: _pendingPrimary.withValues(alpha: .15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: _pendingPrimary,
            size: AppSpacing.walletPendingNoticeIcon,
          ),
          const SizedBox(width: _pendingInlineGap),
          Expanded(
            child: Text(
              'S\u1ED1 x\u00E1c nh\u1EADn c\u1EA7n thi\u1EBFt ph\u1EE5 thu\u1ED9c v\u00E0o m\u1EA1ng blockchain. N\u1EA1p d\u01B0\u1EDBi m\u1EE9c t\u1ED1i thi\u1EC3u s\u1EBD kh\u00F4ng \u0111\u01B0\u1EE3c ghi nh\u1EADn. Li\u00EAn h\u1EC7 h\u1ED7 tr\u1EE3 n\u1EBFu giao d\u1ECBch ch\u01B0a xu\u1EA5t hi\u1EC7n sau 1 gi\u1EDD.',
              style: AppTextStyles.micro.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}

final class _DepositStatusConfig {
  const _DepositStatusConfig({required this.label, required this.color});

  final String label;
  final Color color;
}

_DepositStatusConfig _statusConfig(String status) {
  return switch (status) {
    'credited' => const _DepositStatusConfig(
      label: '\u0110\u00E3 ghi nh\u1EADn',
      color: _pendingGreen,
    ),
    'failed' => const _DepositStatusConfig(
      label: 'Th\u1EA5t b\u1EA1i',
      color: _pendingRed,
    ),
    'processing' => const _DepositStatusConfig(
      label: '\u0110ang x\u1EED l\u00FD',
      color: _pendingPrimary,
    ),
    _ => const _DepositStatusConfig(
      label: '\u0110ang x\u00E1c nh\u1EADn',
      color: _pendingAmber,
    ),
  };
}
