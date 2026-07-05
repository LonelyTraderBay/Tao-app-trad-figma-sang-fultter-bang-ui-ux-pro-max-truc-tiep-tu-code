part of 'launchpad_staking_page.dart';

class _TierChip extends StatelessWidget {
  const _TierChip({required this.tier, required this.selected});

  final LaunchpadStakingTierDraft tier;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: selected
            ? tier.accent.withValues(alpha: .12)
            : AppColors.surface2,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: selected
                ? tier.accent.withValues(alpha: .34)
                : AppColors.cardBorder,
          ),
          borderRadius: AppRadii.smRadius,
        ),
      ),
      child: Padding(
        padding: AppSpacing.launchpadTierChipPadding,
        child: Column(
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                tier.label,
                style: AppTextStyles.micro.copyWith(
                  color: tier.accent,
                  fontWeight: AppTextStyles.bold,
                  height: AppSpacing.launchpadLineHeightTight,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(
              '+${_formatApy(tier.apyBonus)}%',
              style: AppTextStyles.chartLabelXs.copyWith(
                color: AppColors.text2,
                height: AppSpacing.launchpadLineHeightTight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserStakeSummary extends StatelessWidget {
  const _UserStakeSummary({required this.pool});

  final LaunchpoolPoolDraft pool;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: pool.accent.withValues(alpha: .18),
      padding: AppSpacing.launchpadPaddingX4,
      child: Row(
        children: [
          Expanded(
            child: _SummaryText(
              label: 'Bạn đang stake',
              value: _formatUsd(pool.userStaked),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: _SummaryText(
              label: 'Phần thưởng chờ',
              value: '${_formatToken(pool.userRewards)} ${pool.rewardToken}',
              alignEnd: true,
              valueColor: AppColors.warn,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryText extends StatelessWidget {
  const _SummaryText({
    required this.label,
    required this.value,
    this.alignEnd = false,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final bool alignEnd;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: valueColor,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ),
      ],
    );
  }
}

class _TimelineStatus extends StatelessWidget {
  const _TimelineStatus({required this.status});

  final LaunchpoolPoolStatus status;

  @override
  Widget build(BuildContext context) {
    final (text, color, icon) = switch (status) {
      LaunchpoolPoolStatus.upcoming => (
        'Sắp mở',
        AppColors.warn,
        Icons.schedule_rounded,
      ),
      LaunchpoolPoolStatus.active => (
        'Đang diễn ra',
        AppColors.buy,
        Icons.check_circle_outline_rounded,
      ),
      LaunchpoolPoolStatus.ended => (
        'Đã kết thúc',
        AppColors.text2,
        Icons.check_circle_outline_rounded,
      ),
    };
    return Row(
      children: [
        Icon(icon, color: color, size: AppSpacing.iconSm),
        const SizedBox(width: AppSpacing.x2),
        Text(
          text,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _PoolAction extends StatelessWidget {
  const _PoolAction({required this.pool});

  final LaunchpoolPoolDraft pool;

  @override
  Widget build(BuildContext context) {
    if (pool.status == LaunchpoolPoolStatus.upcoming) {
      return VitCard(
        variant: VitCardVariant.inner,
        borderColor: AppColors.warningBorder,
        padding: AppSpacing.launchpadVerticalPaddingX4,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.schedule_rounded,
              color: AppColors.warn,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x2),
            Text(
              'Sắp mở',
              style: AppTextStyles.baseMedium.copyWith(
                color: AppColors.warn,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
      );
    }

    if (pool.status == LaunchpoolPoolStatus.ended) {
      return const VitCtaButton(
        onPressed: null,
        leading: Icon(Icons.lock_outline_rounded),
        child: Text('Đã kết thúc'),
      );
    }

    return VitCtaButton(
      variant: VitCtaButtonVariant.primary,
      leading: const Icon(Icons.currency_exchange_rounded),
      onPressed: HapticFeedback.selectionClick,
      child: Text(pool.userStaked > 0 ? 'Stake thêm' : 'Bắt đầu stake'),
    );
  }
}

class _StepperField extends StatelessWidget {
  const _StepperField({
    required this.label,
    required this.value,
    required this.onMinus,
    required this.onPlus,
  });

  final String label;
  final String value;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: AppSpacing.launchpadPaddingX4,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                Text(
                  value,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
          ),
          _RoundIconButton(icon: Icons.remove_rounded, onTap: onMinus),
          const SizedBox(width: AppSpacing.x2),
          _RoundIconButton(icon: Icons.add_rounded, onTap: onPlus),
        ],
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitIconButton(
      onPressed: onTap,
      icon: icon,
      tooltip: icon == Icons.add_rounded ? 'Tang gia tri' : 'Giam gia tri',
      variant: VitIconButtonVariant.transparent,
      size: VitIconButtonSize.sm,
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.baseMedium.copyWith(
              color: valueColor,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ),
      ],
    );
  }
}

enum _StakingTab {
  pools('pools', 'Pools'),
  positions('positions', 'Vị trí của tôi'),
  calculator('calculator', 'Tính APY');

  const _StakingTab(this.id, this.label);

  final String id;
  final String label;
}

LaunchpadStakingTierDraft? _currentTier(
  List<LaunchpadStakingTierDraft> tiers,
  double amount,
) {
  LaunchpadStakingTierDraft? selected;
  for (final tier in tiers) {
    if (amount >= tier.minStake) selected = tier;
  }
  return selected;
}

LaunchpadStakingTierDraft? _nextTier(
  List<LaunchpadStakingTierDraft> tiers,
  double amount,
) {
  for (final tier in tiers) {
    if (amount < tier.minStake) return tier;
  }
  return null;
}

String _formatUsd(double value) => '\$${_comma(value.round())}';

String _formatToken(double value) => _comma(value.round());

String _formatApy(double value) {
  final rounded = value.toStringAsFixed(
    value.truncateToDouble() == value ? 0 : 1,
  );
  return rounded;
}

String _comma(int value) {
  final sign = value < 0 ? '-' : '';
  final text = value.abs().toString();
  final buffer = StringBuffer(sign);
  for (var index = 0; index < text.length; index++) {
    final fromEnd = text.length - index;
    buffer.write(text[index]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
  }
  return buffer.toString();
}
