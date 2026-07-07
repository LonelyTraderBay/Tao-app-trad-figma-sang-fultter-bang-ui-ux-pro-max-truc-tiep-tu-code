import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class StakingDashboardQuickActions extends StatelessWidget {
  const StakingDashboardQuickActions({
    super.key,
    required this.stakeMoreKey,
    required this.analyticsKey,
    required this.snapshot,
  });

  final Key stakeMoreKey;
  final Key analyticsKey;
  final StakingDashboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: VitCtaButton(
            key: stakeMoreKey,
            leading: const Icon(Icons.add_rounded),
            onPressed: () => context.go(snapshot.stakingRoute),
            child: const Text('Stake thêm'),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: VitCtaButton(
            key: analyticsKey,
            variant: VitCtaButtonVariant.secondary,
            leading: const Icon(Icons.trending_up_rounded),
            onPressed: () => context.go(snapshot.analyticsRoute),
            child: const Text('Phân tích'),
          ),
        ),
      ],
    );
  }
}

class StakingDashboardNavigationCards extends StatelessWidget {
  const StakingDashboardNavigationCards({
    super.key,
    required this.historyKey,
    required this.calendarKey,
    required this.snapshot,
  });

  final Key historyKey;
  final Key calendarKey;
  final StakingDashboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _NavCard(
            key: historyKey,
            icon: Icons.calendar_month_rounded,
            label: 'Lịch sử',
            caption: 'Xem giao dịch',
            route: snapshot.historyRoute,
            accent: AppColors.primary,
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: _NavCard(
            key: calendarKey,
            icon: Icons.paid_outlined,
            label: 'Lịch nhận lãi',
            caption: 'Xem lịch trình',
            route: snapshot.calendarRoute,
            accent: AppModuleAccents.earn,
          ),
        ),
      ],
    );
  }
}

class StakingMaturityAlert extends StatelessWidget {
  const StakingMaturityAlert({super.key, required this.snapshot});

  final StakingDashboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.warn15,
      padding: AppSpacing.earnCardPaddingX4,
      child: Row(
        children: [
          const Icon(
            Icons.event_available_rounded,
            color: AppColors.warn,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(snapshot.alertTitle, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  snapshot.alertBody,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          VitCtaButton(
            variant: VitCtaButtonVariant.warning,
            fullWidth: false,
            height: AppSpacing.buttonCompact,
            padding: AppSpacing.earnHorizontalPaddingX4,
            onPressed: () => context.go(snapshot.calendarRoute),
            child: const Text('Xem'),
          ),
        ],
      ),
    );
  }
}

class _NavCard extends StatelessWidget {
  const _NavCard({
    super.key,
    required this.icon,
    required this.label,
    required this.caption,
    required this.route,
    required this.accent,
  });

  final IconData icon;
  final String label;
  final String caption;
  final String route;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: AppSpacing.earnCardPaddingX4,
      onTap: () => context.go(route),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              DecoratedBox(
                decoration: ShapeDecoration(
                  color: accent.withValues(alpha: 0.12),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadii.lgRadius,
                    side: BorderSide(color: accent.withValues(alpha: 0.35)),
                  ),
                ),
                child: SizedBox(
                  width: AppSpacing.x7,
                  height: AppSpacing.x7,
                  child: Icon(icon, color: accent, size: AppSpacing.iconMd),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: AppTextStyles.baseMedium),
                    Text(
                      caption,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          const Align(
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.arrow_forward_rounded,
              color: AppColors.text3,
              size: AppSpacing.iconMd,
            ),
          ),
        ],
      ),
    );
  }
}
