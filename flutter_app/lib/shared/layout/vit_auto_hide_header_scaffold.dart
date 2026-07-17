import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class VitAutoHideHeaderScaffold extends StatefulWidget {
  const VitAutoHideHeaderScaffold({
    super.key,
    required this.header,
    required this.child,
    this.bottomInset,
    this.semanticLabel,
    this.semanticIdentifier,
    this.headerKey,
    this.bodyKey,
    this.initiallyVisible = true,
    this.hideThreshold = 24,
    this.showAtTopThreshold = 8,
    this.slideOffset = 0.25,
  });

  static const headerHostKey = Key('vit_auto_hide_header_scaffold_header');
  static const bodyHostKey = Key('vit_auto_hide_header_scaffold_body');

  final Widget header;
  final Widget child;
  final double? bottomInset;
  final String? semanticLabel;

  /// Internal screen code (e.g. `SC-007`) for tooling/debugging — see A11Y-1,
  /// docs/02_FLUTTER_MIGRATION/a-plus-roadmap/A-Plus-Task-Manifest.csv.
  final String? semanticIdentifier;
  final Key? headerKey;
  final Key? bodyKey;
  final bool initiallyVisible;
  final double hideThreshold;
  final double showAtTopThreshold;
  final double slideOffset;

  @override
  State<VitAutoHideHeaderScaffold> createState() =>
      _VitAutoHideHeaderScaffoldState();
}

class _VitAutoHideHeaderScaffoldState extends State<VitAutoHideHeaderScaffold> {
  /// Approximate header height used when deciding whether collapsing the
  /// header would shrink [ScrollMetrics.maxScrollExtent] enough to clamp the
  /// current offset back (the "snap to top" bug on short pages).
  static const double _collapseBudget = 96;

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

  /// Collapsing the header grows the body viewport and shrinks
  /// [maxScrollExtent] by roughly the header height. Only hide when the
  /// current offset still fits after that shrink — otherwise Flutter clamps
  /// pixels toward zero and the page appears to spring back.
  bool _canHideHeader(ScrollMetrics metrics) {
    return metrics.pixels <= metrics.maxScrollExtent - _collapseBudget;
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.metrics.axis != Axis.vertical) return false;

    if (notification.metrics.pixels <= widget.showAtTopThreshold) {
      _setHeaderVisible(true);
      return false;
    }

    if (notification is ScrollUpdateNotification) {
      final delta = notification.scrollDelta ?? 0;
      if (delta > 0 &&
          notification.metrics.pixels > widget.hideThreshold &&
          _canHideHeader(notification.metrics)) {
        _setHeaderVisible(false);
      } else if (delta < 0) {
        _setHeaderVisible(true);
      }
    }

    if (notification is UserScrollNotification) {
      switch (notification.direction) {
        case ScrollDirection.reverse:
          if (notification.metrics.pixels > widget.hideThreshold &&
              _canHideHeader(notification.metrics)) {
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
            padding: EdgeInsetsDirectional.only(bottom: bottomInset),
            child: widget.child,
          )
        : widget.child;

    return Semantics(
      container: true,
      label: widget.semanticLabel,
      identifier: widget.semanticIdentifier,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _AutoHideHeaderHost(
            hostKey:
                widget.headerKey ?? VitAutoHideHeaderScaffold.headerHostKey,
            visible: _headerVisible,
            slideOffset: widget.slideOffset,
            child: widget.header,
          ),
          Expanded(
            key: widget.bodyKey ?? VitAutoHideHeaderScaffold.bodyHostKey,
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
  const _AutoHideHeaderHost({
    required this.hostKey,
    required this.visible,
    required this.slideOffset,
    required this.child,
  });

  final Key hostKey;
  final bool visible;
  final double slideOffset;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    const duration = Duration(milliseconds: 180);
    const curve = Curves.easeOutCubic;

    return ClipRect(
      key: hostKey,
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
              offset: visible ? Offset.zero : Offset(0, -slideOffset),
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
