part of '../pages/transaction_history_page.dart';

class _ExportBar extends StatelessWidget {
  const _ExportBar({required this.count, required this.onExport});

  final int count;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.sm,
      padding: _historyExportPadding,
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$count giao dịch',
              style: AppTextStyles.badge.copyWith(color: AppColors.text3),
            ),
          ),
          VitStatusPill(
            key: TransactionHistoryPage.exportKey,
            label: 'Xuất CSV',
            icon: Icons.cloud_download_outlined,
            status: VitStatusPillStatus.info,
            size: VitStatusPillSize.md,
            onTap: onExport,
          ),
        ],
      ),
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
      physics: const ClampingScrollPhysics(),
      child: Row(
        children: [
          for (var i = 0; i < filters.length; i++) ...[
            _FilterChip(
              filter: filters[i],
              active: filters[i].id == active,
              onTap: () => onChanged(filters[i].id),
            ),
            if (i != filters.length - 1) const SizedBox(width: _historyTinyGap),
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
    return VitStatusPill(
      key: TransactionHistoryPage.filterKey(filter.id),
      label: filter.label,
      status: active ? VitStatusPillStatus.info : VitStatusPillStatus.neutral,
      size: VitStatusPillSize.md,
      outline: !active,
      onTap: onTap,
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
        SizedBox(
          height: _historySectionHeaderHeight,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: AppSpacing.zeroInsets.copyWith(left: _historyTinyGap),
              child: Text(
                _formatDate(group.date),
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ),
        ),
        const Divider(
          height: AppSpacing.walletHistoryDividerHeight,
          thickness: AppSpacing.walletHistoryDividerHeight,
          color: AppColors.divider,
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: _historyRowMinHeight),
            child: Padding(
              padding: _historyRowPadding,
              child: Row(
                children: [
                  _TransactionIcon(meta: meta),
                  const SizedBox(width: _historyInlineGap),
                  Expanded(
                    child: _TransactionInfo(tx: tx, meta: meta),
                  ),
                  const SizedBox(width: _historyTinyGap),
                  _AmountStatus(tx: tx, meta: meta),
                  const SizedBox(width: _historyTinyGap),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.text3,
                    size: AppSpacing.iconMd,
                  ),
                ],
              ),
            ),
          ),
          const Divider(
            height: AppSpacing.walletHistoryDividerHeight,
            thickness: AppSpacing.walletHistoryDividerHeight,
            color: AppColors.divider,
          ),
        ],
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
      return VitCard(
        variant: VitCardVariant.inner,
        radius: VitCardRadius.sm,
        width: _historyIconBox,
        height: _historyIconBox,
        alignment: Alignment.center,
        borderColor: meta.color.withValues(alpha: .22),
        child: const Icon(
          Icons.currency_exchange_rounded,
          color: _historyPrimary,
          size: AppSpacing.iconSm,
        ),
      );
    }

    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.sm,
      width: _historyIconBox,
      height: _historyIconBox,
      alignment: Alignment.center,
      borderColor: meta.color.withValues(alpha: .22),
      child: Icon(meta.icon, color: AppColors.text1, size: AppSpacing.iconSm),
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
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: _historyTinyGap),
        Text(
          _timePart(tx.createdAt),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        if (tx.network != null) ...[
          const SizedBox(height: _historyTinyGap),
          Text(
            'Mạng: ${tx.network}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
        if (tx.txHash != null) ...[
          const SizedBox(height: _historyTinyGap),
          Text(
            tx.txHash!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: _historyPrimary),
          ),
        ],
      ],
    );
  }
}
