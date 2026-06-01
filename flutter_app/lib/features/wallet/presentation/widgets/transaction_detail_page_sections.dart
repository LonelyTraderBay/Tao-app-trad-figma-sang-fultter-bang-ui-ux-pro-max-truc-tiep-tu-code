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
        const SizedBox(height: 16),
        _ProgressCard(tx: tx),
        const SizedBox(height: 16),
        _DetailsCard(rows: details, onCopy: onCopy),
        const SizedBox(height: 18),
        if (tx.txHash != null) ...[
          const _ExplorerButton(),
          const SizedBox(height: 12),
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
    return _Card(
      padding: const EdgeInsets.fromLTRB(20, 21, 20, 20),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: type.color.withValues(alpha: .13),
              borderRadius: AppRadii.cardRadius,
            ),
            alignment: Alignment.center,
            child: Icon(type.icon, color: AppColors.text1, size: 29),
          ),
          const SizedBox(height: 16),
          Text(
            type.label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontSize: 13,
              height: 1,
            ),
          ),
          const SizedBox(height: 21),
          Text(
            '${type.isDebit ? '-' : '+'}${_formatAmount(tx)} ${tx.asset}',
            textAlign: TextAlign.center,
            style: AppTextStyles.heroNumber.copyWith(
              color: type.color,
              fontSize: 26,
              fontWeight: FontWeight.w800,
              fontFamily: 'Roboto',
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1,
            ),
          ),
          const SizedBox(height: 21),
          Container(
            height: 34,
            padding: const EdgeInsets.symmetric(horizontal: 13),
            decoration: BoxDecoration(
              color: status.color.withValues(alpha: .12),
              borderRadius: AppRadii.cardRadius,
              border: Border.all(color: status.color.withValues(alpha: .28)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(status.icon, color: status.color, size: 15),
                const SizedBox(width: 6),
                Text(
                  status.label,
                  style: AppTextStyles.caption.copyWith(
                    color: status.color,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
              ],
            ),
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

    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tiến trình',
            style: AppTextStyles.body.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
          const SizedBox(height: 23),
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
            Container(
              width: 13,
              height: 13,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 36,
                margin: const EdgeInsets.symmetric(vertical: 4),
                color: step.done ? _detailGreen : AppColors.borderSolid,
              ),
          ],
        ),
        const SizedBox(width: 13),
        Padding(
          padding: EdgeInsets.only(bottom: isLast ? 0 : 17),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                step.label,
                style: AppTextStyles.caption.copyWith(
                  color: step.done || step.failed
                      ? AppColors.text1
                      : AppColors.text3,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
              if (step.time != null) ...[
                const SizedBox(height: 9),
                Text(
                  step.time!,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 12,
                    height: 1,
                  ),
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
    return _Card(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Text(
              'Thông tin chi tiết',
              style: AppTextStyles.body.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                height: 1,
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
    return Container(
      constraints: const BoxConstraints(minHeight: 44),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              row.label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontSize: 13,
                height: 1,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              row.value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontSize: 13,
                fontWeight: FontWeight.w800,
                fontFamily: 'Roboto',
                fontFeatures: AppTextStyles.tabularFigures,
                height: 1,
              ),
            ),
          ),
          if (row.copyable) ...[
            const SizedBox(width: 10),
            GestureDetector(
              key: TransactionDetailPage.copyTxIdKey,
              onTap: onCopy,
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: 27,
                height: 27,
                decoration: BoxDecoration(
                  color: AppColors.hoverBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.copy_rounded,
                  color: AppColors.text2,
                  size: 14,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ExplorerButton extends StatelessWidget {
  const _ExplorerButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: TransactionDetailPage.explorerKey,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _detailPanel2,
        border: Border.all(color: _detailPrimary.withValues(alpha: .28)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.open_in_new_rounded,
            color: _detailPrimary,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            'Xem trên Explorer',
            style: AppTextStyles.caption.copyWith(
              color: _detailPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
