part of '../pages/price_alerts_page.dart';

class _AddAlertNotice extends StatelessWidget {
  const _AddAlertNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface3,
        borderRadius: AppRadii.mdRadius,
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Text(
        'T\u1EA1o c\u1EA3nh b\u00E1o m\u1EDBi s\u1EBD \u0111\u01B0\u1EE3c b\u1ED5 sung sau',
        style: AppTextStyles.caption.copyWith(color: AppColors.text1),
      ),
    );
  }
}

class _FilterTabs extends StatelessWidget {
  const _FilterTabs({
    required this.activeFilter,
    required this.onFilterSelected,
  });

  final _AlertFilter activeFilter;
  final ValueChanged<_AlertFilter> onFilterSelected;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 13, 20, 13),
        child: Row(
          children: [
            Expanded(
              flex: 8,
              child: _FilterTab(
                key: PriceAlertsPage.allFilterKey,
                label: 'Tất cả',
                active: activeFilter == _AlertFilter.all,
                onTap: () => onFilterSelected(_AlertFilter.all),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 15,
              child: _FilterTab(
                key: PriceAlertsPage.activeFilterKey,
                label: 'Đang hoạt động',
                active: activeFilter == _AlertFilter.active,
                onTap: () => onFilterSelected(_AlertFilter.active),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 14,
              child: _FilterTab(
                key: PriceAlertsPage.triggeredFilterKey,
                label: 'Đã kích hoạt',
                active: activeFilter == _AlertFilter.triggered,
                onTap: () => onFilterSelected(_AlertFilter.triggered),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterTab extends StatelessWidget {
  const _FilterTab({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active
              ? _marketPrimary.withValues(alpha: .16)
              : AppColors.surface,
          border: Border.all(
            color: active
                ? _marketPrimary.withValues(alpha: .48)
                : AppColors.transparent,
          ),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Text(
          label,
          style: AppTextStyles.captionSm.copyWith(
            color: active ? _marketPrimary : AppColors.text2,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _StatsSummary extends StatelessWidget {
  const _StatsSummary({
    required this.total,
    required this.active,
    required this.triggered,
  });

  final int total;
  final int active;
  final int triggered;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatBox(
            label: 'Tổng',
            value: '$total',
            valueKey: PriceAlertsPage.totalCountKey,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatBox(
            label: 'Hoạt động',
            value: '$active',
            valueColor: AppColors.buy,
            valueKey: PriceAlertsPage.activeCountKey,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatBox(
            label: 'Đã kích hoạt',
            value: '$triggered',
            valueColor: _marketPrimary,
            valueKey: PriceAlertsPage.triggeredCountKey,
          ),
        ),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
    this.valueKey,
  });

  final String label;
  final String value;
  final Color valueColor;
  final Key? valueKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.surface3,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: AppTextStyles.captionSm.copyWith(
              color: AppColors.text3,
              height: 1,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            value,
            key: valueKey,
            style: AppTextStyles.sectionTitle.copyWith(
              color: valueColor,
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
