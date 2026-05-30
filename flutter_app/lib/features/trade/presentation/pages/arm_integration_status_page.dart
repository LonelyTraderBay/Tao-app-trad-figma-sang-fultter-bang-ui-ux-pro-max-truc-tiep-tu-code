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
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

const _armBackground = AppColors.bg;
const _armPanel = AppColors.surface;
const _armPanel2 = AppColors.surface2;
const _armBorder = AppColors.borderSolid;
const _armGreen = AppColors.buy;
const _armAmber = AppColors.caution;
const _armRed = AppColors.sell;
const _armPrimary = AppColors.primary;

class ArmIntegrationStatusPage extends ConsumerStatefulWidget {
  const ArmIntegrationStatusPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc095_arm_integration_content');
  static Key connectionKey(String id) => Key('sc095_arm_connection_$id');
  static Key testKey(String id) => Key('sc095_arm_test_$id');
  static Key actionKey(String id) => Key('sc095_arm_action_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ArmIntegrationStatusPage> createState() =>
      _ArmIntegrationStatusPageState();
}

class _ArmIntegrationStatusPageState
    extends ConsumerState<ArmIntegrationStatusPage> {
  String? _testingId;

  void _testConnection(String id) {
    setState(() => _testingId = id);
    Future<void>.delayed(const Duration(milliseconds: 650), () {
      if (mounted && _testingId == id) {
        setState(() => _testingId = null);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getArmIntegrationStatus();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 118
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-095 ARMIntegrationStatusPage',
      child: Material(
        color: _armBackground,
        child: Column(
          children: [
            VitHeader(
              title: 'ARM Integration',
              subtitle: 'Connection Health · Monitoring',
              showBack: true,
              onBack: () =>
                  context.go(AppRoutePaths.tradeCopyRegulatoryReportsDashboard),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: ArmIntegrationStatusPage.contentKey,
                padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _OperationalAlert(),
                    const SizedBox(height: 35),
                    const _SectionLabel('ARM Providers'),
                    const SizedBox(height: 12),
                    for (final connection in snapshot.connections) ...[
                      _ArmProviderCard(
                        connection: connection,
                        isTesting: _testingId == connection.id,
                        onTest: () => _testConnection(connection.id),
                      ),
                      if (connection != snapshot.connections.last)
                        const SizedBox(height: 13),
                    ],
                    const SizedBox(height: 26),
                    const _SectionLabel('Latency Monitoring (Last 15 min)'),
                    const SizedBox(height: 12),
                    _LatencyCard(points: snapshot.latencyHistory),
                    const SizedBox(height: 26),
                    const _SectionLabel('SLA Compliance'),
                    const SizedBox(height: 12),
                    _SlaCard(sla: snapshot.sla),
                    const SizedBox(height: 26),
                    _QuickActions(
                      onQueue: () => context.go(
                        AppRoutePaths.tradeCopyTransactionReporting,
                      ),
                      onDashboard: () => context.go(
                        AppRoutePaths.tradeCopyRegulatoryReportsDashboard,
                      ),
                    ),
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

class _OperationalAlert extends StatelessWidget {
  const _OperationalAlert();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: AppColors.transparent,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: AppColors.text1,
            size: 17,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'All Systems Operational',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 11,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '3/3 ARM providers online. Failover ready. Average uptime: 99.5%.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontSize: 10,
                    fontWeight: AppTextStyles.bold,
                    height: 1.4,
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

class _ArmProviderCard extends StatelessWidget {
  const _ArmProviderCard({
    required this.connection,
    required this.isTesting,
    required this.onTest,
  });

  final TradeArmConnection connection;
  final bool isTesting;
  final VoidCallback onTest;

  @override
  Widget build(BuildContext context) {
    final style = _statusStyle(connection.status);
    return Container(
      key: ArmIntegrationStatusPage.connectionKey(connection.id),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _armPanel,
        border: Border.all(color: _armBorder.withValues(alpha: .72)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: style.color.withValues(alpha: .15),
                  borderRadius: AppRadii.cardRadius,
                ),
                alignment: Alignment.center,
                child: Icon(style.icon, color: style.color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            connection.provider,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.text1,
                              fontSize: 15,
                              fontWeight: AppTextStyles.bold,
                              height: 1,
                            ),
                          ),
                        ),
                        if (connection.isPrimary) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: _armPrimary.withValues(alpha: .15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'PRIMARY',
                              style: AppTextStyles.micro.copyWith(
                                color: _armPrimary,
                                fontSize: 9,
                                fontWeight: AppTextStyles.bold,
                                height: 1,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 9),
                    Text(
                      connection.region,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        fontSize: 11,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: style.color.withValues(alpha: .13),
                  borderRadius: AppRadii.mdRadius,
                ),
                child: Text(
                  style.label,
                  style: AppTextStyles.caption.copyWith(
                    color: style.color,
                    fontSize: 11,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _MetricBox(
                  label: 'Uptime',
                  value: '${connection.uptime.toStringAsFixed(2)}%',
                  color: _armGreen,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MetricBox(
                  label: 'Avg Latency',
                  value: '${connection.avgLatency}ms',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MetricBox(
                  label: 'Current',
                  value: '${connection.currentLatency}ms',
                  color: connection.currentLatency > 60
                      ? _armRed
                      : AppColors.text1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _ConnectionDetails(connection: connection),
          const SizedBox(height: 13),
          Row(
            children: [
              Expanded(
                child: _TestButton(
                  connectionId: connection.id,
                  isTesting: isTesting,
                  onTap: onTest,
                ),
              ),
              const SizedBox(width: 12),
              const _LogsButton(),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricBox extends StatelessWidget {
  const _MetricBox({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      padding: const EdgeInsets.fromLTRB(9, 9, 9, 8),
      decoration: BoxDecoration(
        color: _armPanel2,
        borderRadius: AppRadii.mdRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 9,
              height: 1,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body.copyWith(
              color: color,
              fontSize: 16,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _ConnectionDetails extends StatelessWidget {
  const _ConnectionDetails({required this.connection});

  final TradeArmConnection connection;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 9, 10, 9),
      decoration: BoxDecoration(
        color: _armPanel2,
        borderRadius: AppRadii.mdRadius,
      ),
      child: Column(
        children: [
          _DetailRow(
            label: 'Endpoint:',
            value: connection.endpoint,
            mono: true,
          ),
          const SizedBox(height: 10),
          _DetailRow(label: 'Last Check:', value: connection.lastCheck),
          const SizedBox(height: 10),
          _DetailRow(label: 'Cert Expiry:', value: connection.certExpiry),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.mono = false,
  });

  final String label;
  final String value;
  final bool mono;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 10,
            height: 1,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              fontSize: 10,
              fontFamily: mono ? 'monospace' : null,
              height: 1,
            ),
          ),
        ),
      ],
    );
  }
}

class _TestButton extends StatelessWidget {
  const _TestButton({
    required this.connectionId,
    required this.isTesting,
    required this.onTap,
  });

  final String connectionId;
  final bool isTesting;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: ArmIntegrationStatusPage.testKey(connectionId),
      onTap: isTesting ? null : onTap,
      borderRadius: AppRadii.smRadius,
      child: Container(
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: (isTesting ? _armPanel2 : _armPrimary.withValues(alpha: .14)),
          borderRadius: AppRadii.smRadius,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isTesting ? Icons.sync_rounded : Icons.bolt_rounded,
              color: isTesting ? AppColors.text3 : _armPrimary,
              size: 15,
            ),
            const SizedBox(width: 8),
            Text(
              isTesting ? 'Testing...' : 'Test Connection',
              style: AppTextStyles.caption.copyWith(
                color: isTesting ? AppColors.text3 : _armPrimary,
                fontSize: 11,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LogsButton extends StatelessWidget {
  const _LogsButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 13),
      decoration: BoxDecoration(
        color: _armPanel2,
        borderRadius: AppRadii.inputRadius,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.open_in_new_rounded,
            color: AppColors.text2,
            size: 14,
          ),
          const SizedBox(width: 7),
          Text(
            'Logs',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontSize: 11,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _LatencyCard extends StatelessWidget {
  const _LatencyCard({required this.points});

  final List<TradeArmLatencyPoint> points;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: CustomPaint(
              painter: _LatencyPainter(points: points),
              child: const SizedBox.expand(),
            ),
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: _armBorder),
          const SizedBox(height: 13),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LegendDot(label: 'REGIS-TR', color: _armGreen),
              SizedBox(width: 18),
              _LegendDot(label: 'UnaVista', color: _armPrimary),
              SizedBox(width: 18),
              _LegendDot(label: 'Bloomberg', color: _armAmber),
            ],
          ),
        ],
      ),
    );
  }
}

class _SlaCard extends StatelessWidget {
  const _SlaCard({required this.sla});

  final TradeArmSlaMetrics sla;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 17),
      child: Column(
        children: [
          _ProgressRow(
            label: 'Uptime Target (99.9%)',
            value: '${sla.uptime.toStringAsFixed(2)}%',
            factor: sla.uptime / 100,
          ),
          const SizedBox(height: 17),
          _ProgressRow(
            label: 'Latency Target (<100ms)',
            value: '${sla.latencyAvg}ms avg',
            factor: sla.latencyAvg / 100,
          ),
          const SizedBox(height: 17),
          _ProgressRow(
            label: 'Failover Readiness',
            value: '${sla.failoverReadiness}%',
            factor: sla.failoverReadiness / 100,
          ),
        ],
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  const _ProgressRow({
    required this.label,
    required this.value,
    required this.factor,
  });

  final String label;
  final String value;
  final double factor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontSize: 12,
                  height: 1,
                ),
              ),
            ),
            Text(
              value,
              style: AppTextStyles.caption.copyWith(
                color: _armGreen,
                fontSize: 14,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
                height: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: SizedBox(
            height: 8,
            child: Stack(
              children: [
                const ColoredBox(color: _armPanel2),
                FractionallySizedBox(
                  widthFactor: factor.clamp(0, 1).toDouble(),
                  child: const ColoredBox(color: _armGreen),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.onQueue, required this.onDashboard});

  final VoidCallback onQueue;
  final VoidCallback onDashboard;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickAction(
            key: ArmIntegrationStatusPage.actionKey('queue'),
            label: 'Live Queue',
            icon: Icons.monitor_heart_outlined,
            color: _armPrimary,
            onTap: onQueue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickAction(
            key: ArmIntegrationStatusPage.actionKey('dashboard'),
            label: 'Dashboard',
            icon: Icons.shield_outlined,
            color: _armGreen,
            onTap: onDashboard,
          ),
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 13),
        decoration: BoxDecoration(
          color: _armPanel2,
          border: Border.all(color: _armBorder),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 17),
            const SizedBox(width: 9),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontSize: 12,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.text3,
              size: 17,
            ),
          ],
        ),
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
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            color: _armPrimary,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontSize: 11,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
        ),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 7),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 10,
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
        color: _armPanel,
        border: Border.all(color: _armBorder.withValues(alpha: .72)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: child,
    );
  }
}

class _ArmStatusStyle {
  const _ArmStatusStyle({
    required this.color,
    required this.label,
    required this.icon,
  });

  final Color color;
  final String label;
  final IconData icon;
}

_ArmStatusStyle _statusStyle(String status) {
  return switch (status) {
    'healthy' => const _ArmStatusStyle(
      color: _armGreen,
      label: 'Healthy',
      icon: Icons.check_circle_outline,
    ),
    'degraded' => const _ArmStatusStyle(
      color: _armAmber,
      label: 'Degraded',
      icon: Icons.warning_amber_rounded,
    ),
    _ => const _ArmStatusStyle(
      color: _armRed,
      label: 'Down',
      icon: Icons.cancel_outlined,
    ),
  };
}

class _LatencyPainter extends CustomPainter {
  const _LatencyPainter({required this.points});

  final List<TradeArmLatencyPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = _armBorder.withValues(alpha: .62)
      ..strokeWidth = 1;
    final axis = Paint()
      ..color = AppColors.text3.withValues(alpha: .5)
      ..strokeWidth = 1;
    final chartRect = Rect.fromLTWH(58, 8, size.width - 66, size.height - 34);
    const maxValue = 60.0;
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (final label in const [60, 45, 30, 15, 0]) {
      final y = chartRect.bottom - (label / maxValue) * chartRect.height;
      _drawDashedLine(
        canvas,
        Offset(chartRect.left, y),
        Offset(chartRect.right, y),
        grid,
      );
      textPainter.text = TextSpan(
        text: '$label',
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          fontSize: 9,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(chartRect.left - textPainter.width - 8, y - 6),
      );
    }

    for (var i = 0; i < points.length; i++) {
      final x = chartRect.left + chartRect.width * i / (points.length - 1);
      _drawDashedLine(
        canvas,
        Offset(x, chartRect.top),
        Offset(x, chartRect.bottom),
        grid,
      );
    }
    canvas.drawLine(chartRect.topLeft, chartRect.bottomLeft, axis);
    canvas.drawLine(chartRect.bottomLeft, chartRect.bottomRight, axis);

    _drawLine(
      canvas,
      chartRect,
      points.map((item) => item.registr.toDouble()).toList(),
      _armGreen,
      maxValue,
    );
    _drawLine(
      canvas,
      chartRect,
      points.map((item) => item.unavista.toDouble()).toList(),
      _armPrimary,
      maxValue,
    );
    _drawLine(
      canvas,
      chartRect,
      points.map((item) => item.bloomberg.toDouble()).toList(),
      _armAmber,
      maxValue,
    );

    for (var i = 0; i < points.length; i++) {
      final x = chartRect.left + chartRect.width * i / (points.length - 1);
      textPainter.text = TextSpan(
        text: points[i].time,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          fontSize: 9,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, chartRect.bottom + 8),
      );
    }
  }

  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    const dash = 3.0;
    const gap = 3.0;
    final distance = (end - start).distance;
    if (distance == 0) {
      return;
    }
    final direction = Offset(
      (end.dx - start.dx) / distance,
      (end.dy - start.dy) / distance,
    );
    var drawn = 0.0;
    while (drawn < distance) {
      final segmentEnd = math.min(drawn + dash, distance);
      canvas.drawLine(
        start + direction * drawn,
        start + direction * segmentEnd,
        paint,
      );
      drawn += dash + gap;
    }
  }

  void _drawLine(
    Canvas canvas,
    Rect chartRect,
    List<double> values,
    Color color,
    double maxValue,
  ) {
    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final x = chartRect.left + chartRect.width * i / (values.length - 1);
      final normalized = (values[i] / maxValue).clamp(0.0, 1.0).toDouble();
      final y = chartRect.bottom - normalized * chartRect.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      canvas.drawCircle(Offset(x, y), 3, Paint()..color = color);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant _LatencyPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}
