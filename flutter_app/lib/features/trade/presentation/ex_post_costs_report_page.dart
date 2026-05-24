import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../data/trade_repository.dart';

const _reportBackground = AppColors.bg;
const _reportPanel = AppColors.surface;
const _reportPanel2 = AppColors.surface2;
const _reportBorder = AppColors.borderSolid;
const _reportPrimary = AppColors.primary;
const _reportGreen = Color(0xFF10B981);
const _reportAmber = Color(0xFFF59E0B);
const _reportRed = Color(0xFFEF4444);

class ExPostCostsReportPage extends ConsumerStatefulWidget {
  const ExPostCostsReportPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc107_ex_post_content');
  static const downloadKey = Key('sc107_ex_post_download');
  static Key tabKey(int year) => Key('sc107_ex_post_tab_$year');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ExPostCostsReportPage> createState() =>
      _ExPostCostsReportPageState();
}

class _ExPostCostsReportPageState extends ConsumerState<ExPostCostsReportPage> {
  int _selectedYear = 2025;

  @override
  Widget build(BuildContext context) {
    final repository = ref.watch(tradeRepositoryProvider);
    final snapshot = repository.getExPostCostsReport();
    final report = snapshot.reportForYear(_selectedYear);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 70
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-107 ExPostCostsReportPage',
      child: Material(
        color: _reportBackground,
        child: Column(
          children: [
            VitHeader(
              title: 'Ex-Post Cost Report',
              subtitle: 'Annual Actual Costs',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.tradeCopyExAnteCosts),
              trailing: _DownloadAction(
                onPressed: () => repository.createExPostCostsReportExport(
                  year: _selectedYear,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: ExPostCostsReportPage.contentKey,
                padding: EdgeInsets.fromLTRB(20, 27, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _ComplianceNotice(year: report.year),
                    const SizedBox(height: 35),
                    Row(
                      children: [
                        Expanded(
                          child: _SummaryCard(
                            label: 'Total Actual Costs',
                            value: _formatEur(report.totalActual),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _SummaryCard(
                            label: 'Estimated Costs',
                            value: _formatEur(report.totalEstimated),
                            muted: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _YearTabs(
                      reports: snapshot.reports,
                      activeYear: _selectedYear,
                      onChanged: (year) => setState(() {
                        _selectedYear = year;
                      }),
                    ),
                    const SizedBox(height: 27),
                    const _SectionLabel('Actual vs. Estimated'),
                    const SizedBox(height: 12),
                    _CostBreakdownCard(
                      title: 'One-off Costs',
                      actual: report.oneOff,
                      estimate: report.estimatedOneOff,
                    ),
                    const SizedBox(height: 13),
                    _CostBreakdownCard(
                      title: 'Recurring Costs',
                      actual: report.recurring,
                      estimate: report.estimatedRecurring,
                      note: _VarianceNote.lower(
                        report.estimatedRecurring - report.recurring,
                      ),
                    ),
                    const SizedBox(height: 13),
                    _CostBreakdownCard(
                      title: 'Incidental Costs',
                      actual: report.incidental,
                      estimate: report.estimatedIncidental,
                      note: _VarianceNote.higher(
                        report.incidental - report.estimatedIncidental,
                      ),
                    ),
                    const SizedBox(height: 25),
                    const _SectionLabel('Variance Analysis'),
                    const SizedBox(height: 12),
                    _VarianceCard(report: report),
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

class _DownloadAction extends StatelessWidget {
  const _DownloadAction({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 36,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: _reportPanel2,
          border: Border.all(color: _reportBorder.withValues(alpha: .72)),
          borderRadius: AppRadii.smRadius,
        ),
        child: IconButton(
          key: ExPostCostsReportPage.downloadKey,
          onPressed: onPressed,
          padding: EdgeInsets.zero,
          icon: const Icon(
            Icons.download_rounded,
            color: AppColors.text1,
            size: 18,
          ),
        ),
      ),
    );
  }
}

class _ComplianceNotice extends StatelessWidget {
  const _ComplianceNotice({required this.year});

  final int year;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 8, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle_outline_rounded,
            color: AppColors.text1,
            size: 16,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Annual Cost Report Available',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 11,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'This report shows the actual costs you paid in $year. '
                  'Required by PRIIPs regulation.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text1,
                    fontSize: 10,
                    fontWeight: AppTextStyles.bold,
                    height: 1.35,
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

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.value,
    this.muted = false,
  });

  final String label;
  final String value;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(12, 15, 12, 13),
      child: SizedBox(
        height: 46,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontSize: 10,
                height: 1,
              ),
            ),
            const Spacer(),
            Text(
              value,
              style: AppTextStyles.heroNumber.copyWith(
                color: muted ? AppColors.text3 : AppColors.text1,
                fontSize: 20,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _YearTabs extends StatelessWidget {
  const _YearTabs({
    required this.reports,
    required this.activeYear,
    required this.onChanged,
  });

  final List<TradeExPostCostReport> reports;
  final int activeYear;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 53,
      color: _reportPanel,
      child: Row(
        children: [
          for (final report in reports)
            Expanded(
              child: InkWell(
                key: ExPostCostsReportPage.tabKey(report.year),
                onTap: () => onChanged(report.year),
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          '${report.year}',
                          style: AppTextStyles.caption.copyWith(
                            color: activeYear == report.year
                                ? _reportPrimary
                                : AppColors.text3,
                            fontSize: 12,
                            fontWeight: AppTextStyles.bold,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: activeYear == report.year ? 100 : 0,
                      height: 2,
                      color: _reportPrimary,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CostBreakdownCard extends StatelessWidget {
  const _CostBreakdownCard({
    required this.title,
    required this.actual,
    required this.estimate,
    this.note,
  });

  final String title;
  final double actual;
  final double estimate;
  final _VarianceNote? note;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 15),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    title,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontSize: 13,
                      fontWeight: AppTextStyles.bold,
                      height: 1,
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatEur(actual),
                    style: AppTextStyles.baseMedium.copyWith(
                      color: AppColors.text1,
                      fontSize: 16,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 9),
                  Text(
                    'Est: ${_formatEur(estimate)}',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontSize: 9,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (note != null) ...[
            const SizedBox(height: 22),
            _VarianceNoteView(note: note!),
          ],
        ],
      ),
    );
  }
}

class _VarianceNote {
  const _VarianceNote({required this.amount, required this.kind});

  factory _VarianceNote.lower(double amount) {
    return _VarianceNote(amount: amount, kind: _VarianceNoteKind.lower);
  }

  factory _VarianceNote.higher(double amount) {
    return _VarianceNote(amount: amount, kind: _VarianceNoteKind.higher);
  }

  final double amount;
  final _VarianceNoteKind kind;
}

enum _VarianceNoteKind { lower, higher }

class _VarianceNoteView extends StatelessWidget {
  const _VarianceNoteView({required this.note});

  final _VarianceNote note;

  @override
  Widget build(BuildContext context) {
    final isHigher = note.kind == _VarianceNoteKind.higher;
    final color = isHigher ? _reportAmber : AppColors.text1;
    final bg = isHigher
        ? _reportAmber.withValues(alpha: .12)
        : Colors.transparent;
    final text = isHigher
        ? '${_formatEur(note.amount)} higher (better performance)'
        : '${_formatEur(note.amount)} lower than estimated';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(isHigher ? 10 : 8, 8, 10, 8),
      decoration: BoxDecoration(color: bg, borderRadius: AppRadii.inputRadius),
      child: Row(
        children: [
          Icon(
            isHigher ? Icons.warning_amber_rounded : Icons.check_rounded,
            color: color,
            size: 11,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontSize: 9,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VarianceCard extends StatelessWidget {
  const _VarianceCard({required this.report});

  final TradeExPostCostReport report;

  @override
  Widget build(BuildContext context) {
    final variance = report.variance;
    final higher = variance > 0;
    final text = higher
        ? 'Actual costs were ${_formatEur(variance.abs())} higher than '
              'estimated, mainly due to higher performance fees.'
        : variance < 0
        ? 'Actual costs were ${_formatEur(variance.abs())} lower than '
              'estimated, mainly due to lower transaction costs.'
        : 'Actual costs matched estimates exactly.';

    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 21, 16, 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Total Variance',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 13,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
              ),
              Text(
                '${higher
                    ? '+'
                    : variance < 0
                    ? '-'
                    : ''}'
                '${_formatEur(variance.abs())}',
                style: AppTextStyles.baseMedium.copyWith(
                  color: higher ? _reportRed : _reportGreen,
                  fontSize: 18,
                  height: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(12, 13, 12, 12),
            decoration: BoxDecoration(
              color: _reportPanel2,
              borderRadius: AppRadii.inputRadius,
            ),
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                fontSize: 10,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 14,
          decoration: BoxDecoration(
            color: _reportPrimary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 7),
        Text(
          text,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontSize: 11,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ],
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
        color: _reportPanel,
        border: Border.all(color: _reportBorder.withValues(alpha: .72)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: child,
    );
  }
}

String _formatEur(double value) {
  final rounded = value.round();
  final absolute = rounded.abs().toString();
  final buffer = StringBuffer();
  for (var index = 0; index < absolute.length; index += 1) {
    if (index > 0 && (absolute.length - index) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(absolute[index]);
  }
  final sign = rounded < 0 ? '-' : '';
  return '$sign€${buffer.toString()}';
}
