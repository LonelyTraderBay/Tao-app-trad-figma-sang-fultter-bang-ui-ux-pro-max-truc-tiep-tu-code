import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/arena/domain/entities/arena_entities.dart';
import 'package:vit_trade_flutter/features/arena/presentation/widgets/arena_mode_detail_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class ArenaModeQualitySection extends StatelessWidget {
  const ArenaModeQualitySection({
    super.key,
    required this.infoKey,
    required this.metrics,
    required this.onInfo,
  });

  final Key infoKey;
  final List<ArenaQualityMetricDraft> metrics;
  final VoidCallback onInfo;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitModuleSectionHeader(
          title: 'Chất lượng & Tin cậy',
          accentColor: AppColors.accent,
        ),
        const SizedBox(height: AppSpacing.x3),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: metrics.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppSpacing.x3,
            mainAxisSpacing: AppSpacing.x3,
            mainAxisExtent: 62,
          ),
          itemBuilder: (context, index) {
            final metric = metrics[index];
            return _QualityMetricCard(metric: metric);
          },
        ),
        const SizedBox(height: AppSpacing.x3),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            key: infoKey,
            onPressed: onInfo,
            icon: const Icon(Icons.info_outline_rounded, size: 14),
            label: const Text('Hiểu chỉ số này'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.accent,
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, AppSpacing.buttonCompact),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              textStyle: AppTextStyles.micro.copyWith(
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _QualityMetricCard extends StatelessWidget {
  const _QualityMetricCard({required this.metric});

  final ArenaQualityMetricDraft metric;

  @override
  Widget build(BuildContext context) {
    final color = arenaMetricColor(metric.status);
    final icon = arenaMetricIcon(metric.status, metric.label);
    return VitCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.x3,
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 17),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  metric.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
                Text(
                  metric.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ArenaModeTrustSheet extends StatelessWidget {
  const ArenaModeTrustSheet({super.key, required this.snapshot});

  final ArenaModeDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.x5,
          AppSpacing.x5,
          AppSpacing.x5,
          AppSpacing.x6,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const ArenaModeActionIcon(
                  icon: Icons.shield_outlined,
                  color: AppColors.buy,
                  size: 40,
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chi tiết tin cậy',
                        style: AppTextStyles.base.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      Text(
                        '${snapshot.creator.name} · ${snapshot.creator.trustScore}% Trust',
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
            for (final metric in snapshot.qualityMetrics) ...[
              _TrustSheetRow(metric: metric),
              const SizedBox(height: AppSpacing.x3),
            ],
            VitCard(
              variant: VitCardVariant.inner,
              borderColor: AppColors.accent20,
              padding: const EdgeInsets.all(AppSpacing.x3),
              child: Text(
                'Các chỉ số dựa trên lịch sử challenge, báo cáo cộng đồng và hệ thống kiểm duyệt. Đây là tín hiệu an toàn của Open Arena, không phải chỉ số tài chính.',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text3,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrustSheetRow extends StatelessWidget {
  const _TrustSheetRow({required this.metric});

  final ArenaQualityMetricDraft metric;

  @override
  Widget build(BuildContext context) {
    final color = arenaMetricColor(metric.status);
    return Row(
      children: [
        Icon(
          arenaMetricIcon(metric.status, metric.label),
          color: color,
          size: 17,
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Text(
            metric.label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.medium,
            ),
          ),
        ),
        Text(
          metric.value,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}
