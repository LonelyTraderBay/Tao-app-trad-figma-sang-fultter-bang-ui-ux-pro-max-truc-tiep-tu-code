part of '../pages/withdraw_limits_page.dart';

class _CurrentTierCard extends StatelessWidget {
  const _CurrentTierCard({required this.snapshot});

  final WalletWithdrawLimitsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final tier = snapshot.currentTier;
    final tierColor = Color(tier.colorHex);

    return VitCard(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      radius: VitCardRadius.lg,
      borderColor: _limitsHeroBorder,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: tierColor.withValues(alpha: .14),
                  borderRadius: AppRadii.cardRadius,
                  border: Border.all(color: tierColor.withValues(alpha: .5)),
                ),
                alignment: Alignment.center,
                child: Icon(Icons.shield_outlined, color: tierColor, size: 25),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'KYC Level ${tier.level}',
                          style: AppTextStyles.body.copyWith(
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: _Pill(
                            label: tier.name,
                            color: tierColor,
                            compact: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\u0110\u00E3 x\u00E1c minh',
                      style: AppTextStyles.micro.copyWith(color: _limitsMuted),
                    ),
                  ],
                ),
              ),
              Icon(Icons.check_circle_outline, color: tierColor, size: 22),
            ],
          ),
          const SizedBox(height: 24),
          _LimitProgress(
            label: 'H\u1EA1n m\u1EE9c r\u00FAt/ng\u00E0y',
            used: snapshot.usedToday,
            limit: tier.dailyLimit,
            remaining: snapshot.dailyRemaining,
            percent: snapshot.dailyPercent,
          ),
          const SizedBox(height: 18),
          _LimitProgress(
            label: 'H\u1EA1n m\u1EE9c r\u00FAt/th\u00E1ng',
            used: snapshot.usedMonth,
            limit: tier.monthlyLimit,
            remaining: snapshot.monthlyRemaining,
            percent: snapshot.monthlyPercent,
          ),
        ],
      ),
    );
  }
}

class _LimitProgress extends StatelessWidget {
  const _LimitProgress({
    required this.label,
    required this.used,
    required this.limit,
    required this.remaining,
    required this.percent,
  });

  final String label;
  final double used;
  final double limit;
  final double remaining;
  final double percent;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ),
            Text(
              '${_formatUsd(used)} / ${_formatUsd(limit)}',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            minHeight: 8,
            value: (percent / 100).clamp(0, 1).toDouble(),
            color: _limitsGreen,
            backgroundColor: AppColors.surface3,
          ),
        ),
        const SizedBox(height: 9),
        Row(
          children: [
            Expanded(
              child: Text(
                'C\u00F2n l\u1EA1i: ${_formatUsd(remaining)}',
                style: AppTextStyles.micro.copyWith(
                  color: _limitsGreen,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            Text(
              '${percent.toStringAsFixed(1)}% \u0111\u00E3 d\u00F9ng',
              style: AppTextStyles.micro.copyWith(color: _limitsMuted),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickStats extends StatelessWidget {
  const _QuickStats({required this.tier});

  final WalletKycTier tier;

  @override
  Widget build(BuildContext context) {
    final stats = [
      (
        label: 'R\u00FAt/ng\u00E0y t\u1ED1i \u0111a',
        value: _formatUsd(tier.dailyLimit),
        color: _limitsPrimary,
      ),
      (
        label: 'Giao d\u1ECBch \u0111\u01A1n',
        value: _formatUsd(tier.singleTxLimit),
        color: _limitsGreen,
      ),
      (
        label: 'R\u00FAt/th\u00E1ng',
        value: _formatUsd(tier.monthlyLimit),
        color: _limitsAmber,
      ),
    ];

    return Row(
      children: [
        for (final stat in stats) ...[
          Expanded(
            child: VitCard(
              variant: VitCardVariant.inner,
              height: AppSpacing.walletNetworkSummaryStatHeight,
              padding: AppSpacing.walletNetworkStatPadding,
              borderColor: _limitsBorder,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      stat.value,
                      style: AppTextStyles.caption.copyWith(
                        color: stat.color,
                        fontWeight: AppTextStyles.bold,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.walletNetworkStatTextGap),
                  Text(
                    stat.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.micro.copyWith(color: _limitsMuted),
                  ),
                ],
              ),
            ),
          ),
          if (stat != stats.last)
            const SizedBox(width: AppSpacing.walletAddressStatsGap),
        ],
      ],
    );
  }
}

class _LimitWarning extends StatelessWidget {
  const _LimitWarning();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.fromLTRB(16, 13, 16, 13),
      borderColor: _limitsAmber.withValues(alpha: .34),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: _limitsAmber,
            size: 16,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text:
                        'Y\u00EAu c\u1EA7u r\u00FAt tr\u00EAn \$10,000.00 s\u1EBD c\u1EA7n xem x\u00E9t th\u1EE7 c\u00F4ng (l\u00EAn \u0111\u1EBFn 24 gi\u1EDD). ',
                  ),
                  TextSpan(
                    text:
                        'R\u00FAt tr\u00EAn \$50,000.00 c\u1EA7n x\u00E1c minh video call.',
                    style: AppTextStyles.caption.copyWith(
                      color: _limitsAmber,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
              style: AppTextStyles.caption.copyWith(
                color: _limitsAmber,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 15,
          decoration: BoxDecoration(
            color: _limitsPrimary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 7),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}
