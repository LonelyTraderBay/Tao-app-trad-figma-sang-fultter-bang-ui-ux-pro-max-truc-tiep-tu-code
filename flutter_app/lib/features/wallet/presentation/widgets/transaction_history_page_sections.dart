part of '../pages/transaction_history_page.dart';

class _ExportBar extends StatelessWidget {
  const _ExportBar({required this.count, required this.onExport});

  final int count;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      density: VitDensity.compact,
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
            label: 'Yêu cầu CSV',
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

class _ExportNotice extends StatelessWidget {
  const _ExportNotice({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      density: VitDensity.compact,
      borderColor: AppColors.primary20,
      child: Row(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: _historyPrimary,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
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
    return VitTabBar(
      tabs: [
        for (final filter in filters)
          VitTabItem(
            key: filter.id,
            label: filter.label,
            widgetKey: TransactionHistoryPage.filterKey(filter.id),
          ),
      ],
      activeKey: active,
      onChanged: onChanged,
      variant: VitTabBarVariant.pill,
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
        VitSectionHeader(
          title: _formatDate(group.date),
          icon: Icons.calendar_today_outlined,
          iconColor: AppColors.text2,
          density: VitDensity.compact,
        ),
        const SizedBox(height: AppSpacing.x1),
        for (final tx in group.transactions)
          _TransactionRow(tx: tx, onTap: () => onTransactionTap(tx)),
        const SizedBox(height: AppSpacing.x2),
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

    return VitCard(
      key: TransactionHistoryPage.transactionKey(tx.id),
      onTap: onTap,
      variant: VitCardVariant.ghost,
      density: VitDensity.compact,
      constraints: const BoxConstraints(
        minHeight: AppSpacing.walletHistoryItemMinHeight,
      ),
      borderColor: AppColors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _TransactionIcon(meta: meta),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _TransactionInfo(tx: tx, meta: meta),
              ),
              const SizedBox(width: AppSpacing.x2),
              _AmountStatus(tx: tx, meta: meta),
              const SizedBox(width: AppSpacing.x2),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.text3,
                size: AppSpacing.iconMd,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
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
        radius: VitCardRadius.standard,
        width: AppSpacing.buttonCompact,
        height: AppSpacing.buttonCompact,
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
      radius: VitCardRadius.standard,
      width: AppSpacing.buttonCompact,
      height: AppSpacing.buttonCompact,
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
        const SizedBox(height: AppSpacing.walletHistoryLineSpacing),
        Text(
          _timePart(tx.createdAt),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        if (tx.network != null) ...[
          const SizedBox(height: AppSpacing.walletHistoryLineSpacing),
          Text(
            'Mạng: ${tx.network}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
        if (tx.txHash != null) ...[
          const SizedBox(height: AppSpacing.walletHistoryLineSpacing),
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
