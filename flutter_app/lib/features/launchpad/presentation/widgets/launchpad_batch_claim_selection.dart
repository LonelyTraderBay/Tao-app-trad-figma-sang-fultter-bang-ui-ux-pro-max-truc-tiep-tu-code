part of '../pages/launchpad_batch_claim_page.dart';

class _SelectionHeader extends StatelessWidget {
  const _SelectionHeader({
    required this.selected,
    required this.total,
    required this.onSelectAll,
    required this.onClear,
  });

  final int selected;
  final int total;
  final VoidCallback onSelectAll;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Chọn vị trí ($selected/$total)',
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
        VitCtaButton(
          onPressed: onSelectAll,
          variant: VitCtaButtonVariant.ghost,
          fullWidth: false,
          height: AppSpacing.buttonCompact,
          child: const Text('Chọn tất cả'),
        ),
        const SizedBox(
          width: AppSpacing.launchpadDividerWidth,
          height: AppSpacing.launchpadBox18,
          child: ColoredBox(color: AppColors.divider),
        ),
        VitCtaButton(
          onPressed: onClear,
          variant: VitCtaButtonVariant.ghost,
          fullWidth: false,
          height: AppSpacing.buttonCompact,
          child: const Text('Bỏ chọn'),
        ),
      ],
    );
  }
}

class _BatchPositionCard extends StatelessWidget {
  const _BatchPositionCard({
    required this.position,
    required this.selected,
    required this.onToggle,
    required this.onDetail,
  });

  final LaunchpadBatchClaimPositionDraft position;
  final bool selected;
  final VoidCallback onToggle;
  final VoidCallback onDetail;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadBatchClaimPage.positionKey(position.positionId),
      radius: VitCardRadius.large,
      borderColor: selected
          ? position.accent.resolve().withValues(alpha: .42)
          : AppColors.cardBorder,
      padding: AppSpacing.launchpadPaddingX4,
      onTap: onToggle,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            selected
                ? Icons.check_box_rounded
                : Icons.check_box_outline_blank_rounded,
            key: LaunchpadBatchClaimPage.checkboxKey(position.positionId),
            color: selected ? position.accent.resolve() : AppColors.text3,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    _TokenAvatar(
                      label: _avatarLabel(position.projectSymbol),
                      color: position.accent.resolve(),
                    ),
                    const SizedBox(width: AppSpacing.x3),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            position.projectName,
                            style: AppTextStyles.base.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                          Text(
                            '${position.chain} · APY ${_trimDouble(position.apy)}% · ${_formatNumber(position.stakedAmount)} ${position.stakeToken} staked',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x2),
                DecoratedBox(
                  decoration: const ShapeDecoration(
                    color: AppColors.surface2,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadii.lgRadius,
                    ),
                  ),
                  child: Padding(
                    padding: AppSpacing.launchpadPillPadding,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Có thể nhận',
                                style: AppTextStyles.micro.copyWith(
                                  color: AppColors.text3,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    _formatNumber(position.claimableAmount),
                                    style: AppTextStyles.baseMedium.copyWith(
                                      color: AppColors.buy,
                                      fontWeight: AppTextStyles.bold,
                                      fontFeatures:
                                          AppTextStyles.tabularFigures,
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.x2),
                                  Text(
                                    position.rewardToken,
                                    style: AppTextStyles.micro.copyWith(
                                      color: AppColors.buy,
                                      fontWeight: AppTextStyles.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '~${_formatUsd(position.claimableUsd)} USD',
                                style: AppTextStyles.micro.copyWith(
                                  color: AppColors.text3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _CountBadge(count: position.vestingEntries.length),
                            VitCtaButton(
                              key: LaunchpadBatchClaimPage.detailKey(
                                position.positionId,
                              ),
                              onPressed: onDetail,
                              variant: VitCtaButtonVariant.secondary,
                              fullWidth: false,
                              height: AppSpacing.buttonCompact,
                              padding: AppSpacing.launchpadInlinePillPadding,
                              child: const Text('Chi tiết'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing: AppSpacing.x2,
                    runSpacing: AppSpacing.x2,
                    children: [
                      for (final entry in position.vestingEntries)
                        _VestingPill(entry: entry),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TokenAvatar extends StatelessWidget {
  const _TokenAvatar({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: AppSpacing.launchpadBox36,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: color.withValues(alpha: .18),
          shape: RoundedRectangleBorder(borderRadius: AppRadii.lgRadius),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.buy15,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.inputRadius),
      ),
      child: Padding(
        padding: AppSpacing.launchpadTimelineMarkerPadding,
        child: Text(
          '$count đợt',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.buy,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _VestingPill extends StatelessWidget {
  const _VestingPill({required this.entry});

  final LaunchpadRewardVestingEntryDraft entry;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: AppColors.warn.withValues(alpha: .10),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.inputRadius,
          side: BorderSide(color: AppColors.warn.withValues(alpha: .20)),
        ),
      ),
      child: Padding(
        padding: AppSpacing.launchpadPillPadding,
        child: Text(
          '${entry.label}: ${_formatNumber(entry.amount)} ${entry.token}',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.warn,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _ChainWarning extends StatelessWidget {
  const _ChainWarning({required this.summary});

  final LaunchpadBatchClaimSummaryDraft summary;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      key: LaunchpadBatchClaimPage.warningKey,
      decoration: ShapeDecoration(
        color: AppColors.warn.withValues(alpha: .08),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.lgRadius,
          side: BorderSide(color: AppColors.warn.withValues(alpha: .18)),
        ),
      ),
      child: Padding(
        padding: AppSpacing.launchpadPaddingX4,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.warn,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Text(
                'Các vị trí trên nhiều chain (${summary.chains.join(', ')}). Batch claim sẽ gửi giao dịch riêng cho mỗi chain.',
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
