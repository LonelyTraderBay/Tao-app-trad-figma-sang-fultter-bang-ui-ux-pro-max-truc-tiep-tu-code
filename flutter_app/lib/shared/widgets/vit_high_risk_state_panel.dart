import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_empty_state.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_error_state.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_offline_banner.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_skeleton.dart';

enum VitHighRiskUiState {
  loading,
  empty,
  error,
  offline,
  submitting,
  success,
  riskReview,
}

class VitHighRiskStatePanel extends StatelessWidget {
  const VitHighRiskStatePanel({
    super.key,
    required this.state,
    required this.title,
    required this.message,
    this.contractId,
    this.actionLabel,
    this.onAction,
  });

  final VitHighRiskUiState state;
  final String title;
  final String message;
  final String? contractId;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: contractId == null
          ? 'High risk flow state: ${state.name}'
          : 'High risk flow state: ${state.name}. Contract: $contractId',
      container: true,
      child: switch (state) {
        VitHighRiskUiState.loading => _LoadingPanel(
          title: title,
          message: message,
          contractId: contractId,
        ),
        VitHighRiskUiState.empty => VitEmptyState(
          title: title,
          message: message,
          icon: Icons.inbox_outlined,
          actionLabel: actionLabel,
          onAction: onAction,
        ),
        VitHighRiskUiState.error => VitErrorState(
          title: title,
          message: message,
          actionLabel: actionLabel ?? 'Retry',
          onAction: onAction,
        ),
        VitHighRiskUiState.offline => VitOfflineBanner(
          message: title,
          detail: message,
        ),
        VitHighRiskUiState.submitting => _CompactPanel(
          icon: Icons.pending_actions_rounded,
          title: title,
          message: message,
          contractId: contractId,
          foreground: AppColors.primary,
          background: AppColors.primary08,
          border: AppColors.primary20,
          trailing: const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        VitHighRiskUiState.success => _CompactPanel(
          icon: Icons.check_circle_outline_rounded,
          title: title,
          message: message,
          contractId: contractId,
          foreground: AppColors.buy,
          background: AppColors.buy10,
          border: AppColors.buy20,
        ),
        VitHighRiskUiState.riskReview => _CompactPanel(
          icon: Icons.verified_user_outlined,
          title: title,
          message: message,
          contractId: contractId,
          foreground: AppColors.warn,
          background: AppColors.warn08,
          border: AppColors.warningBorder,
        ),
      },
    );
  }
}

class _LoadingPanel extends StatelessWidget {
  const _LoadingPanel({
    required this.title,
    required this.message,
    this.contractId,
  });

  final String title;
  final String message;
  final String? contractId;

  @override
  Widget build(BuildContext context) {
    return _CompactPanel(
      icon: Icons.hourglass_empty_rounded,
      title: title,
      message: message,
      contractId: contractId,
      foreground: AppColors.text2,
      background: AppColors.surface2,
      border: AppColors.borderSolid,
      trailing: const SizedBox(
        width: 92,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            VitSkeleton(width: 72, height: 10),
            SizedBox(height: AppSpacing.x2),
            VitSkeleton(width: 48, height: 10),
          ],
        ),
      ),
    );
  }
}

class _CompactPanel extends StatelessWidget {
  const _CompactPanel({
    required this.icon,
    required this.title,
    required this.message,
    required this.foreground,
    required this.background,
    required this.border,
    this.contractId,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String message;
  final Color foreground;
  final Color background;
  final Color border;
  final String? contractId;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.x4),
      decoration: BoxDecoration(
        color: background,
        border: Border.all(color: border),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: foreground, size: 18),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    color: foreground,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  message,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                if (contractId != null) ...[
                  const SizedBox(height: AppSpacing.x2),
                  Text(
                    contractId!,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: AppSpacing.x3),
            trailing!,
          ],
        ],
      ),
    );
  }
}
