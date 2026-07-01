part of 'home_page.dart';

class _HomePageState extends ConsumerState<HomePage> {
  static const _surfaceOrder = HomeSurfaceOrder.productsBeforeRecent;

  String _marketTab = 'hot';
  bool _balanceHidden = false;
  final Set<String> _sessionHiddenAnnouncementIds = <String>{};

  void _setTab(String key) {
    setState(() => _marketTab = key);
  }

  void _toggleBalanceHidden() {
    setState(() => _balanceHidden = !_balanceHidden);
  }

  void _go(String path) {
    context.push(path);
  }

  void _showMoreProducts(List<HomeQuickAction> actions, VitDensity density) {
    final rootContext = context;

    if (actions.isEmpty) return;

    showVitBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bg,
      barrierColor: AppColors.modalScrim,
      builder: (sheetContext) {
        return _MoreProductsSheet(
          actions: actions,
          onNavigate: (path) {
            Navigator.of(sheetContext).pop();
            rootContext.push(path);
          },
          density: density,
        );
      },
    );
  }

  void _dismissAnnouncement(HomeAnnouncement announcement) {
    setState(() => _sessionHiddenAnnouncementIds.add(announcement.id));
  }

  bool _handleHomeScrollNotification(
    ScrollNotification notification,
    List<HomeAnnouncement> visibleAnnouncements,
  ) {
    if (notification.metrics.axis != Axis.vertical) return false;
    if (notification.metrics.pixels <
        AppSpacing.homeAnnouncementAutoHideScrollOffset) {
      return false;
    }

    final campaignIds = visibleAnnouncements
        .where(
          (announcement) => announcement.type == HomeAnnouncementType.campaign,
        )
        .map((announcement) => announcement.id)
        .where((id) => !_sessionHiddenAnnouncementIds.contains(id))
        .toList(growable: false);

    if (campaignIds.isEmpty) return false;

    setState(() => _sessionHiddenAnnouncementIds.addAll(campaignIds));
    return false;
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

  HomeDensityVariant _homeDensityVariant(double screenWidth) {
    return screenWidth <= AppSpacing.homeQuickActionDensityBreakpoint
        ? HomeDensityVariant.compact
        : HomeDensityVariant.comfortable;
  }

  VitDensity _tileDensity(HomeDensityVariant variant) {
    return variant == HomeDensityVariant.compact
        ? VitDensity.compact
        : VitDensity.standard;
  }

  int _primaryQuickActionCount(HomeDensityVariant variant) {
    return variant == HomeDensityVariant.compact
        ? AppSpacing.homeQuickActionCompactCount
        : AppSpacing.homeQuickActionStandardCount;
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(homeControllerProvider);
    final snapshot = controller.state.snapshot;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final homeVariant = _homeDensityVariant(screenWidth);
    final homeDensity = _tileDensity(homeVariant);
    final homePrimaryQuickActionCount = _primaryQuickActionCount(homeVariant);
    final visibleAnnouncements = _visibleAnnouncements(snapshot);
    final moreQuickActions = snapshot.quickActions
        .skip(homePrimaryQuickActionCount)
        .toList(growable: false);
    final notificationUnreadCount = ref.watch(notificationUnreadCountProvider);
    final shellRenderMode = widget.shellRenderMode ?? defaultShellRenderMode();
    final nativeShell = !shellRenderMode.usesVisualQaFrame;
    final scrollEndClearance =
        (nativeShell ? _nativeScrollClearance : _framedScrollClearance) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: nativeShell ? VitPageVariant.flush : VitPageVariant.defaultPage,
      semanticLabel: 'SC-007 HomePage',
      child: VitAutoHideHeaderScaffold(
        headerKey: HomePage.headerKey,
        hideThreshold: AppSpacing.homeScrollHideThreshold,
        showAtTopThreshold: AppSpacing.homeScrollShowThreshold,
        slideOffset: AppSpacing.homeSlideOffsetUp,
        header: _HomeHeader(
          notifications: notificationUnreadCount,
          onNavigate: _go,
        ),
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) =>
              _handleHomeScrollNotification(notification, visibleAnnouncements),
          child: VitInsetScrollView(
            key: HomePage.contentKey,
            bottomInset: scrollEndClearance,
            child: VitPageContent(
              padding: VitContentPadding.compact,
              density: VitDensity.compact,
              children: [
                if (visibleAnnouncements.isNotEmpty)
                  _AnnouncementBanner(
                    announcements: visibleAnnouncements,
                    onDismiss: _dismissAnnouncement,
                  ),
                _PortfolioCard(
                  snapshot: snapshot,
                  balanceHidden: _balanceHidden,
                  onToggleBalance: _toggleBalanceHidden,
                  onNavigate: _go,
                ),
                _NextActionSection(
                  nextAction: snapshot.nextAction,
                  onNavigate: _go,
                ),
                _MarketTickerSection(
                  pairs: controller.hotPairs.take(3).toList(),
                  onNavigate: _go,
                ),
                if (_surfaceOrder == HomeSurfaceOrder.productsBeforeRecent) ...[
                  _ProductsSection(
                    actions: snapshot.quickActions,
                    maxVisibleItems: homePrimaryQuickActionCount,
                    moreActions: moreQuickActions,
                    onNavigate: _go,
                    onMore: moreQuickActions.isEmpty
                        ? null
                        : () =>
                              _showMoreProducts(moreQuickActions, homeDensity),
                    density: homeDensity,
                  ),
                  _RecentProductsSection(
                    recentProducts: snapshot.recentProducts,
                    onNavigate: _go,
                  ),
                ] else ...[
                  _RecentProductsSection(
                    recentProducts: snapshot.recentProducts,
                    onNavigate: _go,
                  ),
                  _ProductsSection(
                    actions: snapshot.quickActions,
                    maxVisibleItems: homePrimaryQuickActionCount,
                    moreActions: moreQuickActions,
                    onNavigate: _go,
                    onMore: moreQuickActions.isEmpty
                        ? null
                        : () =>
                              _showMoreProducts(moreQuickActions, homeDensity),
                    density: homeDensity,
                  ),
                ],
                _HomeDiscoverySection(onNavigate: _go),
                _MarketSection(
                  activeTab: _marketTab,
                  pairs: controller.tabPairs(_marketTab),
                  onTabChanged: _setTab,
                  onNavigate: _go,
                ),
                _TrendingSection(
                  pairs: snapshot.pairs.take(5).toList(),
                  onNavigate: _go,
                ),
                _RankedListSection(
                  title: 'Top tăng giá',
                  icon: Icons.trending_up_rounded,
                  iconColor: AppColors.buy,
                  pairs: controller.gainers.take(3).toList(),
                  positive: true,
                  onNavigate: _go,
                ),
                _RankedListSection(
                  title: 'Top giảm giá',
                  icon: Icons.trending_down_rounded,
                  iconColor: AppColors.sell,
                  pairs: controller.losers.take(3).toList(),
                  positive: false,
                  onNavigate: _go,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.notifications, required this.onNavigate});

  final int notifications;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return VitTopChrome(
      type: VitTopChromeType.rootBrand,
      title: 'VitTrade',
      actions: [
        VitHeaderActionItem(
          type: VitHeaderActionType.search,
          tooltip: 'Tìm kiếm toàn cục',
          onPressed: () => onNavigate('/search'),
        ),
        VitHeaderActionItem(
          type: VitHeaderActionType.notifications,
          tooltip: 'Thông báo',
          badgeCount: notifications,
          onPressed: () => onNavigate('/notifications'),
        ),
      ],
    );
  }
}

class _AnnouncementBanner extends StatelessWidget {
  const _AnnouncementBanner({
    required this.announcements,
    required this.onDismiss,
  });

  final List<HomeAnnouncement> announcements;
  final ValueChanged<HomeAnnouncement> onDismiss;

  @override
  Widget build(BuildContext context) {
    final announcement = announcements.first;
    return VitAnnouncementBanner(
      key: HomePage.announcementKey,
      message: announcement.text,
      itemCount: announcements.length,
      activeIndex: 0,
      variant: VitAnnouncementBannerVariant.compact,
      icon: _announcementIcon(announcement.type),
      accentColor: _announcementColor(announcement.type),
      onDismiss: () => onDismiss(announcement),
    );
  }

  IconData _announcementIcon(HomeAnnouncementType type) {
    return switch (type) {
      HomeAnnouncementType.security => Icons.shield_outlined,
      HomeAnnouncementType.risk => Icons.warning_amber_rounded,
      HomeAnnouncementType.campaign => Icons.card_giftcard_rounded,
      HomeAnnouncementType.info => Icons.campaign_rounded,
    };
  }

  Color _announcementColor(HomeAnnouncementType type) {
    return switch (type) {
      HomeAnnouncementType.security => AppColors.info,
      HomeAnnouncementType.risk => AppColors.warn,
      HomeAnnouncementType.campaign => AppColors.primary,
      HomeAnnouncementType.info => AppColors.text2,
    };
  }
}

class _PortfolioCard extends StatelessWidget {
  const _PortfolioCard({
    required this.snapshot,
    required this.balanceHidden,
    required this.onToggleBalance,
    required this.onNavigate,
  });

  final HomeSnapshot snapshot;
  final bool balanceHidden;
  final VoidCallback onToggleBalance;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.hero,
      radius: VitCardRadius.large,
      clip: true,
      padding: AppSpacing.homePortfolioCardPadding,
      background: const VitHeroGlow(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Tổng tài sản (USDT)',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.portfolioTextDim,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
              ),
              VitInlineIconAction(
                tooltip: balanceHidden ? 'Hiá»‡n sá»‘ dÆ°' : 'áº¨n sá»‘ dÆ°',
                onPressed: onToggleBalance,
                icon: balanceHidden
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.portfolioTextDim,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            balanceHidden
                ? '••••••'
                : _formatUsd(snapshot.totalBalance, forceTwoDecimals: true),
            style: AppTextStyles.heroNumber.copyWith(
              color: AppColors.onAccent,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          if (!balanceHidden)
            Row(
              children: [
                Flexible(
                  child: VitMetricDeltaPill(
                    label:
                        '+${_formatUsd(snapshot.dailyPnl)} (${_formatPct(snapshot.dailyPct)})',
                    tone: VitMetricDeltaTone.positive,
                  ),
                ),
                const SizedBox(width: AppSpacing.x3),
                Text(
                  'hôm nay',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.portfolioTextMuted,
                  ),
                ),
              ],
            ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: VitCtaButton(
                  height: _heroActionExtent,
                  density: VitDensity.compact,
                  fullWidth: true,
                  onPressed: () => onNavigate('/wallet/deposit/USDT'),
                  leading: const Icon(Icons.file_download_outlined),
                  child: const Text('Nạp'),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: VitCtaButton(
                  height: _heroActionExtent,
                  density: VitDensity.compact,
                  fullWidth: true,
                  variant: VitCtaButtonVariant.secondary,
                  onPressed: () => onNavigate('/wallet/withdraw/USDT'),
                  leading: const Icon(Icons.file_upload_outlined),
                  child: const Text('Rút'),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: VitCtaButton(
                  height: _heroActionExtent,
                  density: VitDensity.compact,
                  fullWidth: true,
                  variant: VitCtaButtonVariant.secondary,
                  onPressed: () => onNavigate('/wallet'),
                  leading: const Icon(Icons.account_balance_wallet_outlined),
                  child: const Text('Ví'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NextActionSection extends StatelessWidget {
  const _NextActionSection({
    required this.nextAction,
    required this.onNavigate,
  });

  final HomeNextAction nextAction;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitSectionHeader(title: 'Tiếp theo'),
        const SizedBox(height: AppSpacing.x3),
        VitNextActionCard(
          key: HomePage.nextActionKey,
          icon: nextAction.icon,
          title: nextAction.title,
          subtitle: nextAction.subtitle,
          statusLabel: nextAction.stateLabel,
          ctaLabel: nextAction.ctaLabel,
          accentColor: nextAction.accentColor,
          onTap: () => onNavigate(nextAction.routePath),
        ),
      ],
    );
  }
}

class _MarketTickerSection extends StatelessWidget {
  const _MarketTickerSection({required this.pairs, required this.onNavigate});

  final List<HomeCryptoPair> pairs;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return VitMarketTickerStrip(
      key: HomePage.marketTickerKey,
      items: [
        for (final pair in pairs)
          VitMarketTickerData(
            leading: VitAssetAvatar(
              label: pair.baseAsset,
              accentColor: pair.logoColor,
              size: _assetAvatarExtent,
            ),
            title: pair.symbol,
            price: _formatUsd(pair.price),
            changeLabel: _formatPct(pair.change24h),
            trend: pair.change24h >= 0
                ? VitTrendDirection.positive
                : VitTrendDirection.negative,
            onTap: () => onNavigate('/pair/${pair.id}'),
          ),
      ],
    );
  }
}

class _ProductsSection extends StatelessWidget {
  const _ProductsSection({
    required this.actions,
    required this.maxVisibleItems,
    required this.moreActions,
    required this.onNavigate,
    required this.onMore,
    required this.density,
  });

  final List<HomeQuickAction> actions;
  final int maxVisibleItems;
  final List<HomeQuickAction> moreActions;
  final ValueChanged<String> onNavigate;
  final VoidCallback? onMore;
  final VitDensity density;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: HomePage.productsSectionKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitSectionHeader(
          title: 'S\u1EA3n ph\u1EA9m',
          actionLabel: moreActions.isEmpty ? null : 'Xem th\u00EAm',
          onAction: onMore,
        ),
        const SizedBox(height: AppSpacing.x3),
        _QuickActionsGrid(
          actions: actions,
          maxVisibleItems: maxVisibleItems,
          onNavigate: onNavigate,
          density: density,
        ),
      ],
    );
  }
}

class _RecentProductsSection extends StatelessWidget {
  const _RecentProductsSection({
    required this.recentProducts,
    required this.onNavigate,
  });

  final List<HomeRecentProduct> recentProducts;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: HomePage.recentProductsSectionKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitSectionHeader(title: 'G\u1EA7n \u0111\u00E2y'),
        const SizedBox(height: AppSpacing.x3),
        SizedBox(
          key: HomePage.recentProductsKey,
          height: _recentProductExtent,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: recentProducts.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.x3),
            itemBuilder: (context, index) {
              final product = recentProducts[index];
              return _RecentProductTile(
                product: product,
                onTap: () => onNavigate(product.routePath),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _RecentProductTile extends StatelessWidget {
  const _RecentProductTile({required this.product, required this.onTap});

  final HomeRecentProduct product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _recentProductWidth,
      child: VitCompactProductCard(
        key: HomePage.recentProductKey(product.id),
        icon: product.icon,
        title: product.label,
        subtitle: product.contextLabel,
        accentColor: product.accentColor,
        badgeLabel: product.stateLabel,
        onTap: onTap,
      ),
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  const _QuickActionsGrid({
    required this.actions,
    required this.maxVisibleItems,
    required this.onNavigate,
    required this.density,
  });

  final List<HomeQuickAction> actions;
  final int maxVisibleItems;
  final ValueChanged<String> onNavigate;
  final VitDensity density;

  @override
  Widget build(BuildContext context) {
    return VitActionTileGrid(
      density: density,
      itemCount: actions.length,
      maxVisibleItems: maxVisibleItems,
      itemBuilder: (context, index, tileDensity) {
        final action = actions[index];
        return VitServiceTile(
          density: tileDensity,
          icon: action.icon,
          label: action.label,
          accentColor: action.accentColor,
          badgeLabel: action.stateLabel,
          onTap: () => onNavigate(action.routePath),
        );
      },
    );
  }
}

class _MoreProductsSheet extends StatelessWidget {
  const _MoreProductsSheet({
    required this.actions,
    required this.onNavigate,
    required this.density,
  });

  final List<HomeQuickAction> actions;
  final ValueChanged<String> onNavigate;
  final VitDensity density;

  @override
  Widget build(BuildContext context) {
    return VitSheetPanel(
      key: HomePage.moreProductsSheetKey,
      title: 'Th\u00EAm s\u1EA3n ph\u1EA9m',
      child: VitActionTileGrid(
        density: density,
        crossAxisSpacing: AppSpacing.x3,
        mainAxisSpacing: AppSpacing.x3,
        physics: const ClampingScrollPhysics(),
        itemCount: actions.length,
        itemBuilder: (context, index, tileDensity) {
          final action = actions[index];
          return VitServiceTile(
            density: tileDensity,
            icon: action.icon,
            label: action.label,
            accentColor: action.accentColor,
            badgeLabel: action.stateLabel,
            onTap: () => onNavigate(action.routePath),
          );
        },
      ),
    );
  }
}
