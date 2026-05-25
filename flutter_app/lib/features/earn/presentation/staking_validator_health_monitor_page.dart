import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_content.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/earn_repository.dart';

class StakingValidatorHealthMonitorPage extends ConsumerStatefulWidget {
  const StakingValidatorHealthMonitorPage({super.key, this.shellRenderMode});

  static const statsKey = Key('sc383_stats');
  static const validatorsKey = Key('sc383_validators');
  static const trendKey = Key('sc383_trend');
  static const actionKey = Key('sc383_action');
  static const footerKey = Key('sc383_footer');

  static Key validatorKey(String id) => Key('sc383_validator_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingValidatorHealthMonitorPage> createState() =>
      _StakingValidatorHealthMonitorPageState();
}

class _StakingValidatorHealthMonitorPageState
    extends ConsumerState<StakingValidatorHealthMonitorPage> {
  String? _selectedValidatorId;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(stakingValidatorHealthMonitorRepositoryProvider)
        .getValidatorHealth();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-383 StakingValidatorHealthMonitorPage',
      child: Material(
        color: AppColors.bg,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: bottomInset),
                child: VitPageContent(
                  padding: VitContentPadding.compact,
                  gap: VitContentGap.defaultGap,
                  children: [
                    _SummaryStats(snapshot: snapshot),
                    VitPageSection(
                      key: StakingValidatorHealthMonitorPage.validatorsKey,
                      label: 'Active Validators',
                      accentColor: AppColors.primarySoft,
                      children: [
                        for (final validator in snapshot.validators)
                          _ValidatorCard(
                            validator: validator,
                            selected: _selectedValidatorId == validator.id,
                            onTap: () {
                              setState(() {
                                _selectedValidatorId =
                                    _selectedValidatorId == validator.id
                                    ? null
                                    : validator.id;
                              });
                            },
                          ),
                      ],
                    ),
                    _TrendSection(points: snapshot.uptimeHistory),
                    if (snapshot.warningCount > 0)
                      _ActionRequiredCard(snapshot: snapshot),
                    _FooterNote(note: snapshot.footerNote),
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

class _SummaryStats extends StatelessWidget {
  const _SummaryStats({required this.snapshot});

  final StakingValidatorHealthMonitorSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingValidatorHealthMonitorPage.statsKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          Expanded(
            child: _SummaryTile(
              icon: Icons.check_circle_outline_rounded,
              label: 'Healthy',
              value: snapshot.healthyCount.toString(),
              color: AppColors.buy,
              borderColor: AppColors.buy20,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: _SummaryTile(
              icon: Icons.error_outline_rounded,
              label: 'Warning',
              value: snapshot.warningCount.toString(),
              color: AppColors.warn,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: _SummaryTile(
              icon: Icons.monitor_heart_outlined,
              label: 'Avg Uptime',
              value: '${snapshot.averageUptime.toStringAsFixed(2)}%',
              color: AppColors.text2,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.borderColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: borderColor,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x4,
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: AppSpacing.iconMd),
          const SizedBox(height: AppSpacing.x2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: AppTextStyles.sectionTitle.copyWith(
                color: color == AppColors.text2 ? AppColors.text1 : color,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _ValidatorCard extends StatelessWidget {
  const _ValidatorCard({
    required this.validator,
    required this.selected,
    required this.onTap,
  });

  final StakingValidatorHealthDraft validator;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(validator.status);
    return VitCard(
      key: StakingValidatorHealthMonitorPage.validatorKey(validator.id),
      radius: VitCardRadius.lg,
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: AppSpacing.ctaHeight,
                height: AppSpacing.ctaHeight,
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: AppRadii.lgRadius,
                ),
                child: Icon(_statusIcon(validator.status), color: statusColor),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            validator.name,
                            style: AppTextStyles.baseMedium,
                          ),
                        ),
                        _StatusPill(
                          label: _statusLabel(validator.status),
                          color: statusColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      validator.address,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x2),
                    Wrap(
                      spacing: AppSpacing.x2,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Icon(
                          Icons.show_chart_rounded,
                          color: statusColor,
                          size: AppSpacing.iconSm,
                        ),
                        Text(
                          '${_formatPercent(validator.uptime)} uptime',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text2,
                          ),
                        ),
                        const CircleAvatar(
                          radius: 2,
                          backgroundColor: AppColors.borderSolid,
                        ),
                        Text(
                          '${_formatPercent(validator.apr)} APR',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: _ValidatorMetric(
                  label: 'Staked',
                  value: '${_formatEth(validator.totalStakedEth)} ETH',
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _ValidatorMetric(
                  label: 'Commission',
                  value: '${validator.commission}%',
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _ValidatorMetric(
                  label: 'Missed Blocks',
                  value: validator.missedBlocks.toString(),
                  color: validator.missedBlocks > 10
                      ? AppColors.warn
                      : AppColors.text1,
                ),
              ),
            ],
          ),
          if (selected) ...[
            const SizedBox(height: AppSpacing.x3),
            const Divider(color: AppColors.borderSolid, height: 1),
            const SizedBox(height: AppSpacing.x3),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Last Block Produced',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                Text(
                  validator.lastBlock,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x3),
            Row(
              children: [
                Expanded(child: _SmallButton(label: 'View Details')),
                if (validator.status == 'warning') ...[
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: _SmallButton(
                      label: 'Rebalance Stake',
                      color: AppColors.sell,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ValidatorMetric extends StatelessWidget {
  const _ValidatorMetric({
    required this.label,
    required this.value,
    this.color,
  });

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: AppTextStyles.caption.copyWith(
                color: color ?? AppColors.text1,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendSection extends StatelessWidget {
  const _TrendSection({required this.points});

  final List<StakingUptimeHistoryPointDraft> points;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingValidatorHealthMonitorPage.trendKey,
      label: '7-Day Uptime Trend',
      accentColor: AppColors.primarySoft,
      children: [
        VitCard(
          radius: VitCardRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            children: [
              SizedBox(
                height: 196,
                child: CustomPaint(
                  painter: _UptimeTrendPainter(points),
                  child: const SizedBox.expand(),
                ),
              ),
              const SizedBox(height: AppSpacing.x3),
              const Wrap(
                alignment: WrapAlignment.center,
                spacing: AppSpacing.x3,
                runSpacing: AppSpacing.x2,
                children: [
                  _LegendEntry(label: 'Validator #1', color: AppColors.buy),
                  _LegendEntry(
                    label: 'Validator #2',
                    color: AppColors.primarySoft,
                  ),
                  _LegendEntry(label: 'Validator #3', color: AppColors.warn),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionRequiredCard extends StatelessWidget {
  const _ActionRequiredCard({required this.snapshot});

  final StakingValidatorHealthMonitorSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingValidatorHealthMonitorPage.actionKey,
      variant: VitCardVariant.inner,
      borderColor: AppColors.warn.withValues(alpha: 0.35),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: AppColors.warn,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(snapshot.actionTitle, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  snapshot.actionBody,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.55,
                  ),
                ),
                const SizedBox(height: AppSpacing.x3),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.x3),
                  decoration: BoxDecoration(
                    color: AppColors.primarySoft,
                    borderRadius: AppRadii.inputRadius,
                  ),
                  child: Text(
                    snapshot.actionLabel,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.bg,
                      fontWeight: AppTextStyles.bold,
                    ),
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

class _FooterNote extends StatelessWidget {
  const _FooterNote({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingValidatorHealthMonitorPage.footerKey,
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Text(
        note,
        textAlign: TextAlign.center,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          height: 1.55,
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _SmallButton extends StatelessWidget {
  const _SmallButton({required this.label, this.color});

  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final textColor = color ?? AppColors.text1;
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
      decoration: BoxDecoration(
        color: textColor.withValues(alpha: color == null ? 0.06 : 0.15),
        borderRadius: AppRadii.smRadius,
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.micro.copyWith(
          color: textColor,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _LegendEntry extends StatelessWidget {
  const _LegendEntry({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: AppSpacing.x2,
          height: AppSpacing.x2,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: AppSpacing.x1),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _UptimeTrendPainter extends CustomPainter {
  const _UptimeTrendPainter(this.points);

  final List<StakingUptimeHistoryPointDraft> points;

  @override
  void paint(Canvas canvas, Size size) {
    final chartRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final gridPaint = Paint()
      ..color = AppColors.borderSolid
      ..strokeWidth = 1;
    for (var i = 0; i <= 4; i++) {
      final y = chartRect.top + chartRect.height * i / 4;
      canvas.drawLine(
        Offset(chartRect.left, y),
        Offset(chartRect.right, y),
        gridPaint,
      );
    }
    for (var i = 0; i < points.length; i++) {
      final x = points.length == 1
          ? chartRect.left
          : chartRect.left + chartRect.width * i / (points.length - 1);
      canvas.drawLine(
        Offset(x, chartRect.top),
        Offset(x, chartRect.bottom),
        gridPaint,
      );
    }

    _drawSeries(
      canvas,
      chartRect,
      points.map((point) => point.validatorOne).toList(),
      AppColors.buy,
    );
    _drawSeries(
      canvas,
      chartRect,
      points.map((point) => point.validatorTwo).toList(),
      AppColors.primarySoft,
    );
    _drawSeries(
      canvas,
      chartRect,
      points.map((point) => point.validatorThree).toList(),
      AppColors.warn,
    );
  }

  void _drawSeries(Canvas canvas, Rect rect, List<double> values, Color color) {
    if (values.isEmpty) return;
    const minValue = 98.0;
    const maxValue = 100.0;
    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final x = values.length == 1
          ? rect.left
          : rect.left + rect.width * i / (values.length - 1);
      final normalized = ((values[i] - minValue) / (maxValue - minValue)).clamp(
        0.0,
        1.0,
      );
      final y = rect.bottom - normalized * rect.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, linePaint);

    final dotFill = Paint()
      ..color = AppColors.bg
      ..style = PaintingStyle.fill;
    final dotStroke = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    for (var i = 0; i < values.length; i++) {
      final x = values.length == 1
          ? rect.left
          : rect.left + rect.width * i / (values.length - 1);
      final normalized = ((values[i] - minValue) / (maxValue - minValue)).clamp(
        0.0,
        1.0,
      );
      final y = rect.bottom - normalized * rect.height;
      canvas.drawCircle(Offset(x, y), 3.2, dotFill);
      canvas.drawCircle(Offset(x, y), 3.2, dotStroke);
    }
  }

  @override
  bool shouldRepaint(covariant _UptimeTrendPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

Color _statusColor(String status) {
  return switch (status) {
    'warning' => AppColors.warn,
    'critical' => AppColors.sell,
    _ => AppColors.buy,
  };
}

IconData _statusIcon(String status) {
  return switch (status) {
    'warning' => Icons.error_outline_rounded,
    'critical' => Icons.cancel_outlined,
    _ => Icons.check_circle_outline_rounded,
  };
}

String _statusLabel(String status) {
  return switch (status) {
    'warning' => 'Warning',
    'critical' => 'Critical',
    _ => 'Healthy',
  };
}

String _formatPercent(double value) {
  final fixed = value.toStringAsFixed(2);
  return fixed.endsWith('0') ? value.toStringAsFixed(1) : fixed;
}

String _formatEth(double value) {
  final raw = value.round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    if (i > 0 && (raw.length - i) % 3 == 0) buffer.write(',');
    buffer.write(raw[i]);
  }
  return buffer.toString();
}
