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
      child: VitCard(
        padding: AppSpacing.tradeBotCardPadding,
        borderColor: selected ? _taxPrimary : _taxOptionBorder,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CheckBox(selected: selected),
            const SizedBox(width: AppSpacing.x4),
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
                            fontWeight: AppTextStyles.bold,
                            height: AppSpacing.tradeBotLineHeightTight,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.tradeBotSmallGap),
                      _Pill(
                        text: report.format,
                        color: AppColors.text3,
                        background: _taxPanel2,
                      ),
                      if (report.recommended) ...[
                        const SizedBox(width: AppSpacing.tradeBotSmallGap),
                        const _Pill(
                          text: 'Recommended',
                          color: _taxGreen,
                          background: AppColors.buy12,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: AppSpacing.tradeBotRowGap),
                  Text(
                    report.description,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      height: AppSpacing.tradeBotLineHeightTight,
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
      padding: AppSpacing.tradeBotCardPaddingTall,
      child: Column(
        children: [
          _BreakdownRow(
            title: breakdown.shortTermLabel,
            description: breakdown.shortTermDescription,
            value: '+${_formatUsd(summary.shortTermGains)}',
          ),
          const SizedBox(height: AppSpacing.tradeBotContentGap),
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
                  height: AppSpacing.tradeBotLineHeightTight,
                ),
              ),
              const SizedBox(height: AppSpacing.tradeBotTinyGap),
              Text(
                description,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  height: AppSpacing.tradeBotLineHeightTight,
                ),
              ),
            ],
          ),
        ),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: _taxGreen,
            fontWeight: AppTextStyles.bold,
            height: AppSpacing.tradeBotLineHeightTight,
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
    return VitCard(
      variant: VitCardVariant.inner,
      padding: AppSpacing.tradeBotCardPaddingTall,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Important Tax Notes',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              height: AppSpacing.tradeBotLineHeightTight,
            ),
          ),
          const SizedBox(height: AppSpacing.tradeBotSectionMarkerHeight),
          for (final note in notes) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.circle,
                  color: AppColors.text3,
                  size: AppSpacing.x1,
                ),
                const SizedBox(width: AppSpacing.tradeBotRowGap),
                Expanded(
                  child: Text(
                    note,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      height: AppSpacing.tradeBotLineHeightReadable,
                    ),
                  ),
                ),
              ],
            ),
            if (note != notes.last) const SizedBox(height: AppSpacing.x4),
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
        ? DeviceMetrics.safeTop + AppSpacing.tradeBotFooterTopOffset
        : 0.0;
    final top =
        DeviceMetrics.height -
        DeviceMetrics.bottomChrome -
        AppSpacing.tradeBotControlHeight -
        topOffset;
    final child = VitCard(
      variant: VitCardVariant.ghost,
      padding: AppSpacing.tradeBotFooterPadding,
      borderColor: AppColors.borderSolid,
      child: GestureDetector(
        key: BotTaxReportingPage.generateKey,
        behavior: HitTestBehavior.opaque,
        onTap: disabled ? null : onPressed,
        child: VitCard(
          variant: disabled ? VitCardVariant.inner : VitCardVariant.hero,
          height: AppSpacing.tradeBotFooterButtonHeight,
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (generating)
                const SizedBox(
                  width: AppSpacing.tradeBotSelectionDot,
                  height: AppSpacing.tradeBotSelectionDot,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.onAccent,
                  ),
                )
              else
                Icon(
                  Icons.download_rounded,
                  color: disabled ? AppColors.text3 : AppColors.onAccent,
                  size: AppSpacing.iconSm,
                ),
              const SizedBox(width: AppSpacing.tradeBotSmallGap),
              Flexible(
                child: Text(
                  generating
                      ? 'Generating Reports...'
                      : 'Generate $selectedCount Report${selectedCount > 1 ? 's' : ''} for $selectedYear',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: disabled ? AppColors.text3 : AppColors.onAccent,
                    fontWeight: AppTextStyles.bold,
                    height: AppSpacing.tradeBotLineHeightTight,
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
