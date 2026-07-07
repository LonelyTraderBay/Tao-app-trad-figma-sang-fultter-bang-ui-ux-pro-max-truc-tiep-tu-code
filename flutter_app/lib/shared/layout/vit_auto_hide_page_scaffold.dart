import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';

/// Shared outer chrome for pages built on the scroll-to-hide header shell —
/// bottom-nav roots (Home, Wallet, Profile) and standard/detail screens
/// (asset detail, transaction history, settings, security, edit profile...).
///
/// Collapses the repeated [VitPageLayout] + [Material] +
/// [VitAutoHideHeaderScaffold] wrapper into one call so a page only declares
/// its [header] and [body] — background, page semantics, and the
/// scroll-to-hide header behaviour are inherited from here. [body] should be
/// the scroll view directly (e.g. [VitInsetScrollView] /
/// `SingleChildScrollView`); no extra `Column > Expanded` wrapper is needed
/// because [VitAutoHideHeaderScaffold] already expands its child. Pages that
/// need custom auto-hide thresholds or a bottom-inset on the scaffold itself
/// should use [VitAutoHideHeaderScaffold] directly instead.
class VitAutoHidePageScaffold extends StatelessWidget {
  const VitAutoHidePageScaffold({
    super.key,
    required this.semanticLabel,
    required this.header,
    required this.body,
    this.variant = VitPageVariant.flush,
    this.background = AppColors.bg,
    this.headerKey,
  });

  final String semanticLabel;
  final Widget header;
  final Widget body;
  final VitPageVariant variant;
  final Color background;
  final Key? headerKey;

  @override
  Widget build(BuildContext context) {
    return VitPageLayout(
      variant: variant,
      semanticLabel: semanticLabel,
      child: Material(
        color: background,
        child: VitAutoHideHeaderScaffold(
          headerKey: headerKey,
          header: header,
          child: body,
        ),
      ),
    );
  }
}
