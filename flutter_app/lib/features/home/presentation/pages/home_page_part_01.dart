part of 'home_page.dart';

const _homePrimaryQuickActionCount = 12;

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

  void _showMoreProducts(List<HomeQuickAction> actions) {
    if (actions.isEmpty) return;

    final rootContext = context;
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

    if (notification.metrics.pixels <= 8) {
      _setHeaderVisible(true);
      return false;
    }

    switch (notification.direction) {
      case ScrollDirection.reverse:
        if (notification.metrics.pixels > 24) {
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

    if (notification.metrics.pixels <= 8) {
      _setHeaderVisible(true);
      return false;
    }

    final delta = notification.scrollDelta ?? 0;
    if (delta > 0 && notification.metrics.pixels > 24) {
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
    final primaryQuickActions = snapshot.quickActions
        .take(_homePrimaryQuickActionCount)
        .toList(growable: false);
    final moreQuickActions = snapshot.quickActions
        .skip(_homePrimaryQuickActionCount)
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
        (nativeShell ? 16 : 40);

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
                    customGap: nativeShell ? 12 : null,
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
                            : () => _showMoreProducts(moreQuickActions),
                      ),
                      _QuickActionsGrid(
                        actions: primaryQuickActions,
                        onNavigate: _go,
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
            offset: visible ? Offset.zero : const Offset(0, -0.25),
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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              const Icon(
                Icons.card_giftcard_rounded,
                color: AppColors.primary,
                size: 18,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  announcements.first.text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.text3,
                size: 16,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _Dot(active: true),
            SizedBox(width: 5),
            _Dot(active: false),
            SizedBox(width: 5),
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
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
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
                      padding: const EdgeInsets.all(6),
                      child: Icon(
                        balanceHidden
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.portfolioTextDim,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x3),
              Text(
                balanceHidden
                    ? '••••••'
                    : _formatUsd(snapshot.totalBalance, forceTwoDecimals: true),
                style: AppTextStyles.heroNumber.copyWith(
                  color: AppColors.onAccent,
                  fontSize: 34,
                  letterSpacing: 0,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: AppSpacing.x4),
              if (!balanceHidden)
                Row(
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
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
                              size: 12,
                            ),
                            const SizedBox(width: AppSpacing.x1),
                            Flexible(
                              child: Text(
                                '+${_formatUsd(snapshot.dailyPnl)} (${_formatPct(snapshot.dailyPct)})',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.buy,
                                  fontSize: 12,
                                  fontWeight: AppTextStyles.medium,
                                  height: 1,
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
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: VitCtaButton(
                      height: 44,
                      fullWidth: true,
                      onPressed: () => onNavigate('/wallet/deposit/USDT'),
                      leading: const Icon(Icons.file_download_outlined),
                      child: const Text('Nạp'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: VitCtaButton(
                      height: 44,
                      fullWidth: true,
                      variant: VitCtaButtonVariant.secondary,
                      onPressed: () => onNavigate('/wallet/withdraw/USDT'),
                      leading: const Icon(Icons.file_upload_outlined),
                      child: const Text('Rút'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: VitCtaButton(
                      height: 44,
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
        const SizedBox(height: AppSpacing.x3),
        _NextActionCard(
          action: nextAction,
          onTap: () => onNavigate(nextAction.routePath),
        ),
        const SizedBox(height: AppSpacing.x4),
        const _SectionHeader(title: 'Gần đây'),
        const SizedBox(height: AppSpacing.x3),
        SizedBox(
          key: HomePage.recentProductsKey,
          height: 86,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: recentProducts.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
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
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      borderColor: action.accentColor.withValues(alpha: .28),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: action.accentColor.withValues(alpha: .14),
              borderRadius: AppRadii.mdRadius,
            ),
            child: Icon(action.icon, color: action.accentColor, size: 20),
          ),
          const SizedBox(width: 12),
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
                          height: 1.15,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _CommandChip(
                      label: action.stateLabel,
                      color: action.accentColor,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  action.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 10,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            action.ctaLabel,
            style: AppTextStyles.caption.copyWith(
              color: action.accentColor,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            Icons.chevron_right_rounded,
            color: action.accentColor,
            size: 18,
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
      width: 146,
      child: VitCard(
        key: HomePage.recentProductKey(product.id),
        onTap: onTap,
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: product.accentColor.withValues(alpha: .14),
                    borderRadius: AppRadii.smRadius,
                  ),
                  child: Icon(
                    product.icon,
                    color: product.accentColor,
                    size: 15,
                  ),
                ),
                const Spacer(),
                _CommandChip(
                  label: product.stateLabel,
                  color: product.accentColor,
                ),
              ],
            ),
            const Spacer(),
            Text(
              product.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              product.contextLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontSize: 10,
                height: 1,
              ),
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
      constraints: const BoxConstraints(minHeight: 20),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: .26)),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 9,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  const _QuickActionsGrid({required this.actions, required this.onNavigate});

  final List<HomeQuickAction> actions;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: AppSpacing.x3,
        mainAxisSpacing: AppSpacing.x3,
        childAspectRatio: 1.68,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return VitServiceTile(
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
  const _MoreProductsSheet({required this.actions, required this.onNavigate});

  final List<HomeQuickAction> actions;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.sizeOf(context).height * .72;

    return SafeArea(
      top: false,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Padding(
          key: HomePage.moreProductsSheetKey,
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.borderSolid,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.x4),
              Text(
                'Th\u00EAm s\u1EA3n ph\u1EA9m',
                style: AppTextStyles.sectionTitle.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x4),
              Flexible(
                child: GridView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: AppSpacing.x3,
                    mainAxisSpacing: AppSpacing.x3,
                    childAspectRatio: 1.68,
                  ),
                  itemCount: actions.length,
                  itemBuilder: (context, index) {
                    final action = actions[index];
                    return VitServiceTile(
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
