part of '../pages/launchpad_bridge_order_page.dart';

class _BridgeEventLog extends StatelessWidget {
  const _BridgeEventLog({
    required this.order,
    required this.events,
    required this.expanded,
    required this.onToggle,
  });

  final LaunchpadBridgeOrderDraft order;
  final List<LaunchpadBridgeEventDraft> events;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadBridgeOrderPage.eventLogKey,
      radius: VitCardRadius.lg,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: AppRadii.lgRadius,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Row(
                children: [
                  const Icon(
                    Icons.terminal_rounded,
                    color: AppColors.accent,
                    size: AppSpacing.iconSm,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Text(
                    'Event Log',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  _ConnectionBadge(state: order.connectionState),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: Text(
                      '${events.length} events',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ),
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AppColors.text3,
                    size: AppSpacing.iconMd,
                  ),
                ],
              ),
            ),
          ),
          if (expanded) ...[
            const Divider(height: 1, color: AppColors.divider),
            Container(
              width: double.infinity,
              color: AppColors.bg,
              padding: const EdgeInsets.all(AppSpacing.x3),
              child: Column(
                children: [for (final event in events) _EventRow(event: event)],
              ),
            ),
            const Divider(height: 1, color: AppColors.divider),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.x4,
                vertical: AppSpacing.x3,
              ),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.buy,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: Text(
                      'wss://bridge-relay.vitrading.io',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ),
                  Text(
                    '${events.length} msgs',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _EventRow extends StatelessWidget {
  const _EventRow({required this.event});

  final LaunchpadBridgeEventDraft event;

  @override
  Widget build(BuildContext context) {
    final color = _eventColor(event.level);
    return Container(
      key: LaunchpadBridgeOrderPage.eventKey(event.id),
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 68,
            child: Text(
              event.timestamp,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          Container(
            width: 36,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 1),
            decoration: BoxDecoration(
              color: color.withValues(alpha: .14),
              borderRadius: AppRadii.xsRadius,
            ),
            child: Text(
              _eventLabel(event.level),
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Text(
            '[${event.source}]',
            style: AppTextStyles.micro.copyWith(color: AppColors.accent),
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              event.message,
              style: AppTextStyles.micro.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConnectionBadge extends StatelessWidget {
  const _ConnectionBadge({required this.state});

  final LaunchpadBridgeConnectionState state;

  @override
  Widget build(BuildContext context) {
    final connected = state == LaunchpadBridgeConnectionState.connected;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: (connected ? AppColors.buy : AppColors.warn).withValues(
          alpha: .12,
        ),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Row(
        children: [
          Icon(
            connected ? Icons.wifi_rounded : Icons.wifi_find_rounded,
            color: connected ? AppColors.buy : AppColors.warn,
            size: 9,
          ),
          const SizedBox(width: AppSpacing.x1),
          Text(
            connected ? 'Connected' : 'Connecting',
            style: AppTextStyles.micro.copyWith(
              color: connected ? AppColors.buy : AppColors.warn,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}
