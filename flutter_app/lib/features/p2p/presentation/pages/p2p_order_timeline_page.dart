import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';

class P2POrderTimelinePage extends ConsumerWidget {
  const P2POrderTimelinePage({
    super.key,
    required this.orderId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc212_p2p_order_timeline_content');
  static const emptyKey = Key('sc212_p2p_order_timeline_empty');

  final String orderId;
  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(p2pOrderTimelineProvider(orderId));
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-212 P2POrderTimelinePage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Order #$orderId Timeline',
              subtitle: 'Order - P2P',
              showBack: true,
              onBack: () => _close(context, orderId),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: RefreshIndicator(
                  color: AppColors.primary,
                  backgroundColor: AppColors.surface,
                  onRefresh: () async {
                    HapticFeedback.selectionClick();
                    await Future<void>.delayed(
                      const Duration(milliseconds: 80),
                    );
                  },
                  child: SingleChildScrollView(
                    key: contentKey,
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    padding: EdgeInsets.only(bottom: bottomInset),
                    child: snapshot.events.isEmpty
                        ? VitPageContent(
                            key: emptyKey,
                            padding: VitContentPadding.none,
                            children: [
                              VitEmptyState(
                                icon: Icons.timeline_rounded,
                                title: snapshot.emptyTitle,
                                message: snapshot.emptySubtitle,
                              ),
                            ],
                          )
                        : VitPageContent(
                            padding: VitContentPadding.relaxed,
                            customGap: AppSpacing.x5,
                            children: [
                              const _TimelineHeroCard(),
                              _TimelineList(events: snapshot.events),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void _close(BuildContext context, String orderId) {
    HapticFeedback.selectionClick();
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.p2pOrder(orderId));
  }
}

class _TimelineHeroCard extends StatelessWidget {
  const _TimelineHeroCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.primary20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          Container(
            width: AppSpacing.ctaHeight,
            height: AppSpacing.ctaHeight,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: AppRadii.lgRadius,
            ),
            child: const Icon(
              Icons.schedule_rounded,
              color: AppColors.onAccent,
              size: AppSpacing.iconMd,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order Timeline',
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Real-time status updates',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineList extends StatelessWidget {
  const _TimelineList({required this.events});

  final List<P2POrderTimelineEventDraft> events;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: AppSpacing.x6 / 2,
          top: AppSpacing.x1,
          bottom: AppSpacing.x6,
          child: Container(width: 2, color: AppColors.borderSolid),
        ),
        Column(
          children: [
            for (var index = 0; index < events.length; index++)
              _TimelineRow(
                event: events[index],
                isLast: index == events.length - 1,
              ),
          ],
        ),
      ],
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.event, required this.isLast});

  final P2POrderTimelineEventDraft event;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(event.status);
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.x6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppSpacing.x6,
            height: AppSpacing.x6,
            decoration: BoxDecoration(
              color: _statusBackground(event.status),
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2),
            ),
            child: Icon(_eventIcon(event.typeKey), color: color, size: 18),
          ),
          const SizedBox(width: AppSpacing.x5),
          Expanded(
            child: VitCard(
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          event.title,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x2),
                      VitStatusPill(
                        label: event.statusLabel,
                        status: _pillStatus(event.status),
                        size: VitStatusPillSize.sm,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  Text(
                    'By: ${event.actor}',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    event.time,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
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

IconData _eventIcon(String typeKey) {
  return switch (typeKey) {
    'created' => Icons.schedule_rounded,
    'matched' => Icons.check_circle_outline,
    'locked' => Icons.attach_money_rounded,
    'payment' => Icons.chat_bubble_outline_rounded,
    'paid' => Icons.check_circle_outline,
    'confirming' => Icons.schedule_rounded,
    _ => Icons.error_outline,
  };
}

Color _statusColor(P2POrderTimelineStatus status) {
  return switch (status) {
    P2POrderTimelineStatus.completed => AppColors.buy,
    P2POrderTimelineStatus.pending => AppColors.warn,
    P2POrderTimelineStatus.failed => AppColors.sell,
  };
}

Color _statusBackground(P2POrderTimelineStatus status) {
  return switch (status) {
    P2POrderTimelineStatus.completed => AppColors.buy15,
    P2POrderTimelineStatus.pending => AppColors.warn15,
    P2POrderTimelineStatus.failed => AppColors.sell15,
  };
}

VitStatusPillStatus _pillStatus(P2POrderTimelineStatus status) {
  return switch (status) {
    P2POrderTimelineStatus.completed => VitStatusPillStatus.success,
    P2POrderTimelineStatus.pending => VitStatusPillStatus.warning,
    P2POrderTimelineStatus.failed => VitStatusPillStatus.error,
  };
}
