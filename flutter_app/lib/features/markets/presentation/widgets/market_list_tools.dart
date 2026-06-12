import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_asset_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_list_common.dart';

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
      height: AppSpacing.marketToolsHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: tools.length,
        separatorBuilder: (_, _) =>
            const SizedBox(width: AppSpacing.marketToolGap),
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
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        height: AppSpacing.marketToolHeight,
        padding: AppSpacing.marketToolPadding,
        decoration: BoxDecoration(
          color: tool.color.withValues(alpha: 0.08),
          border: Border.all(color: tool.color.withValues(alpha: 0.22)),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Row(
          children: [
            Icon(tool.icon, color: tool.color, size: AppSpacing.marketToolIcon),
            const SizedBox(width: AppSpacing.marketToolIconGap),
            Text(
              tool.label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontWeight: AppTextStyles.medium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
