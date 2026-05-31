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
import 'package:vit_trade_flutter/app/providers/admin_controller_providers.dart';
import 'package:vit_trade_flutter/features/admin/presentation/widgets/admin_dashboard_state_content.dart';

class ABTestDashboard extends ConsumerStatefulWidget {
  const ABTestDashboard({super.key, this.shellRenderMode});

  static const contentKey = Key('sc182_abtests_content');

  static Key testKey(String id) => Key('sc182_abtest_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ABTestDashboard> createState() => _ABTestDashboardState();
}

class _ABTestDashboardState extends ConsumerState<ABTestDashboard> {
  String? _selectedTestId;

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(adminAbTestsControllerProvider);
    final snapshot = controller.state.snapshot;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollBottom =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome
            : DeviceMetrics.nativeBottomChrome) +
        AppSpacing.x6 +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      semanticLabel: 'SC-182 ABTestDashboard',
      child: Column(
        children: [
          VitHeader(
            title: 'A/B Test Dashboard',
            subtitle: 'Test Results & Analysis',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.admin),
          ),
          Expanded(
            child: SingleChildScrollView(
              key: ABTestDashboard.contentKey,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(bottom: scrollBottom),
              child: VitPageContent(
                customGap: AppSpacing.x4,
                children: [
                  AdminDashboardStateContent(
                    status: controller.state.status,
                    title: 'A/B test dashboard',
                    message: controller.state.message,
                    gap: AppSpacing.x4,
                    children: [
                      _SummaryGrid(snapshot: snapshot),
                      const _SectionTitle(title: 'Tất cả A/B Tests'),
                      if (snapshot.tests.isEmpty)
                        const _EmptyTestsCard()
                      else
                        for (final test in snapshot.tests) ...[
                          _ABTestCard(
                            test: test,
                            selected: test.id == _selectedTestId,
                            onTap: () {
                              setState(() {
                                _selectedTestId = test.id == _selectedTestId
                                    ? null
                                    : test.id;
                              });
                            },
                          ),
                        ],
                    ],
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

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({required this.snapshot});

  final AdminAbTestsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            icon: Icons.science_outlined,
            label: 'Tests đang chạy',
            value: '${snapshot.activeTests}',
            delta: '0.0%',
            timeframe: 'Current tests',
            tint: AppColors.accent15,
            accent: AppColors.accent,
          ),
        ),
        const SizedBox(width: AppSpacing.x4),
        Expanded(
          child: _SummaryCard(
            icon: Icons.workspace_premium_outlined,
            label: 'Có kết quả',
            value: '${snapshot.completedTests}',
            delta: '0.0%',
            timeframe: 'Current tests',
            tint: AppColors.buy15,
            accent: AppColors.buy,
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.delta,
    required this.timeframe,
    required this.tint,
    required this.accent,
  });

  final IconData icon;
  final String label;
  final String value;
  final String delta;
  final String timeframe;
  final Color tint;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
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
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 11,
                  ),
                ),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.sectionTitle.copyWith(
                    fontSize: 20,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                Wrap(
                  spacing: AppSpacing.x2,
                  runSpacing: AppSpacing.x1,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    VitStatusPill(
                      label: delta,
                      status: delta.startsWith('-')
                          ? VitStatusPillStatus.error
                          : VitStatusPillStatus.success,
                      size: VitStatusPillSize.sm,
                    ),
                    Text(
                      timeframe,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.baseMedium.copyWith(fontWeight: AppTextStyles.bold),
    );
  }
}

class _ABTestCard extends StatelessWidget {
  const _ABTestCard({
    required this.test,
    required this.selected,
    required this.onTap,
  });

  final AdminAbTestSummary test;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: '${test.name} A/B test',
      child: VitCard(
        key: ABTestDashboard.testKey(test.id),
        onTap: onTap,
        padding: const EdgeInsets.all(AppSpacing.x4),
        borderColor: selected ? AppColors.accent30 : AppColors.cardBorder,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TestHeader(test: test),
            const SizedBox(height: AppSpacing.x4),
            _StatsRow(test: test),
            const SizedBox(height: AppSpacing.x4),
            for (final variant in test.variants) ...[
              _VariantResult(variant: variant),
              if (variant != test.variants.last)
                const SizedBox(height: AppSpacing.x3),
            ],
            if (selected) ...[
              const SizedBox(height: AppSpacing.x4),
              const Divider(height: 1, color: AppColors.divider),
              const SizedBox(height: AppSpacing.x4),
              _ExpandedDetails(test: test),
            ],
          ],
        ),
      ),
    );
  }
}

class _TestHeader extends StatelessWidget {
  const _TestHeader({required this.test});

  final AdminAbTestSummary test;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.science_outlined, color: AppColors.accent, size: 16),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                test.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                test.id,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        VitStatusPill(
          label: test.status == AdminAbTestStatus.active
              ? 'DANG CHAY'
              : 'HOAN THANH',
          status: test.status == AdminAbTestStatus.active
              ? VitStatusPillStatus.info
              : VitStatusPillStatus.success,
          size: VitStatusPillSize.sm,
        ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.test});

  final AdminAbTestSummary test;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MiniStat(label: 'Mẫu', value: '${test.sampleSize}'),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: _MiniStat(label: 'Độ tin cậy', value: test.confidenceLabel),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: _MiniStat(label: 'Lift', value: test.liftLabel),
        ),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Admin A/B test metric $label: $value',
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.surface2,
          borderRadius: AppRadii.inputRadius,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x3,
            vertical: AppSpacing.x3,
          ),
          child: Column(
            children: [
              Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              Text(
                value,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  fontFamily: 'monospace',
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VariantResult extends StatelessWidget {
  const _VariantResult({required this.variant});

  final AdminAbTestVariant variant;

  @override
  Widget build(BuildContext context) {
    final rate = variant.exposures == 0
        ? 0.0
        : (variant.conversions / variant.exposures).clamp(0.0, 1.0).toDouble();
    return Semantics(
      label:
          '${variant.label} variant conversion rate ${variant.conversionRateLabel}, ${variant.conversions} of ${variant.exposures} conversions',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  variant.label,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Text(
                variant.conversionRateLabel,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  fontFamily: 'monospace',
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          ClipRRect(
            borderRadius: AppRadii.xsRadius,
            child: SizedBox(
              height: 7,
              child: Stack(
                children: [
                  const Positioned.fill(
                    child: ColoredBox(color: AppColors.surface2),
                  ),
                  FractionallySizedBox(
                    widthFactor: rate,
                    alignment: Alignment.centerLeft,
                    child: ColoredBox(color: _variantAccent(variant)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            '${variant.conversions} / ${variant.exposures} conversions',
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _ExpandedDetails extends StatelessWidget {
  const _ExpandedDetails({required this.test});

  final AdminAbTestSummary test;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: _DetailStat(label: 'Z-Score', value: test.zScoreLabel),
            ),
            const SizedBox(width: AppSpacing.x4),
            Expanded(
              child: _DetailStat(label: 'P-Value', value: test.pValueLabel),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x4),
        DecoratedBox(
          decoration: const BoxDecoration(
            color: AppColors.warn08,
            borderRadius: AppRadii.inputRadius,
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.x3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  color: AppColors.warn,
                  size: 16,
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cần thêm dữ liệu',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.warn,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      Text(
                        'Độ tin cậy ${test.confidenceLabel} < 95%',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        Row(
          children: [
            Text(
              'Kích thước mẫu',
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
            const Spacer(),
            Text(
              '${test.sampleSize} / ${test.minSampleSize}',
              style: AppTextStyles.caption.copyWith(
                fontWeight: AppTextStyles.bold,
                fontFamily: 'monospace',
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        ClipRRect(
          borderRadius: AppRadii.xsRadius,
          child: const SizedBox(
            height: 7,
            child: ColoredBox(color: AppColors.surface2),
          ),
        ),
      ],
    );
  }
}

class _DetailStat extends StatelessWidget {
  const _DetailStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          style: AppTextStyles.baseMedium.copyWith(
            fontSize: 15,
            fontFamily: 'monospace',
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _EmptyTestsCard extends StatelessWidget {
  const _EmptyTestsCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x6),
      child: Column(
        children: [
          const Icon(Icons.science_outlined, color: AppColors.text3, size: 48),
          const SizedBox(height: AppSpacing.x4),
          Text(
            'Chưa có A/B test nào',
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            'Tạo test mới để bắt đầu thử nghiệm',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

Color _variantAccent(AdminAbTestVariant variant) {
  if (variant.isWinner) return AppColors.buy;
  if (variant.isControl) return AppColors.accent;
  return AppColors.primary;
}
