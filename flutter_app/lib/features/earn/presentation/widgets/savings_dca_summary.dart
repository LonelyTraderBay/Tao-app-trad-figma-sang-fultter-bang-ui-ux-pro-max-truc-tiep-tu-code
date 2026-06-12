part of '../pages/savings_dca_page.dart';

class _DcaSummaryCard extends StatelessWidget {
  const _DcaSummaryCard({
    required this.snapshot,
    required this.onCreate,
    required this.onPlans,
    required this.onHistory,
  });

  final SavingsDcaSnapshot snapshot;
  final VoidCallback onCreate;
  final VoidCallback onPlans;
  final VoidCallback onHistory;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: SavingsDCAPage.summaryKey,
      variant: VitCardVariant.hero,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.repeat_rounded,
                color: AppColors.buy,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  snapshot.heroLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.base.copyWith(color: AppColors.text2),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            'Tổng đã gửi (USD)',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          Text(
            snapshot.totalInvestedUsd,
            style: AppTextStyles.heroNumber.copyWith(
              color: AppColors.text1,
              fontSize: AppSpacing.savingsConsumerStatFontSize,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Row(
            children: [
              _GainPill(
                icon: Icons.trending_up_rounded,
                label: snapshot.gainUsd,
              ),
              const Spacer(),
              Text(
                snapshot.gainLabel,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          Row(
            children: [
              Expanded(
                child: _HeroMetric(
                  label: 'Kế hoạch đang chạy',
                  value: '${snapshot.activePlanCount}',
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroMetric(
                  label: 'Giá trị hiện tại',
                  value: snapshot.totalCurrentUsd,
                  valueColor: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroMetric(
                  label: 'Chiến lược',
                  value: snapshot.strategyLabel,
                  icon: Icons.shield_outlined,
                  valueColor: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          Row(
            children: [
              Expanded(
                child: VitCtaButton(
                  key: SavingsDCAPage.createPlanKey,
                  fullWidth: true,
                  height: AppSpacing.ctaHeight,
                  variant: VitCtaButtonVariant.success,
                  leading: const Icon(Icons.add_rounded),
                  onPressed: onCreate,
                  child: const Text('Tạo DCA'),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroAction(
                  label: 'Danh mục',
                  icon: Icons.bar_chart_rounded,
                  onTap: onPlans,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroAction(
                  label: 'Lịch sử',
                  icon: Icons.schedule_rounded,
                  onTap: onHistory,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GainPill extends StatelessWidget {
  const _GainPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.buy10,
        borderRadius: AppRadii.xlRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x3,
          vertical: AppSpacing.x1,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.buy, size: AppSpacing.iconSm),
            const SizedBox(width: AppSpacing.x1),
            Text(label, style: _microBold.copyWith(color: AppColors.buy)),
          ],
        ),
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({
    required this.label,
    required this.value,
    this.icon,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final IconData? icon;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return VitCardStat(
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x2),
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: valueColor, size: AppSpacing.iconSm),
                const SizedBox(width: AppSpacing.x1),
              ],
              Flexible(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _captionBold.copyWith(
                    color: valueColor,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroAction extends StatelessWidget {
  const _HeroAction({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.ctaHeight,
      child: Material(
        color: AppColors.portfolioBtnGhost,
        borderRadius: AppRadii.inputRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.inputRadius,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: AppColors.text1, size: AppSpacing.iconSm),
                const SizedBox(width: AppSpacing.x2),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _captionBold.copyWith(color: AppColors.text1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      borderColor: AppColors.primary20,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.primary,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}

class _DcaTabs extends StatelessWidget {
  const _DcaTabs({
    required this.tabs,
    required this.active,
    required this.onChanged,
  });

  final List<SavingsPreferenceTabDraft> tabs;
  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitTabBar(
      variant: VitTabBarVariant.segment,
      activeKey: active,
      onChanged: onChanged,
      tabs: [
        for (final tab in tabs)
          VitTabItem(key: tab.id, label: tab.label, icon: _tabIcon(tab.id)),
      ],
    );
  }

  IconData _tabIcon(String id) {
    return id == 'history'
        ? Icons.history_rounded
        : Icons.account_tree_outlined;
  }
}
