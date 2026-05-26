import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/p2p/data/p2p_repository.dart';

class P2PDisputesPage extends ConsumerWidget {
  const P2PDisputesPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc222_p2p_disputes_content');

  static Key disputeKey(String disputeId) =>
      Key('sc222_p2p_disputes_$disputeId');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(p2pRepositoryProvider).getDisputes();
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-222 P2PDisputesPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Tranh chấp P2P',
              subtitle: 'Tranh chấp · P2P',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2p),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: P2PDisputesPage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.contentPad,
                    AppSpacing.x5,
                    AppSpacing.contentPad,
                    bottomInset,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _StatsRow(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x4),
                      _SafetyNotice(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x5),
                      _ListHeader(activeCount: snapshot.activeCount),
                      const SizedBox(height: AppSpacing.x3),
                      if (snapshot.disputes.isEmpty)
                        _EmptyDisputes(snapshot: snapshot)
                      else
                        for (final dispute in snapshot.disputes) ...[
                          _DisputeListTile(dispute: dispute),
                          const SizedBox(height: AppSpacing.x3),
                        ],
                      const SizedBox(height: AppSpacing.x2),
                      _GuideCard(snapshot: snapshot),
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
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.snapshot});

  final P2PDisputesSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.balance_rounded,
            value: snapshot.totalCount.toString(),
            label: 'Tổng cộng',
            color: AppColors.sell,
          ),
        ),
        const SizedBox(width: AppSpacing.x4),
        Expanded(
          child: _StatCard(
            icon: Icons.schedule_rounded,
            value: snapshot.activeCount.toString(),
            label: 'Đang xử lý',
            color: AppColors.warn,
          ),
        ),
        const SizedBox(width: AppSpacing.x4),
        Expanded(
          child: _StatCard(
            icon: Icons.check_circle_outline_rounded,
            value: snapshot.resolvedCount.toString(),
            label: 'Đã giải quyết',
            color: AppColors.buy,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      height: AppSpacing.buttonHero + AppSpacing.x5,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: AppSpacing.x6,
            height: AppSpacing.x6,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: AppSpacing.iconSm),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            value,
            style: AppTextStyles.sectionTitle.copyWith(
              color: color == AppColors.sell ? AppColors.text1 : color,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
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

class _SafetyNotice extends StatelessWidget {
  const _SafetyNotice({required this.snapshot});

  final P2PDisputesSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: AppSpacing.buttonHero + AppSpacing.x1,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x4,
      ),
      decoration: BoxDecoration(
        color: AppModuleAccents.p2p.withValues(alpha: .08),
        border: Border.all(color: AppModuleAccents.p2p.withValues(alpha: .18)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.verified_user_outlined,
            color: AppModuleAccents.p2p,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.noticeTitle,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  snapshot.notice,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: 1.55,
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

class _ListHeader extends StatelessWidget {
  const _ListHeader({required this.activeCount});

  final int activeCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Danh sách tranh chấp',
            style: AppTextStyles.sectionTitle.copyWith(fontSize: 18),
          ),
        ),
        if (activeCount > 0)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: AppSpacing.x2,
                height: AppSpacing.x2,
                decoration: const BoxDecoration(
                  color: AppColors.warn,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppSpacing.x1),
              Text(
                '$activeCount đang xử lý',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.warn,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _EmptyDisputes extends StatelessWidget {
  const _EmptyDisputes({required this.snapshot});

  final P2PDisputesSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        children: [
          const Icon(
            Icons.verified_user_outlined,
            color: AppColors.text3,
            size: AppSpacing.iconLg,
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            snapshot.emptyTitle,
            style: AppTextStyles.body.copyWith(color: AppColors.text2),
          ),
          Text(
            snapshot.emptySubtitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _DisputeListTile extends StatelessWidget {
  const _DisputeListTile({required this.dispute});

  final P2PDisputeListItemDraft dispute;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(dispute.status);
    return VitCard(
      key: P2PDisputesPage.disputeKey(dispute.id),
      onTap: () {
        HapticFeedback.selectionClick();
        context.go(AppRoutePaths.p2pDisputeDetail(dispute.id));
      },
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: AppSpacing.inputHeight,
                height: AppSpacing.inputHeight,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .12),
                  shape: BoxShape.circle,
                ),
                child: Icon(_statusIcon(dispute.status), color: color),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '#${dispute.shortOrderNumber}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      dispute.createdAt,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusPill(label: dispute.statusLabel, color: color),
              const SizedBox(width: AppSpacing.x2),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.text3,
                size: AppSpacing.iconSm,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            dispute.reason,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              _MetaItem(
                icon: Icons.description_outlined,
                label: '${dispute.evidenceCount} bằng chứng',
              ),
              const SizedBox(width: AppSpacing.x5),
              _MetaItem(
                icon: Icons.schedule_rounded,
                label: '${dispute.timelineCount} sự kiện',
              ),
            ],
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
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.smRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  const _MetaItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.text3, size: 11),
        const SizedBox(width: AppSpacing.x1),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _GuideCard extends StatelessWidget {
  const _GuideCard({required this.snapshot});

  final P2PDisputesSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      constraints: const BoxConstraints(
        minHeight: AppSpacing.buttonHero + AppSpacing.x7,
      ),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: AppModuleAccents.p2p,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                snapshot.guideTitle,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          for (var index = 0; index < snapshot.guideSteps.length; index++) ...[
            Text(
              '${index + 1}. ${snapshot.guideSteps[index]}',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
            if (index < snapshot.guideSteps.length - 1)
              const SizedBox(height: AppSpacing.x1),
          ],
        ],
      ),
    );
  }
}

Color _statusColor(P2PDisputeStatus status) {
  return switch (status) {
    P2PDisputeStatus.submitted => AppColors.warn,
    P2PDisputeStatus.underReview => AppModuleAccents.p2p,
    P2PDisputeStatus.resolved => AppColors.buy,
    P2PDisputeStatus.rejected => AppColors.sell,
  };
}

IconData _statusIcon(P2PDisputeStatus status) {
  return switch (status) {
    P2PDisputeStatus.submitted => Icons.schedule_rounded,
    P2PDisputeStatus.underReview => Icons.description_outlined,
    P2PDisputeStatus.resolved => Icons.check_circle_outline_rounded,
    P2PDisputeStatus.rejected => Icons.warning_amber_rounded,
  };
}
