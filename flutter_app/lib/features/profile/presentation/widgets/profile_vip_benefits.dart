part of '../pages/vip_page.dart';

class _BenefitsTab extends StatelessWidget {
  const _BenefitsTab({
    super.key,
    required this.snapshot,
    required this.onTrade,
  });

  final ProfileVipSnapshot snapshot;
  final VoidCallback onTrade;

  @override
  Widget build(BuildContext context) {
    final nextTier = snapshot.nextTier;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final tier in snapshot.tiers.where((tier) => tier.level > 0)) ...[
          _BenefitTierCard(
            tier: tier,
            unlocked: snapshot.currentLevel >= tier.level,
          ),
          const SizedBox(height: AppSpacing.x4),
        ],
        if (nextTier != null) _UpgradeCta(nextTier: nextTier, onTrade: onTrade),
      ],
    );
  }
}

class _BenefitTierCard extends StatelessWidget {
  const _BenefitTierCard({required this.tier, required this.unlocked});

  final ProfileVipTier tier;
  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    final accent = unlocked ? _vipGold : _vipProfileAccent;
    return Opacity(
      opacity: unlocked ? 1 : .68,
      child: VitCard(
        borderColor: accent.withValues(alpha: unlocked ? .34 : .14),
        clip: true,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: unlocked ? .12 : .04),
                border: const Border(
                  bottom: BorderSide(color: AppColors.divider),
                ),
              ),
              child: Row(
                children: [
                  _TierIcon(tier: tier),
                  const SizedBox(width: AppSpacing.x4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tier.name,
                          style: AppTextStyles.base.copyWith(
                            color: accent,
                            fontWeight: FontWeight.w900,
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x3),
                        Text(
                          'Volume >= ${_formatUsd(tier.monthlyVolume)}/th\u00E1ng ho\u1EB7c T\u00E0i s\u1EA3n >= ${_formatUsd(tier.assetHold)}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.micro.copyWith(
                            color: _vipMuted,
                            fontSize: 11,
                            height: 1.25,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    unlocked
                        ? Icons.check_circle_outline_rounded
                        : Icons.lock_outline_rounded,
                    color: accent,
                    size: 19,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  for (final feature in tier.features) ...[
                    _FeatureLine(
                      text: feature,
                      accent: accent,
                      unlocked: unlocked,
                    ),
                    if (feature != tier.features.last)
                      const SizedBox(height: AppSpacing.x3),
                  ],
                  const SizedBox(height: AppSpacing.x4),
                  const Divider(height: 1, color: AppColors.divider),
                  const SizedBox(height: AppSpacing.x4),
                  Row(
                    children: [
                      _BenefitMetric(
                        label: 'Maker',
                        value: _formatFee(tier.makerFee),
                        active: unlocked,
                      ),
                      const SizedBox(width: AppSpacing.x5),
                      _BenefitMetric(
                        label: 'Taker',
                        value: _formatFee(tier.takerFee),
                        active: unlocked,
                      ),
                      const SizedBox(width: AppSpacing.x5),
                      Expanded(
                        child: _BenefitMetric(
                          label: 'H\u1EA1n m\u1EE9c r\u00FAt',
                          value:
                              '${_formatCompactUsd(tier.withdrawLimit)}/ng\u00E0y',
                          active: unlocked,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureLine extends StatelessWidget {
  const _FeatureLine({
    required this.text,
    required this.accent,
    required this.unlocked,
  });

  final String text;
  final Color accent;
  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: unlocked ? .18 : .07),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_rounded,
            color: unlocked ? accent : _vipMuted,
            size: 11,
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: unlocked ? AppColors.text1 : _vipMuted,
              fontSize: 13,
              height: 1.25,
            ),
          ),
        ),
      ],
    );
  }
}

class _BenefitMetric extends StatelessWidget {
  const _BenefitMetric({
    required this.label,
    required this.value,
    required this.active,
  });

  final String label;
  final String value;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: _vipMuted, fontSize: 10),
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: active ? _vipSuccess : AppColors.text2,
            fontWeight: FontWeight.w900,
            fontFeatures: AppTextStyles.tabularFigures,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _UpgradeCta extends StatelessWidget {
  const _UpgradeCta({required this.nextTier, required this.onTrade});

  final ProfileVipTier nextTier;
  final VoidCallback onTrade;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: _vipAccent.withValues(alpha: .24),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary12,
              borderRadius: AppRadii.cardRadius,
            ),
            child: const Icon(
              Icons.workspace_premium_outlined,
              color: _vipAccent,
              size: 21,
            ),
          ),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'N\u00E2ng c\u1EA5p l\u00EAn ${nextTier.name}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
                const SizedBox(height: AppSpacing.x3),
                Text(
                  'T\u0103ng kh\u1ED1i l\u01B0\u1EE3ng giao d\u1ECBch \u0111\u1EC3 ti\u1EBFt ki\u1EC7m th\u00EAm',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontSize: 12,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          GestureDetector(
            key: VIPPage.tradeCtaKey,
            onTap: onTrade,
            behavior: HitTestBehavior.opaque,
            child: Container(
              height: AppSpacing.buttonCompact,
              padding: const EdgeInsets.symmetric(horizontal: 13),
              decoration: BoxDecoration(
                gradient: AppGradients.navCenter,
                borderRadius: AppRadii.smRadius,
              ),
              alignment: Alignment.center,
              child: Text(
                'Giao d\u1ECBch',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.onAccent,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TierIcon extends StatelessWidget {
  const _TierIcon({required this.tier, this.large = false});

  final ProfileVipTier tier;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final size = large ? 56.0 : 18.0;
    final iconSize = large ? 29.0 : 14.0;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _tierAccent(tier).withValues(alpha: large ? .16 : .12),
        borderRadius: large ? AppRadii.cardRadius : AppRadii.smRadius,
      ),
      child: Icon(
        _iconForTier(tier.iconKey),
        color: _tierAccent(tier),
        size: iconSize,
      ),
    );
  }
}

Color _tierAccent(ProfileVipTier tier) {
  if (tier.level == 0) return _vipProfileAccent;
  if (tier.level >= 4) return AppColors.accent;
  return _vipGold;
}

IconData _iconForTier(String key) {
  return switch (key) {
    'star' => Icons.star_rounded,
    'medal' => Icons.military_tech_rounded,
    'workspace' => Icons.workspace_premium_rounded,
    'diamond' => Icons.diamond_outlined,
    'rocket' => Icons.rocket_launch_rounded,
    _ => Icons.person_outline_rounded,
  };
}

String _formatFee(double value) {
  if (value == 0) return '0%';
  return '${value.toStringAsFixed(2)}%';
}

String _formatUsd(double value) {
  return '\$${_formatNumber(value)}.00';
}

String _formatCompactUsd(double value) {
  if (value >= 1000000) {
    return '\$${(value / 1000000).toStringAsFixed(0)}M';
  }
  if (value >= 1000) {
    return '\$${(value / 1000).toStringAsFixed(0)}K';
  }
  return '\$${value.toStringAsFixed(0)}';
}

String _formatNumber(double value) {
  final text = value.toStringAsFixed(0);
  final buffer = StringBuffer();
  for (var i = 0; i < text.length; i++) {
    final remaining = text.length - i;
    buffer.write(text[i]);
    if (remaining > 1 && remaining % 3 == 1) {
      buffer.write(',');
    }
  }
  return buffer.toString();
}
