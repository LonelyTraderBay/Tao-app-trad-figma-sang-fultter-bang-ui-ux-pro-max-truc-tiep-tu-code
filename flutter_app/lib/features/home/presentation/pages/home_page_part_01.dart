part of 'home_page.dart';

class _HomePageState extends ConsumerState<HomePage> {
  String _marketTab = 'hot';
  bool _balanceHidden = false;
  bool _headerVisible = true;

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

  void _setHeaderVisible(bool visible) {
    if (_headerVisible == visible) return;
    setState(() => _headerVisible = visible);
  }

  bool _handleUserScroll(UserScrollNotification notification) {
    if (notification.metrics.axis != Axis.vertical) return false;

    if (notification.metrics.pixels <= AppSpacing.homeScrollShowThreshold) {
      _setHeaderVisible(true);
      return false;
    }

    switch (notification.direction) {
      case ScrollDirection.reverse:
        if (notification.metrics.pixels > AppSpacing.homeScrollHideThreshold) {
          _setHeaderVisible(false);
        }
      case ScrollDirection.forward:
        _setHeaderVisible(true);
      case ScrollDirection.idle:
        break;
    }

    return false;
  }

  bool _handleScrollUpdate(ScrollUpdateNotification notification) {
    if (notification.metrics.axis != Axis.vertical) return false;

    if (notification.metrics.pixels <= AppSpacing.homeScrollShowThreshold) {
      _setHeaderVisible(true);
      return false;
    }

    final delta = notification.scrollDelta ?? 0;
    if (delta > 0 &&
        notification.metrics.pixels > AppSpacing.homeScrollHideThreshold) {
      _setHeaderVisible(false);
    } else if (delta < 0) {
      _setHeaderVisible(true);
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(homeControllerProvider);
    final snapshot = controller.state.snapshot;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final homeDensity =
        screenWidth < AppSpacing.homeQuickActionDensityBreakpoint
        ? VitDensity.compact
        : VitDensity.standard;
    final homePrimaryQuickActionCount = homeDensity == VitDensity.compact
        ? AppSpacing.homeQuickActionCompactCount
        : AppSpacing.homeQuickActionStandardCount;
    final primaryQuickActions = snapshot.quickActions
        .take(homePrimaryQuickActionCount)
        .toList(growable: false);
    final moreQuickActions = snapshot.quickActions
        .skip(homePrimaryQuickActionCount)
        .toList(growable: false);
    final notificationUnreadCount = ref.watch(notificationUnreadCountProvider);
    final shellRenderMode = widget.shellRenderMode ?? defaultShellRenderMode();
    final nativeShell = !shellRenderMode.usesVisualQaFrame;
    final bottomChrome = shellRenderMode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomScrollInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (nativeShell
            ? AppSpacing.homeBottomSheetScrollInset
            : AppSpacing.homeBottomSheetScrollInsetVisual);

    return VitPageLayout(
      variant: nativeShell ? VitPageVariant.flush : VitPageVariant.defaultPage,
      semanticLabel: 'SC-007 HomePage',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _CollapsibleHomeHeader(
            visible: _headerVisible,
            child: _HomeHeader(
              notifications: notificationUnreadCount,
              onNavigate: _go,
            ),
          ),
          Expanded(
            child: NotificationListener<UserScrollNotification>(
              onNotification: _handleUserScroll,
              child: NotificationListener<ScrollUpdateNotification>(
                onNotification: _handleScrollUpdate,
                child: SingleChildScrollView(
                  key: HomePage.contentKey,
                  padding: EdgeInsets.only(bottom: bottomScrollInset),
                  child: VitPageContent(
                    padding: VitContentPadding.compact,
                    gap: VitContentGap.defaultGap,
                    customGap: nativeShell
                        ? AppSpacing.homeNativeShellCustomGap
                        : null,
                    children: [
                      _AnnouncementBanner(
                        announcements: snapshot.announcements,
                      ),
                      _PortfolioCard(
                        snapshot: snapshot,
                        balanceHidden: _balanceHidden,
                        onToggleBalance: _toggleBalanceHidden,
                        onNavigate: _go,
                      ),
                      _HomeCommandCenter(
                        nextAction: snapshot.nextAction,
                        recentProducts: snapshot.recentProducts,
                        onNavigate: _go,
                      ),
                      _SectionHeader(
                        title: 'S\u1EA3n ph\u1EA9m',
                        actionLabel: moreQuickActions.isEmpty
                            ? null
                            : 'Xem th\u00EAm',
                        onAction: moreQuickActions.isEmpty
                            ? null
                            : () => _showMoreProducts(
                                moreQuickActions,
                                homeDensity,
                              ),
                      ),
                      _QuickActionsGrid(
                        actions: primaryQuickActions,
                        onNavigate: _go,
                        density: homeDensity,
                      ),
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
          ),
        ],
      ),
    );
  }
}

class _CollapsibleHomeHeader extends StatelessWidget {
  const _CollapsibleHomeHeader({required this.visible, required this.child});

  final bool visible;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    const duration = Duration(milliseconds: 180);
    const curve = Curves.easeOutCubic;

    return ClipRect(
      child: AnimatedAlign(
        key: HomePage.headerKey,
        alignment: Alignment.topCenter,
        heightFactor: visible ? 1 : 0,
        duration: duration,
        curve: curve,
        child: AnimatedOpacity(
          opacity: visible ? 1 : 0,
          duration: duration,
          curve: curve,
          child: AnimatedSlide(
            offset: visible
                ? Offset.zero
                : const Offset(0, -AppSpacing.homeSlideOffsetUp),
            duration: duration,
            curve: curve,
            child: child,
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
  const _AnnouncementBanner({required this.announcements});

  final List<HomeAnnouncement> announcements;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VitCard(
          radius: VitCardRadius.sm,
          borderColor: AppColors.primary12,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.homeAnnouncementCardHorizontalPadding,
            vertical: AppSpacing.homeAnnouncementCardVerticalPadding,
          ),
          child: Row(
            children: [
              const Icon(
                Icons.card_giftcard_rounded,
                color: AppColors.primary,
                size: AppSpacing.homeAnnouncementIcon,
              ),
              const SizedBox(width: AppSpacing.homeAnnouncementIconGap),
              Expanded(
                child: Text(
                  announcements.first.text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ),
              const SizedBox(width: AppSpacing.homeAnnouncementArrowGap),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.text3,
                size: AppSpacing.homeAnnouncementChevron,
              ),
            ],
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: AppSpacing.x3)),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _Dot(active: true),
            SizedBox(width: AppSpacing.homeAnnouncementDotGap),
            _Dot(active: false),
            SizedBox(width: AppSpacing.homeAnnouncementDotGap),
            _Dot(active: false),
          ],
        ),
      ],
    );
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
      radius: VitCardRadius.lg,
      clip: true,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.homeAnnouncementCardHorizontalPadding,
        AppSpacing.homePortfolioBadgeVerticalPadding + AppSpacing.x1,
        AppSpacing.homeAnnouncementCardHorizontalPadding,
        AppSpacing.homePortfolioBadgeVerticalPadding,
      ),
      child: Stack(
        children: [
          const Positioned.fill(child: _PortfolioGlow()),
          Column(
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
                  InkWell(
                    onTap: onToggleBalance,
                    borderRadius: AppRadii.smRadius,
                    child: Padding(
                      padding: const EdgeInsets.all(
                        AppSpacing.homePortfolioHeaderActionPadding,
                      ),
                      child: Icon(
                        balanceHidden
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.portfolioTextDim,
                        size: AppSpacing.homePortfolioHeaderIcon,
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: AppSpacing.homeSectionInnerGap),
              ),
              Text(
                balanceHidden
                    ? '••••••'
                    : _formatUsd(snapshot.totalBalance, forceTwoDecimals: true),
                style: AppTextStyles.heroNumber.copyWith(
                  color: AppColors.onAccent,
                  letterSpacing: 0,
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: AppSpacing.x4)),
              if (!balanceHidden)
                Row(
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal:
                              AppSpacing.homePortfolioBadgeHorizontalPadding,
                          vertical:
                              AppSpacing.homePortfolioBadgeVerticalPadding,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.buy15,
                          border: Border.all(color: AppColors.buy20),
                          borderRadius: AppRadii.smRadius,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.trending_up_rounded,
                              color: AppColors.buy,
                              size: AppSpacing.homePortfolioBadgeIcon,
                            ),
                            const SizedBox(width: AppSpacing.x1),
                            Flexible(
                              child: Text(
                                '+${_formatUsd(snapshot.dailyPnl)} (${_formatPct(snapshot.dailyPct)})',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.buy,
                                  fontWeight: AppTextStyles.medium,
                                ),
                              ),
                            ),
                          ],
                        ),
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
              const Padding(
                padding: EdgeInsets.only(top: AppSpacing.homeActionRowGap),
              ),
              Row(
                children: [
                  Expanded(
                    child: VitCtaButton(
                      height: AppSpacing.homeHeroActionHeight,
                      density: VitDensity.compact,
                      fullWidth: true,
                      onPressed: () => onNavigate('/wallet/deposit/USDT'),
                      leading: const Icon(Icons.file_download_outlined),
                      child: const Text('Nạp'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.homePortfolioActionSpacing),
                  Expanded(
                    child: VitCtaButton(
                      height: AppSpacing.homeHeroActionHeight,
                      density: VitDensity.compact,
                      fullWidth: true,
                      variant: VitCtaButtonVariant.secondary,
                      onPressed: () => onNavigate('/wallet/withdraw/USDT'),
                      leading: const Icon(Icons.file_upload_outlined),
                      child: const Text('Rút'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.homePortfolioActionSpacing),
                  Expanded(
                    child: VitCtaButton(
                      height: AppSpacing.homeHeroActionHeight,
                      density: VitDensity.compact,
                      fullWidth: true,
                      variant: VitCtaButtonVariant.secondary,
                      onPressed: () => onNavigate('/wallet'),
                      leading: const Icon(
                        Icons.account_balance_wallet_outlined,
                      ),
                      child: const Text('Ví'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HomeCommandCenter extends StatelessWidget {
  const _HomeCommandCenter({
    required this.nextAction,
    required this.recentProducts,
    required this.onNavigate,
  });

  final HomeNextAction nextAction;
  final List<HomeRecentProduct> recentProducts;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionHeader(title: 'Tiếp theo'),
        const Padding(padding: EdgeInsets.only(top: AppSpacing.x3)),
        _NextActionCard(
          action: nextAction,
          onTap: () => onNavigate(nextAction.routePath),
        ),
        const Padding(padding: EdgeInsets.only(top: AppSpacing.x4)),
        const _SectionHeader(title: 'Gần đây'),
        const Padding(padding: EdgeInsets.only(top: AppSpacing.x3)),
        SizedBox(
          key: HomePage.recentProductsKey,
          height: AppSpacing.homeRecentProductHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: recentProducts.length,
            separatorBuilder: (_, _) =>
                const SizedBox(width: AppSpacing.homeSectionCtaGap),
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

class _NextActionCard extends StatelessWidget {
  const _NextActionCard({required this.action, required this.onTap});

  final HomeNextAction action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: HomePage.nextActionKey,
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.homeNextActionCardPadding),
      borderColor: action.accentColor.withValues(alpha: .28),
      child: Row(
        children: [
          Container(
            width: AppSpacing.homeNextActionIconContainer,
            height: AppSpacing.homeNextActionIconContainer,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: action.accentColor.withValues(alpha: .14),
              borderRadius: AppRadii.mdRadius,
            ),
            child: Icon(
              action.icon,
              color: action.accentColor,
              size: AppSpacing.homeNextActionIconSize,
            ),
          ),
          const SizedBox(width: AppSpacing.homeCommandRowSpacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        action.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body.copyWith(
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    _CommandChip(
                      label: action.stateLabel,
                      color: action.accentColor,
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(top: AppSpacing.homeSectionInnerGap),
                ),
                Text(
                  action.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Text(
            action.ctaLabel,
            style: AppTextStyles.caption.copyWith(
              color: action.accentColor,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(width: AppSpacing.homeChevronGap),
          Icon(
            Icons.chevron_right_rounded,
            color: action.accentColor,
            size: AppSpacing.homeActionChevronSize,
          ),
        ],
      ),
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
      width: AppSpacing.homeRecentProductWidth,
      child: VitCard(
        key: HomePage.recentProductKey(product.id),
        onTap: onTap,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.homeMarketSectionGap,
          vertical: AppSpacing.x2,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: AppSpacing.homeRecentProductIcon,
                  height: AppSpacing.homeRecentProductIcon,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: product.accentColor.withValues(alpha: .14),
                    borderRadius: AppRadii.smRadius,
                  ),
                  child: Icon(
                    product.icon,
                    color: product.accentColor,
                    size: AppSpacing.homeRecentProductIconText,
                  ),
                ),
                const Spacer(),
                _CommandChip(
                  label: product.stateLabel,
                  color: product.accentColor,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(
              product.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: AppSpacing.homeSectionInnerGap),
            ),
            Text(
              product.contextLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommandChip extends StatelessWidget {
  const _CommandChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: AppSpacing.homeChipMinHeight,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.homeChipHorizontalPadding,
        vertical: AppSpacing.homeChipVerticalPadding,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: AppRadii.pillRadius,
        border: Border.all(color: color.withValues(alpha: .26)),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  const _QuickActionsGrid({
    required this.actions,
    required this.onNavigate,
    required this.density,
  });

  final List<HomeQuickAction> actions;
  final ValueChanged<String> onNavigate;
  final VitDensity density;

  @override
  Widget build(BuildContext context) {
    final serviceDensity = density == VitDensity.compact
        ? VitServiceTileDensity.compact
        : VitServiceTileDensity.standard;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: AppSpacing.serviceTileCrossAxisCount,
        crossAxisSpacing: AppSpacing.gridGap,
        mainAxisSpacing: AppSpacing.gridGap,
        childAspectRatio: density == VitDensity.compact
            ? AppSpacing.serviceTileGridAspectCompact
            : AppSpacing.serviceTileGridAspectStandard,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return VitServiceTile(
          density: serviceDensity,
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
    final serviceDensity = density == VitDensity.compact
        ? VitServiceTileDensity.compact
        : VitServiceTileDensity.standard;
    final maxHeight = MediaQuery.sizeOf(context).height * .72;

    return SafeArea(
      top: false,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Padding(
          key: HomePage.moreProductsSheetKey,
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.homeSectionCtaGap,
            AppSpacing.x2,
            AppSpacing.homeSectionCtaGap,
            AppSpacing.homeSectionCtaGap,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: AppSpacing.homeMoreProductsSheetHandleWidth,
                  height: AppSpacing.homeMoreProductsSheetHandleHeight,
                  decoration: BoxDecoration(
                    color: AppColors.borderSolid,
                    borderRadius: AppRadii.pillRadius,
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: AppSpacing.x4)),
              Text(
                'Th\u00EAm s\u1EA3n ph\u1EA9m',
                style: AppTextStyles.sectionTitle.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: AppSpacing.x4)),
              Flexible(
                child: GridView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: AppSpacing.serviceTileCrossAxisCount,
                    crossAxisSpacing: AppSpacing.x3,
                    mainAxisSpacing: AppSpacing.x3,
                    childAspectRatio: density == VitDensity.compact
                        ? AppSpacing.serviceTileGridAspectCompact
                        : AppSpacing.serviceTileGridAspectStandard,
                  ),
                  itemCount: actions.length,
                  itemBuilder: (context, index) {
                    final action = actions[index];
                    return VitServiceTile(
                      density: serviceDensity,
                      icon: action.icon,
                      label: action.label,
                      accentColor: action.accentColor,
                      badgeLabel: action.stateLabel,
                      onTap: () => onNavigate(action.routePath),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
