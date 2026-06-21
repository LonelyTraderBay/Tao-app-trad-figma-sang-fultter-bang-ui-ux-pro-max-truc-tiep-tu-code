part of '../pages/launchpad_portfolio_page.dart';

class _SubscriptionCard extends StatelessWidget {
  const _SubscriptionCard({
    required this.subscription,
    required this.receiptRoute,
  });

  final LaunchpadSubscriptionDraft subscription;
  final String receiptRoute;

  @override
  Widget build(BuildContext context) {
    final status = _statusStyle(subscription.status);
    final hasClaimable =
        subscription.status == LaunchpadSubscriptionStatus.allocated ||
        subscription.status == LaunchpadSubscriptionStatus.partiallyAllocated;

    return VitCard(
      key: LaunchpadPortfolioPage.subscriptionKey(subscription.id),
      radius: VitCardRadius.md,
      padding: AppSpacing.launchpadPaddingX4,
      onTap: () => context.go(receiptRoute),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _SubscriptionAvatar(subscription: subscription),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subscription.projectName,
                      style: AppTextStyles.baseMedium.copyWith(
                        fontWeight: AppTextStyles.bold,
                        height: AppSpacing.launchpadLineHeightLabel,
                      ),
                    ),
                    Text(
                      subscription.timestamp,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusPill(style: status),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _InfoTile(
                  label: 'Đã đầu tư',
                  value: _formatUsd(subscription.amount),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _InfoTile(
                  label: 'Token phân bổ',
                  value:
                      '${_formatInt(subscription.tokensAllocated)} ${subscription.projectSymbol}',
                ),
              ),
            ],
          ),
          if (subscription.allocationRatio > 0 &&
              subscription.allocationRatio < 1) ...[
            const SizedBox(height: AppSpacing.x3),
            _InlineNotice(
              icon: Icons.error_outline_rounded,
              label:
                  'Phân bổ ${(subscription.allocationRatio * 100).round()}% — Hoàn lại: ${_formatUsd(subscription.refundAmount)}',
              color: AppColors.warn,
            ),
          ],
          const SizedBox(height: AppSpacing.x4),
          _VestingProgress(subscription: subscription),
          if (hasClaimable) ...[
            const SizedBox(height: AppSpacing.x3),
            _ActionRow(
              key: LaunchpadPortfolioPage.claimKey(subscription.id),
              icon: Icons.lock_open_rounded,
              label: 'Có token sẵn sàng nhận',
              color: AppColors.buy,
              onTap: HapticFeedback.selectionClick,
            ),
          ],
          if (subscription.refundAmount > 0 &&
              subscription.status ==
                  LaunchpadSubscriptionStatus.partiallyAllocated) ...[
            const SizedBox(height: AppSpacing.x3),
            _ActionRow(
              key: LaunchpadPortfolioPage.refundKey(subscription.id),
              icon: Icons.file_download_outlined,
              label: 'Nhận hoàn ${_formatUsd(subscription.refundAmount)} USDT',
              color: AppColors.primary,
              onTap: HapticFeedback.selectionClick,
            ),
          ],
        ],
      ),
    );
  }
}

class _SubscriptionAvatar extends StatelessWidget {
  const _SubscriptionAvatar({required this.subscription});

  final LaunchpadSubscriptionDraft subscription;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: AppSpacing.launchpadBox44,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: subscription.accent.withValues(alpha: .12),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadii.lgRadius,
            side: BorderSide(color: subscription.accent.withValues(alpha: .35)),
          ),
        ),
        child: Center(
          child: Text(
            subscription.projectLogo,
            style: AppTextStyles.caption.copyWith(
              color: subscription.accent,
              fontWeight: AppTextStyles.bold,
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
      radius: VitCardRadius.sm,
      padding: AppSpacing.launchpadPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _VestingProgress extends StatelessWidget {
  const _VestingProgress({required this.subscription});

  final LaunchpadSubscriptionDraft subscription;

  @override
  Widget build(BuildContext context) {
    final total = _formatInt(subscription.tokensAllocated);
    final claimed = _formatInt(subscription.tokensClaimed);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Vesting',
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
            ),
            Text(
              '$claimed / $total ${subscription.projectSymbol}',
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
          child: SizedBox(
            height: AppSpacing.x2,
            child: Stack(
              fit: StackFit.expand,
              children: [
                const ColoredBox(color: AppColors.surface3),
                FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: (subscription.vestingProgress / 100).clamp(
                    0.0,
                    1.0,
                  ),
                  child: const ColoredBox(color: AppColors.primary),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.x2),
        Row(
          children: [
            Expanded(
              child: Text(
                '${subscription.vestingProgress}% đã mở khóa',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ),
            const Icon(
              Icons.schedule_rounded,
              color: AppColors.text3,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x1),
            Text(
              'Tiếp theo: ${subscription.nextUnlockDate}',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      ],
    );
  }
}

class _InlineNotice extends StatelessWidget {
  const _InlineNotice({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: AppSpacing.iconSm),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              height: AppSpacing.launchpadLineHeightShort,
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.inputRadius,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: color.withValues(alpha: .10),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadii.inputRadius,
            side: BorderSide(color: color.withValues(alpha: .20)),
          ),
        ),
        child: Padding(
          padding: AppSpacing.launchpadPaddingX4,
          child: Row(
            children: [
              Icon(icon, color: color, size: AppSpacing.iconMd),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: color,
                size: AppSpacing.iconMd,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.style});

  final _StatusStyle style;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: style.color.withValues(alpha: .12),
        shape: RoundedRectangleBorder(borderRadius: AppRadii.lgRadius),
      ),
      child: Padding(
        padding: AppSpacing.launchpadInlinePillPadding,
        child: Text(
          style.label,
          style: AppTextStyles.micro.copyWith(
            color: style.color,
            fontWeight: AppTextStyles.bold,
            height: AppSpacing.launchpadLineHeightTight,
          ),
        ),
      ),
    );
  }
}
