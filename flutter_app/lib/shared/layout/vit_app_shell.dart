import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

class VitAppShell extends StatefulWidget {
  const VitAppShell({
    super.key,
    required this.child,
    this.activeDestination = VitBottomNavDestination.home,
    this.onDestinationSelected,
    this.showBottomNav = true,
    this.statusBarTime,
    this.notificationBadgeCount,
    this.homeBadgeCount = 0,
    this.renderMode = ShellRenderMode.native,
    this.currentPath,
  });

  static const bottomNavHostKey = Key('vit_app_shell_bottom_nav_host');

  final Widget child;
  final VitBottomNavDestination activeDestination;
  final ValueChanged<VitBottomNavDestination>? onDestinationSelected;
  final bool showBottomNav;
  final String? statusBarTime;
  final int? notificationBadgeCount;
  final int homeBadgeCount;
  final ShellRenderMode renderMode;
  final String? currentPath;

  @override
  State<VitAppShell> createState() => _VitAppShellState();
}

class _VitAppShellState extends State<VitAppShell> {
  bool _bottomNavVisible = true;

  bool get _canAutoHideBottomNav {
    return widget.showBottomNav && !widget.renderMode.usesVisualQaFrame;
  }

  @override
  void didUpdateWidget(covariant VitAppShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentPath != oldWidget.currentPath && !_bottomNavVisible) {
      _bottomNavVisible = true;
    }
  }

  void _setBottomNavVisible(bool visible) {
    if (!_canAutoHideBottomNav || _bottomNavVisible == visible) return;
    setState(() => _bottomNavVisible = visible);
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (!_canAutoHideBottomNav || notification.metrics.axis != Axis.vertical) {
      return false;
    }

    if (notification.metrics.pixels <= 8) {
      _setBottomNavVisible(true);
      return false;
    }

    if (notification is ScrollUpdateNotification) {
      final delta = notification.scrollDelta ?? 0;
      if (delta > 0 && notification.metrics.pixels > 24) {
        _setBottomNavVisible(false);
      } else if (delta < 0) {
        _setBottomNavVisible(true);
      }
    }

    if (notification is UserScrollNotification) {
      switch (notification.direction) {
        case ScrollDirection.reverse:
          if (notification.metrics.pixels > 24) {
            _setBottomNavVisible(false);
          }
        case ScrollDirection.forward:
          _setBottomNavVisible(true);
        case ScrollDirection.idle:
          break;
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final body = Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: NotificationListener<ScrollNotification>(
            onNotification: _handleScrollNotification,
            child: widget.child,
          ),
        ),
        if (widget.showBottomNav)
          Positioned(left: 0, right: 0, bottom: 0, child: _bottomNavHost()),
      ],
    );

    if (!widget.renderMode.usesVisualQaFrame) {
      return SafeArea(top: true, bottom: false, child: body);
    }

    return Column(
      children: [
        VitStatusBar(time: widget.statusBarTime),
        Expanded(child: body),
      ],
    );
  }

  Widget _bottomNavHost() {
    const duration = Duration(milliseconds: 180);
    const curve = Curves.easeOutCubic;

    if (widget.renderMode.usesVisualQaFrame) {
      return KeyedSubtree(
        key: VitAppShell.bottomNavHostKey,
        child: _bottomNav(),
      );
    }

    return IgnorePointer(
      ignoring: !_bottomNavVisible,
      child: AnimatedSlide(
        key: VitAppShell.bottomNavHostKey,
        offset: _bottomNavVisible ? Offset.zero : const Offset(0, 1),
        duration: duration,
        curve: curve,
        child: AnimatedOpacity(
          opacity: _bottomNavVisible ? 1 : 0,
          duration: duration,
          curve: curve,
          child: _bottomNav(),
        ),
      ),
    );
  }

  Widget _bottomNav() {
    final nav = VitBottomNav(
      activeDestination: widget.activeDestination,
      onDestinationSelected: widget.onDestinationSelected,
      homeNotificationBadgeCount:
          widget.notificationBadgeCount ?? widget.homeBadgeCount,
      renderMode: widget.renderMode,
    );

    if (widget.renderMode.usesVisualQaFrame) return nav;
    return SafeArea(top: false, child: nav);
  }
}
