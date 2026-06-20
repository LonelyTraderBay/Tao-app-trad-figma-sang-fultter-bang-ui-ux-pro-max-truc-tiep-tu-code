part of '../pages/copy_trading_v2_page.dart';

class _RiskWarningCard extends StatelessWidget {
  const _RiskWarningCard({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      padding: AppSpacing.zeroInsets.copyWith(
        left: _copyCardSpace,
        top: _copySpace,
        right: _copyCardSpace,
        bottom: _copySpace,
      ),
      variant: VitCardVariant.inner,
      borderColor: AppColors.warningBorder,
      child: VitHighRiskStatePanel(
        state: VitHighRiskUiState.riskReview,
        title: title,
        message:
            '$message Preview, fees, allocation limit and confirmation are reviewed before copying.',
        contractId: 'copy-trading-v2-review',
        density: VitDensity.compact,
      ),
    );
  }
}

class _SortChips extends StatelessWidget {
  const _SortChips({
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  final List<String> options;
  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final option in options) ...[
            _SortChip(
              key: CopyTradingV2Page.sortKey(option),
              label: option,
              active: selected == option,
              onTap: () => onChanged(option),
            ),
            if (option != options.last) const SizedBox(width: AppSpacing.x3),
          ],
        ],
      ),
    );
  }
}

class _SortChip extends StatelessWidget {
  const _SortChip({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.xlRadius,
      child: VitCard(
        width: _sortChipWidth(label),
        height: _copySortChipHeight,
        alignment: Alignment.center,
        padding: AppSpacing.zeroInsets.copyWith(
          left: AppSpacing.walletAssetChartBottomGap,
          right: AppSpacing.walletAssetChartBottomGap,
        ),
        variant: active ? VitCardVariant.standard : VitCardVariant.inner,
        borderColor: active ? _copyPrimary : AppColors.cardBorder,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: active ? AppColors.onAccent : AppColors.text2,
              fontWeight: active ? AppTextStyles.bold : AppTextStyles.medium,
            ),
          ),
        ),
      ),
    );
  }
}

class _TraderCard extends StatelessWidget {
  const _TraderCard({required this.trader, required this.onOpen});

  final TradeCopyTrader trader;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final tier = _tierFor(trader.copiers);
    return VitCard(
      key: CopyTradingV2Page.traderKey(trader.id),
      density: VitDensity.compact,
      padding: AppSpacing.zeroInsets.copyWith(
        left: _copyCardSpace,
        top: _copyCardSpace,
        right: _copyCardSpace,
        bottom: _copyCardSpace,
      ),
      borderColor: AppColors.cardBorder,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _AvatarBadge(trader: trader, tier: tier),
              const SizedBox(width: _copyCardSpace),
              Expanded(
                child: Padding(
                  padding: AppSpacing.zeroInsets.copyWith(
                    top: AppSpacing.dividerHairline,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              trader.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text1,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                          ),
                          if (trader.isFollowing) ...[
                            const SizedBox(width: _copySpace),
                            const Icon(
                              Icons.star_rounded,
                              color: AppColors.warn,
                              size: AppSpacing.iconSm,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: _copySpace),
                      Wrap(
                        spacing: _copySpace,
                        runSpacing: _copySpace,
                        children: [
                          _MiniBadge(label: tier.label, color: tier.color),
                          for (final tag in trader.tags.take(2))
                            _MiniBadge(label: tag, color: AppColors.text2),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: _copySpace),
              _RoiBlock(trader: trader),
            ],
          ),
          const SizedBox(height: _copyCardSpace),
          _DetailsButton(traderId: trader.id, onOpen: onOpen),
        ],
      ),
    );
  }
}

class _AvatarBadge extends StatelessWidget {
  const _AvatarBadge({required this.trader, required this.tier});

  final TradeCopyTrader trader;
  final _TierStyle tier;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _copyAvatarStackWidth,
      height: _copyAvatarStackHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          VitCard(
            width: _copyAvatarSize,
            height: _copyAvatarSize,
            alignment: Alignment.center,
            radius: VitCardRadius.lg,
            variant: VitCardVariant.ghost,
            borderColor: _copyPrimary.withValues(alpha: .27),
            background: ColoredBox(color: _copyPrimary.withValues(alpha: .13)),
            clip: true,
            child: Text(
              trader.avatar,
              style: AppTextStyles.baseMedium.copyWith(
                color: _copyPrimary,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          Positioned(
            right: -AppSpacing.dividerHairline,
            bottom: AppSpacing.hairlineStroke,
            child: VitCard(
              width: _copyTierBadgeSize,
              height: _copyTierBadgeSize,
              alignment: Alignment.center,
              radius: VitCardRadius.lg,
              borderColor: tier.color,
              child: Icon(
                tier.icon,
                color: tier.color,
                size: _copyTierBadgeIcon,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoiBlock extends StatelessWidget {
  const _RoiBlock({required this.trader});

  final TradeCopyTrader trader;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: AppSpacing.copyTradingV2RoiMaxWidth,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '+${trader.totalPnlPct.toStringAsFixed(1)}%',
              style: AppTextStyles.sectionTitle.copyWith(
                color: AppColors.buy,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            'Tổng ROI',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _DetailsButton extends StatelessWidget {
  const _DetailsButton({required this.traderId, required this.onOpen});

  final String traderId;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: CopyTradingV2Page.detailKey(traderId),
      onTap: onOpen,
      borderRadius: AppRadii.inputRadius,
      child: VitCard(
        height: _copyDetailsButtonHeight,
        alignment: Alignment.center,
        variant: VitCardVariant.inner,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Xem chi tiết',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.text1,
              size: AppSpacing.walletAssetSectionGap,
            ),
          ],
        ),
      ),
    );
  }
}
