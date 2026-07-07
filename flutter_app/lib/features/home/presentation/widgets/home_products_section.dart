import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/home_action_tokens.dart';
import 'package:vit_trade_flutter/features/home/domain/entities/home_entities.dart';
import 'package:vit_trade_flutter/features/home/presentation/pages/home_page.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

Widget homeServiceTile(
  HomeQuickAction action,
  VitServiceTileDensity tileDensity,
  ValueChanged<String> onNavigate,
) {
  return VitServiceTile(
    density: tileDensity,
    icon: HomeActionTokens.icon(action.icon),
    label: action.label,
    accentColor: HomeActionTokens.accent(action.accentKey),
    badgeLabel: action.stateLabel,
    riskBadgeLabel: action.riskBadge,
    onTap: () => onNavigate(action.routePath),
  );
}

class HomeProductsSection extends StatelessWidget {
  const HomeProductsSection({
    super.key,
    required this.actions,
    required this.maxVisibleItems,
    required this.moreActions,
    required this.onNavigate,
    required this.onMore,
    required this.density,
  });

  final List<HomeQuickAction> actions;
  final int maxVisibleItems;
  final List<HomeQuickAction> moreActions;
  final ValueChanged<String> onNavigate;
  final VoidCallback? onMore;
  final VitDensity density;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: HomePage.productsSectionKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitSectionHeader(
          title: 'Sản phẩm',
          bottomGap: AppSpacing.pageRhythmCompactInnerGap,
          actionLabel: moreActions.isEmpty
              ? null
              : 'Xem thêm (+${moreActions.length})',
          actionSemanticLabel: 'Xem thêm ${moreActions.length} sản phẩm khác',
          onAction: onMore,
        ),
        HomeQuickActionsGrid(
          actions: actions,
          maxVisibleItems: maxVisibleItems,
          onNavigate: onNavigate,
          density: density,
        ),
      ],
    );
  }
}

class HomeQuickActionsGrid extends StatelessWidget {
  const HomeQuickActionsGrid({
    super.key,
    required this.actions,
    required this.maxVisibleItems,
    required this.onNavigate,
    required this.density,
  });

  final List<HomeQuickAction> actions;
  final int maxVisibleItems;
  final ValueChanged<String> onNavigate;
  final VitDensity density;

  @override
  Widget build(BuildContext context) {
    return VitActionTileGrid(
      density: density,
      itemCount: actions.length,
      maxVisibleItems: maxVisibleItems,
      itemBuilder: (context, index, tileDensity) {
        final action = actions[index];
        return homeServiceTile(action, tileDensity, onNavigate);
      },
    );
  }
}
