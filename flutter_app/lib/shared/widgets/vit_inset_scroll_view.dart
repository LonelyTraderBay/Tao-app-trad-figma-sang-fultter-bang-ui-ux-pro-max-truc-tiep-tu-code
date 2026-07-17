import 'package:flutter/material.dart';

/// Thin [SingleChildScrollView] wrapper that reserves [bottomInset] padding
/// (e.g. for a sticky footer/keyboard) below [child].
class VitInsetScrollView extends StatelessWidget {
  const VitInsetScrollView({
    super.key,
    required this.child,
    this.bottomInset = 0,
    this.physics,
    this.clipBehavior = Clip.hardEdge,
  });

  final Widget child;
  final double bottomInset;
  final ScrollPhysics? physics;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsetsDirectional.only(bottom: bottomInset),
      physics: physics,
      clipBehavior: clipBehavior,
      child: child,
    );
  }
}
