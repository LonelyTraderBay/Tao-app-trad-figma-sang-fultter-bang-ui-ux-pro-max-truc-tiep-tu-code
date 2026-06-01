part of '../pages/staking_history_page.dart';

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
            color: active ? AppColors.onAccent : AppColors.text1,
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
