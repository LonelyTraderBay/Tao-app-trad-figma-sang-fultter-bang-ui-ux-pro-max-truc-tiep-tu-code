import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/earn/data/earn_repository.dart';

class StakingRiskDashboardPage extends ConsumerWidget {
  const StakingRiskDashboardPage({super.key, this.shellRenderMode});

  static const scoreKey = Key('sc381_score');
  static const metricsKey = Key('sc381_metrics');
  static const exposureKey = Key('sc381_exposure');
  static const eventsKey = Key('sc381_events');
  static const actionsKey = Key('sc381_actions');
  static const footerKey = Key('sc381_footer');

  static Key metricKey(String category) => Key('sc381_metric_$category');
  static Key actionKey(String title) => Key('sc381_action_$title');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref
        .watch(stakingRiskDashboardRepositoryProvider)
        .getRiskDashboard();
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-381 StakingRiskDashboardPage',
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
                    _OverallRiskCard(snapshot: snapshot),
                    VitPageSection(
                      key: metricsKey,
                      label: 'Risk Breakdown',
                      accentColor: AppColors.primarySoft,
                      children: [
                        for (final metric in snapshot.riskMetrics)
                          _RiskMetricCard(metric: metric),
                      ],
                    ),
                    VitPageSection(
                      key: exposureKey,
                      label: 'Exposure by Asset',
                      accentColor: AppColors.primarySoft,
                      children: [_ExposureCard(exposures: snapshot.exposures)],
                    ),
                    VitPageSection(
                      key: eventsKey,
                      label: 'Recent Risk Events',
                      accentColor: AppColors.primarySoft,
                      children: [
                        for (final event in snapshot.events)
                          _RiskEventCard(event: event),
                      ],
                    ),
                    VitPageSection(
                      key: actionsKey,
                      label: 'Risk Management Actions',
                      accentColor: AppColors.primarySoft,
                      children: [_ActionsGrid(actions: snapshot.actions)],
                    ),
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

class _OverallRiskCard extends StatelessWidget {
  const _OverallRiskCard({required this.snapshot});

  final StakingRiskDashboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final color = _riskColor(snapshot.overallScore);
    final label = _riskLabel(snapshot.overallScore);
    return VitCard(
      key: StakingRiskDashboardPage.scoreKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Overall Risk Score',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x4),
          Center(
            child: Container(
              width: 128,
              height: 128,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 4),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    snapshot.overallScore.toString(),
                    style: AppTextStyles.display.copyWith(
                      color: color,
                      fontSize: 36,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  Text(
                    '/ 100',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          Center(
            child: _StatusPill(label: label, color: color),
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            'Your staking portfolio has ${label.toLowerCase()}. No immediate action required, but monitor market volatility.',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppSpacing.x5),
          Row(
            children: [
              Expanded(
                child: _MiniRiskMetric(
                  label: 'Total Staked',
                  value: _formatUsd(snapshot.totalStakedUsd),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _MiniRiskMetric(
                  label: 'At Risk',
                  value: _formatUsd(snapshot.atRiskUsd),
                  color: AppColors.warn,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _MiniRiskMetric(
                  label: 'Protected',
                  value: '${snapshot.protectedPercent}%',
                  color: AppColors.buy,
                  borderColor: AppColors.buy20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RiskMetricCard extends StatelessWidget {
  const _RiskMetricCard({required this.metric});

  final StakingRiskMetricDraft metric;

  @override
  Widget build(BuildContext context) {
    final color = _riskColor(metric.score);
    return VitCard(
      key: StakingRiskDashboardPage.metricKey(metric.category),
      radius: VitCardRadius.lg,
      onTap: metric.actionRoute == null
          ? null
          : () => context.go(metric.actionRoute!),
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
                  color: color.withValues(alpha: 0.12),
                  borderRadius: AppRadii.lgRadius,
                ),
                child: Icon(_riskIcon(metric.status), color: color),
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
                            metric.category,
                            style: AppTextStyles.baseMedium,
                          ),
                        ),
                        _ScorePill(score: metric.score, color: color),
                        if (metric.actionRoute != null) ...[
                          const SizedBox(width: AppSpacing.x2),
                          const Icon(
                            Icons.chevron_right_rounded,
                            color: AppColors.text3,
                            size: AppSpacing.iconMd,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      metric.description,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          ClipRRect(
            borderRadius: AppRadii.xsRadius,
            child: LinearProgressIndicator(
              minHeight: AppSpacing.x2,
              value: metric.score / 100,
              backgroundColor: AppColors.surface3,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExposureCard extends StatelessWidget {
  const _ExposureCard({required this.exposures});

  final List<StakingRiskExposureDraft> exposures;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          SizedBox(
            height: 180,
            child: Center(
              child: CustomPaint(
                size: const Size(148, 148),
                painter: _ExposurePiePainter(exposures),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          for (final item in exposures) ...[
            _ExposureRow(item: item),
            if (item != exposures.last) const SizedBox(height: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _ExposureRow extends StatelessWidget {
  const _ExposureRow({required this.item});

  final StakingRiskExposureDraft item;

  @override
  Widget build(BuildContext context) {
    final color = _exposureColor(item.risk);
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        children: [
          Container(
            width: AppSpacing.x3,
            height: AppSpacing.x3,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              item.asset,
              style: AppTextStyles.caption.copyWith(
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatUsd(item.valueUsd),
                style: AppTextStyles.caption.copyWith(
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
              Text(
                '${item.percentage}%',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RiskEventCard extends StatelessWidget {
  const _RiskEventCard({required this.event});

  final StakingRiskEventDraft event;

  @override
  Widget build(BuildContext context) {
    final color = _eventColor(event.type);
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: color.withValues(alpha: 0.22),
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(_eventIcon(event.type), color: color, size: AppSpacing.iconMd),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(event.title, style: AppTextStyles.caption),
                    ),
                    Text(
                      event.dateLabel,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  event.description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
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

class _ActionsGrid extends StatelessWidget {
  const _ActionsGrid({required this.actions});

  final List<StakingRiskActionDraft> actions;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: actions.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.x3,
        crossAxisSpacing: AppSpacing.x3,
        childAspectRatio: 1.55,
      ),
      itemBuilder: (context, index) {
        final action = actions[index];
        final color = _toneColor(action.tone);
        return VitCard(
          key: StakingRiskDashboardPage.actionKey(action.title),
          onTap: () => context.go(action.route),
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                _actionIcon(action.tone),
                color: color,
                size: AppSpacing.iconMd,
              ),
              const Spacer(),
              Text(
                action.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                action.subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MiniRiskMetric extends StatelessWidget {
  const _MiniRiskMetric({
    required this.label,
    required this.value,
    this.color,
    this.borderColor,
  });

  final String label;
  final String value;
  final Color? color;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: borderColor,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: AppTextStyles.baseMedium.copyWith(
                color: color ?? AppColors.text1,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
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
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shield_outlined, color: color, size: AppSpacing.iconSm),
          const SizedBox(width: AppSpacing.x2),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _ScorePill extends StatelessWidget {
  const _ScorePill({required this.score, required this.color});

  final int score;
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
        borderRadius: AppRadii.smRadius,
      ),
      child: Text(
        '$score/100',
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
          fontFeatures: AppTextStyles.tabularFigures,
        ),
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
      key: StakingRiskDashboardPage.footerKey,
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

class _ExposurePiePainter extends CustomPainter {
  const _ExposurePiePainter(this.items);

  final List<StakingRiskExposureDraft> items;

  @override
  void paint(Canvas canvas, Size size) {
    if (items.isEmpty) return;
    final rect = Offset.zero & size;
    var start = -math.pi / 2;
    final paint = Paint()..style = PaintingStyle.fill;
    for (final item in items) {
      final sweep = math.pi * 2 * item.percentage / 100;
      paint.color = _exposureColor(item.risk);
      canvas.drawArc(rect, start, sweep, true, paint);
      start += sweep;
    }
    final border = Paint()
      ..color = AppColors.borderSolid
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(size.center(Offset.zero), size.width / 2, border);
  }

  @override
  bool shouldRepaint(covariant _ExposurePiePainter oldDelegate) {
    return oldDelegate.items != items;
  }
}

Color _riskColor(int score) {
  if (score < 25) return AppColors.buy;
  if (score < 50) return AppColors.warn;
  if (score < 75) return const Color(0xFFF97316);
  return AppColors.sell;
}

String _riskLabel(int score) {
  if (score < 25) return 'Low Risk';
  if (score < 50) return 'Moderate Risk';
  if (score < 75) return 'High Risk';
  return 'Critical Risk';
}

IconData _riskIcon(String status) {
  return switch (status) {
    'low' => Icons.shield_outlined,
    'critical' => Icons.warning_amber_rounded,
    _ => Icons.error_outline_rounded,
  };
}

Color _exposureColor(String risk) {
  return risk == 'low' ? AppColors.buy : AppColors.warn;
}

Color _eventColor(String type) {
  return switch (type) {
    'warning' => AppColors.warn,
    'resolved' => AppColors.buy,
    _ => AppColors.primarySoft,
  };
}

IconData _eventIcon(String type) {
  return switch (type) {
    'warning' => Icons.warning_amber_rounded,
    'resolved' => Icons.shield_outlined,
    _ => Icons.monitor_heart_outlined,
  };
}

Color _toneColor(String tone) {
  return switch (tone) {
    'sell' => AppColors.sell,
    'buy' => AppColors.buy,
    'accent' => AppColors.accent,
    _ => AppColors.primarySoft,
  };
}

IconData _actionIcon(String tone) {
  return switch (tone) {
    'sell' => Icons.warning_amber_rounded,
    'buy' => Icons.shield_outlined,
    'accent' => Icons.verified_user_outlined,
    _ => Icons.monitor_heart_outlined,
  };
}

String _formatUsd(double value) {
  final fixed = value.toStringAsFixed(2);
  final parts = fixed.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    if (i > 0 && (whole.length - i) % 3 == 0) buffer.write(',');
    buffer.write(whole[i]);
  }
  return '\$${buffer.toString()}.${parts.last}';
}
