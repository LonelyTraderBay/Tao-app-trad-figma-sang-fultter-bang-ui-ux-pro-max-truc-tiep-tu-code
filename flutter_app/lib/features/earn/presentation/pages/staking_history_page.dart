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
import 'package:vit_trade_flutter/features/earn/data/earn_repository.dart';

enum _HistoryTypeFilter { all, stake, unstake, claim, compound, penalty }

enum _HistoryStatusFilter { all, completed, pending, failed }

class StakingHistoryPage extends ConsumerStatefulWidget {
  const StakingHistoryPage({super.key, this.shellRenderMode});

  static const summaryKey = Key('sc360_summary_card');
  static const searchKey = Key('sc360_search_field');
  static const filterButtonKey = Key('sc360_filter_button');
  static const exportButtonKey = Key('sc360_export_button');
  static const filterPanelKey = Key('sc360_filter_panel');
  static const resultCountKey = Key('sc360_result_count');
  static const detailKey = Key('sc360_detail_card');
  static const firstTransactionKey = Key('sc360_first_transaction');

  static Key transactionKey(String id) => Key('sc360_transaction_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingHistoryPage> createState() => _StakingHistoryPageState();
}

class _StakingHistoryPageState extends ConsumerState<StakingHistoryPage> {
  final _searchController = TextEditingController();
  _HistoryTypeFilter _typeFilter = _HistoryTypeFilter.all;
  _HistoryStatusFilter _statusFilter = _HistoryStatusFilter.all;
  bool _showFilters = false;
  String _query = '';
  StakingHistoryTransactionDraft? _selected;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(stakingHistoryRepositoryProvider).getHistory();
    final transactions = _filteredTransactions(snapshot.transactions);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-360 StakingHistoryPage',
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
                    _SummaryCard(snapshot: snapshot),
                    _SearchAndActions(
                      controller: _searchController,
                      placeholder: snapshot.searchPlaceholder,
                      filtersActive:
                          _typeFilter != _HistoryTypeFilter.all ||
                          _statusFilter != _HistoryStatusFilter.all,
                      onQueryChanged: (query) {
                        setState(() => _query = query);
                      },
                      onFilter: () {
                        HapticFeedback.selectionClick();
                        setState(() => _showFilters = !_showFilters);
                      },
                      onExport: _export,
                    ),
                    if (_showFilters)
                      _FilterPanel(
                        key: StakingHistoryPage.filterPanelKey,
                        typeFilter: _typeFilter,
                        statusFilter: _statusFilter,
                        onTypeChanged: (filter) {
                          HapticFeedback.selectionClick();
                          setState(() => _typeFilter = filter);
                        },
                        onStatusChanged: (filter) {
                          HapticFeedback.selectionClick();
                          setState(() => _statusFilter = filter);
                        },
                        onClear: _clearFilters,
                      ),
                    _ResultsHeader(
                      count: transactions.length,
                      filtered:
                          transactions.length != snapshot.transactions.length ||
                          _query.isNotEmpty,
                      total: snapshot.transactions.length,
                      onClear: _clearFilters,
                    ),
                    if (_selected != null)
                      _TransactionDetailCard(
                        key: StakingHistoryPage.detailKey,
                        tx: _selected!,
                        onClose: () => setState(() => _selected = null),
                      ),
                    _TransactionList(
                      transactions: transactions,
                      onTap: (tx) {
                        HapticFeedback.selectionClick();
                        setState(() => _selected = tx);
                      },
                    ),
                    _FooterNote(note: snapshot.footerNote),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<StakingHistoryTransactionDraft> _filteredTransactions(
    List<StakingHistoryTransactionDraft> transactions,
  ) {
    final query = _query.trim().toLowerCase();
    return [
      for (final tx in transactions)
        if ((_typeFilter == _HistoryTypeFilter.all ||
                _typeFilter.name == tx.type.name) &&
            (_statusFilter == _HistoryStatusFilter.all ||
                _statusFilter.name == tx.status.name) &&
            (query.isEmpty ||
                tx.id.toLowerCase().contains(query) ||
                tx.asset.toLowerCase().contains(query) ||
                tx.product.toLowerCase().contains(query)))
          tx,
    ];
  }

  void _clearFilters() {
    HapticFeedback.selectionClick();
    _searchController.clear();
    setState(() {
      _query = '';
      _typeFilter = _HistoryTypeFilter.all;
      _statusFilter = _HistoryStatusFilter.all;
      _selected = null;
    });
  }

  void _export() {
    HapticFeedback.selectionClick();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Xuất lịch sử staking CSV sẽ sớm ra mắt')),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.snapshot});

  final StakingHistorySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingHistoryPage.summaryKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          Expanded(
            child: _SummaryMetric(
              label: 'Đã stake',
              value: _formatUsd(snapshot.totalStakedUsd),
              color: AppColors.buy,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: _SummaryMetric(
              label: 'Đã nhận',
              value: '+${_formatUsd(snapshot.totalEarnedUsd)}',
              color: AppColors.primarySoft,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: _SummaryMetric(
              label: 'Đã rút',
              value: _formatUsd(snapshot.totalUnstakedUsd),
              color: AppColors.warn,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x2),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: AppTextStyles.baseMedium.copyWith(
              color: color,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ),
      ],
    );
  }
}

class _SearchAndActions extends StatelessWidget {
  const _SearchAndActions({
    required this.controller,
    required this.placeholder,
    required this.filtersActive,
    required this.onQueryChanged,
    required this.onFilter,
    required this.onExport,
  });

  final TextEditingController controller;
  final String placeholder;
  final bool filtersActive;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onFilter;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.surface3,
              borderRadius: AppRadii.xlRadius,
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
              child: Row(
                children: [
                  const Icon(
                    Icons.search_rounded,
                    color: AppColors.text3,
                    size: 20,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: TextField(
                      key: StakingHistoryPage.searchKey,
                      controller: controller,
                      onChanged: onQueryChanged,
                      style: AppTextStyles.body,
                      decoration: InputDecoration(
                        hintText: placeholder,
                        hintStyle: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                          fontWeight: AppTextStyles.bold,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        _RoundIconButton(
          key: StakingHistoryPage.filterButtonKey,
          icon: Icons.filter_alt_outlined,
          active: filtersActive,
          onTap: onFilter,
        ),
        const SizedBox(width: AppSpacing.x2),
        _RoundIconButton(
          key: StakingHistoryPage.exportButtonKey,
          icon: Icons.file_download_outlined,
          onTap: onExport,
        ),
      ],
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.active = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: active ? AppColors.primary : AppColors.surface3,
      borderRadius: AppRadii.xlRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.xlRadius,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(
            icon,
            color: active ? Colors.white : AppColors.text1,
            size: 20,
          ),
        ),
      ),
    );
  }
}

class _FilterPanel extends StatelessWidget {
  const _FilterPanel({
    super.key,
    required this.typeFilter,
    required this.statusFilter,
    required this.onTypeChanged,
    required this.onStatusChanged,
    required this.onClear,
  });

  final _HistoryTypeFilter typeFilter;
  final _HistoryStatusFilter statusFilter;
  final ValueChanged<_HistoryTypeFilter> onTypeChanged;
  final ValueChanged<_HistoryStatusFilter> onStatusChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Bộ lọc',
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                  ),
                ),
              ),
              TextButton(onPressed: onClear, child: const Text('Xóa')),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          _FilterChips<_HistoryTypeFilter>(
            label: 'Loại giao dịch',
            active: typeFilter,
            values: _HistoryTypeFilter.values,
            labelFor: _typeFilterLabel,
            onChanged: onTypeChanged,
          ),
          const SizedBox(height: AppSpacing.x3),
          _FilterChips<_HistoryStatusFilter>(
            label: 'Trạng thái',
            active: statusFilter,
            values: _HistoryStatusFilter.values,
            labelFor: _statusFilterLabel,
            onChanged: onStatusChanged,
          ),
        ],
      ),
    );
  }
}

class _FilterChips<T> extends StatelessWidget {
  const _FilterChips({
    required this.label,
    required this.active,
    required this.values,
    required this.labelFor,
    required this.onChanged,
  });

  final String label;
  final T active;
  final List<T> values;
  final String Function(T value) labelFor;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.x2),
        Wrap(
          spacing: AppSpacing.x2,
          runSpacing: AppSpacing.x2,
          children: [
            for (final value in values)
              _FilterChip(
                label: labelFor(value),
                selected: value == active,
                onTap: () => onChanged(value),
              ),
          ],
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary12 : AppColors.surface2,
      borderRadius: AppRadii.smRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.smRadius,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color: selected ? AppColors.primary30 : AppColors.cardBorder,
            ),
            borderRadius: AppRadii.smRadius,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.x3,
              vertical: AppSpacing.x2,
            ),
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: selected ? AppColors.primary : AppColors.text2,
                fontWeight: AppTextStyles.medium,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ResultsHeader extends StatelessWidget {
  const _ResultsHeader({
    required this.count,
    required this.filtered,
    required this.total,
    required this.onClear,
  });

  final int count;
  final bool filtered;
  final int total;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            filtered
                ? '$count giao dịch (đã lọc từ $total)'
                : '$count giao dịch',
            key: StakingHistoryPage.resultCountKey,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
        ),
        if (filtered)
          TextButton(onPressed: onClear, child: const Text('Xóa bộ lọc')),
      ],
    );
  }
}

class _TransactionDetailCard extends StatelessWidget {
  const _TransactionDetailCard({
    super.key,
    required this.tx,
    required this.onClose,
  });

  final StakingHistoryTransactionDraft tx;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final color = _typeColor(tx.type);

    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _TypeIcon(type: tx.type),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _typeLabel(tx.type),
                      style: AppTextStyles.baseMedium.copyWith(color: color),
                    ),
                    Text(
                      tx.product,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onClose,
                icon: const Icon(Icons.close_rounded, color: AppColors.text2),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          _DetailRow(label: 'Số lượng', value: '${tx.amountLabel} ${tx.asset}'),
          _DetailRow(label: 'Giá trị USD', value: _formatUsd(tx.usdValue)),
          _DetailRow(label: 'Thời gian', value: '${tx.date} ${tx.time}'),
          _DetailRow(label: 'Trạng thái', value: _statusLabel(tx.status)),
          if (tx.txHash != null)
            _DetailRow(label: 'Tx Hash', value: tx.txHash!),
          if (tx.note != null) _DetailRow(label: 'Ghi chú', value: tx.note!),
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
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.x2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 88,
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionList extends StatelessWidget {
  const _TransactionList({required this.transactions, required this.onTap});

  final List<StakingHistoryTransactionDraft> transactions;
  final ValueChanged<StakingHistoryTransactionDraft> onTap;

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return const VitEmptyState(
        icon: Icons.history_rounded,
        title: 'Không tìm thấy giao dịch',
        message: 'Điều chỉnh bộ lọc hoặc từ khóa để xem lịch sử staking.',
      );
    }

    return Column(
      children: [
        for (var i = 0; i < transactions.length; i++) ...[
          _TransactionCard(
            key: i == 0
                ? StakingHistoryPage.firstTransactionKey
                : StakingHistoryPage.transactionKey(transactions[i].id),
            tx: transactions[i],
            onTap: () => onTap(transactions[i]),
          ),
          if (i != transactions.length - 1)
            const SizedBox(height: AppSpacing.x2),
        ],
      ],
    );
  }
}

class _TransactionCard extends StatelessWidget {
  const _TransactionCard({super.key, required this.tx, required this.onTap});

  final StakingHistoryTransactionDraft tx;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final amountColor = switch (tx.type) {
      StakingHistoryTransactionType.claim ||
      StakingHistoryTransactionType.compound ||
      StakingHistoryTransactionType.unstake => AppColors.buy,
      StakingHistoryTransactionType.penalty => AppColors.sell,
      StakingHistoryTransactionType.stake => AppColors.text1,
    };

    return VitCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        children: [
          _TypeIcon(type: tx.type),
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
                        style: AppTextStyles.baseMedium.copyWith(
                          color: AppColors.text1,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    _StatusPill(status: tx.status),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  '${tx.product} • ${tx.date} ${tx.time}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${tx.amountLabel} ${tx.asset}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: amountColor,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                _formatUsd(tx.usdValue),
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TypeIcon extends StatelessWidget {
  const _TypeIcon({required this.type});

  final StakingHistoryTransactionType type;

  @override
  Widget build(BuildContext context) {
    final color = _typeColor(type);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: AppRadii.lgRadius,
      ),
      child: SizedBox(
        width: 40,
        height: 40,
        child: Icon(_typeIcon(type), color: color, size: 20),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final StakingHistoryTransactionStatus status;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: AppRadii.smRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: 3,
        ),
        child: Text(
          _statusLabel(status),
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

class _FooterNote extends StatelessWidget {
  const _FooterNote({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Text(
        note,
        textAlign: TextAlign.center,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.text3,
          height: 1.5,
        ),
      ),
    );
  }
}

String _typeFilterLabel(_HistoryTypeFilter filter) {
  return switch (filter) {
    _HistoryTypeFilter.all => 'Tất cả',
    _HistoryTypeFilter.stake => 'Stake',
    _HistoryTypeFilter.unstake => 'Unstake',
    _HistoryTypeFilter.claim => 'Nhận lãi',
    _HistoryTypeFilter.compound => 'Tái đầu tư',
    _HistoryTypeFilter.penalty => 'Phí phạt',
  };
}

String _statusFilterLabel(_HistoryStatusFilter filter) {
  return switch (filter) {
    _HistoryStatusFilter.all => 'Tất cả',
    _HistoryStatusFilter.completed => 'Hoàn thành',
    _HistoryStatusFilter.pending => 'Đang xử lý',
    _HistoryStatusFilter.failed => 'Thất bại',
  };
}

String _typeLabel(StakingHistoryTransactionType type) {
  return switch (type) {
    StakingHistoryTransactionType.stake => 'Stake',
    StakingHistoryTransactionType.unstake => 'Unstake',
    StakingHistoryTransactionType.claim => 'Nhận lãi',
    StakingHistoryTransactionType.compound => 'Tái đầu tư',
    StakingHistoryTransactionType.penalty => 'Phí phạt',
  };
}

String _statusLabel(StakingHistoryTransactionStatus status) {
  return switch (status) {
    StakingHistoryTransactionStatus.completed => 'Hoàn thành',
    StakingHistoryTransactionStatus.pending => 'Đang xử lý',
    StakingHistoryTransactionStatus.failed => 'Thất bại',
  };
}

Color _typeColor(StakingHistoryTransactionType type) {
  return switch (type) {
    StakingHistoryTransactionType.stake => AppColors.buy,
    StakingHistoryTransactionType.unstake => AppColors.sell,
    StakingHistoryTransactionType.claim => AppColors.primarySoft,
    StakingHistoryTransactionType.compound => AppColors.accent,
    StakingHistoryTransactionType.penalty => AppColors.warn,
  };
}

Color _statusColor(StakingHistoryTransactionStatus status) {
  return switch (status) {
    StakingHistoryTransactionStatus.completed => AppColors.buy,
    StakingHistoryTransactionStatus.pending => AppColors.warn,
    StakingHistoryTransactionStatus.failed => AppColors.sell,
  };
}

IconData _typeIcon(StakingHistoryTransactionType type) {
  return switch (type) {
    StakingHistoryTransactionType.stake => Icons.arrow_outward_rounded,
    StakingHistoryTransactionType.unstake => Icons.south_east_rounded,
    StakingHistoryTransactionType.claim => Icons.attach_money_rounded,
    StakingHistoryTransactionType.compound => Icons.trending_up_rounded,
    StakingHistoryTransactionType.penalty => Icons.cancel_outlined,
  };
}

String _formatUsd(double value) {
  final fixed = value.toStringAsFixed(2);
  final parts = fixed.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final remaining = whole.length - i;
    buffer.write(whole[i]);
    if (remaining > 1 && remaining % 3 == 1) {
      buffer.write(',');
    }
  }
  return '\$${buffer.toString()}.${parts.last}';
}
