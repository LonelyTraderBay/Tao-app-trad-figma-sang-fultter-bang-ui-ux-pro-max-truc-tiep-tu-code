part of '../pages/launchpad_page.dart';

class _HeaderActions extends StatelessWidget {
  const _HeaderActions({required this.snapshot});

  final LaunchpadHomeSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        VitIconButton(
          key: LaunchpadPage.filterActionKey,
          icon: Icons.tune_rounded,
          tooltip: 'Bộ lọc',
          size: VitIconButtonSize.md,
          onPressed: HapticFeedback.selectionClick,
        ),
        const SizedBox(width: AppSpacing.x2),
        VitIconButton(
          key: LaunchpadPage.performanceActionKey,
          icon: Icons.bar_chart_rounded,
          tooltip: 'Hiệu suất',
          size: VitIconButtonSize.md,
          onPressed: () => context.go(snapshot.performanceRoute),
        ),
        const SizedBox(width: AppSpacing.x2),
        VitIconButton(
          key: LaunchpadPage.portfolioActionKey,
          icon: Icons.business_center_outlined,
          tooltip: 'Portfolio',
          size: VitIconButtonSize.md,
          onPressed: () => context.go(snapshot.portfolioRoute),
        ),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.activeCount});

  final int activeCount;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadPage.heroKey,
      variant: VitCardVariant.hero,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      borderColor: AppModuleAccents.launchpad.withValues(alpha: .24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: AppSpacing.x7,
                height: AppSpacing.x7,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.accent12,
                  border: Border.all(color: AppColors.accent30),
                  borderRadius: AppRadii.lgRadius,
                ),
                child: const Icon(
                  Icons.rocket_launch_outlined,
                  color: AppColors.accent,
                  size: AppSpacing.iconLg,
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'VitLaunch',
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: AppColors.text1,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Ra mắt token an toàn & uy tín',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.portfolioTextDim,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          Row(
            children: [
              const Expanded(
                child: _HeroMetric(
                  icon: Icons.rocket_launch_outlined,
                  label: 'Dự án',
                  value: '47',
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              const Expanded(
                child: _HeroMetric(
                  icon: Icons.groups_2_outlined,
                  label: 'Người tham gia',
                  value: '280K+',
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroMetric(
                  icon: Icons.trending_up_rounded,
                  label: 'Đang hoạt động',
                  value: '$activeCount',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            'Hiệu suất quá khứ không đảm bảo kết quả tương lai. Nghiên cứu kỹ trước khi tham gia.',
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.portfolioTextMuted,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCardStat(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x4,
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.accent, size: AppSpacing.iconSm),
          const SizedBox(height: AppSpacing.x2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text1,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.portfolioTextMuted,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}
