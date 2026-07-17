part of '../../pages/transfer/pending_deposits_page.dart';

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
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitInfoCallout(
      message: text,
      icon: icon,
      accentColor: color,
      iconSize: WalletSpacingTokens.walletPendingNoticeIcon,
      padding: WalletSpacingTokens.walletPendingNoticePadding,
      messageColor: color,
      messageWeight: AppTextStyles.bold,
      maxLines: 1,
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
      radius: VitCardRadius.standard,
      child: Column(
        children: [
          VitInfoRow(
            label: 'X\u00E1c nh\u1EADn y\u00EAu c\u1EA7u',
            value:
                '${deposit.confirmations}/${deposit.requiredConfirmations} x\u00E1c nh\u1EADn',
            leading: const Icon(Icons.fact_check_outlined),
            valueColor: _statusConfig(deposit.status).color,
            density: VitDensity.compact,
            showDivider: true,
          ),
          VitInfoRow(
            label: 'Th\u1EDDi \u0111i\u1EC3m g\u1EEDi',
            value: deposit.createdAt,
            leading: const Icon(Icons.schedule_rounded),
            density: VitDensity.compact,
            showDivider: true,
          ),
          VitInfoRow(
            label: 'ETA',
            value: deposit.estimatedArrival,
            leading: const Icon(Icons.timelapse_rounded),
            density: VitDensity.compact,
            showDivider: true,
          ),
          VitInfoRow(
            label: 'M\u1EA1ng',
            value: deposit.network,
            leading: const Icon(Icons.hub_outlined),
            density: VitDensity.compact,
            showDivider: true,
          ),
          VitInfoRow(
            label: 'T\u1EEB \u0111\u1ECBa ch\u1EC9',
            value: _maskPendingAddress(deposit.fromAddress),
            leading: const Icon(Icons.account_balance_wallet_outlined),
            density: VitDensity.compact,
            showDivider: true,
          ),
          VitInfoRow(
            label: 'TxHash',
            value: _maskPendingAddress(deposit.txHash),
            leading: const Icon(Icons.receipt_long_outlined),
            valueColor: AppColors.primary,
            density: VitDensity.compact,
            trailing: Semantics(
              button: true,
              label: copied
                  ? 'Đã sao chép mã giao dịch của ${deposit.asset}'
                  : 'Sao chép mã giao dịch của ${deposit.asset}',
              child: VitStatusPill(
                key: PendingDepositsPage.copyKey(deposit.id),
                label: copied ? '\u0110\u00E3 ch\u00E9p' : 'Copy',
                icon: copied ? Icons.check_rounded : Icons.content_copy_rounded,
                status: copied
                    ? VitStatusPillStatus.success
                    : VitStatusPillStatus.neutral,
                size: VitStatusPillSize.sm,
                onTap: onCopy,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyDeposits extends StatelessWidget {
  const _EmptyDeposits();

  @override
  Widget build(BuildContext context) {
    return const VitEmptyState(
      title: 'Kh\u00F4ng c\u00F3 giao d\u1ECBch n\u1EA1p n\u00E0o',
      message:
          'B\u1ED9 l\u1ECDc hi\u1EC7n t\u1EA1i kh\u00F4ng c\u00F3 giao d\u1ECBch c\u1EA7n theo d\u00F5i.',
      icon: Icons.inbox_outlined,
    );
  }
}

class _InfoNotice extends StatelessWidget {
  const _InfoNotice();

  @override
  Widget build(BuildContext context) {
    return VitInfoCallout(
      message:
          'S\u1ED1 x\u00E1c nh\u1EADn c\u1EA7n thi\u1EBFt ph\u1EE5 thu\u1ED9c v\u00E0o m\u1EA1ng blockchain. N\u1EA1p d\u01B0\u1EDBi m\u1EE9c t\u1ED1i thi\u1EC3u s\u1EBD kh\u00F4ng \u0111\u01B0\u1EE3c ghi nh\u1EADn. Li\u00EAn h\u1EC7 h\u1ED7 tr\u1EE3 n\u1EBFu giao d\u1ECBch ch\u01B0a xu\u1EA5t hi\u1EC7n sau 1 gi\u1EDD.',
      icon: Icons.warning_amber_rounded,
      accentColor: AppColors.primary,
      variant: VitCardVariant.standard,
      iconSize: WalletSpacingTokens.walletPendingNoticeIcon,
      padding: WalletSpacingTokens.walletPendingInfoPadding,
      messageStyle: AppTextStyles.micro,
    );
  }
}

final class _DepositStatusConfig {
  const _DepositStatusConfig({
    required this.label,
    required this.color,
    required this.icon,
    required this.status,
  });

  final String label;
  final Color color;
  final IconData icon;
  final VitStatusPillStatus status;
}

_DepositStatusConfig _statusConfig(String status) {
  return switch (status) {
    'credited' => const _DepositStatusConfig(
      label: '\u0110\u00E3 ghi nh\u1EADn',
      color: AppColors.buy,
      icon: Icons.check_circle_outline_rounded,
      status: VitStatusPillStatus.success,
    ),
    'failed' => const _DepositStatusConfig(
      label: 'Th\u1EA5t b\u1EA1i',
      color: AppColors.sell,
      icon: Icons.warning_amber_rounded,
      status: VitStatusPillStatus.error,
    ),
    'processing' => const _DepositStatusConfig(
      label: '\u0110ang x\u1EED l\u00FD',
      color: AppColors.primary,
      icon: Icons.sync_rounded,
      status: VitStatusPillStatus.info,
    ),
    _ => const _DepositStatusConfig(
      label: '\u0110ang x\u00E1c nh\u1EADn',
      color: AppColors.caution,
      icon: Icons.access_time_rounded,
      status: VitStatusPillStatus.warning,
    ),
  };
}

String _maskPendingAddress(String value) => maskAddress(value);
