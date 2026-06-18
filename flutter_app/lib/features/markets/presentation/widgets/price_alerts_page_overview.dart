part of '../pages/price_alerts_page.dart';

class _AddAlertNotice extends StatelessWidget {
  const _AddAlertNotice();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: AppColors.surface3,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: AppColors.cardBorder),
          borderRadius: AppRadii.mdRadius,
        ),
        child: Padding(
          padding: AppSpacing.priceAlertsNoticePadding,
          child: Text(
            'T\u1EA1o c\u1EA3nh b\u00E1o m\u1EDBi s\u1EBD \u0111\u01B0\u1EE3c b\u1ED5 sung sau',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              height: AppSpacing.marketLineHeightCaption,
            ),
          ),
        ),
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
    return Material(
      color: AppColors.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: AppSpacing.priceAlertsFilterHeaderPadding,
            child: Row(
              children: [
                Expanded(
                  flex: 8,
                  child: _FilterTab(
                    key: PriceAlertsPage.allFilterKey,
                    label: 'T\u1EA5t c\u1EA3',
                    active: activeFilter == _AlertFilter.all,
                    onTap: () => onFilterSelected(_AlertFilter.all),
                  ),
                ),
                const SizedBox(width: AppSpacing.priceAlertsFilterGap),
                Expanded(
                  flex: 15,
                  child: _FilterTab(
                    key: PriceAlertsPage.activeFilterKey,
                    label: '\u0110ang ho\u1EA1t \u0111\u1ED9ng',
                    active: activeFilter == _AlertFilter.active,
                    onTap: () => onFilterSelected(_AlertFilter.active),
                  ),
                ),
                const SizedBox(width: AppSpacing.priceAlertsFilterGap),
                Expanded(
                  flex: 14,
                  child: _FilterTab(
                    key: PriceAlertsPage.triggeredFilterKey,
                    label: '\u0110\u00E3 k\u00EDch ho\u1EA1t',
                    active: activeFilter == _AlertFilter.triggered,
                    onTap: () => onFilterSelected(_AlertFilter.triggered),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            height: AppSpacing.hairlineStroke,
            thickness: AppSpacing.hairlineStroke,
            color: AppColors.divider,
          ),
        ],
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
    final color = active
        ? _marketPrimary.withValues(alpha: .16)
        : AppColors.surface;
    final borderColor = active
        ? _marketPrimary.withValues(alpha: .48)
        : AppColors.transparent;
    return Material(
      color: color,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: borderColor),
        borderRadius: AppRadii.cardRadius,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.cardRadius,
        child: SizedBox(
          height: AppSpacing.priceAlertsFilterHeight,
          child: Padding(
            padding: AppSpacing.priceAlertsFilterTabPadding,
            child: Center(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.captionSm.copyWith(
                  color: active ? _marketPrimary : AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                  height: AppSpacing.marketLineHeightTight,
                ),
              ),
            ),
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
            label: 'T\u1ED5ng',
            value: '$total',
            valueKey: PriceAlertsPage.totalCountKey,
          ),
        ),
        const SizedBox(width: AppSpacing.priceAlertsStatGap),
        Expanded(
          child: _StatBox(
            label: 'Ho\u1EA1t \u0111\u1ED9ng',
            value: '$active',
            valueColor: AppColors.buy,
            valueKey: PriceAlertsPage.activeCountKey,
          ),
        ),
        const SizedBox(width: AppSpacing.priceAlertsStatGap),
        Expanded(
          child: _StatBox(
            label: '\u0110\u00E3 k\u00EDch ho\u1EA1t',
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
    return Material(
      color: AppColors.surface3,
      borderRadius: AppRadii.cardRadius,
      child: SizedBox(
        height: AppSpacing.priceAlertsStatHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: AppTextStyles.captionSm.copyWith(
                color: AppColors.text3,
                height: AppSpacing.marketLineHeightTight,
              ),
            ),
            const SizedBox(height: AppSpacing.priceAlertsStatLabelGap),
            Text(
              value,
              key: valueKey,
              style: AppTextStyles.sectionTitle.copyWith(
                color: valueColor,
                fontFeatures: AppTextStyles.tabularFigures,
                height: AppSpacing.marketLineHeightTight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
