import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/home_controller_providers.dart';
import 'package:vit_trade_flutter/app/providers/notifications_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/home_announcement_banner.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/home_discovery_panel.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/home_header.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/home_market_ticker_section.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/home_market_watchlist_panel.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/home_next_action_section.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/home_portfolio_card.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/home_products_section.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/home_recent_products_section.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/home_status_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_two_column_tablet_dashboard.dart';

/// Tablet composition of Home (SC-007) — same route, same
/// [homeSnapshotProvider] data and the same public Home widgets as
/// [HomePage], but laid out as a persistent two-column dashboard instead of
/// one scrolling phone column: portfolio + market data on the left, quick
/// actions and discovery on the right. Does not touch `home_page.dart` or
/// its `part` family — the SC-007 phone reference and its golden baseline
/// stay untouched. Reached via `HomeResponsiveEntry` when the shell width is
/// at or above `AppBreakpoints.tablet`. This is the reference
/// implementation for `docs/02_FLUTTER_MIGRATION/standards/
/// Tablet-Adaptive-Standard.md` — follow that doc's rules (R1-R8) when
/// adding a dedicated tablet layout to another screen.
class HomeTabletPage extends ConsumerStatefulWidget {
  const HomeTabletPage({super.key});

  @override
  ConsumerState<HomeTabletPage> createState() => _HomeTabletPageState();
}

class _HomeTabletPageState extends ConsumerState<HomeTabletPage> {
  String _marketTab = 'hot';
  bool _balanceHidden = false;
  final Set<String> _sessionHiddenAnnouncementIds = <String>{};
  final Set<String> _dismissedNextActionIds = <String>{};

  void _setTab(String key) => setState(() => _marketTab = key);

  void _toggleBalanceHidden() =>
      setState(() => _balanceHidden = !_balanceHidden);

  void _go(String path) => unawaited(context.push(path));

  void _dismissAnnouncement(HomeAnnouncement announcement) {
    setState(() => _sessionHiddenAnnouncementIds.add(announcement.id));
  }

  void _dismissNextAction(HomeNextAction nextAction) {
    setState(() => _dismissedNextActionIds.add(nextAction.routePath));
  }

  List<HomeAnnouncement> _visibleAnnouncements(HomeSnapshot snapshot) {
    return snapshot.announcements
        .where(
          (announcement) =>
              announcement.active &&
              announcement.type.surfacesOnHome &&
              !_sessionHiddenAnnouncementIds.contains(announcement.id),
        )
        .toList(growable: false);
  }

  HomeNextAction? _visibleNextAction(HomeNextAction? nextAction) {
    if (nextAction == null) return null;
    if (_dismissedNextActionIds.contains(nextAction.routePath)) return null;
    return nextAction;
  }

  Future<void> _refreshHome() async {
    ref.invalidate(homeSnapshotProvider);
    await ref.read(homeSnapshotProvider.future);
  }

  @override
  Widget build(BuildContext context) {
    final homeAsync = ref.watch(homeSnapshotProvider);
    final notificationUnreadCount = ref.watch(notificationUnreadCountProvider);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Trang chủ',
      semanticIdentifier: 'SC-007',
      child: Column(
        children: [
          HomeHeader(notifications: notificationUnreadCount, onNavigate: _go),
          Expanded(
            child: homeAsync.when(
              loading: () =>
                  const SingleChildScrollView(child: HomeLoadingContent()),
              error: (error, stackTrace) => SingleChildScrollView(
                child: HomeErrorContent(onRetry: _refreshHome),
              ),
              data: _buildDashboard,
            ),
          ),
        ],
      ),
    );
  }

  // Two-column threshold and per-column width caps are owned by
  // [VitTwoColumnTabletDashboard] (`TabletDashboardWidths` defaults) —
  // Home's own content originally established these values, later confirmed
  // on independent content by `WalletTabletPage`. Pass constructor overrides
  // on the call below instead of editing the shared widths if Home's
  // content ever needs a different number.

  Widget _buildDashboard(HomeSnapshot snapshot) {
    final controller = HomeController(state: HomeViewState(snapshot: snapshot));
    final visibleAnnouncements = _visibleAnnouncements(snapshot);
    final visibleNextAction = _visibleNextAction(snapshot.nextAction);
    final marketTickerPairs = controller.gainers
        .take(3)
        .toList(growable: false);

    final primaryChildren = [
      HomePortfolioCard(
        snapshot: snapshot,
        balanceHidden: _balanceHidden,
        onToggleBalance: _toggleBalanceHidden,
        onNavigate: _go,
      ),
      if (marketTickerPairs.isNotEmpty)
        HomeMarketTickerSection(pairs: marketTickerPairs, onNavigate: _go),
      HomeMarketWatchlistPanel(
        activeTab: _marketTab,
        pairs: controller.tabPairs(_marketTab),
        onTabChanged: _setTab,
        onNavigate: _go,
      ),
    ];

    final secondaryChildren = [
      if (visibleAnnouncements.isNotEmpty)
        HomeAnnouncementBanner(
          announcements: visibleAnnouncements,
          onDismiss: _dismissAnnouncement,
          onNavigate: _go,
        ),
      if (visibleNextAction != null)
        HomeNextActionSection(
          nextAction: visibleNextAction,
          onNavigate: _go,
          onDismiss: () => _dismissNextAction(visibleNextAction),
        ),
      // Tablet has room for the full quick-action set inline — no "Xem
      // thêm" overflow sheet needed here.
      HomeProductsSection(
        quickActions: snapshot.quickActions,
        maxVisibleQuickActions: snapshot.quickActions.length,
        moreActionCount: 0,
        onNavigate: _go,
        onMore: null,
        density: VitDensity.standard,
      ),
      HomeRecentProductsSection(
        recentProducts: snapshot.recentProducts,
        onNavigate: _go,
        density: VitDensity.standard,
      ),
      HomeDiscoveryPanel(onNavigate: _go),
    ];

    return VitTwoColumnTabletDashboard(
      primaryChildren: primaryChildren,
      secondaryChildren: secondaryChildren,
    );
  }
}
