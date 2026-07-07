import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/home_action_tokens.dart';
import 'package:vit_trade_flutter/features/home/domain/entities/home_entities.dart';
import 'package:vit_trade_flutter/features/home/presentation/pages/home_page.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class HomeMoreProductsSheet extends StatelessWidget {
  const HomeMoreProductsSheet({
    super.key,
    required this.actions,
    required this.onNavigate,
    required this.density,
  });

  final List<HomeQuickAction> actions;
  final ValueChanged<String> onNavigate;
  final VitDensity density;

  @override
  Widget build(BuildContext context) {
    return VitSheetPanel(
      key: HomePage.moreProductsSheetKey,
      title: 'Thêm sản phẩm',
      child: VitActionTileGrid(
        density: density,
        crossAxisSpacing: AppSpacing.x3,
        mainAxisSpacing: AppSpacing.x3,
        physics: const ClampingScrollPhysics(),
        itemCount: actions.length,
        itemBuilder: (context, index, tileDensity) {
          final action = actions[index];
          return VitServiceTile.fromAction(
            density: tileDensity,
            icon: HomeActionTokens.icon(action.icon),
            label: action.label,
            accentColor: HomeActionTokens.accent(action.accentKey),
            badgeLabel: action.stateLabel,
            riskBadgeLabel: action.riskBadge,
            onTap: () => onNavigate(action.routePath),
          );
        },
      ),
    );
  }
}
