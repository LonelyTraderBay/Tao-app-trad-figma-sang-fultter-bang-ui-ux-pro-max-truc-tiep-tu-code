part of '../pages/trade_history_export_page.dart';

class _FormatSelector extends StatelessWidget {
  const _FormatSelector({
    required this.formats,
    required this.activeFormat,
    required this.onChanged,
  });

  final List<TradeExportFormat> formats;
  final String activeFormat;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < formats.length; i++) ...[
          Expanded(
            child: _FormatCard(
              key: TradeHistoryExportPage.formatKey(formats[i].id),
              format: formats[i],
              active: activeFormat == formats[i].id,
              onTap: () => onChanged(formats[i].id),
            ),
          ),
          if (i < formats.length - 1) const SizedBox(width: 12),
        ],
      ],
    );
  }
}

class _FormatCard extends StatelessWidget {
  const _FormatCard({
    super.key,
    required this.format,
    required this.active,
    required this.onTap,
  });

  final TradeExportFormat format;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? _tradePrimary : AppColors.textSoftLight;
    final icon = format.id == 'csv'
        ? Icons.table_chart_outlined
        : Icons.description_outlined;

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        height: 110,
        padding: const EdgeInsets.fromLTRB(12, 16, 12, 14),
        decoration: BoxDecoration(
          color: active
              ? _tradePrimary.withValues(alpha: .12)
              : _inactiveFormatBackground,
          border: Border.all(
            color: active
                ? _tradePrimary.withValues(alpha: .7)
                : AppColors.onAccent.withValues(alpha: .12),
            width: active ? 1.2 : 1,
          ),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 12),
            Text(
              format.label,
              style: AppTextStyles.body.copyWith(
                color: active ? _tradePrimary : AppColors.text1,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              format.description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.navLabel.copyWith(
                color: AppColors.text3,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PeriodSelector extends StatelessWidget {
  const _PeriodSelector({
    required this.periods,
    required this.activePeriod,
    required this.onChanged,
  });

  final List<TradeExportPeriod> periods;
  final String activePeriod;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final period in periods)
          _PeriodChip(
            key: TradeHistoryExportPage.periodKey(period.id),
            period: period,
            active: activePeriod == period.id,
            onTap: () => onChanged(period.id),
          ),
      ],
    );
  }
}

class _PeriodChip extends StatelessWidget {
  const _PeriodChip({
    super.key,
    required this.period,
    required this.active,
    required this.onTap,
  });

  final TradeExportPeriod period;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: active
              ? _tradePrimary.withValues(alpha: .14)
              : _chipBackground,
          border: Border.all(
            color: active
                ? _tradePrimary.withValues(alpha: .8)
                : AppColors.onAccent.withValues(alpha: .12),
          ),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 17),
          child: SizedBox(
            height: 36,
            child: Center(
              widthFactor: 1,
              child: Text(
                period.label,
                style: AppTextStyles.caption.copyWith(
                  color: active ? _tradePrimary : AppColors.text2,
                  fontWeight: active
                      ? AppTextStyles.bold
                      : AppTextStyles.medium,
                  height: 1,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IncludeList extends StatelessWidget {
  const _IncludeList({required this.includes, required this.onToggle});

  final List<TradeExportInclude> includes;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _cardBackground,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        children: [
          for (var i = 0; i < includes.length; i++)
            _IncludeRow(
              key: TradeHistoryExportPage.includeKey(includes[i].id),
              include: includes[i],
              isLast: i == includes.length - 1,
              onTap: () => onToggle(includes[i].id),
            ),
        ],
      ),
    );
  }
}

class _IncludeRow extends StatelessWidget {
  const _IncludeRow({
    super.key,
    required this.include,
    required this.isLast,
    required this.onTap,
  });

  final TradeExportInclude include;
  final bool isLast;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 41,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isLast ? AppColors.transparent : AppColors.divider,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                include.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.medium,
                  height: 1,
                ),
              ),
            ),
            _CheckBox(checked: include.checked),
          ],
        ),
      ),
    );
  }
}

class _CheckBox extends StatelessWidget {
  const _CheckBox({required this.checked});

  final bool checked;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: checked ? AppColors.buy : AppColors.transparent,
        border: Border.all(
          color: checked ? AppColors.buy : AppColors.borderSolid,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: checked
          ? const Icon(
              Icons.check_circle_outline,
              color: AppColors.onAccent,
              size: 14,
            )
          : null,
    );
  }
}
