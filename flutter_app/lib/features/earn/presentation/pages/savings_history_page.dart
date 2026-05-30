import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_controller_providers.dart';

enum _HistoryTypeFilter { all, subscribe, redeem, interest, compound, early }

enum _HistoryDateFilter { d7, d30, d90, all }

class SavingsHistoryPage extends ConsumerStatefulWidget {
  const SavingsHistoryPage({super.key, this.shellRenderMode});

  static const firstTransactionKey = Key('sc334_first_transaction');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SavingsHistoryPage> createState() => _SavingsHistoryPageState();
}

class _SavingsHistoryPageState extends ConsumerState<SavingsHistoryPage> {
  _HistoryTypeFilter _typeFilter = _HistoryTypeFilter.all;
  _HistoryDateFilter _dateFilter = _HistoryDateFilter.all;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(savingsHistoryRepositoryProvider).getHistory();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;
    final transactions = _filteredTransactions(
      snapshot.transactions,
      _typeFilter,
    );
    final grouped = _groupTransactions(transactions);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-334 SavingsHistoryPage',
      child: Material(
        color: AppColors.bg,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: bottomInset),
                child: VitPageContent(
                  padding: VitContentPadding.compact,
                  gap: VitContentGap.defaultGap,
                  children: [
                    _SummaryPills(snapshot: snapshot),
                    _SearchField(placeholder: snapshot.searchPlaceholder),
                    _TypeFilterRow(
                      active: _typeFilter,
                      onChanged: (filter) {
                        HapticFeedback.selectionClick();
                        setState(() => _typeFilter = filter);
                      },
                    ),
                    _DateFilterRow(
                      active: _dateFilter,
                      onChanged: (filter) {
                        HapticFeedback.selectionClick();
                        setState(() => _dateFilter = filter);
                      },
                    ),
                    _ResultsHeader(count: transactions.length),
                    for (final group in grouped) ...[
                      _DateHeader(date: group.date),
                      for (final tx in group.transactions)
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: tx == group.transactions.last
                                ? AppSpacing.x4
                                : AppSpacing.x3,
                          ),
                          child: _TransactionCard(
                            key: tx == transactions.first
                                ? SavingsHistoryPage.firstTransactionKey
                                : null,
                            tx: tx,
                            receiptRoute: snapshot.receiptRoute,
                          ),
                        ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryPills extends StatelessWidget {
  const _SummaryPills({required this.snapshot});

  final SavingsHistorySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SummaryPill(
            label: 'Tổng gửi',
            value: snapshot.totalSubscribed,
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: _SummaryPill(
            label: 'Tổng lãi',
            value: snapshot.totalInterest,
            color: AppColors.accent,
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: _SummaryPill(
            label: 'Đã rút',
            value: snapshot.totalRedeemed,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

class _SummaryPill extends StatelessWidget {
  const _SummaryPill({
    required this.label,
    required this.value,
    this.color = AppColors.buy,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.xlRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x3,
          vertical: AppSpacing.x3,
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Text(
                label,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(width: AppSpacing.x1),
              Text(
                value,
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.placeholder});

  final String placeholder;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface3,
        borderRadius: AppRadii.xlRadius,
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x4,
          vertical: AppSpacing.x3,
        ),
        child: Row(
          children: [
            const Icon(
              Icons.search_rounded,
              color: AppColors.text3,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Text(
                placeholder,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text3,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypeFilterRow extends StatelessWidget {
  const _TypeFilterRow({required this.active, required this.onChanged});

  final _HistoryTypeFilter active;
  final ValueChanged<_HistoryTypeFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    const filters = [
      _HistoryTypeFilter.all,
      _HistoryTypeFilter.subscribe,
      _HistoryTypeFilter.redeem,
      _HistoryTypeFilter.interest,
      _HistoryTypeFilter.compound,
      _HistoryTypeFilter.early,
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          for (final filter in filters) ...[
            _Chip(
              label: _typeFilterLabel(filter),
              selected: filter == active,
              onTap: () => onChanged(filter),
            ),
            if (filter != filters.last) const SizedBox(width: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _DateFilterRow extends StatelessWidget {
  const _DateFilterRow({required this.active, required this.onChanged});

  final _HistoryDateFilter active;
  final ValueChanged<_HistoryDateFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    const filters = [
      _HistoryDateFilter.d7,
      _HistoryDateFilter.d30,
      _HistoryDateFilter.d90,
      _HistoryDateFilter.all,
    ];
    return Row(
      children: [
        for (final filter in filters) ...[
          Expanded(
            child: _Chip(
              label: _dateFilterLabel(filter),
              selected: filter == active,
              onTap: () => onChanged(filter),
              center: true,
            ),
          ),
          if (filter != filters.last) const SizedBox(width: AppSpacing.x2),
        ],
        const SizedBox(width: AppSpacing.x2),
        DecoratedBox(
          decoration: const BoxDecoration(
            color: AppColors.surface2,
            shape: BoxShape.circle,
          ),
          child: const SizedBox(
            width: 38,
            height: 38,
            child: Icon(
              Icons.filter_alt_outlined,
              color: AppColors.text3,
              size: AppSpacing.iconSm,
            ),
          ),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.center = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool center;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary12 : AppColors.surface2,
      borderRadius: AppRadii.xlRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.xlRadius,
        child: Container(
          alignment: center ? Alignment.center : null,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x4,
            vertical: AppSpacing.x2,
          ),
          decoration: BoxDecoration(
            borderRadius: AppRadii.xlRadius,
            border: Border.all(
              color: selected ? AppColors.primary30 : AppColors.cardBorder,
            ),
          ),
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: selected ? AppColors.primary : AppColors.text3,
              fontWeight: selected ? AppTextStyles.bold : AppTextStyles.normal,
            ),
          ),
        ),
      ),
    );
  }
}

class _ResultsHeader extends StatelessWidget {
  const _ResultsHeader({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$count giao dịch',
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
        const Spacer(),
        DecoratedBox(
          decoration: const BoxDecoration(
            color: AppColors.surface2,
            borderRadius: AppRadii.mdRadius,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.x3,
              vertical: AppSpacing.x1,
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.download_rounded,
                  color: AppColors.text3,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: AppSpacing.x1),
                Text(
                  'Xuất CSV',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DateHeader extends StatelessWidget {
  const _DateHeader({required this.date});

  final String date;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.calendar_month_outlined,
          color: AppColors.text3,
          size: AppSpacing.iconSm,
        ),
        const SizedBox(width: AppSpacing.x2),
        Text(
          date,
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
        const SizedBox(width: AppSpacing.x2),
        const Expanded(child: Divider(color: AppColors.divider, height: 1)),
      ],
    );
  }
}

class _TransactionCard extends StatelessWidget {
  const _TransactionCard({
    super.key,
    required this.tx,
    required this.receiptRoute,
  });

  final SavingsHistoryTransactionDraft tx;
  final String receiptRoute;

  @override
  Widget build(BuildContext context) {
    final typeColor = _typeColor(tx.type);
    final amountColor = _amountColor(tx.type);
    return VitCard(
      radius: VitCardRadius.lg,
      padding: EdgeInsets.zero,
      onTap: () {
        HapticFeedback.selectionClick();
        context.go(receiptRoute);
      },
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: typeColor.withValues(alpha: 0.16),
                borderRadius: AppRadii.mdRadius,
              ),
              child: SizedBox(
                width: AppSpacing.x6,
                height: AppSpacing.x6,
                child: Icon(_typeIcon(tx.type), color: typeColor, size: 18),
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          _typeLabel(tx.type),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                      if (tx.status == SavingsHistoryTransactionStatus.pending)
                        Padding(
                          padding: const EdgeInsets.only(left: AppSpacing.x2),
                          child: _StatusPill(
                            label: 'Đang xử lý',
                            color: AppColors.warn,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    '${tx.product} · ${tx.time}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  tx.amount,
                  style: AppTextStyles.caption.copyWith(
                    color: amountColor,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  tx.usdValue,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ),
    );
  }
}

final class _TransactionGroup {
  const _TransactionGroup({required this.date, required this.transactions});

  final String date;
  final List<SavingsHistoryTransactionDraft> transactions;
}

List<_TransactionGroup> _groupTransactions(
  List<SavingsHistoryTransactionDraft> transactions,
) {
  final groups = <String, List<SavingsHistoryTransactionDraft>>{};
  for (final tx in transactions) {
    groups.putIfAbsent(tx.date, () => []).add(tx);
  }
  return [
    for (final entry in groups.entries)
      _TransactionGroup(date: entry.key, transactions: entry.value),
  ];
}

List<SavingsHistoryTransactionDraft> _filteredTransactions(
  List<SavingsHistoryTransactionDraft> transactions,
  _HistoryTypeFilter filter,
) {
  return transactions.where((tx) {
    return switch (filter) {
      _HistoryTypeFilter.all => true,
      _HistoryTypeFilter.subscribe =>
        tx.type == SavingsHistoryTransactionType.subscribe,
      _HistoryTypeFilter.redeem =>
        tx.type == SavingsHistoryTransactionType.redeem,
      _HistoryTypeFilter.interest =>
        tx.type == SavingsHistoryTransactionType.interest,
      _HistoryTypeFilter.compound =>
        tx.type == SavingsHistoryTransactionType.compound,
      _HistoryTypeFilter.early =>
        tx.type == SavingsHistoryTransactionType.earlyRedeem,
    };
  }).toList();
}

String _typeFilterLabel(_HistoryTypeFilter filter) {
  return switch (filter) {
    _HistoryTypeFilter.all => 'Tất cả',
    _HistoryTypeFilter.subscribe => 'Gửi',
    _HistoryTypeFilter.redeem => 'Rút',
    _HistoryTypeFilter.interest => 'Lãi',
    _HistoryTypeFilter.compound => 'Tái ĐT',
    _HistoryTypeFilter.early => 'Rút sớm',
  };
}

String _dateFilterLabel(_HistoryDateFilter filter) {
  return switch (filter) {
    _HistoryDateFilter.d7 => '7N',
    _HistoryDateFilter.d30 => '30N',
    _HistoryDateFilter.d90 => '90N',
    _HistoryDateFilter.all => 'Tất cả',
  };
}

String _typeLabel(SavingsHistoryTransactionType type) {
  return switch (type) {
    SavingsHistoryTransactionType.subscribe => 'Gửi tiết kiệm',
    SavingsHistoryTransactionType.redeem => 'Rút tiết kiệm',
    SavingsHistoryTransactionType.interest => 'Nhận lãi',
    SavingsHistoryTransactionType.compound => 'Tái đầu tư',
    SavingsHistoryTransactionType.earlyRedeem => 'Rút sớm',
  };
}

IconData _typeIcon(SavingsHistoryTransactionType type) {
  return switch (type) {
    SavingsHistoryTransactionType.subscribe => Icons.arrow_downward_rounded,
    SavingsHistoryTransactionType.redeem => Icons.arrow_upward_rounded,
    SavingsHistoryTransactionType.interest => Icons.trending_up_rounded,
    SavingsHistoryTransactionType.compound => Icons.bolt_rounded,
    SavingsHistoryTransactionType.earlyRedeem => Icons.warning_amber_rounded,
  };
}

Color _typeColor(SavingsHistoryTransactionType type) {
  return switch (type) {
    SavingsHistoryTransactionType.subscribe => AppColors.buy,
    SavingsHistoryTransactionType.redeem => AppColors.primary,
    SavingsHistoryTransactionType.interest => AppColors.accent,
    SavingsHistoryTransactionType.compound => AppColors.primarySoft,
    SavingsHistoryTransactionType.earlyRedeem => AppColors.sell,
  };
}

Color _amountColor(SavingsHistoryTransactionType type) {
  return switch (type) {
    SavingsHistoryTransactionType.interest ||
    SavingsHistoryTransactionType.compound => AppColors.buy,
    SavingsHistoryTransactionType.earlyRedeem ||
    SavingsHistoryTransactionType.redeem => AppColors.sell,
    SavingsHistoryTransactionType.subscribe => AppColors.text1,
  };
}
