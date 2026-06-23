part of 'referral_rewards_page.dart';

const double _rewardChartExtent =
    AppSpacing.x7 + AppSpacing.x6 + AppSpacing.x5 + AppSpacing.x4;

class _RewardChart extends StatelessWidget {
  const _RewardChart({required this.snapshot});

  final ReferralRewardsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ReferralRewardsPage.chartKey,
      padding: AppSpacing.referralChartPadding,
      child: SizedBox(
        height: _rewardChartExtent,
        child: CustomPaint(
          painter: _ReferralRewardChartPainter(snapshot.chartPoints),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (final point in snapshot.chartPoints)
                  Text(
                    point.month,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RewardTabs extends StatelessWidget {
  const _RewardTabs({
    required this.filters,
    required this.active,
    required this.onChanged,
  });

  final List<ReferralRewardFilterDraft> filters;
  final ReferralRewardFilter active;
  final ValueChanged<ReferralRewardFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ReferralRewardsPage.tabsKey,
      variant: VitCardVariant.inner,
      padding: AppSpacing.referralTinyPillPadding,
      child: Row(
        children: [
          for (final filter in filters)
            Expanded(
              child: Padding(
                padding: AppSpacing.referralFineInset,
                child: _FilterButton(
                  filter: filter,
                  active: filter.filter == active,
                  onTap: () => onChanged(filter.filter),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({
    required this.filter,
    required this.active,
    required this.onTap,
  });

  final ReferralRewardFilterDraft filter;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      key: ReferralRewardsPage.tabKey(filter.filter),
      label: filter.label,
      selected: active,
      onTap: onTap,
      accentColor: AppColors.primary,
      fullWidth: true,
      height: VitDensity.compact.controlHeight,
      padding: AppSpacing.referralTabButtonPadding,
    );
  }
}

class _SortRail extends StatelessWidget {
  const _SortRail({
    required this.options,
    required this.active,
    required this.onChanged,
  });

  final List<ReferralRewardSortDraft> options;
  final ReferralRewardSort active;
  final ValueChanged<ReferralRewardSort> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: ReferralRewardsPage.sortKey,
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const Icon(
            Icons.swap_vert_rounded,
            color: AppColors.text3,
            size: AppSpacing.referralSortIcon,
          ),
          const SizedBox(width: AppSpacing.x2),
          Text(
            'Sắp xếp:',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(width: AppSpacing.x3),
          for (final option in options) ...[
            _SortChip(
              option: option,
              active: option.sort == active,
              onTap: () => onChanged(option.sort),
            ),
            const SizedBox(width: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _SortChip extends StatelessWidget {
  const _SortChip({
    required this.option,
    required this.active,
    required this.onTap,
  });

  final ReferralRewardSortDraft option;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      key: ReferralRewardsPage.sortOptionKey(option.sort),
      label: option.label,
      selected: active,
      onTap: onTap,
      accentColor: AppColors.primary,
      height: AppSpacing.buttonCompact - AppSpacing.x1,
      padding: AppSpacing.referralSortChipPadding,
    );
  }
}

class _RewardLedger extends StatelessWidget {
  const _RewardLedger({required this.snapshot, required this.onReport});

  final ReferralRewardsSnapshot snapshot;
  final ValueChanged<ReferralRewardRecordDraft> onReport;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ReferralRewardsPage.ledgerKey,
      clip: true,
      child: Column(
        children: [
          Padding(
            padding: AppSpacing.referralLedgerHeaderPadding,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Lịch sử thưởng',
                    style: AppTextStyles.baseMedium.copyWith(
                      color: AppColors.text1,
                    ),
                  ),
                ),
                if (snapshot.pendingCount > 0) ...[
                  _PendingPill(count: snapshot.pendingCount),
                  const SizedBox(width: AppSpacing.x2),
                ],
                Text(
                  '${snapshot.completedCount} hoàn tất',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const Divider(
            height: AppSpacing.dividerHairline,
            color: AppColors.divider,
          ),
          if (snapshot.records.isEmpty)
            const Padding(
              padding: AppSpacing.referralEmptyPadding,
              child: VitEmptyState(
                title: 'Chưa có giao dịch',
                message: 'Thử thay đổi bộ lọc phần thưởng',
                icon: Icons.card_giftcard_rounded,
              ),
            )
          else
            for (var i = 0; i < snapshot.records.length; i++) ...[
              _RewardRecordRow(
                record: snapshot.records[i],
                onReport: () => onReport(snapshot.records[i]),
              ),
              if (i < snapshot.records.length - 1)
                const Divider(
                  height: AppSpacing.dividerHairline,
                  color: AppColors.divider,
                ),
            ],
        ],
      ),
    );
  }
}

class _PendingPill extends StatelessWidget {
  const _PendingPill({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.warn10,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.xlRadius),
      ),
      child: Padding(
        padding: AppSpacing.referralTinyPillPadding,
        child: Row(
          children: [
            const Icon(
              Icons.schedule_rounded,
              color: AppColors.warn,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x1),
            Text(
              '$count đang chờ',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.warn,
                fontWeight: AppTextStyles.bold,
                height: AppSpacing.referralLineHeightTight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RewardRecordRow extends StatelessWidget {
  const _RewardRecordRow({required this.record, required this.onReport});

  final ReferralRewardRecordDraft record;
  final VoidCallback onReport;

  @override
  Widget build(BuildContext context) {
    final pending = record.status == ReferralRewardStatus.pending;
    final typeColor = switch (record.type) {
      ReferralRewardType.kycBonus => AppModuleAccents.neutral,
      ReferralRewardType.tradeCommission => AppColors.buy,
    };
    final amountColor = pending ? AppColors.warn : typeColor;

    return Opacity(
      opacity: pending ? 0.74 : 1,
      child: Padding(
        key: ReferralRewardsPage.recordKey(record.id),
        padding: AppSpacing.referralLedgerHeaderPadding,
        child: Row(
          children: [
            _RecordIcon(type: record.type),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          record.friendName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                      if (pending) ...[
                        const SizedBox(width: AppSpacing.x2),
                        _StatusPill(label: 'Đang chờ'),
                      ],
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    '${record.action} ${record.date}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${pending ? '~' : '+'}${_formatUsd(record.amount)}',
                  style: AppTextStyles.body.copyWith(
                    color: amountColor,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
                Text(
                  record.currency,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
            if (!pending) ...[
              const SizedBox(width: AppSpacing.x2),
              VitInlineIconAction(
                key: ReferralRewardsPage.reportKey(record.id),
                onPressed: onReport,
                icon: Icons.warning_amber_rounded,
                tooltip: 'Báo cáo phần thưởng',
                color: AppColors.warn,
                size: AppSpacing.iconMd,
                padding: AppSpacing.x2,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _RecordIcon extends StatelessWidget {
  const _RecordIcon({required this.type});

  final ReferralRewardType type;

  @override
  Widget build(BuildContext context) {
    final isKyc = type == ReferralRewardType.kycBonus;
    return SizedBox.square(
      dimension: AppSpacing.iconLg + AppSpacing.x3,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: isKyc ? AppColors.primary12 : AppColors.buy10,
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.xlRadius),
        ),
        child: Center(
          child: Icon(
            isKyc ? Icons.workspace_premium_rounded : Icons.trending_up_rounded,
            color: isKyc ? AppColors.primary : AppColors.buy,
            size: AppSpacing.iconMd,
          ),
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.warn10,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.xlRadius),
      ),
      child: Padding(
        padding: AppSpacing.referralTinyPillPadding,
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.warn,
            fontWeight: AppTextStyles.bold,
            height: AppSpacing.referralLineHeightTight,
          ),
        ),
      ),
    );
  }
}
