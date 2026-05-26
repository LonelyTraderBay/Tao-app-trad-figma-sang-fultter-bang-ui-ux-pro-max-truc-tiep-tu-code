import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
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
import 'package:vit_trade_flutter/features/admin/data/admin_repository.dart';

class FunnelDashboard extends ConsumerStatefulWidget {
  const FunnelDashboard({super.key, this.shellRenderMode});

  static const contentKey = Key('sc183_funnel_content');

  static Key selectorKey(String id) => Key('sc183_funnel_selector_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<FunnelDashboard> createState() => _FunnelDashboardState();
}

class _FunnelDashboardState extends ConsumerState<FunnelDashboard> {
  late String _selectedFunnelId;

  @override
  void initState() {
    super.initState();
    _selectedFunnelId = const AdminRepository().getFunnels().selectedFunnelId;
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(adminRepositoryProvider).getFunnels();
    final selectedFunnel = snapshot.funnels.firstWhere(
      (funnel) => funnel.id == _selectedFunnelId,
      orElse: () => snapshot.funnels.first,
    );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollBottom =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome
            : DeviceMetrics.nativeBottomChrome) +
        AppSpacing.x6 +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      semanticLabel: 'SC-183 FunnelDashboard',
      child: Column(
        children: [
          VitHeader(
            title: 'Funnel Analytics',
            subtitle: 'Conversion Funnel Tracking',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.admin),
          ),
          Expanded(
            child: SingleChildScrollView(
              key: FunnelDashboard.contentKey,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(bottom: scrollBottom),
              child: VitPageContent(
                customGap: AppSpacing.x4,
                children: [
                  _FunnelSelector(
                    funnels: snapshot.funnels,
                    selectedFunnelId: _selectedFunnelId,
                    onChanged: (id) => setState(() => _selectedFunnelId = id),
                  ),
                  _MetricsGrid(snapshot: snapshot),
                  _WaterfallCard(funnel: selectedFunnel),
                  _DropoutChartCard(funnel: selectedFunnel),
                  _StepDetailsCard(funnel: selectedFunnel),
                  if (snapshot.totalSessions == 0) const _EmptyFunnelCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FunnelSelector extends StatelessWidget {
  const _FunnelSelector({
    required this.funnels,
    required this.selectedFunnelId,
    required this.onChanged,
  });

  final List<AdminConversionFunnel> funnels;
  final String selectedFunnelId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Chọn funnel',
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x3),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: funnels.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 82,
            crossAxisSpacing: AppSpacing.x3,
            mainAxisSpacing: AppSpacing.x3,
          ),
          itemBuilder: (context, index) {
            final funnel = funnels[index];
            final selected = funnel.id == selectedFunnelId;
            return GestureDetector(
              key: FunnelDashboard.selectorKey(funnel.id),
              behavior: HitTestBehavior.opaque,
              onTap: () => onChanged(funnel.id),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: selected ? AppColors.surface : AppColors.surface2,
                  borderRadius: AppRadii.inputRadius,
                  border: Border.all(
                    color: selected ? AppColors.accent : Colors.transparent,
                    width: selected ? 2 : 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.x4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        funnel.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        funnel.stepCountLabel,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _MetricsGrid extends StatelessWidget {
  const _MetricsGrid({required this.snapshot});

  final AdminFunnelsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MetricCard(
            icon: Icons.filter_alt_outlined,
            title: 'Phiên',
            value: '${snapshot.totalSessions}',
            caption: '${snapshot.completedSessions} hoàn thành',
            tint: AppColors.accent15,
            accent: AppColors.accent,
          ),
        ),
        const SizedBox(width: AppSpacing.x4),
        Expanded(
          child: _MetricCard(
            icon: Icons.check_circle_outline_rounded,
            title: 'Tỷ lệ hoàn thành',
            value: snapshot.completionRateLabel,
            caption: 'Trung bình ${snapshot.avgCompletionTimeLabel}',
            tint: AppColors.buy15,
            accent: AppColors.buy,
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.caption,
    required this.tint,
    required this.accent,
  });

  final IconData icon;
  final String title;
  final String value;
  final String caption;
  final Color tint;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: tint,
                  borderRadius: AppRadii.inputRadius,
                ),
                child: Icon(icon, color: accent, size: 20),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontSize: 11,
                      ),
                    ),
                    Text(
                      value,
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: accent,
                        fontSize: 20,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            caption,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _WaterfallCard extends StatelessWidget {
  const _WaterfallCard({required this.funnel});

  final AdminConversionFunnel funnel;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _CardTitle(
            icon: Icons.filter_alt_outlined,
            title: 'Funnel Waterfall',
          ),
          const SizedBox(height: AppSpacing.x4),
          for (var i = 0; i < funnel.steps.length; i++) ...[
            _WaterfallStep(index: i + 1, step: funnel.steps[i]),
            if (i != funnel.steps.length - 1)
              const SizedBox(height: AppSpacing.x4),
          ],
        ],
      ),
    );
  }
}

class _WaterfallStep extends StatelessWidget {
  const _WaterfallStep({required this.index, required this.step});

  final int index;
  final AdminFunnelStep step;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            _StepNumber(index: index),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Text(
                step.label,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${step.reached}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    fontFamily: 'monospace',
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
                Text(
                  '0%',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        ClipRRect(
          borderRadius: AppRadii.inputRadius,
          child: const SizedBox(
            height: 32,
            child: ColoredBox(
              color: AppColors.surface2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.x4),
                  child: Text(
                    'hoàn thành',
                    style: TextStyle(
                      color: AppColors.text1,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.x2),
        Row(
          children: [
            const Icon(
              Icons.check_circle_outline_rounded,
              color: AppColors.buy,
              size: 12,
            ),
            const SizedBox(width: AppSpacing.x1),
            Text(
              '${step.completionRateLabel} hoàn thành',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      ],
    );
  }
}

class _DropoutChartCard extends StatelessWidget {
  const _DropoutChartCard({required this.funnel});

  final AdminConversionFunnel funnel;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardTitle(
            icon: Icons.trending_down_rounded,
            title: 'Tỷ lệ rời bỏ theo bước',
          ),
          const SizedBox(height: AppSpacing.x4),
          SizedBox(
            height: 200,
            child: CustomPaint(
              painter: _DropoutChartPainter(steps: funnel.steps),
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepDetailsCard extends StatelessWidget {
  const _StepDetailsCard({required this.funnel});

  final AdminConversionFunnel funnel;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _CardTitle(
            icon: Icons.bar_chart_rounded,
            title: 'Chi tiết từng bước',
          ),
          const SizedBox(height: AppSpacing.x4),
          for (var i = 0; i < funnel.steps.length; i++) ...[
            _StepDetailRow(index: i + 1, step: funnel.steps[i]),
            if (i != funnel.steps.length - 1)
              const SizedBox(height: AppSpacing.x3),
          ],
        ],
      ),
    );
  }
}

class _StepDetailRow extends StatelessWidget {
  const _StepDetailRow({required this.index, required this.step});

  final int index;
  final AdminFunnelStep step;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.inputRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                _StepNumber(index: index),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Text(
                    step.label,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.text3,
                  size: 16,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x3),
            Row(
              children: [
                Expanded(
                  child: _DetailStat(
                    label: 'Tiếp cận',
                    value: '${step.reached}',
                  ),
                ),
                Expanded(
                  child: _DetailStat(
                    label: 'Hoàn thành',
                    value: '${step.completed}',
                    valueColor: AppColors.buy,
                  ),
                ),
                Expanded(
                  child: _DetailStat(label: 'Tỷ lệ', value: '0%'),
                ),
                Expanded(
                  child: _DetailStat(
                    label: 'Thời gian',
                    value: step.avgTimeLabel,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailStat extends StatelessWidget {
  const _DetailStat({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: valueColor,
            fontWeight: AppTextStyles.bold,
            fontFamily: 'monospace',
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _EmptyFunnelCard extends StatelessWidget {
  const _EmptyFunnelCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x6),
      child: Column(
        children: [
          const Icon(
            Icons.filter_alt_outlined,
            color: AppColors.text3,
            size: 48,
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            'Chưa có dữ liệu funnel',
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            'Dữ liệu sẽ xuất hiện khi có người dùng đi qua funnel',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _CardTitle extends StatelessWidget {
  const _CardTitle({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.text1, size: 18),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _StepNumber extends StatelessWidget {
  const _StepNumber({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.accent30,
        borderRadius: AppRadii.smRadius,
      ),
      child: Text(
        '$index',
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text1,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _DropoutChartPainter extends CustomPainter {
  const _DropoutChartPainter({required this.steps});

  final List<AdminFunnelStep> steps;

  @override
  void paint(Canvas canvas, Size size) {
    const leftPad = 28.0;
    const bottomPad = 64.0;
    const topPad = 8.0;
    const rightPad = 6.0;
    final chartWidth = math.max(1.0, size.width - leftPad - rightPad);
    final chartHeight = math.max(1.0, size.height - topPad - bottomPad);
    final chartLeft = leftPad;
    final chartTop = topPad;
    final chartBottom = topPad + chartHeight;

    final gridPaint = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 1;
    final axisPaint = Paint()
      ..color = AppColors.borderSolid
      ..strokeWidth = 1.2;

    for (var i = 0; i <= 4; i++) {
      final y = chartTop + chartHeight * i / 4;
      canvas.drawLine(Offset(chartLeft, y), Offset(size.width, y), gridPaint);
      _drawText(
        canvas,
        '${4 - i}',
        Offset(2, y - 7),
        color: AppColors.text3,
        fontSize: 10,
      );
    }

    canvas.drawLine(
      Offset(chartLeft, chartBottom),
      Offset(chartLeft + chartWidth, chartBottom),
      axisPaint,
    );

    final count = math.max(1, steps.length);
    for (var i = 0; i < steps.length; i++) {
      final x = chartLeft + chartWidth * (i + .5) / count;
      canvas.drawLine(Offset(x, chartTop), Offset(x, chartBottom), gridPaint);
      _drawRotatedText(canvas, steps[i].label, Offset(x - 4, chartBottom + 44));
    }
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset offset, {
    required Color color,
    required double fontSize,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          height: 1,
          fontFeatures: AppTextStyles.tabularFigures,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: 42);
    painter.paint(canvas, offset);
  }

  void _drawRotatedText(Canvas canvas, String text, Offset offset) {
    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    canvas.rotate(-math.pi / 4);
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(color: AppColors.text3, fontSize: 9, height: 1),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
      ellipsis: '...',
    )..layout(maxWidth: 70);
    painter.paint(canvas, Offset.zero);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _DropoutChartPainter oldDelegate) {
    return oldDelegate.steps != steps;
  }
}
