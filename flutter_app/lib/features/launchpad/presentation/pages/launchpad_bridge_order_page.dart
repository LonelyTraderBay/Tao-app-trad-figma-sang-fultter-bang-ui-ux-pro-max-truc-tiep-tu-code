import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
import 'package:vit_trade_flutter/app/providers/launchpad_controller_providers.dart';

part '../widgets/launchpad_bridge_order_hero.dart';
part '../widgets/launchpad_bridge_order_timeline.dart';
part '../widgets/launchpad_bridge_order_events.dart';
part '../widgets/launchpad_bridge_order_details.dart';

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
        .watch(launchpadControllerProvider)
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
