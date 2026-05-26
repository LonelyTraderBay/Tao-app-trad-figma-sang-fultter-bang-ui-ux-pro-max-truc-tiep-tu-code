import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';

const _taxBackground = AppColors.bg;
const _taxPanel = AppColors.surface;
const _taxPanel2 = AppColors.surface2;
const _taxPrimary = AppColors.primary;
const _taxGreen = Color(0xFF10B981);
const _taxAmber = Color(0xFFF59E0B);
const _taxRed = Color(0xFFEF4444);
const _taxOptionBorder = Color(0xFF314166);

class BotTaxReportingPage extends ConsumerStatefulWidget {
  const BotTaxReportingPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc133_bot_tax_reporting_content');
  static const generateKey = Key('sc133_bot_tax_reporting_generate');
  static Key yearKey(String year) => Key('sc133_bot_tax_year_$year');
  static Key methodKey(String method) => Key('sc133_bot_tax_method_$method');
  static Key reportKey(String reportId) =>
      Key('sc133_bot_tax_report_$reportId');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<BotTaxReportingPage> createState() =>
      _BotTaxReportingPageState();
}

class _BotTaxReportingPageState extends ConsumerState<BotTaxReportingPage> {
  late String _selectedYear;
  late String _costBasisMethod;
  late Set<String> _selectedReportIds;
  bool _generating = false;

  @override
  void initState() {
    super.initState();
    final snapshot = ref.read(tradeRepositoryProvider).getBotTaxReporting();
    _selectedYear = snapshot.defaultYear;
    _costBasisMethod = snapshot.defaultCostBasisMethod;
    _selectedReportIds = {
      for (final report in snapshot.reportTypes)
        if (report.selectedByDefault) report.id,
    };
  }

  @override
  Widget build(BuildContext context) {
    final repository = ref.watch(tradeRepositoryProvider);
    final snapshot = repository.getBotTaxReporting();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 128
            : DeviceMetrics.nativeBottomChrome + 96) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-133 BotTaxReportingPage',
      child: Material(
        color: _taxBackground,
        child: Stack(
          children: [
            Column(
              children: [
                VitHeader(
                  title: 'Tax Reporting',
                  showBack: true,
                  onBack: () => context.go(AppRoutePaths.tradeBots),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    key: BotTaxReportingPage.contentKey,
                    padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const _TaxNotice(),
                        const SizedBox(height: 31),
                        const _SectionLabel('Select Tax Year'),
                        const SizedBox(height: 10),
                        _YearPicker(
                          years: snapshot.taxYears,
                          selectedYear: _selectedYear,
                          onChanged: (year) {
                            setState(() => _selectedYear = year);
                          },
                        ),
                        const SizedBox(height: 18),
                        _SectionLabel('Summary for $_selectedYear'),
                        const SizedBox(height: 10),
                        _SummaryCard(summary: snapshot.summary),
                        const SizedBox(height: 18),
                        const _SectionLabel('Cost Basis Method'),
                        const SizedBox(height: 10),
                        _CostBasisPicker(
                          selectedMethod: _costBasisMethod,
                          onChanged: (method) {
                            setState(() => _costBasisMethod = method);
                          },
                        ),
                        const SizedBox(height: 18),
                        const _SectionLabel('Select Report Types'),
                        const SizedBox(height: 10),
                        for (final report in snapshot.reportTypes) ...[
                          _ReportTypeCard(
                            report: report,
                            selected: _selectedReportIds.contains(report.id),
                            onTap: () => _toggleReport(report.id),
                          ),
                          if (report != snapshot.reportTypes.last)
                            const SizedBox(height: 10),
                        ],
                        const SizedBox(height: 18),
                        const _SectionLabel('Capital Gains Breakdown'),
                        const SizedBox(height: 10),
                        _BreakdownCard(
                          summary: snapshot.summary,
                          breakdown: snapshot.breakdown,
                        ),
                        const SizedBox(height: 17),
                        _TaxNotesCard(notes: snapshot.taxNotes),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            _GenerateFooter(
              visualMode: mode.usesVisualQaFrame,
              disabled: _selectedReportIds.isEmpty || _generating,
              generating: _generating,
              selectedCount: _selectedReportIds.length,
              selectedYear: _selectedYear,
              onPressed: () => _generate(repository),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleReport(String id) {
    setState(() {
      if (_selectedReportIds.contains(id)) {
        _selectedReportIds.remove(id);
      } else {
        _selectedReportIds.add(id);
      }
    });
  }

  void _generate(TradeRepository repository) {
    if (_selectedReportIds.isEmpty || _generating) return;
    setState(() => _generating = true);
    repository.createBotTaxReportExport(
      TradeBotTaxReportExportRequest(
        year: _selectedYear,
        reportTypeIds: _selectedReportIds.toList(growable: false),
        costBasisMethod: _costBasisMethod,
      ),
    );
    setState(() => _generating = false);
  }
}

class _TaxNotice extends StatelessWidget {
  const _TaxNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 16),
      decoration: BoxDecoration(
        color: _taxAmber.withValues(alpha: .10),
        border: Border.all(color: _taxAmber.withValues(alpha: .30)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 1),
            child: Icon(
              Icons.warning_amber_rounded,
              color: _taxAmber,
              size: 21,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tax Reporting Notice',
                  style: AppTextStyles.caption.copyWith(
                    color: _taxAmber,
                    fontSize: 13,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Cryptocurrency trading is taxable in most countries. Bot '
                  'trades are treated as individual transactions. We provide '
                  'reports for convenience, but you should consult a tax '
                  'professional for accurate filing.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontSize: 11,
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _YearPicker extends StatelessWidget {
  const _YearPicker({
    required this.years,
    required this.selectedYear,
    required this.onChanged,
  });

  final List<String> years;
  final String selectedYear;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < years.length; i++) ...[
          Expanded(
            child: GestureDetector(
              key: BotTaxReportingPage.yearKey(years[i]),
              behavior: HitTestBehavior.opaque,
              onTap: () => onChanged(years[i]),
              child: Container(
                height: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selectedYear == years[i]
                      ? _taxPrimary
                      : _taxBackground,
                  border: Border.all(
                    color: selectedYear == years[i]
                        ? _taxPrimary
                        : _taxOptionBorder,
                  ),
                  borderRadius: AppRadii.cardRadius,
                ),
                child: Text(
                  years[i],
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 13,
                    fontWeight: AppTextStyles.bold,
                    fontFamily: 'Roboto',
                    height: 1,
                  ),
                ),
              ),
            ),
          ),
          if (i != years.length - 1) const SizedBox(width: 10),
        ],
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.summary});

  final TradeBotTaxSummary summary;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 18),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _SummaryStat(
                  label: 'Total Trades',
                  value: _formatInt(summary.totalTrades),
                  color: AppColors.text1,
                ),
              ),
              Expanded(
                child: _SummaryStat(
                  label: 'Total Fees Paid',
                  value: _formatUsd(summary.totalFees),
                  color: AppColors.text1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _SummaryStat(
                  label: 'Realized Gains',
                  value: '+${_formatUsd(summary.realizedGains)}',
                  color: _taxGreen,
                ),
              ),
              Expanded(
                child: _SummaryStat(
                  label: 'Realized Losses',
                  value: _formatSignedUsd(summary.realizedLosses),
                  color: _taxRed,
                ),
              ),
            ],
          ),
          const SizedBox(height: 17),
          const Divider(height: 1, thickness: 1, color: _taxOptionBorder),
          const SizedBox(height: 19),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Net Gain/Loss:',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    height: 1,
                  ),
                ),
              ),
              Text(
                '+${_formatUsd(summary.netGainLoss)}',
                style: AppTextStyles.baseMedium.copyWith(
                  color: _taxGreen,
                  fontSize: 20,
                  fontWeight: AppTextStyles.bold,
                  fontFamily: 'Roboto',
                  height: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryStat extends StatelessWidget {
  const _SummaryStat({
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
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 11,
            height: 1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTextStyles.baseMedium.copyWith(
            color: color,
            fontSize: 20,
            fontWeight: AppTextStyles.bold,
            fontFamily: 'Roboto',
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _CostBasisPicker extends StatelessWidget {
  const _CostBasisPicker({
    required this.selectedMethod,
    required this.onChanged,
  });

  final String selectedMethod;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    const methods = [
      ('FIFO', 'First In, First Out (most common)'),
      ('LIFO', 'Last In, First Out'),
    ];
    return Row(
      children: [
        for (var i = 0; i < methods.length; i++) ...[
          Expanded(
            child: GestureDetector(
              key: BotTaxReportingPage.methodKey(methods[i].$1),
              behavior: HitTestBehavior.opaque,
              onTap: () => onChanged(methods[i].$1),
              child: Container(
                height: 82,
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
                decoration: BoxDecoration(
                  color: _taxPanel,
                  border: Border.all(
                    color: selectedMethod == methods[i].$1
                        ? _taxPrimary
                        : _taxOptionBorder,
                    width: 2,
                  ),
                  borderRadius: AppRadii.cardRadius,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _RadioDot(selected: selectedMethod == methods[i].$1),
                        const SizedBox(width: 8),
                        Text(
                          methods[i].$1,
                          style: AppTextStyles.caption.copyWith(
                            color: selectedMethod == methods[i].$1
                                ? _taxPrimary
                                : AppColors.text1,
                            fontSize: 13,
                            fontWeight: AppTextStyles.bold,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Text(
                        methods[i].$2,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          fontSize: 10,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (i != methods.length - 1) const SizedBox(width: 12),
        ],
      ],
    );
  }
}

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
                          background: Color(0x1F10B981),
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
                    color: Colors.white,
                  ),
                )
              else
                Icon(
                  Icons.download_rounded,
                  color: disabled ? AppColors.text3 : Colors.white,
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
                    color: disabled ? AppColors.text3 : Colors.white,
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

class _RadioDot extends StatelessWidget {
  const _RadioDot({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? _taxPrimary : _taxOptionBorder,
          width: 2,
        ),
      ),
      child: selected
          ? Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: _taxPrimary,
                shape: BoxShape.circle,
              ),
            )
          : null,
    );
  }
}

class _CheckBox extends StatelessWidget {
  const _CheckBox({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? _taxPrimary : Colors.transparent,
        border: Border.all(
          color: selected ? _taxPrimary : _taxOptionBorder,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(7),
      ),
      child: selected
          ? const Icon(
              Icons.check_circle_rounded,
              color: Colors.white,
              size: 16,
            )
          : null,
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.text,
    required this.color,
    required this.background,
  });

  final String text;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 11,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child, required this.padding});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: _taxPanel,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: child,
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 15,
          decoration: BoxDecoration(
            color: _taxPrimary,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 7),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 12,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ],
    );
  }
}

String _formatInt(int value) {
  final raw = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final remaining = raw.length - i;
    buffer.write(raw[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
  }
  return buffer.toString();
}

String _formatUsd(double value) => '\$${value.abs().toStringAsFixed(2)}';

String _formatSignedUsd(double value) {
  final sign = value < 0 ? '\$-' : '\$';
  return '$sign${value.abs().toStringAsFixed(2)}';
}
