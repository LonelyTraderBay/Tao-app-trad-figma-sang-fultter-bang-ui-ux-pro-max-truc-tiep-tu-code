part of '../pages/transaction_detail_page.dart';

class _TransactionDetailContent extends StatelessWidget {
  const _TransactionDetailContent({
    required this.tx,
    required this.onCopy,
    required this.onSupport,
  });

  final WalletTransaction tx;
  final ValueChanged<String> onCopy;
  final VoidCallback onSupport;

  @override
  Widget build(BuildContext context) {
    final type = _DetailTypeMeta.from(tx);
    final status = _DetailStatusMeta.from(tx.status);
    final details = _detailsFor(tx, type.isDebit);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SummaryCard(tx: tx, type: type, status: status),
        const SizedBox(height: AppSpacing.walletTransactionSummaryTopGap),
        _ProgressCard(tx: tx),
        const SizedBox(height: AppSpacing.walletTransactionSummaryTopGap),
        _DetailsCard(rows: details, onCopy: onCopy),
        const SizedBox(height: AppSpacing.walletTransactionProgressBottomGap),
        if (tx.txHash != null) ...[
          const _ExplorerButton(),
          const SizedBox(height: AppSpacing.walletTransactionDetailsBottomPad),
        ],
        _SupportButton(onTap: onSupport),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.tx,
    required this.type,
    required this.status,
  });

  final WalletTransaction tx;
  final _DetailTypeMeta type;
  final _DetailStatusMeta status;

  @override
  Widget build(BuildContext context) {
    return _VitCardSurface(
      padding: AppSpacing.walletTransactionSummaryPadding,
      child: Column(
        children: [
          VitCard(
            variant: VitCardVariant.inner,
            radius: VitCardRadius.sm,
            width: AppSpacing.walletTransactionSummaryIconSize,
            height: AppSpacing.walletTransactionSummaryIconSize,
            alignment: Alignment.center,
            borderColor: type.color.withValues(alpha: .22),
            child: Icon(
              type.icon,
              color: AppColors.text1,
              size: AppSpacing.walletTransactionSummaryStatusIcon,
            ),
          ),
          const SizedBox(height: AppSpacing.walletTransactionSummaryTopGap),
          Text(
            type.label,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(
            height: AppSpacing.walletTransactionSummarySectionVPad,
          ),
          Text(
            '${type.isDebit ? '-' : '+'}${_formatAmount(tx)} ${tx.asset}',
            textAlign: TextAlign.center,
            style: AppTextStyles.heroNumber.copyWith(
              color: type.color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(
            height: AppSpacing.walletTransactionSummarySectionVPad,
          ),
          VitStatusPill(
            label: status.label,
            icon: status.icon,
            status: _detailPillStatus(tx.status),
            size: VitStatusPillSize.lg,
          ),
        ],
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.tx});

  final WalletTransaction tx;

  @override
  Widget build(BuildContext context) {
    final steps = [
      _ProgressStep('Tạo yêu cầu', tx.createdAt, done: true),
      _ProgressStep(
        'Đang xử lý',
        tx.status == WalletTransactionStatus.failed ? null : tx.createdAt,
        done: tx.status != WalletTransactionStatus.failed,
      ),
      _ProgressStep(
        tx.status == WalletTransactionStatus.completed
            ? 'Hoàn tất'
            : tx.status == WalletTransactionStatus.failed
            ? 'Thất bại'
            : 'Đang chờ...',
        tx.status == WalletTransactionStatus.completed ? tx.createdAt : null,
        done: tx.status == WalletTransactionStatus.completed,
        failed: tx.status == WalletTransactionStatus.failed,
      ),
    ];

    return _VitCardSurface(
      padding: AppSpacing.walletTransactionProgressCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tiến trình',
            style: AppTextStyles.body.copyWith(fontWeight: AppTextStyles.bold),
          ),
          const SizedBox(height: AppSpacing.walletTransactionStepSpacing),
          for (var i = 0; i < steps.length; i++)
            _ProgressRow(step: steps[i], isLast: i == steps.length - 1),
        ],
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  const _ProgressRow({required this.step, required this.isLast});

  final _ProgressStep step;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final color = step.failed
        ? _detailRed
        : step.done
        ? _detailGreen
        : AppColors.borderSolid;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            ClipRRect(
              borderRadius: AppRadii.pillRadius,
              child: SizedBox(
                width: AppSpacing.walletTransactionProgressDotSize,
                height: AppSpacing.walletTransactionProgressDotSize,
                child: ColoredBox(color: color),
              ),
            ),
            if (!isLast)
              Padding(
                padding: AppSpacing.zeroInsets.copyWith(
                  top: AppSpacing.walletTransactionProgressLineSpacing,
                  bottom: AppSpacing.walletTransactionProgressLineSpacing,
                ),
                child: SizedBox(
                  width: AppSpacing.walletTransactionProgressLineWidth,
                  height: AppSpacing.walletTransactionStepLineHeight,
                  child: ColoredBox(
                    color: step.done ? _detailGreen : AppColors.borderSolid,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: AppSpacing.walletTransactionSummarySectionVPad),
        Padding(
          padding: AppSpacing.zeroInsets.copyWith(
            bottom: isLast ? 0 : AppSpacing.walletTransactionSummarySectionVPad,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                step.label,
                style: AppTextStyles.caption.copyWith(
                  color: step.done || step.failed
                      ? AppColors.text1
                      : AppColors.text3,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              if (step.time != null) ...[
                const SizedBox(
                  height: AppSpacing.walletTransactionProgressVerticalGap,
                ),
                Text(
                  step.time!,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _DetailsCard extends StatelessWidget {
  const _DetailsCard({required this.rows, required this.onCopy});

  final List<_DetailRowData> rows;
  final ValueChanged<String> onCopy;

  @override
  Widget build(BuildContext context) {
    return _VitCardSurface(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: AppSpacing.walletTransactionSummaryHeaderPadding,
            child: Text(
              'Thông tin chi tiết',
              style: AppTextStyles.body.copyWith(
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          for (final row in rows)
            _DetailInfoRow(row: row, onCopy: () => onCopy(row.value)),
        ],
      ),
    );
  }
}

class _DetailInfoRow extends StatelessWidget {
  const _DetailInfoRow({required this.row, required this.onCopy});

  final _DetailRowData row;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(
          height: AppSpacing.walletHistoryDividerHeight,
          thickness: AppSpacing.walletHistoryDividerHeight,
          color: AppColors.divider,
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: AppSpacing.walletTransactionInfoRowMinHeight,
          ),
          child: Padding(
            padding: AppSpacing.walletTransactionDetailRowPadding,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    row.label,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.walletHistoryFilterGap),
                Flexible(
                  child: Text(
                    row.value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ),
                if (row.copyable) ...[
                  const SizedBox(width: AppSpacing.walletHistoryEndListGap),
                  VitIconButton(
                    key: TransactionDetailPage.copyTxIdKey,
                    icon: Icons.copy_rounded,
                    tooltip: 'Copy transaction field',
                    size: VitIconButtonSize.sm,
                    onPressed: onCopy,
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ExplorerButton extends StatelessWidget {
  const _ExplorerButton();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: TransactionDetailPage.explorerKey,
      height: AppSpacing.walletTransactionExplorerHeight,
      alignment: Alignment.center,
      variant: VitCardVariant.inner,
      borderColor: _detailPrimary.withValues(alpha: .28),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.open_in_new_rounded,
            color: _detailPrimary,
            size: AppSpacing.walletTransactionActionIcon,
          ),
          const SizedBox(width: AppSpacing.rowGapCompact),
          Text(
            'Xem trên Explorer',
            style: AppTextStyles.caption.copyWith(
              color: _detailPrimary,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}
