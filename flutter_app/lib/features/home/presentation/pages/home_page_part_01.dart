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
    context.go(path);
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
              notifications: snapshot.notifications,
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
                      const _SectionHeader(title: 'Dịch vụ'),
                      _QuickActionsGrid(
                        actions: snapshot.quickActions,
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'VitTrade',
              style: AppTextStyles.pageTitle.copyWith(
                fontSize: 26,
                letterSpacing: 0,
                height: 1.25,
              ),
            ),
          ),
          Row(
            children: [
              VitIconButton(
                icon: Icons.search_rounded,
                tooltip: 'Tìm kiếm toàn cục',
                size: VitIconButtonSize.md,
                onPressed: () => onNavigate('/search'),
              ),
              const SizedBox(width: 6),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  VitIconButton(
                    icon: Icons.notifications_none_rounded,
                    tooltip: 'Thông báo',
                    size: VitIconButtonSize.md,
                    onPressed: () => onNavigate('/notifications'),
                  ),
                  Positioned(
                    top: -5,
                    right: -5,
                    child: _CountBadge(count: notifications),
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
          onTap: () => onNavigate(action.routePath),
        );
      },
    );
  }
}
