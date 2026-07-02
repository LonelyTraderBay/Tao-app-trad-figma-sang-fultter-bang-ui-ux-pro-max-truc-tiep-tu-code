import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_inset_scroll_view.dart';

/// Home-like scroll shell for beginner trade experience.
class VitTradeSimpleShell extends StatelessWidget {
  const VitTradeSimpleShell({
    super.key,
    required this.title,
    required this.children,
    this.semanticLabel,
    this.subtitle,
    this.contentKey,
    this.showBack = false,
    this.onBack,
    this.backKey,
    this.shellRenderMode,
    this.trailing,
  });

  final String title;
  final List<Widget> children;
  final String? semanticLabel;
  final String? subtitle;
  final Key? contentKey;
  final bool showBack;
  final VoidCallback? onBack;
  final Key? backKey;
  final ShellRenderMode? shellRenderMode;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final scrollEndClearance = tradeScrollBottomInset(
      context,
      shellRenderMode: shellRenderMode,
    );

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: semanticLabel,
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: title,
            subtitle: subtitle,
            showBack: showBack,
            onBack: onBack,
            backKey: backKey,
            trailing: trailing,
          ),
          child: VitInsetScrollView(
            key: contentKey,
            bottomInset: scrollEndClearance,
            child: VitPageContent(
              padding: VitContentPadding.compact,
              density: VitDensity.compact,
              children: [
                ...children,
                const SizedBox(height: AppSpacing.x2),
                Text(
                  'Giao dịch tiền mã hoá có rủi ro. Chỉ dùng số tiền bạn chấp nhận mất.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
