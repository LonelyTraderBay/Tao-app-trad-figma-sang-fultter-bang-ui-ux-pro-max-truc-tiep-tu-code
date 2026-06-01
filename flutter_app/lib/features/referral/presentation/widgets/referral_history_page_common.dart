part of '../pages/referral_history_page.dart';

class _FriendCard extends StatelessWidget {
  const _FriendCard({
    required this.friend,
    required this.reminded,
    required this.onOpen,
    required this.onRemind,
  });

  final ReferralFriendDraft friend;
  final bool reminded;
  final VoidCallback onOpen;
  final VoidCallback onRemind;

  @override
  Widget build(BuildContext context) {
    final palette = _statusPalette(friend.status);
    return VitCard(
      key: ReferralHistoryPage.friendKey(friend.id),
      onTap: onOpen,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Avatar(initial: friend.initial),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            friend.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.x3),
                        _StatusPill(
                          label: palette.label,
                          color: palette.color,
                          background: palette.background,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      'Tham gia: ${friend.joinedDate}',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    friend.totalCommission > 0
                        ? '+${_formatUsd(friend.totalCommission)}'
                        : '—',
                    style: AppTextStyles.body.copyWith(
                      color: friend.totalCommission > 0
                          ? AppColors.buy
                          : AppColors.text3,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  Text(
                    'Hoa hồng',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: _FriendMetric(
                  label: 'KYC',
                  value: friend.kycCompleted ? 'Hoàn tất' : 'Đang chờ',
                  icon: friend.kycCompleted
                      ? Icons.check_circle_rounded
                      : Icons.schedule_rounded,
                  color: friend.kycCompleted ? AppColors.buy : AppColors.warn,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _FriendMetric(
                  label: 'Khối lượng GD',
                  value: friend.totalVolume > 0
                      ? _formatUsd(friend.totalVolume)
                      : '—',
                  color: AppColors.text1,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _FriendMetric(
                  label: 'GD đầu tiên',
                  value: friend.firstTradeDate ?? '—',
                  color: AppColors.text1,
                ),
              ),
            ],
          ),
          if (friend.canRemindKyc) ...[
            const SizedBox(height: AppSpacing.x3),
            InkWell(
              key: ReferralHistoryPage.remindKey(friend.id),
              onTap: onRemind,
              borderRadius: AppRadii.mdRadius,
              child: Container(
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primary08,
                  border: Border.all(color: AppColors.primary20),
                  borderRadius: AppRadii.mdRadius,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      reminded ? Icons.check_rounded : Icons.send_rounded,
                      color: AppColors.primary,
                      size: 15,
                    ),
                    const SizedBox(width: AppSpacing.x3),
                    Text(
                      reminded ? 'Đã nhắc KYC' : 'Nhắc hoàn tất KYC',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.initial});

  final String initial;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.surface2,
        border: Border.all(color: AppColors.borderSolid),
        borderRadius: AppRadii.lgRadius,
      ),
      child: Text(
        initial,
        style: AppTextStyles.baseMedium.copyWith(color: AppColors.text2),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.label,
    required this.color,
    required this.background,
  });

  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadii.lgRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _FriendMetric extends StatelessWidget {
  const _FriendMetric({
    required this.label,
    required this.value,
    required this.color,
    this.icon,
  });

  final String label;
  final String value;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.x3),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.mdRadius,
      ),
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
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: color, size: 13),
                const SizedBox(width: AppSpacing.x1),
              ],
              Flexible(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

final class _ReferralStatusPalette {
  const _ReferralStatusPalette({
    required this.label,
    required this.color,
    required this.background,
  });

  final String label;
  final Color color;
  final Color background;
}

_ReferralStatusPalette _statusPalette(ReferralFriendStatus status) {
  return switch (status) {
    ReferralFriendStatus.pendingKyc => const _ReferralStatusPalette(
      label: 'Chờ KYC',
      color: AppColors.warn,
      background: AppColors.warn10,
    ),
    ReferralFriendStatus.kycDone => const _ReferralStatusPalette(
      label: 'Đã KYC',
      color: AppColors.primary,
      background: AppColors.primary12,
    ),
    ReferralFriendStatus.activeTrader => const _ReferralStatusPalette(
      label: 'Đang giao dịch',
      color: AppColors.buy,
      background: AppColors.buy10,
    ),
    ReferralFriendStatus.inactive => const _ReferralStatusPalette(
      label: 'Không hoạt động',
      color: AppColors.text3,
      background: AppColors.surface2,
    ),
  };
}

String _formatUsd(double value) {
  final fixed = value.toStringAsFixed(2);
  final parts = fixed.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final fromEnd = whole.length - i;
    buffer.write(whole[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
  }
  return '\$${buffer.toString()}.${parts.last}';
}
