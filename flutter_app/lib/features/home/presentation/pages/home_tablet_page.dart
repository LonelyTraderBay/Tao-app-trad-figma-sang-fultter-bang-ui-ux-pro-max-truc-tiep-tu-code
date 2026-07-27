import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/home_controller_providers.dart';
import 'package:vit_trade_flutter/app/providers/notifications_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
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
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';

/// Tablet composition of Home (SC-007) — same route, same
/// [homeSnapshotProvider] data and the same public Home widgets as
/// [HomePage], but laid out as a persistent two-column dashboard instead of
/// one scrolling phone column: portfolio + market data on the left, quick
/// actions and discovery on the right. Does not touch `home_page.dart` or
/// its `part` family — the SC-007 phone reference and its golden baseline
/// stay untouched. Reached via `HomeResponsiveEntry` when the shell width is
/// at or above `AppBreakpoints.tablet`.
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

  /// Below this content width, the two-column dashboard doesn't have enough
  /// room per column for widgets sized for ~340-400px phone content (e.g.
  /// `VitDiscoveryActionCard`) without overflowing — fall back to a single
  /// column (still tablet-shell, still rail nav, just not side-by-side) down
  /// to `AppBreakpoints.tablet`. Local to this page, not a global breakpoint:
  /// it's about this dashboard's own content width needs, not a device class.
  static const double _twoColumnMinWidth = 900;

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

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < _twoColumnMinWidth) {
          return SingleChildScrollView(
            child: VitPageContent(
              padding: VitContentPadding.compact,
              rhythm: VitPageRhythm.compact,
              children: [...primaryChildren, ...secondaryChildren],
            ),
          );
        }

        // Each column scrolls independently inside its own
        // SingleChildScrollView rather than one scrollview wrapping the
        // whole Row — a Row of two independently-scrolling, height-bounded
        // columns is the well-supported shape; a Row of unbounded natural
        // height inside one outer scrollview is not.
        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                child: VitPageContent(
                  padding: VitContentPadding.compact,
                  rhythm: VitPageRhythm.compact,
                  children: primaryChildren,
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                child: VitPageContent(
                  padding: VitContentPadding.compact,
                  rhythm: VitPageRhythm.compact,
                  children: secondaryChildren,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
