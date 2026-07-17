import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/admin/presentation/controllers/admin_controller.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/admin_spacing_tokens.dart';

class AdminDashboardStateContent extends StatelessWidget {
  const AdminDashboardStateContent({
    super.key,
    required this.status,
    required this.title,
    required this.children,
    this.message,
    this.gap = AppSpacing.x5,
  });

  final AdminDashboardLoadStatus status;
  final String title;
  final String? message;
  final List<Widget> children;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return switch (status) {
      AdminDashboardLoadStatus.loading => Semantics(
        label: 'Đang tải $title',
        child: const VitSkeletonList(rows: 4),
      ),
      AdminDashboardLoadStatus.empty => VitCard(
        child: VitEmptyState(
          icon: Icons.inbox_outlined,
          title: '$title has no data',
          message: message ?? 'No rows are available for the selected scope.',
        ),
      ),
      AdminDashboardLoadStatus.error => VitCard(
        child: VitErrorState(
          title: '$title data unavailable',
          message: message ?? 'The admin data source did not return a view.',
          verticalPadding: AppSpacing.x6,
          horizontalPadding: AppSpacing.x4,
          onAction: () {},
        ),
      ),
      AdminDashboardLoadStatus.offline => _SpacedColumn(
        gap: gap,
        children: [
          VitOfflineBanner(
            message: 'Offline. Showing cached admin data.',
            detail:
                message ?? 'Controls are read-only until connectivity returns.',
          ),
          ...children,
        ],
      ),
      AdminDashboardLoadStatus.ready => _SpacedColumn(
        gap: gap,
        children: children,
      ),
    };
  }
}

class AdminInlineEmptyState extends StatelessWidget {
  const AdminInlineEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$title. $message',
      child: VitCard(
        variant: VitCardVariant.ghost,
        padding: AdminSpacingTokens.adminCardPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: AppColors.text3,
              size: AdminSpacingTokens.adminIconLg,
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    message,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      height: AdminSpacingTokens.adminLineHeightDense,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SpacedColumn extends StatelessWidget {
  const _SpacedColumn({required this.children, required this.gap});

  final List<Widget> children;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) SizedBox(height: gap),
          children[i],
        ],
      ],
    );
  }
}
