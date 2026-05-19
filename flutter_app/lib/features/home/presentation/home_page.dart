import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/vit_page_content.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/home_mock_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc007_home_scroll_content');
  static const headerKey = Key('sc007_home_header');

  final ShellRenderMode? shellRenderMode;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _marketTab = 'hot';
  bool _balanceHidden = false;
  bool _headerVisible = true;

  List<HomeCryptoPair> get _hotPairs {
    return HomeMockData.pairs.where((pair) => pair.isFavorite).take(5).toList();
  }

  List<HomeCryptoPair> get _gainers {
    final pairs = [...HomeMockData.pairs];
    pairs.sort((a, b) => b.change24h.compareTo(a.change24h));
    return pairs.take(5).toList();
  }

  List<HomeCryptoPair> get _losers {
    final pairs = [...HomeMockData.pairs];
    pairs.sort((a, b) => a.change24h.compareTo(b.change24h));
    return pairs.take(5).toList();
  }

  List<HomeCryptoPair> get _tabPairs {
    switch (_marketTab) {
      case 'gainers':
        return _gainers;
      case 'losers':
        return _losers;
      case 'new':
        return HomeMockData.pairs.reversed.take(5).toList();
      case 'hot':
      default:
        return _hotPairs;
    }
  }

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
            child: _HomeHeader(onNavigate: _go),
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
                      const _AnnouncementBanner(),
                      _PortfolioCard(
                        balanceHidden: _balanceHidden,
                        onToggleBalance: _toggleBalanceHidden,
                        onNavigate: _go,
                      ),
                      const _SectionHeader(title: 'Dịch vụ'),
                      _QuickActionsGrid(onNavigate: _go),
                      _HomeDiscoverySection(onNavigate: _go),
                      _MarketSection(
                        activeTab: _marketTab,
                        pairs: _tabPairs,
                        onTabChanged: _setTab,
                        onNavigate: _go,
                      ),
                      _TrendingSection(
                        pairs: HomeMockData.pairs.take(5).toList(),
                        onNavigate: _go,
                      ),
                      _RankedListSection(
                        title: 'Top tăng giá',
                        icon: Icons.trending_up_rounded,
                        iconColor: AppColors.buy,
                        pairs: _gainers.take(3).toList(),
                        positive: true,
                        onNavigate: _go,
                      ),
                      _RankedListSection(
                        title: 'Top giảm giá',
                        icon: Icons.trending_down_rounded,
                        iconColor: AppColors.sell,
                        pairs: _losers.take(3).toList(),
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
  const _HomeHeader({required this.onNavigate});

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
                  const Positioned(
                    top: -5,
                    right: -5,
                    child: _CountBadge(count: HomeMockData.notifications),
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
  const _AnnouncementBanner();

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
                  HomeMockData.announcements.first.text,
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
    required this.balanceHidden,
    required this.onToggleBalance,
    required this.onNavigate,
  });

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
                    : _formatUsd(
                        HomeMockData.totalBalance,
                        forceTwoDecimals: true,
                      ),
                style: AppTextStyles.heroNumber.copyWith(
                  color: Colors.white,
                  fontSize: 34,
                  letterSpacing: 0,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: AppSpacing.x4),
              if (!balanceHidden)
                Row(
                  children: [
                    Container(
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
                          Text(
                            '+${_formatUsd(HomeMockData.dailyPnl)} (${_formatPct(HomeMockData.dailyPct)})',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.buy,
                              fontSize: 12,
                              fontWeight: AppTextStyles.medium,
                              height: 1,
                            ),
                          ),
                        ],
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
  const _QuickActionsGrid({required this.onNavigate});

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
      itemCount: HomeMockData.quickActions.length,
      itemBuilder: (context, index) {
        final action = HomeMockData.quickActions[index];
        return VitCard(
          radius: VitCardRadius.sm,
          onTap: () => onNavigate(action.routePath),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                action.icon,
                style: const TextStyle(fontSize: 18, height: 1),
              ),
              const SizedBox(height: AppSpacing.x3),
              Text(
                action.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HomeDiscoverySection extends StatelessWidget {
  const _HomeDiscoverySection({required this.onNavigate});

  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionHeader(title: 'Dự đoán & Thách đấu'),
        const SizedBox(height: AppSpacing.x4),
        _DiscoveryCard(
          title: 'Prediction Markets',
          badge: 'Prediction Market',
          subtitle: 'Thị trường xác suất, vị thế và portfolio',
          actionLabel: 'Khám phá thị trường',
          icon: Icons.adjust_rounded,
          color: AppColors.accent,
          border: AppColors.accent20,
          background: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.accent15, AppColors.primary08],
          ),
          onTap: () => onNavigate('/markets/predictions'),
        ),
        const SizedBox(height: 10),
        _DiscoveryCard(
          title: 'Open Arena',
          badge: 'Arena Points only',
          subtitle: 'Tạo mode chơi, mở room, dùng Arena Points',
          actionLabel: 'Vào Arena',
          icon: Icons.sports_esports_outlined,
          color: AppColors.warn,
          border: AppColors.warningBorder,
          background: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.warn15, Color(0x1AEA580C)],
          ),
          onTap: () => onNavigate('/arena'),
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          'Predictions sử dụng vị thế thực. Arena sử dụng Points (không phải tiền thật).',
          textAlign: TextAlign.center,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 9,
          ),
        ),
      ],
    );
  }
}

class _MarketSection extends StatelessWidget {
  const _MarketSection({
    required this.activeTab,
    required this.pairs,
    required this.onTabChanged,
    required this.onNavigate,
  });

  final String activeTab;
  final List<HomeCryptoPair> pairs;
  final ValueChanged<String> onTabChanged;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionHeader(
          title: 'Thị trường',
          actionLabel: 'Xem tất cả',
          onAction: () => onNavigate('/markets'),
        ),
        const SizedBox(height: AppSpacing.x4),
        VitTabBar(
          activeKey: activeTab,
          onChanged: onTabChanged,
          tabs: const [
            VitTabItem(key: 'hot', label: '🔥 Hot'),
            VitTabItem(key: 'gainers', label: '📈 Tăng'),
            VitTabItem(key: 'losers', label: '📉 Giảm'),
            VitTabItem(key: 'new', label: '🆕 Mới'),
          ],
        ),
        const SizedBox(height: AppSpacing.x4),
        VitCard(
          clip: true,
          child: Column(
            children: [
              for (var i = 0; i < pairs.length; i++) ...[
                _MarketRow(
                  pair: pairs[i],
                  showSparkline: true,
                  onTap: () => onNavigate('/pair/${pairs[i].id}'),
                ),
                if (i < pairs.length - 1)
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.divider,
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _TrendingSection extends StatelessWidget {
  const _TrendingSection({required this.pairs, required this.onNavigate});

  final List<HomeCryptoPair> pairs;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionHeader(
          title: 'Xu hướng',
          icon: Icons.bolt_rounded,
          iconColor: AppColors.warn,
          actionLabel: 'Xem tất cả',
          onAction: () => onNavigate('/markets'),
        ),
        const SizedBox(height: AppSpacing.x4),
        SizedBox(
          height: 128,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: pairs.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final pair = pairs[index];
              return SizedBox(
                width: 148,
                child: VitCard(
                  onTap: () => onNavigate('/pair/${pair.id}'),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _CoinAvatar(
                            pair: pair,
                            size: 28,
                            radius: AppRadii.xs,
                          ),
                          const SizedBox(width: AppSpacing.x3),
                          Expanded(
                            child: Text(
                              pair.baseAsset,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.body.copyWith(
                                fontWeight: AppTextStyles.medium,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        _formatUsd(pair.price),
                        style: AppTextStyles.base.copyWith(
                          fontWeight: AppTextStyles.bold,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        _formatPct(pair.change24h),
                        style: AppTextStyles.micro.copyWith(
                          color: pair.change24h >= 0
                              ? AppColors.buy
                              : AppColors.sell,
                          fontWeight: AppTextStyles.medium,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _RankedListSection extends StatelessWidget {
  const _RankedListSection({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.pairs,
    required this.positive,
    required this.onNavigate,
  });

  final String title;
  final IconData icon;
  final Color iconColor;
  final List<HomeCryptoPair> pairs;
  final bool positive;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionHeader(
          title: title,
          icon: icon,
          iconColor: iconColor,
          actionLabel: 'Xem tất cả',
          onAction: () => onNavigate('/markets'),
        ),
        const SizedBox(height: AppSpacing.x4),
        VitCard(
          clip: true,
          child: Column(
            children: [
              for (var i = 0; i < pairs.length; i++) ...[
                _RankedRow(
                  rank: i + 1,
                  pair: pairs[i],
                  positive: positive,
                  onTap: () => onNavigate('/pair/${pairs[i].id}'),
                ),
                if (i < pairs.length - 1)
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.divider,
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    this.icon,
    this.iconColor,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final IconData? icon;
  final Color? iconColor;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            color: iconColor ?? AppColors.text1,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: 6),
        ],
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.sectionTitle.copyWith(
              fontWeight: AppTextStyles.bold,
              height: 1.2,
            ),
          ),
        ),
        if (actionLabel != null && onAction != null)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onAction,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.x3,
                vertical: AppSpacing.x2,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    actionLabel!,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: AppTextStyles.medium,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x1),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.primary,
                    size: 14,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _DiscoveryCard extends StatelessWidget {
  const _DiscoveryCard({
    required this.title,
    required this.badge,
    required this.subtitle,
    required this.actionLabel,
    required this.icon,
    required this.color,
    required this.border,
    required this.background,
    required this.onTap,
  });

  final String title;
  final String badge;
  final String subtitle;
  final String actionLabel;
  final IconData icon;
  final Color color;
  final Color border;
  final Gradient background;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      onTap: onTap,
      borderColor: border,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: background,
              borderRadius: AppRadii.mdRadius,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: AppSpacing.x3,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    VitStatusPill(
                      label: badge,
                      status: color == AppColors.warn
                          ? VitStatusPillStatus.warning
                          : VitStatusPillStatus.purple,
                      size: VitStatusPillSize.sm,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  actionLabel,
                  style: AppTextStyles.micro.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: color, size: 16),
        ],
      ),
    );
  }
}

class _MarketRow extends StatelessWidget {
  const _MarketRow({
    required this.pair,
    required this.showSparkline,
    required this.onTap,
  });

  final HomeCryptoPair pair;
  final bool showSparkline;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            _CoinAvatar(pair: pair),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pair.symbol,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: AppTextStyles.medium,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    'Vol \$${_formatBillions(pair.volume24h)}B',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ),
            if (showSparkline) ...[
              SizedBox(
                width: 64,
                height: 30,
                child: CustomPaint(
                  painter: _SparklinePainter(
                    values: pair.sparkline,
                    color: pair.change24h >= 0 ? AppColors.buy : AppColors.sell,
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
            SizedBox(
              width: 85,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatUsd(pair.price),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: AppTextStyles.medium,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    _formatPct(pair.change24h),
                    style: AppTextStyles.micro.copyWith(
                      color: pair.change24h >= 0
                          ? AppColors.buy
                          : AppColors.sell,
                      fontWeight: AppTextStyles.medium,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RankedRow extends StatelessWidget {
  const _RankedRow({
    required this.rank,
    required this.pair,
    required this.positive,
    required this.onTap,
  });

  final int rank;
  final HomeCryptoPair pair;
  final bool positive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = positive ? AppColors.buy : AppColors.sell;
    final bg = positive ? AppColors.buy10 : AppColors.sell10;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            SizedBox(
              width: 20,
              child: Text(
                '$rank',
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(
                  color: rank == 1 && positive
                      ? AppColors.warn
                      : AppColors.text3,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            _CoinAvatar(pair: pair),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                pair.symbol,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body.copyWith(
                  fontWeight: AppTextStyles.medium,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: AppRadii.xsRadius,
              ),
              child: Text(
                _formatPct(pair.change24h),
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CoinAvatar extends StatelessWidget {
  const _CoinAvatar({
    required this.pair,
    this.size = 34,
    this.radius = AppRadii.sm,
  });

  final HomeCryptoPair pair;
  final double size;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: pair.logoColor.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Text(
        pair.baseAsset.characters.first,
        style: AppTextStyles.caption.copyWith(
          color: pair.logoColor,
          fontSize: size <= 28 ? 10 : 13,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 16),
      height: 16,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.sell,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: AppColors.sell20,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        count > 99 ? '99+' : '$count',
        style: AppTextStyles.micro.copyWith(
          color: Colors.white,
          fontSize: 9,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: active ? 16 : 5,
      height: 5,
      decoration: BoxDecoration(
        color: active
            ? AppColors.primary
            : AppColors.text3.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

class _PortfolioGlow extends StatelessWidget {
  const _PortfolioGlow();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0.58, -0.68),
          radius: 0.82,
          colors: [
            AppColors.primary12,
            AppColors.primary08.withValues(alpha: 0.08),
            Colors.transparent,
          ],
          stops: const [0, 0.36, 1],
        ),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  const _SparklinePainter({required this.values, required this.color});

  final List<double> values;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;

    final minValue = values.reduce((a, b) => a < b ? a : b);
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    final range = maxValue - minValue == 0 ? 1 : maxValue - minValue;
    final path = Path();
    final fillPath = Path();

    for (var i = 0; i < values.length; i++) {
      final x = i / (values.length - 1) * size.width;
      final y =
          size.height -
          ((values[i] - minValue) / range * (size.height - 6)) -
          3;
      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
      if (i == values.length - 1) {
        fillPath.lineTo(x, size.height);
        fillPath.close();
      }
    }

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withValues(alpha: 0.28), color.withValues(alpha: 0)],
      ).createShader(Offset.zero & size)
      ..style = PaintingStyle.fill;
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) {
    return oldDelegate.values != values || oldDelegate.color != color;
  }
}

String _formatUsd(double value, {bool forceTwoDecimals = false}) {
  final decimals = forceTwoDecimals || value >= 1 ? 2 : 4;
  final fixed = value.toStringAsFixed(decimals);
  final parts = fixed.split('.');
  final buffer = StringBuffer();
  final whole = parts.first;
  for (var i = 0; i < whole.length; i++) {
    final fromEnd = whole.length - i;
    buffer.write(whole[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
  }
  return '\$${buffer.toString()}.${parts.last}';
}

String _formatPct(double value) {
  final sign = value >= 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(2)}%';
}

String _formatBillions(double value) {
  return (value / 1000000000).toStringAsFixed(2);
}
