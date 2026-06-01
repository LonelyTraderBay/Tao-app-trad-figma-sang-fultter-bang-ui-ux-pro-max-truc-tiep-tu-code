import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';

part '../widgets/p2p_transaction_limits_page_sections.dart';
part '../widgets/p2p_transaction_limits_page_common.dart';

class P2PTransactionLimitsPage extends ConsumerWidget {
  const P2PTransactionLimitsPage({super.key, this.shellRenderMode});

  static const tierHeroKey = Key('sc266_p2p_limits_tier_hero');
  static const usageKey = Key('sc266_p2p_limits_usage');
  static const trackerLinkKey = Key('sc266_p2p_limits_tracker_link');
  static const detailsKey = Key('sc266_p2p_limits_details');
  static const upgradeKey = Key('sc266_p2p_limits_upgrade');
  static const upgradeCtaKey = Key('sc266_p2p_limits_upgrade_cta');
  static const infoKey = Key('sc266_p2p_limits_info');

  static Key usageItemKey(String id) => Key('sc266_p2p_limits_usage_$id');

  static Key detailItemKey(String id) => Key('sc266_p2p_limits_detail_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(p2pTransactionLimitsProvider);
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-266 P2PTransactionLimitsPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              subtitle: snapshot.subtitle,
              showBack: true,
              onBack: () => context.go(snapshot.parentRoute),
              trailing: const _HeaderChartButton(),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.contentPad,
                    AppSpacing.x4,
                    AppSpacing.contentPad,
                    bottomInset,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _TierHero(tier: snapshot.currentTier),
                      const SizedBox(height: AppSpacing.x5),
                      _CurrentUsage(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x6),
                      _LimitDetails(items: snapshot.detailItems),
                      const SizedBox(height: AppSpacing.x6),
                      _UpgradeCard(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x6),
                      _LimitInfoNotice(items: snapshot.infoBullets),
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
