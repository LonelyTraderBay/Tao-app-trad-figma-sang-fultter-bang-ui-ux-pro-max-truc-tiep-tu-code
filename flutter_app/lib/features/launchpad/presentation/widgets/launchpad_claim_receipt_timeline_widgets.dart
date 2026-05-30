part of '../pages/launchpad_claim_receipt_page.dart';

class _VestingTimelineCard extends StatelessWidget {
  const _VestingTimelineCard({required this.receipt, required this.onClaim});

  final LaunchpadRewardClaimReceiptDraft receipt;
  final ValueChanged<LaunchpadRewardVestingEntryDraft> onClaim;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Lịch trình mở khóa',
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          ClipRRect(
            borderRadius: AppRadii.xsRadius,
            child: Row(
              children: [
                for (final entry in receipt.vestingSchedule)
                  Expanded(
                    flex: entry.percent,
                    child: SizedBox(
                      height: AppSpacing.x3,
                      child: ColoredBox(color: _vestingColor(entry.status)),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          for (final entry in receipt.vestingSchedule)
            _VestingTimelineRow(entry: entry, onClaim: onClaim),
        ],
      ),
    );
  }
}

class _ClaimHistoryCard extends StatelessWidget {
  const _ClaimHistoryCard({required this.receipt});

  final LaunchpadRewardClaimReceiptDraft receipt;

  @override
  Widget build(BuildContext context) {
    final totalUsd = receipt.claimHistory.fold<double>(
      0,
      (sum, entry) => sum + entry.usdValue,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCard(
          radius: VitCardRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Row(
            children: [
              Expanded(
                child: _SummaryTile(
                  label: 'Số lượng',
                  value: _formatNumber(receipt.totalClaimed),
                  suffix: receipt.rewardToken,
                  color: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _SummaryTile(
                  label: 'Giá trị',
                  value: _formatUsd(totalUsd),
                  suffix: 'USD',
                  color: AppColors.text1,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _SummaryTile(
                  label: 'Giao dịch',
                  value: '${receipt.claimHistory.length}',
                  suffix: 'lần',
                  color: AppColors.text1,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        for (final entry in receipt.claimHistory) _HistoryEntry(entry: entry),
      ],
    );
  }
}

class _VestingMiniRow extends StatelessWidget {
  const _VestingMiniRow({required this.entry});

  final LaunchpadRewardVestingEntryDraft entry;

  @override
  Widget build(BuildContext context) {
    final color = _vestingColor(entry.status);
    return Container(
      key: LaunchpadClaimReceiptPage.vestingKey(entry.id),
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x3),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          Icon(
            _vestingIcon(entry.status),
            color: color,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  entry.unlockDate,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${_formatNumber(entry.amount)} ${entry.token}',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
              _StatusBadge(label: _vestingLabel(entry.status), color: color),
            ],
          ),
        ],
      ),
    );
  }
}

class _VestingTimelineRow extends StatelessWidget {
  const _VestingTimelineRow({required this.entry, required this.onClaim});

  final LaunchpadRewardVestingEntryDraft entry;
  final ValueChanged<LaunchpadRewardVestingEntryDraft> onClaim;

  @override
  Widget build(BuildContext context) {
    final claimable =
        entry.status == LaunchpadVestingEntryStatus.claimable ||
        entry.status == LaunchpadVestingEntryStatus.unlocking;
    return Padding(
      key: LaunchpadClaimReceiptPage.vestingKey(entry.id),
      padding: const EdgeInsets.only(bottom: AppSpacing.x3),
      child: VitCard(
        variant: claimable ? VitCardVariant.inner : VitCardVariant.standard,
        radius: VitCardRadius.md,
        padding: const EdgeInsets.all(AppSpacing.x3),
        child: Row(
          children: [
            Icon(
              _vestingIcon(entry.status),
              color: _vestingColor(entry.status),
              size: AppSpacing.iconMd,
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.label,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  Text(
                    '${entry.unlockDate} · ${entry.percent}%',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ),
            if (claimable)
              VitCtaButton(
                onPressed: () => onClaim(entry),
                variant: VitCtaButtonVariant.success,
                fullWidth: false,
                height: AppSpacing.buttonCompact,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x3),
                child: const Text('Nhận'),
              )
            else
              Text(
                '${_formatNumber(entry.amount)} ${entry.token}',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
