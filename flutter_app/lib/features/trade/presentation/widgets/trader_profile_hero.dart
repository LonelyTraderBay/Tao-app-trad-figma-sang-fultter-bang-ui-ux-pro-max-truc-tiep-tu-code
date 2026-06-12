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
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.surface, AppColors.surface2],
        ),
        border: Border.all(color: _profilePrimary.withValues(alpha: .25)),
        borderRadius: AppRadii.cardLargeRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 64,
                height: 64,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _profilePrimary.withValues(alpha: .13),
                  border: Border.all(
                    color: _profilePrimary.withValues(alpha: .28),
                    width: 2.5,
                  ),
                  borderRadius: AppRadii.cardRadius,
                ),
                child: Text(
                  trader.avatar,
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: _profilePrimary,
                    height: 1,
                  ),
                ),
              ),
              const SizedBox(width: 16),
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
                              height: 1.2,
                            ),
                          ),
                        ),
                        if (isFollowing)
                          const Icon(
                            Icons.star_rounded,
                            color: _profileAmber,
                            size: 17,
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
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
          const SizedBox(height: 18),
          Row(
            children: [
              _HeroMetric(
                label: 'Tổng ROI',
                value: '+${trader.totalPnlPct.toStringAsFixed(1)}%',
                color: _profileGreen,
              ),
              const SizedBox(width: 8),
              _HeroMetric(
                label: 'Win Rate',
                value: '${trader.winRate.toStringAsFixed(1)}%',
                color: _profileGreen,
              ),
              const SizedBox(width: 8),
              _HeroMetric(
                label: 'Sharpe',
                value: trader.sharpeRatio.toStringAsFixed(2),
                color: _profileAmber,
              ),
              const SizedBox(width: 8),
              _HeroMetric(
                label: 'MDD',
                value: '${trader.maxDrawdown.toStringAsFixed(1)}%',
                color: _profileRed,
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Text(
                'Copiers: ${trader.copiers} / ${trader.maxCopiers}',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  height: 1,
                ),
              ),
              const Spacer(),
              Text(
                '${trader.maxCopiers - trader.copiers} slots trống',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  height: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 8,
              value: (trader.copiers / trader.maxCopiers).clamp(0, 1),
              backgroundColor: AppColors.onAccent.withValues(alpha: .10),
              valueColor: const AlwaysStoppedAnimation(_profilePrimary),
            ),
          ),
          const SizedBox(height: 15),
          InkWell(
            key: TraderProfilePage.copyButtonKey,
            onTap: onToggleFollow,
            borderRadius: AppRadii.cardRadius,
            child: Container(
              height: AppSpacing.inputHeight,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isFollowing
                    ? _profileRed.withValues(alpha: .15)
                    : _profilePrimary,
                border: isFollowing
                    ? Border.all(color: _profileRed.withValues(alpha: .3))
                    : null,
                borderRadius: AppRadii.cardRadius,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isFollowing
                        ? Icons.warning_amber_rounded
                        : Icons.content_copy_rounded,
                    color: isFollowing ? _profileRed : AppColors.onAccent,
                    size: 17,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isFollowing ? 'Hủy theo dõi' : 'Copy Trader này',
                    style: AppTextStyles.body.copyWith(
                      color: isFollowing ? _profileRed : AppColors.onAccent,
                      fontWeight: AppTextStyles.bold,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (color ?? AppColors.onAccent).withValues(alpha: .08),
        borderRadius: AppRadii.smRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: chipColor,
          fontWeight: AppTextStyles.medium,
          height: 1,
        ),
      ),
    );
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
      child: Container(
        height: 54,
        padding: const EdgeInsets.fromLTRB(8, 9, 8, 8),
        decoration: BoxDecoration(
          color: AppColors.onAccent.withValues(alpha: .05),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                height: 1,
              ),
            ),
            const Spacer(),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
                height: 1,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
