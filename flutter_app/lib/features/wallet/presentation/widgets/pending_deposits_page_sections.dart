part of '../pages/pending_deposits_page.dart';

class _TrustReviewNotice extends StatelessWidget {
  const _TrustReviewNotice();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      borderColor: AppColors.caution.withValues(alpha: .28),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.fact_check_outlined,
            color: AppColors.caution,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: _pendingInlineGap),
          Expanded(
            child: Text(
              'Ki\u1EC3m tra m\u1EA1ng, s\u1ED1 x\u00E1c nh\u1EADn, s\u1ED1 ti\u1EC1n v\u00E0 ph\u00ED tr\u01B0\u1EDBc khi thao t\u00E1c v\u00ED.',
              style: AppTextStyles.micro.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryBanner extends StatelessWidget {
  const _SummaryBanner({
    required this.pendingCount,
    required this.onRefresh,
    this.lastRefreshLabel,
  });

  final int pendingCount;
  final VoidCallback onRefresh;
  final String? lastRefreshLabel;

  @override
  Widget build(BuildContext context) {
    final hasPending = pendingCount > 0;
    final color = hasPending ? AppColors.caution : AppColors.buy;
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      constraints: const BoxConstraints(
        minHeight: AppSpacing.walletPendingSummaryHeight,
      ),
      padding: AppSpacing.walletPendingCardPadding,
      borderColor: AppColors.overlayStroke,
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: color.withValues(alpha: .12),
              borderRadius: AppRadii.smRadius,
              border: Border.all(color: color.withValues(alpha: .22)),
            ),
            child: SizedBox(
              width: AppSpacing.walletPendingAssetIconBox,
              height: AppSpacing.walletPendingAssetIconBox,
              child: Icon(
                hasPending
                    ? Icons.access_time_rounded
                    : Icons.check_circle_outline_rounded,
                color: color,
                size: AppSpacing.walletPendingSummaryIconGlyph,
              ),
            ),
          ),
          const SizedBox(width: _pendingInlineGap),
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
                const SizedBox(height: _pendingTinyGap),
                Text(
                  lastRefreshLabel ??
                      (hasPending
                          ? 'Trang t\u1EF1 \u0111\u1ED9ng c\u1EADp nh\u1EADt m\u1ED7i 5 gi\u00E2y'
                          : 'Kh\u00F4ng c\u00F3 giao d\u1ECBch n\u00E0o \u0111ang ch\u1EDD'),
                  key: lastRefreshLabel == null
                      ? null
                      : PendingDepositsPage.refreshFeedbackKey,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const SizedBox(width: _pendingInlineGap),
          Semantics(
            button: true,
            label: 'Refresh pending deposit statuses',
            child: VitIconButton(
              key: PendingDepositsPage.refreshKey,
              icon: Icons.refresh_rounded,
              tooltip: 'Refresh pending deposits',
              size: VitIconButtonSize.sm,
              onPressed: onRefresh,
            ),
          ),
        ],
      ),
    );
  }
}

class _PendingDepositFilters extends StatelessWidget {
  const _PendingDepositFilters({
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
      spacing: _pendingTinyGap,
      runSpacing: _pendingTinyGap,
      children: [
        for (final item in items)
          Semantics(
            button: true,
            selected: active == item.$1,
            label: '${item.$2} pending deposit filter',
            child: VitStatusPill(
              key: PendingDepositsPage.filterKey(item.$1.name),
              label: item.$2,
              status: active == item.$1
                  ? VitStatusPillStatus.info
                  : VitStatusPillStatus.neutral,
              size: VitStatusPillSize.sm,
              outline: active != item.$1,
              onTap: () => onChanged(item.$1),
            ),
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
      borderColor: AppColors.overlayStroke,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: config.color.withValues(alpha: .12),
                  borderRadius: AppRadii.smRadius,
                  border: Border.all(
                    color: config.color.withValues(alpha: .22),
                  ),
                ),
                child: SizedBox(
                  width: AppSpacing.walletPendingAssetIconBox,
                  height: AppSpacing.walletPendingAssetIconBox,
                  child: Icon(
                    Icons.south_west_rounded,
                    color: config.color,
                    size: AppSpacing.walletPendingAssetIconGlyph,
                  ),
                ),
              ),
              const SizedBox(width: _pendingInlineGap),
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
                        const SizedBox(width: _pendingInlineGap),
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
                    const SizedBox(height: _pendingTinyGap),
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
                        const SizedBox(width: _pendingInlineGap),
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
            const SizedBox(height: _pendingGap),
            _ConfirmationProgress(deposit: deposit, color: config.color),
          ],
          if (deposit.status == 'credited') ...[
            const SizedBox(height: _pendingGap),
            _StatusNotice(
              color: AppColors.buy,
              icon: Icons.check_circle_outline_rounded,
              text:
                  '\u0110\u00E3 ghi nh\u1EADn v\u00E0o v\u00ED \u2014 ${deposit.confirmations}/${deposit.requiredConfirmations} x\u00E1c nh\u1EADn',
            ),
          ],
          if (deposit.status == 'failed') ...[
            const SizedBox(height: _pendingGap),
            const _StatusNotice(
              color: AppColors.sell,
              icon: Icons.warning_amber_rounded,
              text:
                  'Giao d\u1ECBch th\u1EA5t b\u1EA1i \u2014 li\u00EAn h\u1EC7 h\u1ED7 tr\u1EE3 n\u1EBFu \u0111\u00E3 g\u1EEDi ti\u1EC1n',
            ),
          ],
          const SizedBox(height: _pendingGap),
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
    return VitStatusPill(
      label: config.label,
      icon: config.icon,
      status: config.status,
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
    return Semantics(
      container: true,
      label:
          'Blockchain confirmations ${deposit.confirmations} of ${deposit.requiredConfirmations}',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'X\u00E1c nh\u1EADn blockchain',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
              ),
              VitStatusPill(
                label:
                    '${deposit.confirmations}/${deposit.requiredConfirmations} y\u00EAu c\u1EA7u',
                icon: Icons.fact_check_outlined,
                status: deposit.confirmations >= deposit.requiredConfirmations
                    ? VitStatusPillStatus.success
                    : VitStatusPillStatus.warning,
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          const SizedBox(height: _pendingTinyGap),
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
          const SizedBox(height: _pendingTinyGap),
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
      ),
    );
  }
}
