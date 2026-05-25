import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
import '../data/launchpad_repository.dart';

class LaunchpadBridgeOrderPage extends ConsumerStatefulWidget {
  const LaunchpadBridgeOrderPage({
    super.key,
    this.txId = 'tx001',
    this.shellRenderMode,
  });

  static const contentKey = Key('sc303_launchpad_bridge_order_content');
  static const heroKey = Key('sc303_launchpad_bridge_order_hero');
  static const timelineKey = Key('sc303_launchpad_bridge_order_timeline');
  static const eventLogKey = Key('sc303_launchpad_bridge_order_event_log');
  static const detailsKey = Key('sc303_launchpad_bridge_order_details');
  static const safetyKey = Key('sc303_launchpad_bridge_order_safety');

  static Key stepKey(String id) => Key('sc303_launchpad_bridge_step_$id');
  static Key eventKey(String id) => Key('sc303_launchpad_bridge_event_$id');

  final String txId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<LaunchpadBridgeOrderPage> createState() =>
      _LaunchpadBridgeOrderPageState();
}

class _LaunchpadBridgeOrderPageState
    extends ConsumerState<LaunchpadBridgeOrderPage> {
  var _logExpanded = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(launchpadRepositoryProvider)
        .getBridgeOrder(widget.txId);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-303 LaunchpadBridgeOrderPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: LaunchpadBridgeOrderPage.contentKey,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: bottomInset),
                child: VitPageContent(
                  padding: VitContentPadding.defaultPadding,
                  customGap: AppSpacing.x4,
                  children: [
                    _BridgeStatusHero(order: snapshot.order),
                    _BridgeTimeline(order: snapshot.order),
                    _BridgeEventLog(
                      order: snapshot.order,
                      events: snapshot.events,
                      expanded: _logExpanded,
                      onToggle: () =>
                          setState(() => _logExpanded = !_logExpanded),
                    ),
                    _BridgeDetails(order: snapshot.order),
                    const _SimulationDisclosure(),
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

class _BridgeStatusHero extends StatelessWidget {
  const _BridgeStatusHero({required this.order});

  final LaunchpadBridgeOrderDraft order;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(order.status);
    return VitCard(
      key: LaunchpadBridgeOrderPage.heroKey,
      variant: VitCardVariant.hero,
      radius: VitCardRadius.lg,
      borderColor: order.accent.withValues(alpha: .22),
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .14),
              shape: BoxShape.circle,
            ),
            child: Icon(_statusIcon(order.status), color: color, size: 30),
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            _heroTitle(order.status),
            textAlign: TextAlign.center,
            style: AppTextStyles.sectionTitle.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            '${order.sourceChain} -> ${order.targetChain}',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _AmountColumn(
                label: 'Ban',
                value: _formatUsd(order.inputAmount),
                token: order.inputToken,
              ),
              const SizedBox(width: AppSpacing.x3),
              const Icon(
                Icons.arrow_forward_rounded,
                color: AppColors.text3,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x3),
              _AmountColumn(
                label: 'Nhan',
                value: _formatNumber(order.expectedOutput),
                token: order.outputToken,
                color: AppColors.buy,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.x3,
              vertical: AppSpacing.x2,
            ),
            decoration: BoxDecoration(
              color: AppColors.surface3.withValues(alpha: .72),
              borderRadius: BorderRadius.circular(AppRadii.xl),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.schedule_rounded,
                  color: AppColors.text2,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: AppSpacing.x2),
                Text(
                  'ETA ~${order.etaSeconds}s',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
                Text(
                  'Poll #${order.pollCount}',
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

class _AmountColumn extends StatelessWidget {
  const _AmountColumn({
    required this.label,
    required this.value,
    required this.token,
    this.color = AppColors.text1,
  });

  final String label;
  final String value;
  final String token;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        Text(
          value,
          style: AppTextStyles.baseMedium.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
        Text(
          token,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _BridgeTimeline extends StatelessWidget {
  const _BridgeTimeline({required this.order});

  final LaunchpadBridgeOrderDraft order;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadBridgeOrderPage.timelineKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                Icons.account_tree_outlined,
                color: _statusColor(order.status),
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Tien trinh',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              const _LiveBadge(),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Stack(
            children: [
              Positioned(
                left: 15,
                top: AppSpacing.x3,
                bottom: AppSpacing.x3,
                child: Container(width: 1, color: AppColors.borderSolid),
              ),
              Column(
                children: [
                  for (final step in order.steps)
                    _BridgeTimelineStep(step: step, orderStatus: order.status),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BridgeTimelineStep extends StatelessWidget {
  const _BridgeTimelineStep({required this.step, required this.orderStatus});

  final LaunchpadBridgeStepDraft step;
  final LaunchpadBridgeOrderStatus orderStatus;

  @override
  Widget build(BuildContext context) {
    final isDone = _statusIndex(step.status) < _statusIndex(orderStatus);
    final isActive = step.status == orderStatus;
    final isFuture = _statusIndex(step.status) > _statusIndex(orderStatus);
    final color = isDone
        ? AppColors.buy
        : isActive
        ? _statusColor(step.status)
        : AppColors.borderSolid;
    final opacity = isFuture ? .45 : 1.0;

    return Padding(
      key: LaunchpadBridgeOrderPage.stepKey(step.id),
      padding: const EdgeInsets.only(bottom: AppSpacing.x2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 31,
            child: Padding(
              padding: const EdgeInsets.only(top: AppSpacing.x3),
              child: Icon(
                isDone
                    ? Icons.check_circle_outline_rounded
                    : isActive
                    ? Icons.circle
                    : Icons.circle_outlined,
                color: color.withValues(alpha: opacity),
                size: isActive ? 12 : AppSpacing.iconSm,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Opacity(
              opacity: opacity,
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.x3),
                decoration: BoxDecoration(
                  color: isActive
                      ? _statusColor(step.status).withValues(alpha: .08)
                      : AppColors.surface2,
                  border: Border.all(
                    color: isActive
                        ? _statusColor(step.status).withValues(alpha: .25)
                        : Colors.transparent,
                  ),
                  borderRadius: AppRadii.smRadius,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            step.label,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                        if (step.timestamp != null)
                          Text(
                            step.timestamp!,
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                              fontFeatures: AppTextStyles.tabularFigures,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      step.detail,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LiveBadge extends StatelessWidget {
  const _LiveBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: .14),
        borderRadius: BorderRadius.circular(AppRadii.xl),
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.x1),
          Text(
            'LIVE',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.primary,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

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

class _BridgeDetails extends StatelessWidget {
  const _BridgeDetails({required this.order});

  final LaunchpadBridgeOrderDraft order;

  @override
  Widget build(BuildContext context) {
    final rows = [
      _DetailRow('Du an', order.projectName),
      _DetailRow('Route', order.routeProvider),
      _DetailRow('Hops', '${order.routeHops} buoc'),
      _DetailRow('Slippage', '${_trimDouble(order.slippage)}%'),
      _DetailRow(
        'Price Impact',
        '${_trimDouble(order.priceImpact)}%',
        color: order.priceImpact > 1 ? AppColors.warn : AppColors.buy,
      ),
      _DetailRow('Gas', order.gasCost),
      _DetailRow('Tong phi', order.totalFee),
      _DetailRow('Source Tx', order.sourceTxHash, monospace: true),
    ];

    return VitCard(
      key: LaunchpadBridgeOrderPage.detailsKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: AppColors.text2,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Chi tiet don',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          for (final row in rows) _DetailsRow(row: row),
        ],
      ),
    );
  }
}

class _DetailRow {
  const _DetailRow(
    this.label,
    this.value, {
    this.color,
    this.monospace = false,
  });

  final String label;
  final String value;
  final Color? color;
  final bool monospace;
}

class _DetailsRow extends StatelessWidget {
  const _DetailsRow({required this.row});

  final _DetailRow row;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              row.label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Flexible(
            child: Text(
              row.value,
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: row.color ?? AppColors.text1,
                fontWeight: AppTextStyles.bold,
                fontFeatures: row.monospace
                    ? AppTextStyles.tabularFigures
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SimulationDisclosure extends StatelessWidget {
  const _SimulationDisclosure();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: LaunchpadBridgeOrderPage.safetyKey,
      padding: const EdgeInsets.all(AppSpacing.x4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: .08),
        border: Border.all(color: AppColors.primary.withValues(alpha: .16)),
        borderRadius: AppRadii.lgRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.primary,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              'Đây là chế độ mô phỏng. Trạng thái được cập nhật tự động mỗi vài giây. Giao dịch không được gửi lên blockchain thật.',
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}

Color _statusColor(LaunchpadBridgeOrderStatus status) {
  return switch (status) {
    LaunchpadBridgeOrderStatus.initiated => AppColors.primary,
    LaunchpadBridgeOrderStatus.approved => AppColors.accent,
    LaunchpadBridgeOrderStatus.bridging => AppColors.warn,
    LaunchpadBridgeOrderStatus.confirming => AppColors.primarySoft,
    LaunchpadBridgeOrderStatus.swapping => AppColors.sell,
    LaunchpadBridgeOrderStatus.finalizing => AppColors.buy,
    LaunchpadBridgeOrderStatus.completed => AppColors.buy,
    LaunchpadBridgeOrderStatus.failed => AppColors.sell,
  };
}

IconData _statusIcon(LaunchpadBridgeOrderStatus status) {
  return switch (status) {
    LaunchpadBridgeOrderStatus.initiated => Icons.bolt_rounded,
    LaunchpadBridgeOrderStatus.approved => Icons.sync_rounded,
    LaunchpadBridgeOrderStatus.bridging => Icons.account_tree_outlined,
    LaunchpadBridgeOrderStatus.confirming => Icons.schedule_rounded,
    LaunchpadBridgeOrderStatus.swapping => Icons.sync_rounded,
    LaunchpadBridgeOrderStatus.finalizing => Icons.hourglass_top_rounded,
    LaunchpadBridgeOrderStatus.completed => Icons.check_circle_outline_rounded,
    LaunchpadBridgeOrderStatus.failed => Icons.error_outline_rounded,
  };
}

String _heroTitle(LaunchpadBridgeOrderStatus status) {
  return switch (status) {
    LaunchpadBridgeOrderStatus.completed => 'Bridge hoàn tất!',
    LaunchpadBridgeOrderStatus.failed => 'Bridge thất bại',
    _ => 'Đang xử lý bridge...',
  };
}

int _statusIndex(LaunchpadBridgeOrderStatus status) {
  return switch (status) {
    LaunchpadBridgeOrderStatus.initiated => 0,
    LaunchpadBridgeOrderStatus.approved => 1,
    LaunchpadBridgeOrderStatus.bridging => 2,
    LaunchpadBridgeOrderStatus.confirming => 3,
    LaunchpadBridgeOrderStatus.swapping => 4,
    LaunchpadBridgeOrderStatus.finalizing => 5,
    LaunchpadBridgeOrderStatus.completed => 6,
    LaunchpadBridgeOrderStatus.failed => 7,
  };
}

Color _eventColor(LaunchpadBridgeEventLevel level) {
  return switch (level) {
    LaunchpadBridgeEventLevel.info => AppColors.primary,
    LaunchpadBridgeEventLevel.success => AppColors.buy,
    LaunchpadBridgeEventLevel.warning => AppColors.warn,
    LaunchpadBridgeEventLevel.error => AppColors.sell,
    LaunchpadBridgeEventLevel.debug => AppColors.text3,
    LaunchpadBridgeEventLevel.system => AppColors.accent,
  };
}

String _eventLabel(LaunchpadBridgeEventLevel level) {
  return switch (level) {
    LaunchpadBridgeEventLevel.info => 'INFO',
    LaunchpadBridgeEventLevel.success => 'SUCC',
    LaunchpadBridgeEventLevel.warning => 'WARN',
    LaunchpadBridgeEventLevel.error => 'ERR',
    LaunchpadBridgeEventLevel.debug => 'DEBG',
    LaunchpadBridgeEventLevel.system => 'SYS',
  };
}

String _formatUsd(double value) {
  if (value == value.roundToDouble()) {
    return '\$${value.toInt().toString()}';
  }
  return '\$${value.toStringAsFixed(2)}';
}

String _formatNumber(num value) {
  final parts = value.toString().split('.');
  final integer = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < integer.length; i++) {
    final remaining = integer.length - i;
    buffer.write(integer[i]);
    if (remaining > 1 && remaining % 3 == 1) {
      buffer.write(',');
    }
  }
  if (parts.length > 1 && int.parse(parts.last) != 0) {
    buffer.write('.');
    buffer.write(parts.last.replaceFirst(RegExp(r'0+$'), ''));
  }
  return buffer.toString();
}

String _trimDouble(double value) {
  if (value == value.roundToDouble()) return value.toInt().toString();
  return value.toStringAsFixed(2).replaceFirst(RegExp(r'0+$'), '');
}
