part of '../pages/bot_tax_reporting_page.dart';

class _ReportTypeCard extends StatelessWidget {
  const _ReportTypeCard({
    required this.report,
    required this.selected,
    required this.onTap,
  });

  final TradeBotTaxReportType report;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: BotTaxReportingPage.reportKey(report.id),
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        decoration: BoxDecoration(
          color: _taxPanel,
          border: Border.all(
            color: selected ? _taxPrimary : _taxOptionBorder,
            width: 2,
          ),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CheckBox(selected: selected),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          report.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            color: selected ? _taxPrimary : AppColors.text1,
                            fontSize: 13,
                            fontWeight: AppTextStyles.bold,
                            height: 1,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _Pill(
                        text: report.format,
                        color: AppColors.text3,
                        background: _taxPanel2,
                      ),
                      if (report.recommended) ...[
                        const SizedBox(width: 8),
                        const _Pill(
                          text: 'Recommended',
                          color: _taxGreen,
                          background: AppColors.buy12,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    report.description,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontSize: 11,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BreakdownCard extends StatelessWidget {
  const _BreakdownCard({required this.summary, required this.breakdown});

  final TradeBotTaxSummary summary;
  final TradeBotTaxBreakdown breakdown;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 18),
      child: Column(
        children: [
          _BreakdownRow(
            title: breakdown.shortTermLabel,
            description: breakdown.shortTermDescription,
            value: '+${_formatUsd(summary.shortTermGains)}',
          ),
          const SizedBox(height: 18),
          _BreakdownRow(
            title: breakdown.longTermLabel,
            description: breakdown.longTermDescription,
            value: '+${_formatUsd(summary.longTermGains)}',
          ),
        ],
      ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  const _BreakdownRow({
    required this.title,
    required this.description,
    required this.value,
  });

  final String title;
  final String description;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontSize: 12,
                  height: 1,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                description,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 10,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: _taxGreen,
            fontSize: 14,
            fontWeight: AppTextStyles.bold,
            fontFamily: 'Roboto',
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _TaxNotesCard extends StatelessWidget {
  const _TaxNotesCard({required this.notes});

  final List<String> notes;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      decoration: BoxDecoration(
        color: _taxPanel2,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Important Tax Notes',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontSize: 12,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
          const SizedBox(height: 15),
          for (final note in notes) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 3,
                  height: 3,
                  margin: const EdgeInsets.only(top: 7),
                  decoration: const BoxDecoration(
                    color: AppColors.text3,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    note,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontSize: 11,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
            if (note != notes.last) const SizedBox(height: 13),
          ],
        ],
      ),
    );
  }
}

class _GenerateFooter extends StatelessWidget {
  const _GenerateFooter({
    required this.visualMode,
    required this.disabled,
    required this.generating,
    required this.selectedCount,
    required this.selectedYear,
    required this.onPressed,
  });

  final bool visualMode;
  final bool disabled;
  final bool generating;
  final int selectedCount;
  final String selectedYear;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final mediaHeight = MediaQuery.sizeOf(context).height;
    final topOffset = mediaHeight <= DeviceMetrics.height + 1
        ? DeviceMetrics.safeTop + 10
        : 0.0;
    final top =
        DeviceMetrics.height - DeviceMetrics.bottomChrome - 46 - topOffset;
    final child = Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      color: _taxBackground.withValues(alpha: .96),
      child: GestureDetector(
        key: BotTaxReportingPage.generateKey,
        behavior: HitTestBehavior.opaque,
        onTap: disabled ? null : onPressed,
        child: Container(
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: disabled ? _taxPanel2 : _taxPrimary,
            borderRadius: AppRadii.inputRadius,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (generating)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.onAccent,
                  ),
                )
              else
                Icon(
                  Icons.download_rounded,
                  color: disabled ? AppColors.text3 : AppColors.onAccent,
                  size: 17,
                ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  generating
                      ? 'Generating Reports...'
                      : 'Generate $selectedCount Report${selectedCount > 1 ? 's' : ''} for $selectedYear',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: disabled ? AppColors.text3 : AppColors.onAccent,
                    fontSize: 14,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (visualMode) {
      return Positioned(left: 0, right: 0, top: top, child: child);
    }
    return Positioned(
      left: 0,
      right: 0,
      bottom:
          DeviceMetrics.nativeBottomChrome +
          MediaQuery.paddingOf(context).bottom,
      child: child,
    );
  }
}
