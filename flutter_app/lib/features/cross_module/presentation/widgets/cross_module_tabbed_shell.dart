import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';

class CrossModuleTabbedPageShell extends StatelessWidget {
  const CrossModuleTabbedPageShell({
    super.key,
    required this.semanticLabel,
    required this.contentKey,
    required this.title,
    required this.onBack,
    required this.scrollEndClearance,
    required this.tabs,
    required this.body,
    this.contentGap = VitContentGap.defaultGap,
  });

  final String semanticLabel;
  final Key contentKey;
  final String title;
  final VoidCallback onBack;
  final double scrollEndClearance;
  final Widget tabs;
  final Widget body;
  final VitContentGap contentGap;

  @override
  Widget build(BuildContext context) {
    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: semanticLabel,
      child: Material(
        color: AppColors.bg,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: title,
            showBack: true,
            onBack: onBack,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              tabs,
              Expanded(
                child: SingleChildScrollView(
                  key: contentKey,
                  physics: const ClampingScrollPhysics(),
                  padding: AppSpacing.crossModuleScrollPadding(
                    scrollEndClearance,
                  ),
                  child: VitPageContent(
 rhythm: VitPageRhythm.standard,
                    gap: contentGap,
                    children: [body],
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
