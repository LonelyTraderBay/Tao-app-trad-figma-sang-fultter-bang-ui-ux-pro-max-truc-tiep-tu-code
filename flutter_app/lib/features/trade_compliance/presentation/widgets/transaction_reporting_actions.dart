import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/widgets/transaction_reporting_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';

class TransactionReportingQuickActions extends StatelessWidget {
  const TransactionReportingQuickActions({
    required this.onDashboard,
    required this.onArmStatus,
    super.key,
  });

  final VoidCallback onDashboard;
  final VoidCallback onArmStatus;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickActionCard(
            key: transactionReportingActionKey('dashboard'),
            icon: Icons.bar_chart_rounded,
            title: 'Dashboard',
            subtitle: 'View all reports',
            color: AppColors.primary,
            onTap: onDashboard,
          ),
        ),
        const SizedBox(width: AppSpacing.x4),
        Expanded(
          child: _QuickActionCard(
            key: transactionReportingActionKey('arm-status'),
            icon: Icons.monitor_heart_outlined,
            title: 'ARM Status',
            subtitle: 'Connection health',
            color: transactionReportGreen,
            onTap: onArmStatus,
          ),
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      height: AppSpacing.buttonHero,
      padding: TradeSpacingTokens.transactionReportingQuickActionCardPadding,
      borderColor: transactionReportBorder,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: AppSpacing.ctaLoadingIcon + 1),
          const Spacer(),
          Text(
            title,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              height: TradeSpacingTokens.transactionReportingLineHeightTight,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: TradeSpacingTokens.transactionReportingLineHeightTight,
            ),
          ),
        ],
      ),
    );
  }
}
