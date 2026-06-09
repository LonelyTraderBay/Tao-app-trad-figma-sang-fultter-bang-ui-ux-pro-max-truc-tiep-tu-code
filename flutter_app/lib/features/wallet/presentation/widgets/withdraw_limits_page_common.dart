part of '../pages/withdraw_limits_page.dart';

class _KycTierCard extends StatelessWidget {
  const _KycTierCard({required this.tier, required this.currentLevel});

  final WalletKycTier tier;
  final int currentLevel;

  @override
  Widget build(BuildContext context) {
    final tierColor = Color(tier.colorHex);
    final isCurrent = tier.level == currentLevel;
    final isCompleted = tier.level < currentLevel;
    final isLocked = tier.level > currentLevel;

    return GestureDetector(
      key: WithdrawLimitsPage.tierKey(tier.level),
      onTap: isLocked ? () => context.go(AppRoutePaths.profileKyc) : () {},
      behavior: HitTestBehavior.opaque,
      child: VitCard(
        height: AppSpacing.buttonStandard + AppSpacing.x4,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        borderColor: isCurrent
            ? tierColor.withValues(alpha: .45)
            : _limitsBorder,
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: tierColor.withValues(alpha: isCurrent ? .15 : .12),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                isLocked
                    ? Icons.lock_outline_rounded
                    : isCompleted
                    ? Icons.check_circle_outline_rounded
                    : Icons.star_border_rounded,
                color: tierColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Level ${tier.level}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          height: 1,
                        ),
                      ),
                      const SizedBox(width: 9),
                      Flexible(
                        child: Text(
                          tier.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.micro.copyWith(
                            color: tierColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            height: 1,
                          ),
                        ),
                      ),
                      if (isCurrent) ...[
                        const SizedBox(width: 8),
                        _Pill(
                          label: 'HI\u1EC6N T\u1EA0I',
                          color: tierColor,
                          compact: true,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 9),
                  Text(
                    tier.dailyLimit > 0
                        ? '${_formatUsd(tier.dailyLimit)}/ng\u00E0y'
                        : 'Kh\u00F4ng c\u00F3 h\u1EA1n m\u1EE9c',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: _limitsMuted,
                      fontSize: 11,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.sectionLabel,
              size: 21,
            ),
          ],
        ),
      ),
    );
  }
}

class _FaqCard extends StatelessWidget {
  const _FaqCard({required this.faqs});

  final List<WalletLimitFaq> faqs;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      borderColor: _limitsBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'C\u00E2u h\u1ECFi th\u01B0\u1EDDng g\u1EB7p',
            style: AppTextStyles.body.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          const SizedBox(height: 16),
          for (var i = 0; i < faqs.length; i++) ...[
            Text(
              faqs[i].question,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontSize: 13,
                fontWeight: FontWeight.w900,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              faqs[i].answer,
              style: AppTextStyles.caption.copyWith(
                color: _limitsMuted,
                fontSize: 12,
                height: 1.45,
              ),
            ),
            if (i != faqs.length - 1) ...[
              const SizedBox(height: 14),
              const Divider(height: 1, color: AppColors.divider),
              const SizedBox(height: 14),
            ],
          ],
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.color, this.compact = false});

  final String label;
  final Color color;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 7 : 8,
        vertical: compact ? 4 : 5,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .16),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: compact ? 10 : 11,
          fontWeight: FontWeight.w900,
          height: 1,
        ),
      ),
    );
  }
}

String _formatUsd(double value) {
  final fixed = value.toStringAsFixed(2);
  final parts = fixed.split('.');
  final integer = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < integer.length; i++) {
    if (i > 0 && (integer.length - i) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(integer[i]);
  }
  return '\$${buffer.toString()}.${parts.last}';
}
