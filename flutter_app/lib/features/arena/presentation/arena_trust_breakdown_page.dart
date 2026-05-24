import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
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
import '../data/arena_repository.dart';

class ArenaTrustBreakdownPage extends ConsumerWidget {
  const ArenaTrustBreakdownPage({
    super.key,
    required this.entityId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc199_trust_content');
  static const creatorLinkKey = Key('sc199_creator_link');
  static const safetyLinkKey = Key('sc199_safety_link');
  static const closeKey = Key('sc199_close');

  final String entityId;
  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref
        .watch(arenaRepositoryProvider)
        .getArenaTrustBreakdown(entityId);
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-199 ArenaTrustBreakdownPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Trust Score',
              subtitle: 'Độ tin cậy · Open Arena',
              showBack: true,
              onBack: () => _close(context),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: snapshot.creator == null
                      ? VitPageContent(
                          padding: VitContentPadding.none,
                          children: [
                            VitEmptyState(
                              icon: Icons.warning_amber_rounded,
                              title: snapshot.emptyTitle,
                              message: snapshot.emptySubtitle,
                            ),
                          ],
                        )
                      : VitPageContent(
                          padding: VitContentPadding.compact,
                          customGap: AppSpacing.x5,
                          children: [
                            _TrustBreakdownCard(snapshot: snapshot),
                            _CreatorProfileLink(snapshot: snapshot),
                            _SafetyLink(snapshot: snapshot),
                            VitCtaButton(
                              key: closeKey,
                              onPressed: () => _close(context),
                              child: const Text('Đóng'),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void _close(BuildContext context) {
    HapticFeedback.selectionClick();
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.arena);
  }
}

class _TrustBreakdownCard extends StatelessWidget {
  const _TrustBreakdownCard({required this.snapshot});

  final ArenaTrustBreakdownSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final creator = snapshot.creator!;
    return VitModuleHeroCard(
      accentColor: AppColors.buy,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.buy10,
                  borderRadius: AppRadii.cardRadius,
                  border: Border.all(color: AppColors.buy20),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${creator.trustScore}',
                  style: AppTextStyles.pageTitle.copyWith(
                    color: AppColors.buy,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${creator.name} Trust Score',
                      style: AppTextStyles.baseMedium.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      'Community metrics: Fair Play, completion, report rate và dispute rate.',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        height: 1.4,
                      ),
                    ),
                    if (creator.fairPlayBadge) ...[
                      const SizedBox(height: AppSpacing.x2),
                      const VitStatusPill(
                        label: 'Fair Play',
                        status: VitStatusPillStatus.success,
                        size: VitStatusPillSize.sm,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Column(
            children: [
              for (final metric in snapshot.metrics) ...[
                _TrustMetricRow(metric: metric),
                if (metric != snapshot.metrics.last)
                  const Divider(
                    height: AppSpacing.x4,
                    color: AppColors.divider,
                  ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            snapshot.disclaimer,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _TrustMetricRow extends StatelessWidget {
  const _TrustMetricRow({required this.metric});

  final ArenaCreatorTrustMetricDraft metric;

  @override
  Widget build(BuildContext context) {
    final color = _metricColor(metric.kind);
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: .14),
            borderRadius: AppRadii.mdRadius,
          ),
          child: Icon(_metricIcon(metric.kind), color: color, size: 18),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Text(
            metric.label,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
        Text(
          metric.value,
          style: AppTextStyles.baseMedium.copyWith(
            color: color,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _CreatorProfileLink extends StatelessWidget {
  const _CreatorProfileLink({required this.snapshot});

  final ArenaTrustBreakdownSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final creator = snapshot.creator!;
    return VitCard(
      key: ArenaTrustBreakdownPage.creatorLinkKey,
      onTap: () {
        HapticFeedback.selectionClick();
        context.go(AppRoutePaths.arenaCreator(creator.id));
      },
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.surface2,
              borderRadius: AppRadii.mdRadius,
            ),
            alignment: Alignment.center,
            child: Text(
              'CM',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  creator.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Xem profile đầy đủ',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.text3),
        ],
      ),
    );
  }
}

class _SafetyLink extends StatelessWidget {
  const _SafetyLink({required this.snapshot});

  final ArenaTrustBreakdownSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitModuleHeroCard(
      key: ArenaTrustBreakdownPage.safetyLinkKey,
      accentColor: AppColors.buy,
      onTap: () {
        HapticFeedback.selectionClick();
        context.go(AppRoutePaths.arenaSafety);
      },
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.shield_outlined, color: AppColors.buy, size: 20),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.safetyTitle,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  snapshot.safetyDescription,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  'Xem quy tắc an toàn',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.buy,
                    fontWeight: AppTextStyles.bold,
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

Color _metricColor(ArenaCreatorTrustMetricKind kind) {
  switch (kind) {
    case ArenaCreatorTrustMetricKind.fairPlay:
    case ArenaCreatorTrustMetricKind.disputeRate:
      return AppColors.buy;
    case ArenaCreatorTrustMetricKind.completion:
      return AppColors.primary;
    case ArenaCreatorTrustMetricKind.communityRating:
      return AppColors.warn;
  }
}

IconData _metricIcon(ArenaCreatorTrustMetricKind kind) {
  switch (kind) {
    case ArenaCreatorTrustMetricKind.fairPlay:
      return Icons.shield_outlined;
    case ArenaCreatorTrustMetricKind.disputeRate:
      return Icons.outlined_flag_rounded;
    case ArenaCreatorTrustMetricKind.completion:
      return Icons.verified_outlined;
    case ArenaCreatorTrustMetricKind.communityRating:
      return Icons.star_outline_rounded;
  }
}
