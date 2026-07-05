part of 'launchpad_staking_page.dart';

class _PositionCard extends StatelessWidget {
  const _PositionCard({
    required this.position,
    required this.claimReceiptRoute,
  });

  final LaunchpadStakePositionDraft position;
  final String claimReceiptRoute;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadStakingPage.positionKey(position.id),
      radius: VitCardRadius.large,
      padding: AppSpacing.launchpadPaddingX5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _LogoBadge(
                label: position.projectSymbol.length > 2
                    ? position.projectSymbol.substring(0, 2)
                    : position.projectSymbol,
                color: position.accent,
                size: AppSpacing.x7,
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      position.projectName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.baseMedium.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.extraBold,
                      ),
                    ),
                    Text(
                      'Stake ${position.stakeToken} · Earn ${position.rewardToken}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const VitStatusPill(
                label: 'Đang stake',
                status: VitStatusPillStatus.success,
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _InfoTile(
                  label: 'Số lượng stake',
                  value: _formatUsd(position.stakedAmount),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _InfoTile(
                  label: 'APY',
                  value: '${_formatApy(position.apy)}%',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: _InfoTile(
                  label: 'Phần thưởng chờ',
                  value:
                      '${_formatToken(position.pendingRewards)} ${position.rewardToken}',
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _InfoTile(
                  label: 'Đã nhận',
                  value:
                      '${_formatToken(position.claimedRewards)} ${position.rewardToken}',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          VitCard(
            variant: VitCardVariant.inner,
            borderColor: AppColors.warn15,
            padding: AppSpacing.launchpadPaddingX4,
            child: Row(
              children: [
                const Icon(
                  Icons.lock_clock_rounded,
                  color: AppColors.warn,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Text(
                    'Khóa đến: ${position.lockUntil}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: VitCtaButton(
                  key: LaunchpadStakingPage.claimKey(position.id),
                  variant: VitCtaButtonVariant.secondary,
                  height: AppSpacing.buttonCompact,
                  leading: const Icon(Icons.redeem_rounded),
                  onPressed: () => context.go(claimReceiptRoute),
                  child: const Text('Nhận thưởng'),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: VitCtaButton(
                  variant: VitCtaButtonVariant.ghost,
                  height: AppSpacing.buttonCompact,
                  leading: const Icon(Icons.lock_open_rounded),
                  onPressed: HapticFeedback.selectionClick,
                  child: const Text('Unstake'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ApyCalculator extends StatefulWidget {
  const _ApyCalculator({required this.pools});

  final List<LaunchpoolPoolDraft> pools;

  @override
  State<_ApyCalculator> createState() => _ApyCalculatorState();
}

class _ApyCalculatorState extends State<_ApyCalculator> {
  late String _poolId = widget.pools
      .firstWhere((pool) => pool.status == LaunchpoolPoolStatus.active)
      .id;
  var _amount = 1000.0;
  var _days = 30;

  @override
  Widget build(BuildContext context) {
    final pool = widget.pools.firstWhere(
      (candidate) => candidate.id == _poolId,
    );
    final tierBonus = _currentTier(pool.tiers, _amount)?.apyBonus ?? 0;
    final apy = pool.baseApy + tierBonus;
    final rewards = (_amount * apy / 100) / 365 * _days / pool.rewardTokenPrice;
    final nextTier = _nextTier(pool.tiers, _amount);

    final activePools = widget.pools
        .where((pool) => pool.status == LaunchpoolPoolStatus.active)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitTabBar(
          tabs: [
            for (final candidate in activePools)
              VitTabItem(key: candidate.id, label: candidate.projectSymbol),
          ],
          activeKey: _poolId,
          onChanged: (id) => setState(() => _poolId = id),
          variant: VitTabBarVariant.segment,
        ),
        const SizedBox(height: AppSpacing.x4),
        VitCard(
          key: LaunchpadStakingPage.calculatorKey,
          radius: VitCardRadius.large,
          padding: AppSpacing.launchpadPaddingX5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.calculate_outlined,
                    color: AppColors.primary,
                    size: AppSpacing.iconMd,
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Text(
                      'Tính toán phần thưởng',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.baseMedium.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x5),
              _StepperField(
                label: 'Số tiền stake',
                value: _formatUsd(_amount),
                onMinus: () => setState(
                  () => _amount = (_amount - 500).clamp(100, 20000).toDouble(),
                ),
                onPlus: () => setState(
                  () => _amount = (_amount + 500).clamp(100, 20000).toDouble(),
                ),
              ),
              const SizedBox(height: AppSpacing.x3),
              _StepperField(
                label: 'Thời gian',
                value: '$_days ngày',
                onMinus: () =>
                    setState(() => _days = (_days - 7).clamp(7, 90).toInt()),
                onPlus: () =>
                    setState(() => _days = (_days + 7).clamp(7, 90).toInt()),
              ),
              const SizedBox(height: AppSpacing.x5),
              VitCard(
                variant: VitCardVariant.inner,
                borderColor: pool.accent.withValues(alpha: .24),
                padding: AppSpacing.launchpadPaddingX4,
                child: Column(
                  children: [
                    _ResultRow(
                      label: 'APY hiệu lực',
                      value: '${_formatApy(apy)}%',
                    ),
                    const SizedBox(height: AppSpacing.x3),
                    _ResultRow(
                      label: 'Phần thưởng ước tính',
                      value: '${_formatToken(rewards)} ${pool.rewardToken}',
                      valueColor: AppColors.warn,
                    ),
                    if (nextTier != null) ...[
                      const SizedBox(height: AppSpacing.x3),
                      Text(
                        'Stake thêm ${_formatUsd(nextTier.minStake - _amount)} để lên ${nextTier.label} (+${_formatApy(nextTier.apyBonus)}%).',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RiskDisclosure extends StatelessWidget {
  const _RiskDisclosure();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadStakingPage.disclaimerKey,
      variant: VitCardVariant.inner,
      borderColor: AppColors.warningBorder,
      padding: AppSpacing.launchpadPaddingX4,
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warn,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              'Lưu ý rủi ro đầu tư',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.warn,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconSm,
          ),
        ],
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return VitCardStat(
      padding: AppSpacing.launchpadMetricCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.portfolioTextMuted,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.baseMedium.copyWith(
              color: valueColor,
              fontWeight: AppTextStyles.extraBold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _LogoBadge extends StatelessWidget {
  const _LogoBadge({
    required this.label,
    required this.color,
    required this.size,
  });

  final String label;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: color.withValues(alpha: .12),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: color.withValues(alpha: .34),
              width: AppSpacing.launchpadBorderWidthFocus,
            ),
            borderRadius: AppRadii.lgRadius,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: AppTextStyles.extraBold,
              height: AppSpacing.launchpadLineHeightTight,
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: AppSpacing.launchpadPaddingX3,
      child: Column(
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
              maxLines: 1,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CapacityBar extends StatelessWidget {
  const _CapacityBar({required this.pool});

  final LaunchpoolPoolDraft pool;

  @override
  Widget build(BuildContext context) {
    final percentage = (pool.fillRatio * 100).clamp(0, 100).toDouble();
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Dung lượng pool',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
            ),
            Text(
              '${percentage.toStringAsFixed(1)}%',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
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
            value: percentage / 100,
            backgroundColor: AppColors.surface3,
            valueColor: AlwaysStoppedAnimation<Color>(pool.accent),
          ),
        ),
      ],
    );
  }
}
