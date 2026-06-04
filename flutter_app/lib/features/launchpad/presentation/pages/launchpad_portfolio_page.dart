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
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/launchpad_controller_providers.dart';

part '../widgets/launchpad_portfolio_hero_tabs.dart';
part '../widgets/launchpad_portfolio_subscription.dart';
part '../widgets/launchpad_portfolio_empty_disclaimer_common.dart';

class LaunchpadPortfolioPage extends ConsumerStatefulWidget {
  const LaunchpadPortfolioPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc296_launchpad_portfolio_content');
  static const heroKey = Key('sc296_launchpad_portfolio_hero');
  static const tabsKey = Key('sc296_launchpad_portfolio_tabs');
  static const disclaimerKey = Key('sc296_launchpad_portfolio_disclaimer');

  static Key tabKey(String id) => Key('sc296_launchpad_portfolio_tab_$id');
  static Key subscriptionKey(String id) =>
      Key('sc296_launchpad_portfolio_subscription_$id');
  static Key claimKey(String id) => Key('sc296_launchpad_portfolio_claim_$id');
  static Key refundKey(String id) =>
      Key('sc296_launchpad_portfolio_refund_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<LaunchpadPortfolioPage> createState() =>
      _LaunchpadPortfolioPageState();
}

class _LaunchpadPortfolioPageState
    extends ConsumerState<LaunchpadPortfolioPage> {
  var _activeTab = _PortfolioTab.all;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(launchpadControllerProvider).getPortfolio();
    final subscriptions = _subscriptionsFor(snapshot.subscriptions, _activeTab);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-296 LaunchpadPortfolioPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          bottomInset: bottomInset,
          semanticLabel: 'SC-296 LaunchpadPortfolioPage scroll surface',
          header: VitHeader(
            title: snapshot.title,
            subtitle: snapshot.subtitle,
            showBack: true,
            onBack: () => context.go(snapshot.backRoute),
          ),
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(
              context,
            ).copyWith(scrollbars: false),
            child: SingleChildScrollView(
              key: LaunchpadPortfolioPage.contentKey,
              physics: const BouncingScrollPhysics(),
              child: VitPageContent(
                padding: VitContentPadding.defaultPadding,
                customGap: AppSpacing.x4,
                children: [
                  _PortfolioHero(subscriptions: snapshot.subscriptions),
                  _PortfolioTabs(
                    activeTab: _activeTab,
                    onChanged: (tab) => setState(() => _activeTab = tab),
                  ),
                  if (subscriptions.isEmpty)
                    _EmptyPortfolio(route: snapshot.launchpadRoute)
                  else
                    for (final subscription in subscriptions)
                      _SubscriptionCard(
                        subscription: subscription,
                        receiptRoute: snapshot.receiptRoute,
                      ),
                  const _PortfolioDisclaimer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
