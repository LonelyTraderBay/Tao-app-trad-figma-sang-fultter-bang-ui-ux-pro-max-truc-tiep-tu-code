part of '../pages/staking_institutional_page.dart';

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.snapshot});

  final StakingInstitutionalSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingInstitutionalPage.infoKey,
      variant: VitCardVariant.inner,
      borderColor: AppColors.primary20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.apartment_rounded,
            color: AppColors.primarySoft,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(snapshot.infoTitle, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  snapshot.infoBody,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.snapshot});

  final StakingInstitutionalSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingInstitutionalPage.statsKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          for (var i = 0; i < snapshot.stats.length; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.x3),
            Expanded(child: _StatTile(stat: snapshot.stats[i])),
          ],
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.stat});

  final StakingInstitutionalStatDraft stat;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(stat.tone);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x3,
      ),
      decoration: BoxDecoration(
        color: _toneFillColor(stat.tone),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        children: [
          Icon(_infoIcon(stat.icon), color: color, size: AppSpacing.iconSm),
          const SizedBox(height: AppSpacing.x2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              stat.value,
              style: AppTextStyles.sectionTitle.copyWith(
                color: stat.tone == 'success' ? AppColors.buy : AppColors.text1,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            stat.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _BatchTabs extends StatelessWidget {
  const _BatchTabs({required this.active, required this.onChanged});

  final _InstitutionalBatchTab active;
  final ValueChanged<_InstitutionalBatchTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: StakingInstitutionalPage.tabsKey,
      decoration: const BoxDecoration(color: AppColors.surface),
      child: Row(
        children: [
          for (final tab in _InstitutionalBatchTab.values)
            Expanded(
              child: Material(
                color: AppColors.transparent,
                child: InkWell(
                  key: StakingInstitutionalPage.tabKey(tab.name),
                  onTap: () => onChanged(tab),
                  child: Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.x4),
                    child: Column(
                      children: [
                        Text(
                          _tabLabel(tab),
                          style: AppTextStyles.caption.copyWith(
                            color: active == tab
                                ? AppColors.primarySoft
                                : AppColors.text3,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x4),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 160),
                          width: active == tab ? AppSpacing.buttonHero : 0,
                          height: AppSpacing.stakingProductTabIndicatorHeight,
                          decoration: BoxDecoration(
                            color: active == tab
                                ? AppColors.primarySoft
                                : AppColors.transparent,
                            borderRadius: AppRadii.xsRadius,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BatchOperationCard extends StatelessWidget {
  const _BatchOperationCard({required this.batch});

  final StakingInstitutionalBatchDraft batch;

  @override
  Widget build(BuildContext context) {
    final progress = batch.approvals / batch.requiredApprovals;
    return VitCard(
      key: StakingInstitutionalPage.batchKey(batch.id),
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Batch ${_batchTypeLabel(batch.type)}',
                      style: AppTextStyles.baseMedium,
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '${batch.operations} operations - ${_formatAmount(batch.totalAmount)} ETH',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusPill(status: batch.status),
            ],
          ),
          if (batch.status != StakingInstitutionalBatchStatus.executed) ...[
            const SizedBox(height: AppSpacing.x4),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Approvals',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ),
                Text(
                  '${batch.approvals}/${batch.requiredApprovals}',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x2),
            ClipRRect(
              borderRadius: AppRadii.xsRadius,
              child: LinearProgressIndicator(
                minHeight: AppSpacing.x2,
                value: progress,
                backgroundColor: AppColors.surface3,
                valueColor: AlwaysStoppedAnimation<Color>(
                  batch.status == StakingInstitutionalBatchStatus.approved
                      ? AppColors.buy
                      : AppColors.warn,
                ),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.x3),
          const Divider(
            height: AppSpacing.stakingProductDividerHeight,
            color: AppColors.borderSolid,
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              const Icon(
                Icons.access_time_rounded,
                color: AppColors.text3,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x1),
              Expanded(
                child: Text(
                  batch.created,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              if (batch.status == StakingInstitutionalBatchStatus.pending)
                _InlineAction(label: 'Approve', color: AppColors.primary)
              else if (batch.status == StakingInstitutionalBatchStatus.approved)
                _InlineAction(label: 'Execute', color: AppColors.buy),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final StakingInstitutionalBatchStatus status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      StakingInstitutionalBatchStatus.pending => AppColors.warn,
      StakingInstitutionalBatchStatus.approved => AppColors.primarySoft,
      StakingInstitutionalBatchStatus.executed => AppColors.buy,
    };
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: switch (status) {
          StakingInstitutionalBatchStatus.pending => AppColors.warn15,
          StakingInstitutionalBatchStatus.approved => AppColors.primary15,
          StakingInstitutionalBatchStatus.executed => AppColors.buy15,
        },
        borderRadius: AppRadii.smRadius,
      ),
      child: Text(
        _statusLabel(status),
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _InlineAction extends StatelessWidget {
  const _InlineAction({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      borderRadius: AppRadii.lgRadius,
      child: InkWell(
        onTap: HapticFeedback.selectionClick,
        borderRadius: AppRadii.lgRadius,
        child: Ink(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x4,
            vertical: AppSpacing.x2,
          ),
          decoration: BoxDecoration(
            color: color,
            borderRadius: AppRadii.lgRadius,
          ),
          child: Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.onAccent,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}
