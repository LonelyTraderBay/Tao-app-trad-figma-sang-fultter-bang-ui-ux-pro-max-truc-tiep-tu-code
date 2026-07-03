part of 'home_page.dart';

Widget _homeServiceTile(
  HomeQuickAction action,
  VitServiceTileDensity tileDensity,
  ValueChanged<String> onNavigate,
) {
  return VitServiceTile(
    density: tileDensity,
    icon: action.icon,
    label: action.label,
    accentColor: action.accentColor,
    badgeLabel: action.stateLabel,
    onTap: () => onNavigate(action.routePath),
  );
}

class _HomePageState extends ConsumerState<HomePage> {
  String _marketTab = 'hot';
  bool _balanceHidden = false;
  final Set<String> _sessionHiddenAnnouncementIds = <String>{};
  final Set<String> _dismissedNextActionIds = <String>{};

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
    final announcements = snapshot.announcements
        .where(
          (announcement) =>
              announcement.active &&
              announcement.type.surfacesOnHome &&
              !_sessionHiddenAnnouncementIds.contains(announcement.id),
        )
        .toList(growable: false);
    announcements.sort(
      (a, b) => _announcementSortKey(a.type).compareTo(
        _announcementSortKey(b.type),
      ),
    );
    return announcements;
  }

  int _announcementSortKey(HomeAnnouncementType type) {
    return switch (type) {
      HomeAnnouncementType.security => 0,
      HomeAnnouncementType.risk => 1,
      HomeAnnouncementType.campaign => 2,
      HomeAnnouncementType.info => 3,
    };
  }

  List<HomeQuickAction> _gridQuickActions(List<HomeQuickAction> actions) {
    return actions
        .where(
          (action) => !_homeDiscoveryQuickActionRoutes.contains(action.routePath),
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

  void _dismissNextAction(HomeNextAction nextAction) {
    setState(() => _dismissedNextActionIds.add(nextAction.routePath));
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

  int _primaryQuickActionCount(HomeDensityVariant variant) {
    return variant == HomeDensityVariant.compact
        ? AppSpacing.homeQuickActionCompactCount
        : AppSpacing.homeQuickActionStandardCount;
  }

  @override
  Widget build(BuildContext context) {
    final homeAsync = ref.watch(homeSnapshotProvider);
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
        child: homeAsync.when(
          loading: () => _HomeScrollShell(
            scrollEndClearance: scrollEndClearance,
            onRefresh: _refreshHome,
            visibleAnnouncements: const [],
            child: const _HomeLoadingContent(),
          ),
          error: (error, stackTrace) => _HomeErrorContent(onRetry: _refreshHome),
          data: (snapshot) {
            final controller = HomeController(
              state: HomeViewState(snapshot: snapshot),
            );
            final screenWidth = MediaQuery.sizeOf(context).width;
            final homeVariant = _homeDensityVariant(screenWidth);
            final homeDensity = _tileDensity(homeVariant);
            final homePrimaryQuickActionCount = _primaryQuickActionCount(
              homeVariant,
            );
            final visibleAnnouncements = _visibleAnnouncements(snapshot);
            final gridQuickActions = _gridQuickActions(snapshot.quickActions);
            final moreQuickActions = gridQuickActions
                .skip(homePrimaryQuickActionCount)
                .toList(growable: false);
            final visibleNextAction = _visibleNextAction(snapshot.nextAction);

            return _HomeScrollShell(
              scrollEndClearance: scrollEndClearance,
              onRefresh: _refreshHome,
              visibleAnnouncements: visibleAnnouncements,
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
                  if (visibleNextAction != null)
                    _NextActionSection(
                      nextAction: visibleNextAction,
                      onNavigate: _go,
                      onDismiss: () => _dismissNextAction(visibleNextAction),
                    ),
                  _MarketTickerSection(
                    pairs: controller.hotPairs.take(3).toList(),
                    onNavigate: _go,
                  ),
                  _ProductsSection(
                    actions: gridQuickActions,
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
                  _HomeDiscoverySection(onNavigate: _go),
                  _MarketSection(
                    activeTab: _marketTab,
                    pairs: controller.tabPairs(_marketTab),
                    onTabChanged: _setTab,
                    onNavigate: _go,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _HomeScrollShell extends StatelessWidget {
  const _HomeScrollShell({
    required this.scrollEndClearance,
    required this.onRefresh,
    required this.visibleAnnouncements,
    required this.child,
  });

  final double scrollEndClearance;
  final Future<void> Function() onRefresh;
  final List<HomeAnnouncement> visibleAnnouncements;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        final state = context.findAncestorStateOfType<_HomePageState>();
        return state?._handleHomeScrollNotification(
              notification,
              visibleAnnouncements,
            ) ??
            false;
      },
      child: RefreshIndicator(
        onRefresh: onRefresh,
        child: VitInsetScrollView(
          key: HomePage.contentKey,
          bottomInset: scrollEndClearance,
          physics: const AlwaysScrollableScrollPhysics(),
          child: child,
        ),
      ),
    );
  }
}

class _HomeLoadingContent extends StatelessWidget {
  const _HomeLoadingContent();

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      padding: VitContentPadding.compact,
      density: VitDensity.compact,
      children: const [
        _HomePortfolioSkeleton(),
        SizedBox(height: AppSpacing.x3),
        _HomeMarketSkeleton(),
      ],
    );
  }
}

class _HomeErrorContent extends StatelessWidget {
  const _HomeErrorContent({required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return VitInsetScrollView(
      key: HomePage.contentKey,
      physics: const AlwaysScrollableScrollPhysics(),
      child: VitErrorState(
        title: 'Không tải được dữ liệu',
        message: 'Vui lòng kiểm tra kết nối và thử lại.',
        actionLabel: 'Thử lại',
        onAction: () => onRetry(),
      ),
    );
  }
}

class _HomePortfolioSkeleton extends StatelessWidget {
  const _HomePortfolioSkeleton();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: AppSpacing.homePortfolioCardPadding,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VitSkeleton(width: 160, height: AppSpacing.x3),
          SizedBox(height: AppSpacing.x3),
          VitSkeleton(width: double.infinity, height: AppSpacing.x6),
          SizedBox(height: AppSpacing.x3),
          VitSkeleton(width: 120, height: AppSpacing.x3),
        ],
      ),
    );
  }
}

class _HomeMarketSkeleton extends StatelessWidget {
  const _HomeMarketSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitSkeleton(width: 120, height: AppSpacing.x4),
        SizedBox(height: AppSpacing.x3),
        VitSkeletonList(rows: 3),
      ],
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

class _AnnouncementBanner extends StatefulWidget {
  const _AnnouncementBanner({
    required this.announcements,
    required this.onDismiss,
  });

  final List<HomeAnnouncement> announcements;
  final ValueChanged<HomeAnnouncement> onDismiss;

  @override
  State<_AnnouncementBanner> createState() => _AnnouncementBannerState();
}

class _AnnouncementBannerState extends State<_AnnouncementBanner> {
  static const _autoAdvanceInterval = Duration(seconds: 5);

  int _activeIndex = 0;
  Timer? _autoAdvanceTimer;

  @override
  void initState() {
    super.initState();
    _startAutoAdvance();
  }

  @override
  void didUpdateWidget(covariant _AnnouncementBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.announcements.length != widget.announcements.length) {
      _activeIndex = 0;
    } else if (_activeIndex >= widget.announcements.length) {
      _activeIndex = 0;
    }
    _startAutoAdvance();
  }

  @override
  void dispose() {
    _autoAdvanceTimer?.cancel();
    super.dispose();
  }

  void _startAutoAdvance() {
    _autoAdvanceTimer?.cancel();
    if (widget.announcements.length <= 1) return;

    _autoAdvanceTimer = Timer.periodic(_autoAdvanceInterval, (_) {
      if (!mounted) return;
      setState(() {
        _activeIndex = (_activeIndex + 1) % widget.announcements.length;
      });
    });
  }

  void _showNextAnnouncement() {
    if (widget.announcements.length <= 1) return;
    setState(() {
      _activeIndex = (_activeIndex + 1) % widget.announcements.length;
    });
    _startAutoAdvance();
  }

  @override
  Widget build(BuildContext context) {
    final announcement = widget.announcements[_activeIndex];
    return VitAnnouncementBanner(
      key: HomePage.announcementKey,
      message: announcement.text,
      itemCount: widget.announcements.length,
      activeIndex: _activeIndex,
      variant: VitAnnouncementBannerVariant.compact,
      showCompactDots: true,
      icon: _announcementIcon(announcement.type),
      accentColor: _announcementColor(announcement.type),
      onTap: _showNextAnnouncement,
      onDismiss: () => widget.onDismiss(announcement),
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

class _PortfolioCard extends StatefulWidget {
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
  State<_PortfolioCard> createState() => _PortfolioCardState();
}

class _PortfolioCardState extends State<_PortfolioCard> {
  bool _btcPrimary = false;

  HomeSnapshot get snapshot => widget.snapshot;
  bool get balanceHidden => widget.balanceHidden;

  bool get _isEmpty => snapshot.totalBalance <= 0;

  String get _primaryBalanceLabel {
    if (balanceHidden) return '••••••';
    if (_btcPrimary) {
      return '${snapshot.totalBtc.toStringAsFixed(8)} BTC';
    }
    return _formatUsd(snapshot.totalBalance, forceTwoDecimals: true);
  }

  String get _secondaryBalanceLabel {
    if (balanceHidden) return '••••• BTC';
    if (_btcPrimary) {
      return _formatUsd(snapshot.totalBalance, forceTwoDecimals: true);
    }
    return '≈ ${snapshot.totalBtc.toStringAsFixed(8)} BTC';
  }

  @override
  Widget build(BuildContext context) {
    if (_isEmpty) {
      return _buildEmptyCard(context);
    }

    final showDelta = !balanceHidden;
    final pnlPositive = snapshot.dailyPnl >= 0;
    final trend = snapshot.portfolioTrend7d;
    final trendPositive =
        trend.length >= 2 ? trend.last >= trend.first : pnlPositive;

    return VitCard(
      key: HomePage.portfolioCardKey,
      variant: VitCardVariant.hero,
      radius: VitCardRadius.large,
      clip: true,
      padding: AppSpacing.homePortfolioCardPadding,
      background: const VitHeroGlow(center: Alignment(0, -0.96)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          const SizedBox(height: AppSpacing.x3),
          _buildBalanceSection(),
          if (showDelta) ...[
            const SizedBox(height: AppSpacing.x3),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'PnL hôm nay',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.portfolioTextMuted,
                      fontWeight: AppTextStyles.medium,
                    ),
                  ),
                ),
                VitMetricDeltaPill(
                  label:
                      '${pnlPositive ? '+' : ''}${_formatUsd(snapshot.dailyPnl.abs())} (${_formatPct(snapshot.dailyPct)})',
                  tone: pnlPositive
                      ? VitMetricDeltaTone.positive
                      : VitMetricDeltaTone.negative,
                ),
              ],
            ),
            if (trend.length >= 2) ...[
              const SizedBox(height: AppSpacing.x3),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Biến động 7 ngày',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.portfolioTextMuted,
                            fontWeight: AppTextStyles.medium,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x1),
                        Text(
                          'Theo giá trị tài sản',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.portfolioTextDim,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: _homePortfolioTrendHeight,
                      child: VitSparkline(
                        values: trend,
                        color: trendPositive ? AppColors.buy : AppColors.sell,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
          const SizedBox(height: AppSpacing.x3),
          _HomePortfolioBreakdown(
            snapshot: snapshot,
            balanceHidden: balanceHidden,
            onNavigate: widget.onNavigate,
          ),
          const SizedBox(height: AppSpacing.x4),
          _buildActionRow(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tổng tài sản ước tính',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.portfolioTextDim,
                  fontWeight: AppTextStyles.medium,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                'Quy USD · theo giá thị trường',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.portfolioTextMuted,
                ),
              ),
            ],
          ),
        ),
        VitInlineIconAction(
          tooltip: balanceHidden ? 'Hiện số dư' : 'Ẩn số dư',
          onPressed: widget.onToggleBalance,
          icon: balanceHidden
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: AppColors.portfolioTextDim,
        ),
      ],
    );
  }

  Widget _buildBalanceSection() {
    return Semantics(
      button: true,
      label: balanceHidden
          ? 'Số dư đang ẩn. Chạm để mở trang ví.'
          : 'Tổng tài sản $_primaryBalanceLabel. Chạm để mở trang ví.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => widget.onNavigate('/wallet'),
            borderRadius: AppRadii.inputRadius,
            child: Text(
              _primaryBalanceLabel,
              style: AppTextStyles.heroNumber.copyWith(
                color: AppColors.onAccent,
                letterSpacing: 0,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Tooltip(
            message: balanceHidden
                ? 'Số dư đang ẩn'
                : 'Chạm để đổi hiển thị USD/BTC',
            child: InkWell(
              onTap: balanceHidden
                  ? null
                  : () => setState(() => _btcPrimary = !_btcPrimary),
              borderRadius: AppRadii.inputRadius,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!balanceHidden) ...[
                    Icon(
                      Icons.swap_horiz_rounded,
                      size: AppSpacing.homePortfolioBadgeIcon,
                      color: AppColors.portfolioTextMuted,
                    ),
                    const SizedBox(width: AppSpacing.x1),
                  ],
                  Text(
                    _secondaryBalanceLabel,
                    style: AppTextStyles.numericMicro.copyWith(
                      color: AppColors.portfolioTextMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow() {
    return Row(
      children: [
        Expanded(
          child: VitCtaButton(
            height: _heroActionExtent,
            density: VitDensity.compact,
            fullWidth: true,
            onPressed: () => widget.onNavigate('/wallet/deposit/USDT'),
            leading: const Icon(Icons.file_download_outlined),
            child: const Text('Nạp'),
          ),
        ),
        const SizedBox(width: AppSpacing.homePortfolioActionSpacing),
        Expanded(
          child: VitCtaButton(
            height: _heroActionExtent,
            density: VitDensity.compact,
            fullWidth: true,
            variant: VitCtaButtonVariant.secondary,
            onPressed: () => widget.onNavigate('/wallet/withdraw/USDT'),
            leading: const Icon(Icons.file_upload_outlined),
            child: const Text('Rút'),
          ),
        ),
        const SizedBox(width: AppSpacing.homePortfolioActionSpacing),
        Expanded(
          child: VitCtaButton(
            height: _heroActionExtent,
            density: VitDensity.compact,
            fullWidth: true,
            variant: VitCtaButtonVariant.secondary,
            onPressed: () => widget.onNavigate('/wallet'),
            leading: const Icon(Icons.account_balance_wallet_outlined),
            child: const Text('Ví'),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyCard(BuildContext context) {
    return VitCard(
      key: HomePage.portfolioCardKey,
      variant: VitCardVariant.hero,
      radius: VitCardRadius.large,
      clip: true,
      padding: AppSpacing.homePortfolioCardPadding,
      background: const VitHeroGlow(center: Alignment(0, -0.96)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                Icons.account_balance_wallet_outlined,
                color: AppColors.portfolioTextDim,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chưa có tài sản',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.onAccent,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      'Nạp USDT để bắt đầu giao dịch, earn và khám phá sản phẩm trên VitTrade.',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.portfolioTextMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          VitCtaButton(
            key: HomePage.portfolioDepositKey,
            height: _heroActionExtent,
            density: VitDensity.compact,
            fullWidth: true,
            onPressed: () => widget.onNavigate('/wallet/deposit/USDT'),
            leading: const Icon(Icons.file_download_outlined),
            child: const Text('Nạp ngay'),
          ),
          const SizedBox(height: AppSpacing.x2),
          VitCtaButton(
            height: _heroActionExtent,
            density: VitDensity.compact,
            fullWidth: true,
            variant: VitCtaButtonVariant.secondary,
            onPressed: () => widget.onNavigate('/markets'),
            leading: const Icon(Icons.insights_outlined),
            child: const Text('Xem thị trường'),
          ),
        ],
      ),
    );
  }
}

class _HomePortfolioBreakdown extends StatelessWidget {
  const _HomePortfolioBreakdown({
    required this.snapshot,
    required this.balanceHidden,
    required this.onNavigate,
  });

  final HomeSnapshot snapshot;
  final bool balanceHidden;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        'Spot',
        snapshot.spotBalance,
        Icons.swap_horiz_rounded,
        'Ví spot — tiền dùng mua/bán coin ngay lập tức',
        AppRoutePaths.wallet,
      ),
      (
        'Earn',
        snapshot.earnBalance,
        Icons.savings_outlined,
        'Tài sản stake hoặc savings — sinh lãi theo thời gian',
        AppRoutePaths.earnStaking,
      ),
      (
        'Funding',
        snapshot.fundingBalance,
        Icons.account_balance_outlined,
        'Ví funding cho margin, futures và chuyển nội bộ',
        AppRoutePaths.walletTransfer,
      ),
    ];

    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      padding: VitDensity.compact.cardPadding,
      borderColor: AppColors.onAccent.withValues(alpha: .08),
      child: Row(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            Expanded(
              child: Semantics(
                button: true,
                label: '${items[i].$1}: mở ${items[i].$1}',
                child: InkWell(
                  onTap: () => onNavigate(items[i].$5),
                  borderRadius: AppRadii.inputRadius,
                  child: Tooltip(
                    message: items[i].$4,
                    child: Column(
                      children: [
                        VitStatusPill(
                          label: items[i].$1,
                          status: VitStatusPillStatus.neutral,
                          icon: items[i].$3,
                          size: VitStatusPillSize.sm,
                        ),
                        const SizedBox(height: AppSpacing.x1),
                        Text(
                          balanceHidden ? '••••' : _formatUsd(items[i].$2),
                          textAlign: TextAlign.center,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                            fontFeatures: AppTextStyles.tabularFigures,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (i != items.length - 1) const SizedBox(width: AppSpacing.x1),
          ],
        ],
      ),
    );
  }
}

class _NextActionSection extends StatelessWidget {
  const _NextActionSection({
    required this.nextAction,
    required this.onNavigate,
    required this.onDismiss,
  });

  final HomeNextAction nextAction;
  final ValueChanged<String> onNavigate;
  final VoidCallback onDismiss;

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
          onDismiss: onDismiss,
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
        if (recentProducts.isEmpty)
          VitEmptyState(
            title: 'Chưa có hoạt động gần đây',
            message: 'Các sản phẩm bạn vừa dùng sẽ hiện ở đây.',
            icon: Icons.history_rounded,
            actionLabel: 'Khám phá thị trường',
            onAction: () => onNavigate('/markets'),
          )
        else
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
        return _homeServiceTile(action, tileDensity, onNavigate);
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
          return _homeServiceTile(action, tileDensity, onNavigate);
        },
      ),
    );
  }
}
