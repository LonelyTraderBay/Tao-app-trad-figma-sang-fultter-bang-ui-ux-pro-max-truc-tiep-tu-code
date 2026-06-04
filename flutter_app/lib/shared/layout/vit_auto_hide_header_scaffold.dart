import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class VitAutoHideHeaderScaffold extends StatefulWidget {
  const VitAutoHideHeaderScaffold({
    super.key,
    required this.header,
    required this.child,
    this.bottomInset,
    this.semanticLabel,
    this.initiallyVisible = true,
    this.hideThreshold = 24,
    this.showAtTopThreshold = 8,
  });

  static const headerHostKey = Key('vit_auto_hide_header_scaffold_header');
  static const bodyHostKey = Key('vit_auto_hide_header_scaffold_body');

  final Widget header;
  final Widget child;
  final double? bottomInset;
  final String? semanticLabel;
  final bool initiallyVisible;
  final double hideThreshold;
  final double showAtTopThreshold;

  @override
  State<VitAutoHideHeaderScaffold> createState() =>
      _VitAutoHideHeaderScaffoldState();
}

class _VitAutoHideHeaderScaffoldState extends State<VitAutoHideHeaderScaffold> {
  late bool _headerVisible;

  @override
  void initState() {
    super.initState();
    _headerVisible = widget.initiallyVisible;
  }

  void _setHeaderVisible(bool visible) {
    if (_headerVisible == visible) return;
    setState(() => _headerVisible = visible);
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.metrics.axis != Axis.vertical) return false;

    if (notification.metrics.pixels <= widget.showAtTopThreshold) {
      _setHeaderVisible(true);
      return false;
    }

    if (notification is ScrollUpdateNotification) {
      final delta = notification.scrollDelta ?? 0;
      if (delta > 0 && notification.metrics.pixels > widget.hideThreshold) {
        _setHeaderVisible(false);
      } else if (delta < 0) {
        _setHeaderVisible(true);
      }
    }

    if (notification is UserScrollNotification) {
      switch (notification.direction) {
        case ScrollDirection.reverse:
          if (notification.metrics.pixels > widget.hideThreshold) {
            _setHeaderVisible(false);
          }
        case ScrollDirection.forward:
          _setHeaderVisible(true);
        case ScrollDirection.idle:
          break;
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = widget.bottomInset ?? 0;
    final body = bottomInset > 0
        ? Padding(
            padding: EdgeInsets.only(bottom: bottomInset),
            child: widget.child,
          )
        : widget.child;

    return Semantics(
      container: true,
      label: widget.semanticLabel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _AutoHideHeaderHost(visible: _headerVisible, child: widget.header),
          Expanded(
            key: VitAutoHideHeaderScaffold.bodyHostKey,
            child: NotificationListener<ScrollNotification>(
              onNotification: _handleScrollNotification,
              child: body,
            ),
          ),
        ],
      ),
    );
  }
}

class _AutoHideHeaderHost extends StatelessWidget {
  const _AutoHideHeaderHost({required this.visible, required this.child});

  final bool visible;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    const duration = Duration(milliseconds: 180);
    const curve = Curves.easeOutCubic;

    return ClipRect(
      key: VitAutoHideHeaderScaffold.headerHostKey,
      child: AnimatedAlign(
        alignment: Alignment.topCenter,
        heightFactor: visible ? 1 : 0,
        duration: duration,
        curve: curve,
        child: IgnorePointer(
          ignoring: !visible,
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
      ),
    );
  }
}
