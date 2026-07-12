part of '../pages/trader_profile_page.dart';

class _ProfileHero extends StatelessWidget {
  const _ProfileHero({
    required this.trader,
    required this.isFollowing,
    required this.onToggleFollow,
  });

  final TradeCopyTrader trader;
  final bool isFollowing;
  final VoidCallback onToggleFollow;

  @override
  Widget build(BuildContext context) {
    final risk = _riskPresentation(trader.riskLevel);
    return VitCard(
      variant: VitCardVariant.hero,
      radius: VitCardRadius.large,
      borderColor: _profilePrimary.withValues(alpha: .25),
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VitAssetAvatar(
                label: trader.avatar,
                accentColor: _profilePrimary,
                size: TradeSpacingTokens.traderProfileAvatarSize,
                radius: AppRadii.cardRadius,
                border: true,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            trader.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.baseMedium.copyWith(
                              color: AppColors.onAccent,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                        if (isFollowing)
                          const Icon(
                            Icons.star_rounded,
                            color: _profileAmber,
                            size: TradeSpacingTokens.traderProfileActionIcon,
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Wrap(
                      spacing: AppSpacing.x1,
                      runSpacing: AppSpacing.x1,
                      children: [
                        for (final tag in trader.tags) _TagChip(label: tag),
                        _TagChip(
                          label: 'Rủi ro: ${risk.label}',
                          color: risk.color,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            children: [
              _HeroMetric(
                label: 'Tổng ROI',
                value: '+${trader.totalPnlPct.toStringAsFixed(1)}%',
                color: _profileGreen,
              ),
              const SizedBox(width: AppSpacing.x2),
              _HeroMetric(
                label: 'Win Rate',
                value: '${trader.winRate.toStringAsFixed(1)}%',
                color: _profileGreen,
              ),
              const SizedBox(width: AppSpacing.x2),
              _HeroMetric(
                label: 'Sharpe',
                value: trader.sharpeRatio.toStringAsFixed(2),
                color: _profileAmber,
              ),
              const SizedBox(width: AppSpacing.x2),
              _HeroMetric(
                label: 'MDD',
                value: '${trader.maxDrawdown.toStringAsFixed(1)}%',
                color: _profileRed,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            children: [
              Flexible(
                child: Text(
                  'Copiers: ${trader.copiers} / ${trader.maxCopiers}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Flexible(
                child: Text(
                  '${trader.maxCopiers - trader.copiers} slots trống',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          ClipRRect(
            borderRadius: AppRadii.pillRadius,
            child: LinearProgressIndicator(
              minHeight: TradeSpacingTokens.traderProfileProgressHeight,
              value: (trader.copiers / trader.maxCopiers).clamp(0, 1),
              backgroundColor: AppColors.onAccent.withValues(alpha: .10),
              valueColor: const AlwaysStoppedAnimation(_profilePrimary),
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          VitCtaButton(
            key: TraderProfilePage.copyButtonKey,
            onPressed: onToggleFollow,
            variant: isFollowing
                ? VitCtaButtonVariant.destructive
                : VitCtaButtonVariant.primary,
            leading: Icon(
              isFollowing
                  ? Icons.warning_amber_rounded
                  : Icons.content_copy_rounded,
              size: TradeSpacingTokens.traderProfileActionIcon,
            ),
            child: Text(isFollowing ? 'Hủy theo dõi' : 'Copy Trader này'),
          ),
        ],
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.label, this.color});

  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? AppColors.text2;
    return VitAccentPill(label: label, accentColor: chipColor);
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: VitCard(
        density: VitDensity.compact,
        variant: VitCardVariant.inner,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
