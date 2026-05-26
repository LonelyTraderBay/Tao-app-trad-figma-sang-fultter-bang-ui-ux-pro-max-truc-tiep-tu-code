import 'dart:math' as math;

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

const _riskBackground = AppColors.bg;
const _riskPanel = AppColors.surface;
const _riskPanel2 = AppColors.surface2;
const _riskPrimary = AppColors.primary;
const _riskGreen = Color(0xFF10B981);
const _riskAmber = Color(0xFFF59E0B);
const _riskRed = Color(0xFFEF4444);
const _riskPurple = Color(0xFF8B5CF6);
const _riskTrack = Color(0xFF202B45);

class BotRiskDashboardPage extends ConsumerWidget {
  const BotRiskDashboardPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc120_bot_risk_dashboard_content');
  static const emergencyHeaderKey = Key('sc120_bot_risk_header_emergency');
  static const emergencyButtonKey = Key('sc120_bot_risk_emergency_button');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(tradeRepositoryProvider).getBotRiskDashboard();
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 104
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-120 BotRiskDashboardPage',
      child: Material(
        color: _riskBackground,
        child: Column(
          children: [
            VitHeader(
              title: 'Risk Dashboard',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.tradeBots),
              trailing: _HeaderEmergencyButton(
                onTap: () => context.go(snapshot.emergencyPath),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: BotRiskDashboardPage.contentKey,
                padding: EdgeInsets.fromLTRB(20, 12, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _RiskScoreCard(snapshot: snapshot),
                    const SizedBox(height: 16),
                    const _SectionLabel('Critical Metrics'),
                    const SizedBox(height: 8),
                    _CriticalMetricsGrid(snapshot: snapshot),
                    const SizedBox(height: 14),
                    const _SectionLabel('Drawdown Trend (24h)'),
                    const SizedBox(height: 12),
                    _DrawdownChartCard(points: snapshot.drawdownPoints),
                    const SizedBox(height: 18),
                    const _SectionLabel('Exposure by Asset'),
                    const SizedBox(height: 12),
                    _ExposureCard(exposures: snapshot.exposures),
                    const SizedBox(height: 18),
                    const _SectionLabel('VaR Trend (7 days)'),
                    const SizedBox(height: 12),
                    _VarChartCard(points: snapshot.varHistory),
                    const SizedBox(height: 18),
                    const _SectionLabel('Safety Controls'),
                    const SizedBox(height: 12),
                    _SafetyControlsCard(controls: snapshot.safetyControls),
                    const SizedBox(height: 18),
                    const _SectionLabel('Emergency Actions'),
                    const SizedBox(height: 12),
                    _EmergencyActionCard(
                      runningBots: snapshot.runningBots,
                      onTap: () => context.go(snapshot.emergencyPath),
                    ),
                    const SizedBox(height: 18),
                    const _RiskExplanationCard(),
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

class _HeaderEmergencyButton extends StatelessWidget {
  const _HeaderEmergencyButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: BotRiskDashboardPage.emergencyHeaderKey,
      onTap: onTap,
      borderRadius: AppRadii.inputRadius,
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _riskPanel2,
          border: Border.all(color: AppColors.cardBorder),
          borderRadius: AppRadii.inputRadius,
        ),
        child: const Icon(
          Icons.error_outline_rounded,
          color: AppColors.text1,
          size: 21,
        ),
      ),
    );
  }
}

class _RiskScoreCard extends StatelessWidget {
  const _RiskScoreCard({required this.snapshot});

  final TradeBotRiskDashboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final color = _riskColor(snapshot.riskScore);
    return _Card(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Portfolio Risk Score',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        fontSize: 12,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${snapshot.riskScore}/100',
                      style: AppTextStyles.heroNumber.copyWith(
                        color: color,
                        fontSize: 28,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      snapshot.riskLabel,
                      style: AppTextStyles.caption.copyWith(
                        color: color,
                        fontSize: 13,
                        fontWeight: AppTextStyles.bold,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 96,
                height: 96,
                child: CustomPaint(
                  painter: _RiskRingPainter(
                    percent: snapshot.riskScore / 100,
                    color: color,
                  ),
                  child: Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: _riskPanel,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.shield_outlined,
                        color: color,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(13, 12, 13, 13),
            decoration: BoxDecoration(
              color: color.withValues(alpha: .08),
              border: Border.all(color: color.withValues(alpha: .28)),
              borderRadius: AppRadii.cardRadius,
            ),
            child: Text(
              snapshot.riskMessage,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontSize: 11,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CriticalMetricsGrid extends StatelessWidget {
  const _CriticalMetricsGrid({required this.snapshot});

  final TradeBotRiskDashboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final metrics = [
      _MetricData(
        icon: Icons.trending_down_rounded,
        label: 'Drawdown',
        value: '${snapshot.currentDrawdown.toStringAsFixed(1)}%',
        limit: 'Limit: ${snapshot.maxDrawdownLimit.toStringAsFixed(0)}%',
        color: _riskRed,
        percent: (snapshot.currentDrawdown / snapshot.maxDrawdownLimit).abs(),
      ),
      _MetricData(
        icon: Icons.attach_money_rounded,
        label: 'Daily Loss',
        value: '-\$${snapshot.dailyLoss.abs().toStringAsFixed(0)}',
        limit: 'Limit: -\$${snapshot.dailyLossLimit.abs().toStringAsFixed(0)}',
        color: _riskAmber,
        percent: (snapshot.dailyLoss / snapshot.dailyLossLimit).abs(),
      ),
      _MetricData(
        icon: Icons.monitor_heart_outlined,
        label: 'Total Exposure',
        value: '\$${_formatCompact(snapshot.totalExposure)}',
        limit: 'Max: \$${_formatCompact(snapshot.maxExposure)}',
        color: _riskPrimary,
        percent: snapshot.totalExposure / snapshot.maxExposure,
      ),
      _MetricData(
        icon: Icons.bolt_rounded,
        label: 'VaR (95%)',
        value: '\$${snapshot.var95.toStringAsFixed(0)}',
        limit: 'Max 1-day loss (95%)',
        color: _riskPurple,
        percent: .72,
      ),
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 13,
      childAspectRatio: 1.52,
      children: [for (final metric in metrics) _MetricCard(metric: metric)],
    );
  }
}

class _MetricData {
  const _MetricData({
    required this.icon,
    required this.label,
    required this.value,
    required this.limit,
    required this.color,
    required this.percent,
  });

  final IconData icon;
  final String label;
  final String value;
  final String limit;
  final Color color;
  final double percent;
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.metric});

  final _MetricData metric;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(metric.icon, color: metric.color, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  metric.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 12,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            metric.value,
            style: AppTextStyles.sectionTitle.copyWith(
              color:
                  metric.label == 'Total Exposure' ||
                      metric.label == 'VaR (95%)'
                  ? AppColors.text1
                  : metric.color,
              fontSize: 20,
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            metric.limit,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 10,
              height: 1,
            ),
          ),
          const SizedBox(height: 10),
          _ProgressTrack(value: metric.percent, color: metric.color),
        ],
      ),
    );
  }
}

class _DrawdownChartCard extends StatelessWidget {
  const _DrawdownChartCard({required this.points});

  final List<TradeBotDrawdownPoint> points;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 19, 16, 15),
      child: SizedBox(
        height: 178,
        child: CustomPaint(
          painter: _DrawdownChartPainter(points),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

class _ExposureCard extends StatelessWidget {
  const _ExposureCard({required this.exposures});

  final List<TradeBotExposure> exposures;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 15),
      child: Column(
        children: [
          for (final exposure in exposures) ...[
            Row(
              children: [
                Text(
                  exposure.asset,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 13,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${exposure.percentage}%',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontSize: 11,
                    height: 1,
                  ),
                ),
                const Spacer(),
                Text(
                  '\$${_formatCompact(exposure.exposure)}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 13,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _ProgressTrack(
              value: exposure.percentage / 100,
              color: Color(exposure.colorHex),
            ),
            if (exposure != exposures.last) const SizedBox(height: 14),
          ],
          const SizedBox(height: 16),
          const Divider(color: AppColors.borderSolid, height: 1),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Diversification Score',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 12,
                    height: 1,
                  ),
                ),
              ),
              Text(
                '72/100 (Good)',
                style: AppTextStyles.caption.copyWith(
                  color: _riskGreen,
                  fontSize: 13,
                  fontWeight: AppTextStyles.bold,
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

class _VarChartCard extends StatelessWidget {
  const _VarChartCard({required this.points});

  final List<TradeBotVarPoint> points;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      child: SizedBox(
        height: 140,
        child: CustomPaint(
          painter: _VarChartPainter(points),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

class _SafetyControlsCard extends StatelessWidget {
  const _SafetyControlsCard({required this.controls});

  final List<TradeBotSafetyControl> controls;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: _riskGreen,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _riskGreen.withValues(alpha: .7),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Circuit Breaker',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontSize: 13,
                        fontWeight: AppTextStyles.bold,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Auto-stop at limit breach',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        fontSize: 11,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'Active',
                style: AppTextStyles.caption.copyWith(
                  color: _riskGreen,
                  fontSize: 12,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 17),
          for (final control in controls) ...[
            Container(
              padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
              decoration: BoxDecoration(
                color: _riskPanel2,
                borderRadius: AppRadii.inputRadius,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      control.label,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        fontSize: 11,
                        height: 1,
                      ),
                    ),
                  ),
                  Text(
                    control.value,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontSize: 11,
                      fontWeight: AppTextStyles.bold,
                      height: 1,
                    ),
                  ),
                  const SizedBox(width: 9),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: _riskGreen,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
            if (control != controls.last) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _EmergencyActionCard extends StatelessWidget {
  const _EmergencyActionCard({required this.runningBots, required this.onTap});

  final int runningBots;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: BotRiskDashboardPage.emergencyButtonKey,
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        constraints: const BoxConstraints(minHeight: 70),
        padding: const EdgeInsets.fromLTRB(16, 15, 12, 15),
        decoration: BoxDecoration(
          color: _riskRed.withValues(alpha: .08),
          border: Border.all(color: _riskRed.withValues(alpha: .48), width: 2),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline_rounded, color: _riskRed, size: 24),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Emergency Stop All Bots',
                    style: AppTextStyles.caption.copyWith(
                      color: _riskRed,
                      fontSize: 14,
                      fontWeight: AppTextStyles.bold,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Stop all $runningBots running bots immediately',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                      fontSize: 11,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
            const Text('->', style: TextStyle(color: AppColors.text3)),
          ],
        ),
      ),
    );
  }
}

class _RiskExplanationCard extends StatelessWidget {
  const _RiskExplanationCard();

  static const _items = [
    'Current drawdown (30%)',
    'Daily loss vs limit (25%)',
    'Portfolio exposure (20%)',
    'VaR trend (15%)',
    'Diversification (10%)',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 17),
      decoration: BoxDecoration(
        color: _riskPanel2,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How Risk Score is Calculated',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontSize: 12,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
          const SizedBox(height: 14),
          for (final item in _items) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '-',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontSize: 11,
                    height: 1,
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    item,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                      fontSize: 11,
                      height: 1,
                    ),
                  ),
                ),
              ],
            ),
            if (item != _items.last) const SizedBox(height: 16),
          ],
        ],
      ),
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
            color: _riskPrimary,
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

class _ProgressTrack extends StatelessWidget {
  const _ProgressTrack({required this.value, required this.color});

  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: SizedBox(
        height: 8,
        child: LinearProgressIndicator(
          value: value.clamp(0, 1),
          backgroundColor: _riskTrack,
          valueColor: AlwaysStoppedAnimation<Color>(color),
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
        color: _riskPanel,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: child,
    );
  }
}

class _RiskRingPainter extends CustomPainter {
  const _RiskRingPainter({required this.percent, required this.color});

  final double percent;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = 7.0;
    final rect = Offset.zero & size;
    final arcRect = rect.deflate(stroke / 2);
    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.butt
      ..color = _riskTrack;
    final active = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.butt
      ..color = color;
    canvas.drawArc(arcRect, -math.pi / 2, math.pi * 2, false, track);
    canvas.drawArc(arcRect, -math.pi / 2, math.pi * 2 * percent, false, active);
  }

  @override
  bool shouldRepaint(covariant _RiskRingPainter oldDelegate) {
    return oldDelegate.percent != percent || oldDelegate.color != color;
  }
}

class _DrawdownChartPainter extends CustomPainter {
  const _DrawdownChartPainter(this.points);

  final List<TradeBotDrawdownPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    final plot = Rect.fromLTWH(66, 4, size.width - 74, size.height - 36);
    final path = Path();
    final area = Path();
    for (var i = 0; i < points.length; i++) {
      final x = plot.left + plot.width * i / (points.length - 1);
      final y = plot.top + plot.height * (points[i].value / -16).clamp(0, 1);
      if (i == 0) {
        path.moveTo(x, y);
        area.moveTo(x, plot.top);
        area.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        area.lineTo(x, y);
      }
    }
    area.lineTo(plot.right, plot.top);
    area.close();
    canvas.drawPath(area, Paint()..color = _riskRed.withValues(alpha: .18));
    canvas.drawPath(
      path,
      Paint()
        ..color = _riskRed
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    _drawAxes(
      canvas,
      plot,
      ['0%', '-8%', '-12%', '-16%'],
      ['00:00', '04:00', '08:00', '12:00', '16:00', 'Now'],
    );
  }

  @override
  bool shouldRepaint(covariant _DrawdownChartPainter oldDelegate) => false;
}

class _VarChartPainter extends CustomPainter {
  const _VarChartPainter(this.points);

  final List<TradeBotVarPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    final plot = Rect.fromLTWH(66, 10, size.width - 78, size.height - 34);
    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final x = plot.left + plot.width * i / (points.length - 1);
      final y = plot.bottom - plot.height * (points[i].value / 220).clamp(0, 1);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      canvas.drawCircle(Offset(x, y), 4.5, Paint()..color = _riskPurple);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = _riskPurple
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    _drawAxes(
      canvas,
      plot,
      ['\$220', '\$110', '\$0'],
      [for (final point in points) point.label],
    );
  }

  @override
  bool shouldRepaint(covariant _VarChartPainter oldDelegate) => false;
}

void _drawAxes(
  Canvas canvas,
  Rect plot,
  List<String> yLabels,
  List<String> xLabels,
) {
  final axisPaint = Paint()
    ..color = AppColors.text3.withValues(alpha: .55)
    ..strokeWidth = 1;
  canvas.drawLine(plot.bottomLeft, plot.topLeft, axisPaint);
  canvas.drawLine(plot.bottomLeft, plot.bottomRight, axisPaint);

  for (var i = 0; i < yLabels.length; i++) {
    final y = plot.top + plot.height * i / (yLabels.length - 1);
    _drawSmallText(
      canvas,
      yLabels[i],
      Offset(plot.left - 8, y),
      alignRight: true,
    );
  }
  for (var i = 0; i < xLabels.length; i++) {
    final x = plot.left + plot.width * i / (xLabels.length - 1);
    _drawSmallText(
      canvas,
      xLabels[i],
      Offset(x, plot.bottom + 10),
      center: true,
    );
  }
}

void _drawSmallText(
  Canvas canvas,
  String text,
  Offset offset, {
  bool alignRight = false,
  bool center = false,
}) {
  final painter = TextPainter(
    text: TextSpan(
      text: text,
      style: AppTextStyles.micro.copyWith(
        color: AppColors.text3,
        fontSize: 10,
        fontFamily: 'Roboto',
        height: 1,
      ),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  var dx = offset.dx;
  if (alignRight) dx -= painter.width;
  if (center) dx -= painter.width / 2;
  painter.paint(canvas, Offset(dx, offset.dy - painter.height / 2));
}

Color _riskColor(int score) {
  if (score < 40) return _riskGreen;
  if (score < 70) return _riskAmber;
  return _riskRed;
}

String _formatCompact(double value) {
  final text = value.toStringAsFixed(0);
  final buffer = StringBuffer();
  for (var i = 0; i < text.length; i++) {
    final remaining = text.length - i;
    buffer.write(text[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
  }
  return buffer.toString();
}
