part of '../pages/pending_deposits_page.dart';

class _SummaryBanner extends StatelessWidget {
  const _SummaryBanner({required this.pendingCount, required this.onRefresh});

  final int pendingCount;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final hasPending = pendingCount > 0;
    final color = hasPending ? _pendingAmber : _pendingGreen;
    return VitCard(
      height: AppSpacing.walletPendingSummaryHeight,
      padding: AppSpacing.walletPendingSummaryPadding,
      borderColor: _pendingBorder,
      child: Row(
        children: [
          VitCard(
            variant: VitCardVariant.inner,
            radius: VitCardRadius.sm,
            width: AppSpacing.walletPendingSummaryIconBox,
            height: AppSpacing.walletPendingSummaryIconBox,
            alignment: Alignment.center,
            borderColor: color.withValues(alpha: .22),
            child: Icon(
              hasPending
                  ? Icons.access_time_rounded
                  : Icons.check_circle_outline_rounded,
              color: color,
              size: AppSpacing.walletPendingSummaryIconGlyph,
            ),
          ),
          const SizedBox(width: AppSpacing.walletPendingRowGap),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasPending
                      ? '$pendingCount giao d\u1ECBch \u0111ang ch\u1EDD x\u00E1c nh\u1EADn'
                      : 'T\u1EA5t c\u1EA3 n\u1EA1p ti\u1EC1n \u0111\u00E3 ho\u00E0n t\u1EA5t',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.walletPendingTextGap),
                Text(
                  hasPending
                      ? 'Trang t\u1EF1 \u0111\u1ED9ng c\u1EADp nh\u1EADt m\u1ED7i 5 gi\u00E2y'
                      : 'Kh\u00F4ng c\u00F3 giao d\u1ECBch n\u00E0o \u0111ang ch\u1EDD',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.walletPendingRowGap),
          VitIconButton(
            key: PendingDepositsPage.refreshKey,
            icon: Icons.refresh_rounded,
            tooltip: 'Refresh pending deposits',
            size: VitIconButtonSize.sm,
            onPressed: onRefresh,
          ),
        ],
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({
    required this.active,
    required this.pendingCount,
    required this.onChanged,
  });

  final _DepositFilter active;
  final int pendingCount;
  final ValueChanged<_DepositFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    final items = [
      (_DepositFilter.all, 'T\u1EA5t c\u1EA3'),
      (_DepositFilter.pending, '\u0110ang ch\u1EDD ($pendingCount)'),
      (_DepositFilter.done, 'Ho\u00E0n t\u1EA5t'),
    ];
    return Wrap(
      spacing: AppSpacing.walletPendingChipGap,
      runSpacing: AppSpacing.walletPendingChipGap,
      children: [
        for (final item in items)
          VitStatusPill(
            key: PendingDepositsPage.filterKey(item.$1.name),
            label: item.$2,
            status: active == item.$1
                ? VitStatusPillStatus.info
                : VitStatusPillStatus.neutral,
            size: VitStatusPillSize.md,
            outline: active != item.$1,
            onTap: () => onChanged(item.$1),
          ),
      ],
    );
  }
}

class _DepositCard extends StatelessWidget {
  const _DepositCard({
    required this.deposit,
    required this.copied,
    required this.onCopy,
  });

  final WalletPendingDeposit deposit;
  final bool copied;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    final config = _statusConfig(deposit.status);
    return VitCard(
      key: PendingDepositsPage.depositKey(deposit.id),
      padding: AppSpacing.walletPendingCardPadding,
      borderColor: _pendingBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              VitCard(
                variant: VitCardVariant.inner,
                radius: VitCardRadius.sm,
                width: AppSpacing.walletPendingAssetIconBox,
                height: AppSpacing.walletPendingAssetIconBox,
                alignment: Alignment.center,
                borderColor: config.color.withValues(alpha: .22),
                child: Icon(
                  Icons.south_west_rounded,
                  color: config.color,
                  size: AppSpacing.walletPendingAssetIconGlyph,
                ),
              ),
              const SizedBox(width: AppSpacing.walletPendingRowGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'N\u1EA1p ${deposit.asset}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: AppSpacing.walletPendingInlineGap,
                        ),
                        Flexible(
                          child: Text(
                            '+${deposit.amountLabel}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.right,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.walletPendingTextGap),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            deposit.createdAt,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: AppSpacing.walletPendingInlineGap,
                        ),
                        _DepositStatusBadge(config: config),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (deposit.status == 'confirming' ||
              deposit.status == 'processing') ...[
            const SizedBox(height: AppSpacing.walletPendingProgressBlockGap),
            _ConfirmationProgress(deposit: deposit, color: config.color),
          ],
          if (deposit.status == 'credited') ...[
            const SizedBox(height: AppSpacing.walletPendingStatusGap),
            _StatusNotice(
              color: _pendingGreen,
              icon: Icons.check_circle_outline_rounded,
              text:
                  '\u0110\u00E3 ghi nh\u1EADn v\u00E0o v\u00ED \u2014 ${deposit.confirmations}/${deposit.requiredConfirmations} x\u00E1c nh\u1EADn',
            ),
          ],
          if (deposit.status == 'failed') ...[
            const SizedBox(height: AppSpacing.walletPendingStatusGap),
            const _StatusNotice(
              color: _pendingRed,
              icon: Icons.warning_amber_rounded,
              text:
                  'Giao d\u1ECBch th\u1EA5t b\u1EA1i \u2014 li\u00EAn h\u1EC7 h\u1ED7 tr\u1EE3 n\u1EBFu \u0111\u00E3 g\u1EEDi ti\u1EC1n',
            ),
          ],
          const SizedBox(height: AppSpacing.walletPendingRowGap),
          _DepositDetails(deposit: deposit, copied: copied, onCopy: onCopy),
        ],
      ),
    );
  }
}

class _DepositStatusBadge extends StatelessWidget {
  const _DepositStatusBadge({required this.config});

  final _DepositStatusConfig config;

  @override
  Widget build(BuildContext context) {
    return VitAccentPill(
      label: config.label,
      accentColor: config.color,
      size: VitStatusPillSize.sm,
    );
  }
}

class _ConfirmationProgress extends StatelessWidget {
  const _ConfirmationProgress({required this.deposit, required this.color});

  final WalletPendingDeposit deposit;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final dotCount = deposit.requiredConfirmations.clamp(2, 12);
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'X\u00E1c nh\u1EADn blockchain',
                style: AppTextStyles.micro.copyWith(color: AppColors.text2),
              ),
            ),
            Text(
              '${deposit.confirmations}/${deposit.requiredConfirmations}',
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.walletPendingProgressGap),
        ClipRRect(
          borderRadius: AppRadii.pillRadius,
          child: SizedBox(
            height: AppSpacing.walletPendingProgressHeight,
            child: LinearProgressIndicator(
              value: deposit.progress.clamp(.05, 1),
              backgroundColor: AppColors.surface3,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.walletPendingInlineGap),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (var i = 0; i < dotCount; i++)
              ClipRRect(
                borderRadius: AppRadii.pillRadius,
                child: SizedBox(
                  width: AppSpacing.walletPendingProgressDot,
                  height: AppSpacing.walletPendingProgressDot,
                  child: ColoredBox(
                    color: i < deposit.confirmations
                        ? color
                        : AppColors.surface3,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
