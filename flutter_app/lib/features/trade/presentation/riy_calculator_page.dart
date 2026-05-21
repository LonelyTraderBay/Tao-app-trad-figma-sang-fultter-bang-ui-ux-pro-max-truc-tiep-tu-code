import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

const _riyBg = Color(0xFF080C14);
const _riySurface = Color(0xFF151A23);
const _riySurface2 = Color(0xFF1E2535);
const _riyBorder = Color(0xFF273142);
const _riyBlue = Color(0xFF3B82F6);
const _riyGreen = Color(0xFF10B981);
const _riyRed = Color(0xFFEF4444);
const _riyGrid = Color(0x1FFFFFFF);

class RIYCalculatorPage extends ConsumerStatefulWidget {
  const RIYCalculatorPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc106_riy_content');
  static const investmentKey = Key('sc106_riy_investment');
  static const expectedReturnKey = Key('sc106_riy_expected_return');
  static const totalCostsKey = Key('sc106_riy_total_costs');
  static const yearsKey = Key('sc106_riy_years');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<RIYCalculatorPage> createState() => _RIYCalculatorPageState();
}

class _RIYCalculatorPageState extends ConsumerState<RIYCalculatorPage> {
  late double _investment;
  late double _expectedReturn;
  late double _totalCosts;
  late int _years;

  @override
  void initState() {
    super.initState();
    final snapshot = ref.read(tradeRepositoryProvider).getRiyCalculator();
    _investment = snapshot.investmentAmount;
    _expectedReturn = snapshot.expectedReturnPct;
    _totalCosts = snapshot.totalCostsPct;
    _years = snapshot.holdingPeriodYears;
  }

  @override
  Widget build(BuildContext context) {
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 70
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;
    final projections = _buildProjections(
      investment: _investment,
      expectedReturn: _expectedReturn,
      totalCosts: _totalCosts,
      years: _years,
    );
    final finalWithoutCosts = projections.last.withoutCosts;
    final finalWithCosts = projections.last.withCosts;
    final difference = finalWithoutCosts - finalWithCosts;
    final lossPct = finalWithoutCosts <= 0
        ? 0.0
        : (difference / finalWithoutCosts) * 100;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-106 RIYCalculatorPage',
      child: Material(
        color: _riyBg,
        child: Column(
          children: [
            VitHeader(
              title: 'RIY Calculator',
              subtitle: 'Cost Impact Analysis',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.tradeCopyExAnteCosts),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: RIYCalculatorPage.contentKey,
                padding: EdgeInsets.fromLTRB(20, 15, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _SectionLabel('Investment Parameters'),
                    const SizedBox(height: 12),
                    _InputCard(
                      investment: _investment,
                      expectedReturn: _expectedReturn,
                      totalCosts: _totalCosts,
                      years: _years,
                      onInvestmentChanged: (value) =>
                          setState(() => _investment = value),
                      onExpectedReturnChanged: (value) =>
                          setState(() => _expectedReturn = value),
                      onTotalCostsChanged: (value) =>
                          setState(() => _totalCosts = value),
                      onYearsChanged: (value) => setState(() => _years = value),
                    ),
                    const SizedBox(height: 25),
                    const _SectionLabel('Impact Analysis'),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _ResultMetric(
                            label: 'Without Costs',
                            value: _formatEur(finalWithoutCosts),
                            color: _riyGreen,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _ResultMetric(
                            label: 'With Costs',
                            value: _formatEur(finalWithCosts),
                            color: _riyRed,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _CostImpactCard(
                      years: _years,
                      difference: difference,
                      lossPct: lossPct,
                    ),
                    const SizedBox(height: 25),
                    const _SectionLabel('Growth Comparison'),
                    const SizedBox(height: 12),
                    _ChartCard(projections: projections),
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

class _InputCard extends StatelessWidget {
  const _InputCard({
    required this.investment,
    required this.expectedReturn,
    required this.totalCosts,
    required this.years,
    required this.onInvestmentChanged,
    required this.onExpectedReturnChanged,
    required this.onTotalCostsChanged,
    required this.onYearsChanged,
  });

  final double investment;
  final double expectedReturn;
  final double totalCosts;
  final int years;
  final ValueChanged<double> onInvestmentChanged;
  final ValueChanged<double> onExpectedReturnChanged;
  final ValueChanged<double> onTotalCostsChanged;
  final ValueChanged<int> onYearsChanged;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      child: Column(
        children: [
          _NumberField(
            key: RIYCalculatorPage.investmentKey,
            label: 'Initial Investment (€)',
            initialValue: _formatInput(investment),
            onChanged: (value) {
              final parsed = double.tryParse(value);
              if (parsed != null && parsed >= 0) onInvestmentChanged(parsed);
            },
          ),
          const SizedBox(height: 17),
          _NumberField(
            key: RIYCalculatorPage.expectedReturnKey,
            label: 'Expected Annual Return (%)',
            initialValue: _formatInput(expectedReturn),
            onChanged: (value) {
              final parsed = double.tryParse(value);
              if (parsed != null) onExpectedReturnChanged(parsed);
            },
          ),
          const SizedBox(height: 17),
          _NumberField(
            key: RIYCalculatorPage.totalCostsKey,
            label: 'Total Annual Costs (%)',
            initialValue: _formatInput(totalCosts),
            onChanged: (value) {
              final parsed = double.tryParse(value);
              if (parsed != null && parsed >= 0) onTotalCostsChanged(parsed);
            },
          ),
          const SizedBox(height: 17),
          _NumberField(
            key: RIYCalculatorPage.yearsKey,
            label: 'Holding Period (Years)',
            initialValue: '$years',
            decimals: false,
            onChanged: (value) {
              final parsed = int.tryParse(value);
              if (parsed != null && parsed > 0) {
                onYearsChanged(parsed.clamp(1, 20).toInt());
              }
            },
          ),
        ],
      ),
    );
  }
}

class _NumberField extends StatelessWidget {
  const _NumberField({
    super.key,
    required this.label,
    required this.initialValue,
    required this.onChanged,
    this.decimals = true,
  });

  final String label;
  final String initialValue;
  final ValueChanged<String> onChanged;
  final bool decimals;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 11,
            height: 1,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 48,
          child: TextFormField(
            initialValue: initialValue,
            keyboardType: TextInputType.numberWithOptions(decimal: decimals),
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                decimals ? RegExp(r'[0-9.]') : RegExp(r'[0-9]'),
              ),
            ],
            onChanged: onChanged,
            cursorColor: _riyBlue,
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text1,
              fontSize: 16,
              height: 1,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: _riySurface2,
              contentPadding: const EdgeInsets.fromLTRB(13, 14, 13, 12),
              border: _fieldBorder(_riyBorder),
              enabledBorder: _fieldBorder(_riyBorder),
              focusedBorder: _fieldBorder(_riyBlue),
            ),
          ),
        ),
      ],
    );
  }
}

class _ResultMetric extends StatelessWidget {
  const _ResultMetric({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 13),
      child: SizedBox(
        height: 42,
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
              style: AppTextStyles.baseMedium.copyWith(
                color: color,
                fontSize: 18,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CostImpactCard extends StatelessWidget {
  const _CostImpactCard({
    required this.years,
    required this.difference,
    required this.lossPct,
  });

  final int years;
  final double difference;
  final double lossPct;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 21, 16, 18),
      child: SizedBox(
        height: 74,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Cost Impact',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontSize: 14,
                      fontWeight: AppTextStyles.bold,
                      height: 1,
                    ),
                  ),
                ),
                Text(
                  '-${_formatEur(difference)}',
                  style: AppTextStyles.baseMedium.copyWith(
                    color: _riyRed,
                    fontSize: 20,
                    height: 1,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 9),
              decoration: BoxDecoration(
                color: _riyBlue.withValues(alpha: .04),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Over $years years, costs reduce your investment by '
                '${_formatEur(difference)} (${lossPct.toStringAsFixed(1)}% loss).',
                textAlign: TextAlign.center,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text1,
                  fontSize: 10,
                  fontWeight: AppTextStyles.bold,
                  height: 1.25,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.projections});

  final List<TradeRiyProjection> projections;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 15),
      child: SizedBox(
        height: 200,
        child: CustomPaint(painter: _RiyChartPainter(projections)),
      ),
    );
  }
}

class _RiyChartPainter extends CustomPainter {
  const _RiyChartPainter(this.projections);

  final List<TradeRiyProjection> projections;

  @override
  void paint(Canvas canvas, Size size) {
    if (projections.length < 2) return;

    const leftPad = 66.0;
    const rightPad = 6.0;
    const topPad = 7.0;
    const bottomPad = 25.0;
    final chart = Rect.fromLTWH(
      leftPad,
      topPad,
      size.width - leftPad - rightPad,
      size.height - topPad - bottomPad,
    );

    final gridPaint = Paint()
      ..color = _riyGrid
      ..strokeWidth = 1;
    final axisPaint = Paint()
      ..color = AppColors.text3.withValues(alpha: .48)
      ..strokeWidth = 1.2;

    const maxValue = 16000.0;
    const yTicks = [16000, 12000, 8000, 4000, 0];
    for (final tick in yTicks) {
      final y = chart.top + (1 - tick / maxValue) * chart.height;
      canvas.drawLine(Offset(chart.left, y), Offset(chart.right, y), gridPaint);
      _drawLabel(
        canvas,
        '$tick',
        Offset(chart.left - 8, y - 7),
        alignRight: true,
      );
    }

    final maxYear = math.max(1, projections.last.year);
    for (final projection in projections) {
      final x = chart.left + (projection.year / maxYear) * chart.width;
      canvas.drawLine(Offset(x, chart.top), Offset(x, chart.bottom), gridPaint);
      _drawLabel(
        canvas,
        '${projection.year}',
        Offset(x, chart.bottom + 7),
        centered: true,
      );
    }

    canvas
      ..drawLine(
        Offset(chart.left, chart.top),
        Offset(chart.left, chart.bottom),
        axisPaint,
      )
      ..drawLine(
        Offset(chart.left, chart.bottom),
        Offset(chart.right, chart.bottom),
        axisPaint,
      );

    _drawSeries(canvas, chart, maxValue, _riyGreen, (point) {
      return point.withoutCosts;
    });
    _drawSeries(canvas, chart, maxValue, _riyRed, (point) => point.withCosts);
  }

  void _drawSeries(
    Canvas canvas,
    Rect chart,
    double maxValue,
    Color color,
    double Function(TradeRiyProjection point) valueFor,
  ) {
    final maxYear = math.max(1, projections.last.year);
    final path = Path();
    for (var index = 0; index < projections.length; index += 1) {
      final point = projections[index];
      final x = chart.left + (point.year / maxYear) * chart.width;
      final y =
          chart.top +
          (1 - (valueFor(point).clamp(0, maxValue).toDouble() / maxValue)) *
              chart.height;
      if (index == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  void _drawLabel(
    Canvas canvas,
    String text,
    Offset offset, {
    bool alignRight = false,
    bool centered = false,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          fontSize: 10,
          height: 1,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final dx = alignRight
        ? offset.dx - painter.width
        : centered
        ? offset.dx - painter.width / 2
        : offset.dx;
    painter.paint(canvas, Offset(dx, offset.dy));
  }

  @override
  bool shouldRepaint(covariant _RiyChartPainter oldDelegate) {
    return oldDelegate.projections != projections;
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
            color: _riyBlue,
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
        color: _riySurface,
        border: Border.all(color: _riyBorder.withValues(alpha: .72)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: child,
    );
  }
}

OutlineInputBorder _fieldBorder(Color color) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(18),
    borderSide: BorderSide(color: color.withValues(alpha: .72)),
  );
}

List<TradeRiyProjection> _buildProjections({
  required double investment,
  required double expectedReturn,
  required double totalCosts,
  required int years,
}) {
  final safeYears = years.clamp(1, 20).toInt();
  return [
    for (var year = 0; year <= safeYears; year += 1)
      TradeRiyProjection(
        year: year,
        withoutCosts:
            investment * math.pow(1 + expectedReturn / 100, year).toDouble(),
        withCosts:
            investment *
            math.pow(1 + (expectedReturn - totalCosts) / 100, year).toDouble(),
      ),
  ];
}

String _formatInput(double value) {
  if (value == value.roundToDouble()) return value.toStringAsFixed(0);
  return value.toStringAsFixed(1);
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
