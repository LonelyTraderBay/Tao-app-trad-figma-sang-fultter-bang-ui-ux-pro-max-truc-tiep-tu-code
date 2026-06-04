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
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

const _trackingBackground = AppColors.bg;
const _trackingPanel = AppColors.surface;
const _trackingPanel2 = AppColors.surface3;
const _trackingBorder = AppColors.borderSolid;
const _trackingPrimary = AppColors.primary;
const _trackingGreen = AppColors.buy;
const _trackingAmber = AppColors.caution;

class ComplaintTrackingPage extends ConsumerWidget {
  const ComplaintTrackingPage({
    super.key,
    this.complaintId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc113_complaint_tracking_content');
  static Key actionKey(String id) => Key('sc113_tracking_action_$id');

  final String? complaintId;
  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getComplaintTracking(complaintId: complaintId);
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 38
            : DeviceMetrics.nativeBottomChrome + 24) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-113 ComplaintTrackingPage',
      child: Material(
        color: _trackingBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Complaint ${snapshot.complaintId}',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.tradeCopyComplaintsHandling),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: contentKey,
                  padding: EdgeInsets.fromLTRB(20, 13, 20, bottomInset),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _StatusCard(snapshot: snapshot),
                      const SizedBox(height: 26),
                      _DeadlineNotice(snapshot: snapshot),
                      const SizedBox(height: 26),
                      const _SectionLabel('Investigation Timeline'),
                      const SizedBox(height: 13),
                      _TimelineList(steps: snapshot.timeline),
                      const SizedBox(height: 22),
                      for (final action in snapshot.actions) ...[
                        _TrackingActionButton(action: action),
                        if (action != snapshot.actions.last)
                          const SizedBox(height: 13),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.snapshot});

  final TradeComplaintTrackingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(17, 17, 17, 16),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _trackingAmber.withValues(alpha: .15),
                  borderRadius: AppRadii.cardRadius,
                ),
                child: const Icon(
                  Icons.schedule_rounded,
                  color: _trackingAmber,
                  size: 24,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Status',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          fontSize: 10,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        snapshot.statusLabel,
                        style: AppTextStyles.base.copyWith(
                          color: AppColors.text1,
                          fontSize: 16,
                          fontWeight: AppTextStyles.bold,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatusMetricBox(
                  label: 'Submitted',
                  value: snapshot.submittedLabel,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatusMetricBox(
                  label: 'Response Due',
                  value: snapshot.responseDueLabel,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusMetricBox extends StatelessWidget {
  const _StatusMetricBox({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 51,
      padding: const EdgeInsets.fromLTRB(11, 9, 11, 8),
      decoration: BoxDecoration(
        color: _trackingPanel2,
        borderRadius: AppRadii.inputRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 9,
              height: 1,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text1,
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

class _DeadlineNotice extends StatelessWidget {
  const _DeadlineNotice({required this.snapshot});

  final TradeComplaintTrackingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(13, 12, 13, 12),
      decoration: BoxDecoration(
        color: _trackingAmber.withValues(alpha: .11),
        border: Border.all(color: _trackingAmber.withValues(alpha: .45)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.error_outline_rounded,
              color: _trackingAmber,
              size: 16,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${snapshot.daysRemaining} Days Remaining',
                  style: AppTextStyles.micro.copyWith(
                    color: _trackingAmber,
                    fontSize: 11,
                    fontWeight: AppTextStyles.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  snapshot.deadlineNotice,
                  style: AppTextStyles.micro.copyWith(
                    color: _trackingAmber,
                    fontSize: 10,
                    height: 1.35,
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
            color: _trackingPrimary,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
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

class _TimelineList extends StatelessWidget {
  const _TimelineList({required this.steps});

  final List<TradeComplaintTrackingStep> steps;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < steps.length; index++)
          _TimelineStepRow(
            step: steps[index],
            hasConnector: index < steps.length - 1,
          ),
      ],
    );
  }
}

class _TimelineStepRow extends StatelessWidget {
  const _TimelineStepRow({required this.step, required this.hasConnector});

  final TradeComplaintTrackingStep step;
  final bool hasConnector;

  @override
  Widget build(BuildContext context) {
    final color = switch (step.state) {
      TradeComplaintTrackingStepState.completed => _trackingGreen,
      TradeComplaintTrackingStepState.current => _trackingAmber,
      TradeComplaintTrackingStepState.pending => _trackingBorder,
    };

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 32,
          child: Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color.withValues(
                    alpha: step.state == TradeComplaintTrackingStepState.pending
                        ? .55
                        : .15,
                  ),
                  shape: BoxShape.circle,
                ),
                child: _TimelineIcon(state: step.state),
              ),
              if (hasConnector)
                Container(
                  width: 2,
                  height: 48,
                  margin: const EdgeInsets.symmetric(vertical: 1),
                  color: step.state == TradeComplaintTrackingStepState.completed
                      ? _trackingGreen
                      : _trackingBorder,
                ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 12,
                    fontWeight: AppTextStyles.bold,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  step.description,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 10,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  step.dateLabel,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 9,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TimelineIcon extends StatelessWidget {
  const _TimelineIcon({required this.state});

  final TradeComplaintTrackingStepState state;

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      TradeComplaintTrackingStepState.completed => const Icon(
        Icons.check_circle_outline_rounded,
        color: _trackingGreen,
        size: 17,
      ),
      TradeComplaintTrackingStepState.current => const Icon(
        Icons.schedule_rounded,
        color: _trackingAmber,
        size: 17,
      ),
      TradeComplaintTrackingStepState.pending => Center(
        child: Container(
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: AppColors.text3,
            shape: BoxShape.circle,
          ),
        ),
      ),
    };
  }
}

class _TrackingActionButton extends StatelessWidget {
  const _TrackingActionButton({required this.action});

  final TradeComplaintTrackingAction action;

  @override
  Widget build(BuildContext context) {
    final accent = switch (action.icon) {
      TradeComplaintTrackingActionIcon.message => _trackingPrimary,
      TradeComplaintTrackingActionIcon.document => _trackingGreen,
      TradeComplaintTrackingActionIcon.warning => _trackingAmber,
    };
    final icon = switch (action.icon) {
      TradeComplaintTrackingActionIcon.message => Icons.chat_bubble_outline,
      TradeComplaintTrackingActionIcon.document => Icons.description_outlined,
      TradeComplaintTrackingActionIcon.warning => Icons.error_outline_rounded,
    };

    return InkWell(
      key: ComplaintTrackingPage.actionKey(action.id),
      borderRadius: AppRadii.cardRadius,
      onTap: () {
        final routePath = action.routePath;
        if (routePath == null) return;
        context.go(routePath);
      },
      child: Container(
        height: 43,
        padding: const EdgeInsets.symmetric(horizontal: 13),
        decoration: BoxDecoration(
          color: _trackingPanel2,
          border: Border.all(color: _trackingBorder),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Row(
          children: [
            Icon(icon, color: accent, size: 16),
            const SizedBox(width: 11),
            Expanded(
              child: Text(
                action.label,
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
              size: 18,
            ),
          ],
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
        color: _trackingPanel,
        border: Border.all(color: _trackingBorder.withValues(alpha: .76)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: child,
    );
  }
}
