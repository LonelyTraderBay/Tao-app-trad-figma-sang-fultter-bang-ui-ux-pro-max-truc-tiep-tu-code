import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_asset_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_list_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

const double _marketToolsCompactHeight = AppSpacing.buttonCompact;
const double _marketToolCompactHeight =
    AppSpacing.buttonCompact - AppSpacing.x1;
const double _marketToolCompactGap = AppSpacing.x2;
const EdgeInsets _marketToolCompactPadding = EdgeInsets.symmetric(
  horizontal: AppSpacing.x3,
);
const double _marketToolCompactIcon = AppSpacing.iconSm;

class MarketListTools extends StatelessWidget {
  const MarketListTools({super.key, required this.onNavigate});

  final ValueChanged<String> onNavigate;

  static const tools = [
    _MarketTool(
      icon: Icons.filter_alt_outlined,
      label: 'Bộ lọc',
      route: 'screener',
      color: marketListPrimary,
    ),
    _MarketTool(
      icon: Icons.balance_outlined,
      label: 'So sánh',
      route: 'compare',
      color: marketListPredictionAccent,
    ),
    _MarketTool(
      icon: Icons.calendar_month_outlined,
      label: 'Sự kiện',
      route: 'calendar',
      color: marketListArenaAccent,
    ),
    _MarketTool(
      icon: Icons.bolt_outlined,
      label: 'Phái sinh',
      route: 'derivatives',
      color: AppColors.sell,
    ),
    _MarketTool(
      icon: Icons.forum_outlined,
      label: 'Tâm lý',
      route: 'social-sentiment',
      color: AppAssetColors.cyanChain,
    ),
    _MarketTool(
      icon: Icons.pie_chart_outline_rounded,
      label: 'Danh mục',
      route: 'portfolio-tracker',
      color: AppColors.buy,
    ),
    _MarketTool(
      icon: Icons.article_outlined,
      label: 'Tin tức',
      route: 'news',
      color: AppColors.text3,
    ),
    _MarketTool(
      icon: Icons.show_chart_rounded,
      label: 'Phân tích',
      route: 'advanced-charts',
      color: AppAssetColors.skyChain,
    ),
    _MarketTool(
      icon: Icons.lock_open_rounded,
      label: 'Unlock',
      route: 'unlocks',
      color: AppAssetColors.violetChain,
    ),
    _MarketTool(
      icon: Icons.radio_button_checked,
      label: 'Tín hiệu',
      route: 'signals',
      color: AppColors.riskHigh,
    ),
    _MarketTool(
      icon: Icons.account_tree_outlined,
      label: 'Tương quan',
      route: 'correlations',
      color: AppAssetColors.tealChain,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _marketToolsCompactHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: tools.length,
        separatorBuilder: (_, _) =>
            const SizedBox(width: _marketToolCompactGap),
        itemBuilder: (context, index) {
          final tool = tools[index];
          return _ToolChip(
            tool: tool,
            onTap: () => onNavigate('/markets/${tool.route}'),
          );
        },
      ),
    );
  }
}

class _MarketTool {
  const _MarketTool({
    required this.icon,
    required this.label,
    required this.route,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String route;
  final Color color;
}

class _ToolChip extends StatelessWidget {
  const _ToolChip({required this.tool, required this.onTap});

  final _MarketTool tool;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      label: tool.label,
      selected: true,
      onTap: onTap,
      accentColor: tool.color,
      height: _marketToolCompactHeight,
      padding: _marketToolCompactPadding,
      leading: Icon(tool.icon, color: tool.color, size: _marketToolCompactIcon),
    );
  }
}
