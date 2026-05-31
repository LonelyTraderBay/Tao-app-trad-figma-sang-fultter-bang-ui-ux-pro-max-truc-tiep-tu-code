import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/transaction_reporting_common.dart';

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
        const SizedBox(width: 12),
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
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        height: 88,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: transactionReportPanel2,
          border: Border.all(color: transactionReportBorder),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 19),
            const Spacer(),
            Text(
              title,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontSize: 12,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontSize: 10,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
