part of '../pages/p2p_escrow_detail_page.dart';

class _EscrowTimelineCard extends StatelessWidget {
  const _EscrowTimelineCard({required this.events});

  final List<P2PEscrowTimelineEventDraft> events;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PEscrowDetailPage.timelineKey,
      radius: VitCardRadius.lg,
      padding: AppSpacing.p2pEscrowDetailCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.schedule_rounded,
                color: AppColors.text2,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Tiến trình Escrow',
                style: AppTextStyles.baseMedium.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          for (var i = 0; i < events.length; i++)
            _TimelineRow(event: events[i], isLast: i == events.length - 1),
        ],
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.event, required this.isLast});

  final P2PEscrowTimelineEventDraft event;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final color = _timelineColor(event.status);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: AppSpacing.buttonCompact,
          child: Column(
            children: [
              SizedBox.square(
                dimension: AppSpacing.buttonCompact,
                child: Material(
                  color: _timelineBackground(event.status),
                  shape: CircleBorder(side: BorderSide(color: color)),
                  child: Icon(
                    _timelineIcon(event.iconKey),
                    color: color,
                    size: AppSpacing.p2pEscrowDetailTimelineIcon,
                  ),
                ),
              ),
              if (!isLast)
                SizedBox(
                  width: AppSpacing.dividerHairline,
                  height: AppSpacing.x5,
                  child: ColoredBox(color: color),
                ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Padding(
            padding: isLast
                ? AppSpacing.zeroInsets
                : AppSpacing.p2pEscrowDetailTimelineRowPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        event.label,
                        style: AppTextStyles.caption.copyWith(
                          color: event.status == P2POrderStepStatus.pending
                              ? AppColors.text3
                              : AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    Text(
                      event.time,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
                if (event.description.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    event.description,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SecurityNotice extends StatelessWidget {
  const _SecurityNotice({required this.snapshot});

  final P2PEscrowDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return P2PNoticeCard(
      key: P2PEscrowDetailPage.securityKey,
      icon: Icons.verified_user_outlined,
      title: snapshot.securityTitle,
      message: snapshot.securityBody,
      iconColor: AppColors.buy,
      titleColor: AppColors.buy,
      radius: VitCardRadius.lg,
      borderColor: AppColors.buy20,
      messageStyle: AppTextStyles.caption.copyWith(
        color: AppColors.text2,
        height: AppSpacing.p2pEscrowDetailBodyLineHeight,
      ),
    );
  }
}

class _OrderLink extends StatelessWidget {
  const _OrderLink({required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PEscrowDetailPage.orderLinkKey,
      radius: VitCardRadius.lg,
      padding: AppSpacing.p2pEscrowDetailCardPadding,
      onTap: () {
        HapticFeedback.selectionClick();
        context.go(AppRoutePaths.p2pOrder(orderId));
      },
      child: Row(
        children: [
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text2,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              'Xem chi tiết đơn hàng',
              style: AppTextStyles.baseMedium.copyWith(
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconSm,
          ),
        ],
      ),
    );
  }
}

class _FeedbackBanner extends StatelessWidget {
  const _FeedbackBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PEscrowDetailPage.feedbackKey,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.sm,
      borderColor: AppColors.buy20,
      padding: AppSpacing.p2pEscrowDetailInnerPadding,
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline_rounded,
            color: AppColors.buy,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Color _timelineColor(P2POrderStepStatus status) {
  return switch (status) {
    P2POrderStepStatus.completed => AppColors.buy,
    P2POrderStepStatus.active => AppModuleAccents.p2p,
    P2POrderStepStatus.pending => AppColors.text3,
  };
}

Color _timelineBackground(P2POrderStepStatus status) {
  return switch (status) {
    P2POrderStepStatus.completed => AppColors.buy10,
    P2POrderStepStatus.active => AppColors.primary12,
    P2POrderStepStatus.pending => AppColors.surface2,
  };
}

IconData _timelineIcon(String iconKey) {
  return switch (iconKey) {
    'key' => Icons.vpn_key_outlined,
    'lock' => Icons.lock_outline_rounded,
    'clock' => Icons.schedule_rounded,
    'shield' => Icons.shield_outlined,
    'unlock' => Icons.lock_open_rounded,
    _ => Icons.circle_outlined,
  };
}

String _formatAmount4(double value) => value.toStringAsFixed(4);

String _formatVnd(int value) {
  final raw = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    if (i > 0 && (raw.length - i) % 3 == 0) buffer.write('.');
    buffer.write(raw[i]);
  }
  return buffer.toString();
}
