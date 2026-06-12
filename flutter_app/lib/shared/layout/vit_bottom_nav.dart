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
    final capsuleHeight = renderMode.usesVisualQaFrame
        ? AppSpacing.bottomNavCapsuleHeightVisual
        : AppSpacing.bottomNavCapsuleHeightNative;
    final bottomGap = renderMode.usesVisualQaFrame
        ? AppSpacing.bottomNavBottomGapVisual
        : AppSpacing.bottomNavBottomGapNative;

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
                left: AppSpacing.bottomNavHorizontalInset,
                right: AppSpacing.bottomNavHorizontalInset,
                bottom: bottomGap,
                height: capsuleHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: AppRadii.pillRadius,
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
                        blurRadius: AppSpacing.bottomNavSurfaceShadowBlur,
                        offset: const Offset(
                          0,
                          AppSpacing.bottomNavSurfaceShadowOffsetY,
                        ),
                      ),
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: .12),
                        blurRadius: AppSpacing.bottomNavPrimaryShadowBlur,
                        offset: const Offset(
                          0,
                          AppSpacing.bottomNavPrimaryShadowOffsetY,
                        ),
                      ),
                    ],
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final horizontalPad = constraints.maxWidth < 340
                          ? AppSpacing.bottomNavHorizontalPadCompact
                          : AppSpacing.bottomNavHorizontalPad;
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

  static const double _nativeCenterButtonTop =
      AppSpacing.bottomNavCenterButtonTopNative;
  static const double _visualQaCenterButtonTop =
      AppSpacing.bottomNavCenterButtonTopVisual;

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
                    width: renderMode.usesVisualQaFrame
                        ? AppSpacing.bottomNavCenterButtonSizeVisual
                        : AppSpacing.bottomNavCenterButtonSizeNative,
                    height: renderMode.usesVisualQaFrame
                        ? AppSpacing.bottomNavCenterButtonSizeVisual
                        : AppSpacing.bottomNavCenterButtonSizeNative,
                    decoration: BoxDecoration(
                      gradient: AppGradients.navCenter,
                      borderRadius: AppRadii.lgRadius,
                      border: Border.all(
                        color: AppColors.primarySoft.withValues(alpha: .20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: activeShadow.withValues(alpha: .40),
                          blurRadius: AppSpacing.bottomNavCenterGlowBlur,
                          offset: const Offset(
                            0,
                            AppSpacing.bottomNavCenterGlowOffsetY,
                          ),
                        ),
                        BoxShadow(
                          color: activeShadow.withValues(alpha: .20),
                          blurRadius: AppSpacing.bottomNavCenterGlowWeakBlur,
                        ),
                      ],
                    ),
                    child: Icon(
                      item.icon,
                      color: AppColors.navCenterIcon,
                      size: AppSpacing.bottomNavCenterIconSize,
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: renderMode.usesVisualQaFrame
                      ? AppSpacing.bottomNavBottomOffsetCompact
                      : AppSpacing.bottomNavBottomOffsetRegular,
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
          height: AppSpacing.bottomNavItemHeight,
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
                      bottom: AppSpacing.bottomNavActiveDotOffset,
                      child: Container(
                        key: Key(
                          'vit_bottom_nav_active_${item.destination.name}',
                        ),
                        width: AppSpacing.bottomNavActiveDotSize,
                        height: AppSpacing.bottomNavActiveDotSize,
                        decoration: BoxDecoration(
                          color: activeColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: activeShadow.withValues(alpha: .60),
                              blurRadius: AppSpacing.bottomNavActiveDotBlur,
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (badgeCount > 0)
                    Positioned(
                      top: AppSpacing.bottomNavBadgeTopOffset,
                      right: AppSpacing.bottomNavBadgeRightOffset,
                      child: _NavBadge(count: badgeCount),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.bottomNavLabelGap),
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
      constraints: const BoxConstraints(
        minWidth: AppSpacing.bottomNavBadgeMinWidth,
      ),
      height: AppSpacing.bottomNavBadgeHeight,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.bottomNavBadgeHorizontalPadding,
      ),
      decoration: BoxDecoration(
        color: AppColors.sell,
        borderRadius: AppRadii.pillRadius,
      ),
      alignment: Alignment.center,
      child: Text(
        count > 99 ? '99+' : '$count',
        style: AppTextStyles.navLabel.copyWith(
          color: AppColors.onAccent,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}
