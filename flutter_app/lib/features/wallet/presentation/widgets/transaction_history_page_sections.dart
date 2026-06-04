part of '../pages/transaction_history_page.dart';

class _ExportBar extends StatelessWidget {
  const _ExportBar({required this.count, required this.onExport});

  final int count;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '$count giao dịch',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 11,
              height: 1,
            ),
          ),
        ),
        GestureDetector(
          key: TransactionHistoryPage.exportKey,
          onTap: onExport,
          behavior: HitTestBehavior.opaque,
          child: Container(
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 11),
            decoration: BoxDecoration(
              color: _historyPrimary.withValues(alpha: .14),
              borderRadius: AppRadii.mdRadius,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.cloud_download_outlined,
                  color: _historyPrimary,
                  size: 12,
                ),
                const SizedBox(width: 5),
                Text(
                  'Xuất CSV',
                  style: AppTextStyles.micro.copyWith(
                    color: _historyPrimary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FilterTabs extends StatelessWidget {
  const _FilterTabs({
    required this.filters,
    required this.active,
    required this.onChanged,
  });

  final List<WalletTransactionFilter> filters;
  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          for (var i = 0; i < filters.length; i++) ...[
            _FilterChip(
              filter: filters[i],
              active: filters[i].id == active,
              onTap: () => onChanged(filters[i].id),
            ),
            if (i != filters.length - 1) const SizedBox(width: 12),
          ],
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.filter,
    required this.active,
    required this.onTap,
  });

  final WalletTransactionFilter filter;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: TransactionHistoryPage.filterKey(filter.id),
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active
              ? _historyPrimary.withValues(alpha: .18)
              : AppColors.transparent,
          borderRadius: AppRadii.inputRadius,
          border: Border.all(
            color: active
                ? _historyPrimary.withValues(alpha: .48)
                : AppColors.transparent,
          ),
        ),
        child: Text(
          filter.label,
          style: AppTextStyles.micro.copyWith(
            color: active ? _historyPrimary : AppColors.text2,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            height: 1,
          ),
        ),
      ),
    );
  }
}

final class _TransactionDateGroup {
  const _TransactionDateGroup({required this.date, required this.transactions});

  final String date;
  final List<WalletTransaction> transactions;
}

class _TransactionGroup extends StatelessWidget {
  const _TransactionGroup({
    required this.group,
    required this.onTransactionTap,
  });

  final _TransactionDateGroup group;
  final ValueChanged<WalletTransaction> onTransactionTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 41,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 19),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.divider)),
          ),
          child: Text(
            _formatDate(group.date),
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
        ),
        for (final tx in group.transactions)
          _TransactionRow(tx: tx, onTap: () => onTransactionTap(tx)),
      ],
    );
  }
}

class _TransactionRow extends StatelessWidget {
  const _TransactionRow({required this.tx, required this.onTap});

  final WalletTransaction tx;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final meta = _TransactionMeta.from(tx);

    return GestureDetector(
      key: TransactionHistoryPage.transactionKey(tx.id),
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        constraints: const BoxConstraints(minHeight: 84),
        padding: const EdgeInsets.fromLTRB(17, 13, 16, 13),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.divider)),
        ),
        child: Row(
          children: [
            _TransactionIcon(meta: meta),
            const SizedBox(width: 56),
            Expanded(
              child: _TransactionInfo(tx: tx, meta: meta),
            ),
            const SizedBox(width: 8),
            _AmountStatus(tx: tx, meta: meta),
            const SizedBox(width: 9),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.text3,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionIcon extends StatelessWidget {
  const _TransactionIcon({required this.meta});

  final _TransactionMeta meta;

  @override
  Widget build(BuildContext context) {
    if (meta.isTrade) {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: meta.color.withValues(alpha: .12),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: _historyPrimary,
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Icon(
            Icons.currency_exchange_rounded,
            color: AppColors.onAccent,
            size: 14,
          ),
        ),
      );
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: meta.color.withValues(alpha: .12),
        shape: BoxShape.circle,
      ),
      child: Icon(meta.icon, color: AppColors.text1, size: 22),
    );
  }
}

class _TransactionInfo extends StatelessWidget {
  const _TransactionInfo({required this.tx, required this.meta});

  final WalletTransaction tx;
  final _TransactionMeta meta;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${meta.label} ${tx.asset}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.body.copyWith(
            color: AppColors.text1,
            fontSize: 15,
            fontWeight: FontWeight.w700,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _timePart(tx.createdAt),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 12,
            height: 1,
          ),
        ),
        if (tx.network != null) ...[
          const SizedBox(height: 5),
          Text(
            'Mạng: ${tx.network}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 11,
              height: 1,
            ),
          ),
        ],
        if (tx.txHash != null) ...[
          const SizedBox(height: 5),
          Text(
            tx.txHash!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: _historyPrimary,
              fontSize: 11,
              fontFamily: 'Roboto',
              height: 1,
            ),
          ),
        ],
      ],
    );
  }
}
