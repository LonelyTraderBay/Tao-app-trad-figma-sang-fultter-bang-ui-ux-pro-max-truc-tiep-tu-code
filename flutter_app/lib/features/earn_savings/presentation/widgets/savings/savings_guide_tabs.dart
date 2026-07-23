import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/features/earn_core/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

class SavingsGuideTabs extends StatelessWidget {
  const SavingsGuideTabs({
    super.key,
    required this.tabs,
    required this.active,
    required this.onChanged,
  });

  final List<SavingsGuideTabDraft> tabs;
  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surface,
      child: Padding(
        padding: EarnSpacingTokens.earnSurfaceTabsPadding,
        child: VitTabBar(
          variant: VitTabBarVariant.underline,
          activeKey: active,
          onChanged: onChanged,
          tabs: [
            for (final tab in tabs) VitTabItem(key: tab.id, label: tab.label),
          ],
        ),
      ),
    );
  }
}
