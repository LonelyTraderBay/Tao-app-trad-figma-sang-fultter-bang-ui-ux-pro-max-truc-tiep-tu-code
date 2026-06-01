part of '../pages/arena_creator_page.dart';

class _CreatorHero extends StatelessWidget {
  const _CreatorHero({required this.creator, required this.onTrust});

  final ArenaCreatorProfileDraft creator;
  final VoidCallback onTrust;

  @override
  Widget build(BuildContext context) {
    return VitModuleHeroCard(
      accentColor: _arenaAccent,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: AppColors.surface2,
                  borderRadius: AppRadii.cardRadius,
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: _arenaAccent,
                  size: 34,
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      creator.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x2),
                    Wrap(
                      spacing: AppSpacing.x2,
                      runSpacing: AppSpacing.x2,
                      children: [
                        if (creator.fairPlayBadge)
                          const VitStatusPill(
                            label: 'Fair Play',
                            status: VitStatusPillStatus.success,
                            size: VitStatusPillSize.sm,
                            icon: Icons.shield_outlined,
                          ),
                        VitStatusPill(
                          label: creator.badge,
                          status: VitStatusPillStatus.orange,
                          size: VitStatusPillSize.sm,
                        ),
                        VitStatusPill(
                          label: 'Lv.${creator.level}',
                          status: VitStatusPillStatus.purple,
                          size: VitStatusPillSize.sm,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _CreatorStatTile(
                  label: 'Modes',
                  value: '${creator.modesCreated}',
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _CreatorStatTile(
                  label: 'Phòng HT',
                  value: '${creator.completedRooms}',
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _CreatorStatTile(
                  label: 'Clone',
                  value: '${creator.totalClones}',
                  color: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _CreatorStatTile(
                  label: 'Trust',
                  value: '${creator.trustScore}%',
                  color: AppColors.warn,
                  onTap: onTrust,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CreatorStatTile extends StatelessWidget {
  const _CreatorStatTile({
    required this.label,
    required this.value,
    required this.color,
    this.onTap,
  });

  final String label;
  final String value;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.sm,
      borderColor: onTap == null ? null : color.withValues(alpha: .28),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x3,
      ),
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.baseMedium.copyWith(
              color: color,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _TrustSection extends StatelessWidget {
  const _TrustSection({required this.metrics, required this.onDetails});

  final List<ArenaCreatorTrustMetricDraft> metrics;
  final VoidCallback onDetails;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TrustHeader(onDetails: onDetails),
        const SizedBox(height: AppSpacing.x3),
        Column(
          children: [
            Row(
              children: [
                Expanded(child: _TrustMetricCard(metric: metrics[0])),
                const SizedBox(width: AppSpacing.x3),
                Expanded(child: _TrustMetricCard(metric: metrics[1])),
              ],
            ),
            const SizedBox(height: AppSpacing.x3),
            Row(
              children: [
                Expanded(child: _TrustMetricCard(metric: metrics[2])),
                const SizedBox(width: AppSpacing.x3),
                Expanded(child: _TrustMetricCard(metric: metrics[3])),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _TrustHeader extends StatelessWidget {
  const _TrustHeader({required this.onDetails});

  final VoidCallback onDetails;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: const BoxDecoration(
            color: AppColors.buy,
            borderRadius: AppRadii.xsRadius,
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Text(
            'Chi tiết tin cậy',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
        Material(
          type: MaterialType.transparency,
          child: InkWell(
            key: ArenaCreatorPage.trustDetailKey,
            onTap: onDetails,
            borderRadius: AppRadii.smRadius,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.x2,
                vertical: AppSpacing.x2,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Xem chi tiết',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.buy,
                      fontWeight: AppTextStyles.medium,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x1),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.buy,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TrustMetricCard extends StatelessWidget {
  const _TrustMetricCard({required this.metric});

  final ArenaCreatorTrustMetricDraft metric;

  @override
  Widget build(BuildContext context) {
    final color = _metricColor(metric.kind);
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.sm,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .14),
              borderRadius: AppRadii.mdRadius,
            ),
            child: Icon(_metricIcon(metric.kind), color: color, size: 18),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  metric.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: color,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  metric.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
