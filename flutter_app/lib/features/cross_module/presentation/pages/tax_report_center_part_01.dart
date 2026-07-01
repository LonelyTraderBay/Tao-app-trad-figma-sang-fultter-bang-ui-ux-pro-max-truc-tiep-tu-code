part of 'tax_report_center.dart';

class _TaxReportCenterState extends ConsumerState<TaxReportCenter> {
  TaxReportTab _activeTab = TaxReportTab.generate;
  TaxExportFormat _format = TaxExportFormat.pdf;
  String _jurisdictionId = 'us';
  String _startDate = '01/01/2024';
  String _endDate = '12/31/2024';
  bool _includeArena = false;
  bool _exportQueued = false;

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(taxReportControllerProvider);
    final snapshot = controller.state.snapshot;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndClearance =
        (mode.usesVisualQaFrame
            ? AppSpacing.x7 + AppSpacing.x6
            : AppSpacing.x7) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-324 TaxReportCenter',
      child: Material(
        color: AppColors.bg,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: snapshot.title,
            showBack: true,
            onBack: () => context.go(snapshot.backRoute),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _TaxTabs(
                tabs: snapshot.tabs,
                active: _activeTab,
                onChanged: (tab) {
                  HapticFeedback.selectionClick();
                  setState(() => _activeTab = tab);
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  key: TaxReportCenter.contentKey,
                  physics: const ClampingScrollPhysics(),
                  padding: AppSpacing.crossModuleScrollPadding(
                    scrollEndClearance,
                  ),
                  child: VitPageContent(
                    gap: VitContentGap.tight,
                    children: [
                      if (_activeTab == TaxReportTab.generate)
                        _GenerateTaxReportTab(
                          snapshot: snapshot,
                          startDate: _startDate,
                          endDate: _endDate,
                          format: _format,
                          jurisdictionId: _jurisdictionId,
                          exportQueued: _exportQueued,
                          onPresetSelected: (start, end) {
                            HapticFeedback.selectionClick();
                            setState(() {
                              _startDate = start;
                              _endDate = end;
                            });
                          },
                          onFormatChanged: (format) {
                            HapticFeedback.selectionClick();
                            setState(() => _format = format);
                          },
                          onJurisdictionChanged: (id) {
                            HapticFeedback.selectionClick();
                            setState(() => _jurisdictionId = id);
                          },
                          onGenerate: () {
                            HapticFeedback.mediumImpact();
                            setState(() => _exportQueued = true);
                          },
                        )
                      else if (_activeTab == TaxReportTab.reports)
                        _ReportsTab(snapshot: snapshot)
                      else
                        _TaxSettingsTab(
                          includeArena: _includeArena,
                          onToggleArena: () {
                            HapticFeedback.selectionClick();
                            setState(() => _includeArena = !_includeArena);
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TaxTabs extends StatelessWidget {
  const _TaxTabs({
    required this.tabs,
    required this.active,
    required this.onChanged,
  });

  final List<TaxReportTabDraft> tabs;
  final TaxReportTab active;
  final ValueChanged<TaxReportTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: AppSpacing.crossModuleTabBarPadding,
            child: Row(
              children: [
                for (final tab in tabs)
                  Expanded(
                    child: VitCard(
                      key: TaxReportCenter.tabKey(tab.tab),
                      onTap: () => onChanged(tab.tab),
                      variant: VitCardVariant.ghost,
                      radius: VitCardRadius.standard,
                      padding: EdgeInsets.zero,
                      borderColor: AppColors.transparent,
                      child: Column(
                        children: [
                          Padding(
                            padding: AppSpacing.crossModuleTabLabelPadding,
                            child: Text(
                              tab.label,
                              style: AppTextStyles.caption.copyWith(
                                color: tab.tab == active
                                    ? AppColors.primary
                                    : AppColors.text3,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: AppSpacing.buttonHero,
                            height: AppSpacing.x1,
                            child: TweenAnimationBuilder<double>(
                              tween: Tween<double>(
                                end: tab.tab == active ? 1 : 0,
                              ),
                              duration: const Duration(milliseconds: 160),
                              builder: (context, value, child) =>
                                  Transform.scale(scaleX: value, child: child),
                              child: const DecoratedBox(
                                decoration: ShapeDecoration(
                                  color: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: AppRadii.xlRadius,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(
            height: AppSpacing.dividerHairline,
            child: ColoredBox(color: AppColors.divider),
          ),
        ],
      ),
    );
  }
}

class _GenerateTaxReportTab extends StatelessWidget {
  const _GenerateTaxReportTab({
    required this.snapshot,
    required this.startDate,
    required this.endDate,
    required this.format,
    required this.jurisdictionId,
    required this.exportQueued,
    required this.onPresetSelected,
    required this.onFormatChanged,
    required this.onJurisdictionChanged,
    required this.onGenerate,
  });

  final TaxReportSnapshot snapshot;
  final String startDate;
  final String endDate;
  final TaxExportFormat format;
  final String jurisdictionId;
  final bool exportQueued;
  final void Function(String startDate, String endDate) onPresetSelected;
  final ValueChanged<TaxExportFormat> onFormatChanged;
  final ValueChanged<String> onJurisdictionChanged;
  final VoidCallback onGenerate;

  @override
  Widget build(BuildContext context) {
    final jurisdiction = snapshot.jurisdictions.firstWhere(
      (item) => item.id == jurisdictionId,
      orElse: () => snapshot.jurisdictions.first,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _TaxSummaryCard(snapshot: snapshot),
        const SizedBox(height: AppSpacing.sectionGap),
        _TaxPeriodCard(
          startDate: startDate,
          endDate: endDate,
          onPresetSelected: onPresetSelected,
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        VitPageSection(
          label: 'Module Breakdown',
          children: [
            for (final activity in snapshot.activities)
              _TaxActivityCard(activity: activity),
          ],
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        _ExportFormatCard(selected: format, onChanged: onFormatChanged),
        const SizedBox(height: AppSpacing.sectionGap),
        _JurisdictionCard(
          jurisdiction: jurisdiction,
          jurisdictions: snapshot.jurisdictions,
          onChanged: onJurisdictionChanged,
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        _GenerateReportButton(
          format: format,
          queued: exportQueued,
          onTap: onGenerate,
        ),
        if (exportQueued) ...[
          const SizedBox(height: AppSpacing.x3),
          const _InfoPanel(
            icon: Icons.check_circle_outline_rounded,
            color: AppColors.buy,
            background: AppColors.buy10,
            border: AppColors.buy20,
            text:
                'Export request queued locally. Production wiring will post to /exports with the selected period and format.',
          ),
        ],
        const SizedBox(height: AppSpacing.x4),
        const _InfoPanel(
          icon: Icons.warning_amber_rounded,
          color: AppColors.warn,
          background: AppColors.warn08,
          border: AppColors.warn15,
          text:
              'Tax reports are for reference only. Consult a tax professional for accurate filing. We are not tax advisors.',
        ),
      ],
    );
  }
}

class _TaxSummaryCard extends StatelessWidget {
  const _TaxSummaryCard({required this.snapshot});

  final TaxReportSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.crossModuleCardPadding,
      radius: VitCardRadius.large,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _IconBadge(
                icon: Icons.description_outlined,
                color: AppColors.buy,
                background: AppColors.buy10,
                size: AppSpacing.inputHeight,
                iconSize: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tax Summary',
                      style: AppTextStyles.baseMedium.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      'All taxable activities',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          Row(
            children: [
              Expanded(
                child: _MetricBlock(
                  label: 'Total Gain/Loss',
                  value: _formatMoney(snapshot.totalGainLoss),
                  valueColor: AppColors.buy,
                ),
              ),
              Expanded(
                child: _MetricBlock(
                  label: 'Transactions',
                  value: _formatInteger(snapshot.totalTransactions),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _MetricBlock(
                  label: 'Taxable Modules',
                  value: '${snapshot.taxableModules}',
                  compact: true,
                ),
              ),
              Expanded(
                child: _MetricBlock(
                  label: 'Reports Generated',
                  value: '${snapshot.reports.length}',
                  compact: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricBlock extends StatelessWidget {
  const _MetricBlock({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
    this.compact = false,
  });

  final String label;
  final String value;
  final Color valueColor;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          value,
          style:
              (compact ? AppTextStyles.baseMedium : AppTextStyles.sectionTitle)
                  .copyWith(
                    color: valueColor,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
        ),
      ],
    );
  }
}

class _TaxPeriodCard extends StatelessWidget {
  const _TaxPeriodCard({
    required this.startDate,
    required this.endDate,
    required this.onPresetSelected,
  });

  final String startDate;
  final String endDate;
  final void Function(String startDate, String endDate) onPresetSelected;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.crossModuleCardPadding,
      radius: VitCardRadius.large,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tax Period',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _DateField(label: 'Start Date', value: startDate),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: _DateField(label: 'End Date', value: endDate),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              _PresetButton(
                label: '2024',
                onTap: () => onPresetSelected('01/01/2024', '12/31/2024'),
              ),
              const SizedBox(width: AppSpacing.x3),
              _PresetButton(
                label: 'Q4 2024',
                onTap: () => onPresetSelected('10/01/2024', '12/31/2024'),
              ),
              const SizedBox(width: AppSpacing.x3),
              _PresetButton(
                label: 'YTD',
                onTap: () => onPresetSelected('01/01/2024', '05/25/2026'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.x2),
        DecoratedBox(
          decoration: const ShapeDecoration(
            color: AppColors.bg,
            shape: RoundedRectangleBorder(borderRadius: AppRadii.xlRadius),
          ),
          child: Padding(
            padding: AppSpacing.crossModuleSelectorPadding,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                const Icon(
                  Icons.calendar_today_outlined,
                  size: AppSpacing.iconSm,
                  color: AppColors.text3,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
