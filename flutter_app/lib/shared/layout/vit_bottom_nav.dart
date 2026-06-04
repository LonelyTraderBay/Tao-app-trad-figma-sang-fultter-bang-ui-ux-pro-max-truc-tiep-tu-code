import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_gradients.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

enum VitBottomNavDestination { home, markets, trade, wallet, profile }

extension VitBottomNavDestinationRoute on VitBottomNavDestination {
  String get routePath {
    switch (this) {
      case VitBottomNavDestination.home:
        return '/home';
      case VitBottomNavDestination.markets:
        return '/markets';
      case VitBottomNavDestination.trade:
        return '/trade';
      case VitBottomNavDestination.wallet:
        return '/wallet';
      case VitBottomNavDestination.profile:
        return '/profile';
    }
  }
}

class VitBottomNav extends StatelessWidget {
  const VitBottomNav({
    super.key,
    this.activeDestination = VitBottomNavDestination.home,
    this.onDestinationSelected,
    this.homeNotificationBadgeCount,
    this.homeBadgeCount = 0,
    this.renderMode = ShellRenderMode.native,
  });

  final VitBottomNavDestination activeDestination;
  final ValueChanged<VitBottomNavDestination>? onDestinationSelected;
  final int? homeNotificationBadgeCount;
  final int homeBadgeCount;
  final ShellRenderMode renderMode;

  static const List<_VitBottomNavItem> _items = [
    _VitBottomNavItem(
      destination: VitBottomNavDestination.home,
      icon: Icons.home_rounded,
      label: 'Trang chủ',
    ),
    _VitBottomNavItem(
      destination: VitBottomNavDestination.markets,
      icon: Icons.bar_chart_rounded,
      label: 'Thị trường',
    ),
    _VitBottomNavItem(
      destination: VitBottomNavDestination.trade,
      icon: Icons.swap_horiz_rounded,
      label: 'Giao dịch',
      isCenter: true,
    ),
    _VitBottomNavItem(
      destination: VitBottomNavDestination.wallet,
      icon: Icons.account_balance_wallet_rounded,
      label: 'Ví',
    ),
    _VitBottomNavItem(
      destination: VitBottomNavDestination.profile,
      icon: Icons.person_rounded,
      label: 'Tôi',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final height = renderMode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final capsuleHeight = renderMode.usesVisualQaFrame ? 58.0 : 56.0;
    final bottomGap = renderMode.usesVisualQaFrame ? 20.0 : 8.0;
    final radius = BorderRadius.circular(capsuleHeight / 2);

    return SizedBox(
      height: height,
      child: Material(
        type: MaterialType.transparency,
        child: DecoratedBox(
          decoration: const BoxDecoration(color: AppColors.transparent),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: 20,
                right: 20,
                bottom: bottomGap,
                height: capsuleHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: radius,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.surface2.withValues(alpha: .98),
                        AppColors.bg.withValues(alpha: .96),
                      ],
                    ),
                    border: Border.all(
                      color: AppColors.borderSolid.withValues(alpha: .46),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.bg.withValues(alpha: .45),
                        blurRadius: 22,
                        offset: const Offset(0, 10),
                      ),
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: .12),
                        blurRadius: 28,
                        offset: const Offset(0, -1),
                      ),
                    ],
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final horizontalPad = constraints.maxWidth < 340
                          ? 3.0
                          : 6.0;
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPad,
                        ),
                        child: Row(
                          children: [
                            for (final item in _items)
                              Expanded(
                                child: _VitBottomNavButton(
                                  item: item,
                                  active: item.destination == activeDestination,
                                  renderMode: renderMode,
                                  badgeCount:
                                      item.destination ==
                                          VitBottomNavDestination.home
                                      ? homeNotificationBadgeCount ??
                                            homeBadgeCount
                                      : 0,
                                  onTap: () => onDestinationSelected?.call(
                                    item.destination,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VitBottomNavItem {
  const _VitBottomNavItem({
    required this.destination,
    required this.icon,
    required this.label,
    this.isCenter = false,
  });

  final VitBottomNavDestination destination;
  final IconData icon;
  final String label;
  final bool isCenter;
}

class _VitBottomNavButton extends StatelessWidget {
  const _VitBottomNavButton({
    required this.item,
    required this.active,
    required this.onTap,
    required this.renderMode,
    this.badgeCount = 0,
  });

  final _VitBottomNavItem item;
  final bool active;
  final VoidCallback? onTap;
  final ShellRenderMode renderMode;
  final int badgeCount;

  static const double _nativeCenterButtonTop = -18;
  static const double _visualQaCenterButtonTop = -22;

  @override
  Widget build(BuildContext context) {
    const activeColor = AppColors.navActive;
    const activeShadow = AppColors.primary;
    final semanticLabel =
        item.destination == VitBottomNavDestination.home && badgeCount > 0
        ? '${item.label}, $badgeCount unread notifications'
        : item.label;

    if (item.isCenter) {
      return Semantics(
        key: Key('vit_bottom_nav_${item.destination.name}'),
        button: true,
        selected: active,
        label: semanticLabel,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.cardRadius,
          child: SizedBox(
            width: double.infinity,
            height: DeviceMetrics.tabBar,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Positioned(
                  top: renderMode.usesVisualQaFrame
                      ? _visualQaCenterButtonTop
                      : _nativeCenterButtonTop,
                  child: Container(
                    key: active
                        ? Key('vit_bottom_nav_active_${item.destination.name}')
                        : null,
                    width: renderMode.usesVisualQaFrame ? 54 : 50,
                    height: renderMode.usesVisualQaFrame ? 54 : 50,
                    decoration: BoxDecoration(
                      gradient: AppGradients.navCenter,
                      borderRadius: AppRadii.lgRadius,
                      border: Border.all(
                        color: AppColors.primarySoft.withValues(alpha: .20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: activeShadow.withValues(alpha: .40),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                        BoxShadow(
                          color: activeShadow.withValues(alpha: .20),
                          blurRadius: 32,
                        ),
                      ],
                    ),
                    child: Icon(
                      item.icon,
                      color: AppColors.navCenterIcon,
                      size: 22,
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: renderMode.usesVisualQaFrame ? 2 : 4,
                  child: Text(
                    key: item.destination == VitBottomNavDestination.trade
                        ? const Key('vit_bottom_nav_trade_label')
                        : null,
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.micro.copyWith(
                      color: activeColor,
                      fontWeight: AppTextStyles.medium,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Semantics(
      key: Key('vit_bottom_nav_${item.destination.name}'),
      button: true,
      selected: active,
      label: semanticLabel,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.mdRadius,
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Icon(
                    item.icon,
                    color: active ? activeColor : AppColors.navInactive,
                    size: AppSpacing.iconMd,
                  ),
                  if (active)
                    Positioned(
                      bottom: -5,
                      child: Container(
                        key: Key(
                          'vit_bottom_nav_active_${item.destination.name}',
                        ),
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: activeColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: activeShadow.withValues(alpha: .60),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (badgeCount > 0)
                    Positioned(
                      top: -6,
                      right: -10,
                      child: _NavBadge(count: badgeCount),
                    ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                item.label,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(
                  color: active ? activeColor : AppColors.navInactive,
                  fontWeight: active
                      ? AppTextStyles.medium
                      : AppTextStyles.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavBadge extends StatelessWidget {
  const _NavBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 16),
      height: 16,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: AppColors.sell,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        count > 99 ? '99+' : '$count',
        style: AppTextStyles.micro.copyWith(
          color: AppColors.onAccent,
          fontSize: 9,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}
