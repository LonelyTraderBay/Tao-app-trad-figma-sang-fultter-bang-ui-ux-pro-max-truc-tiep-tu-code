part of '../pages/copy_notifications_page.dart';

class _UnreadSummary extends StatelessWidget {
  const _UnreadSummary({
    required this.unreadCount,
    required this.onMarkAllRead,
  });

  final int unreadCount;
  final VoidCallback onMarkAllRead;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      height: AppSpacing.tradeBotSheetActionHeight,
      padding: AppSpacing.tradeBotChipPadding,
      borderColor: _notificationPrimary,
      child: Row(
        children: [
          const Icon(
            Icons.notifications_none_rounded,
            color: _notificationPrimary,
            size: AppSpacing.inputPrefixIcon,
          ),
          const SizedBox(width: AppSpacing.statusPillHorizontalPaddingMd),
          Expanded(
            child: Text(
              '$unreadCount thông báo chưa đọc',
              style: AppTextStyles.caption.copyWith(
                color: _notificationPrimary,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          VitCtaButton(
            key: CopyNotificationsPage.markAllReadKey,
            onPressed: onMarkAllRead,
            variant: VitCtaButtonVariant.ghost,
            height: AppSpacing.buttonCompact,
            fullWidth: false,
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: AppSpacing.x2,
            ),
            child: Text(
              'Đánh dấu tất cả đã đọc',
              style: AppTextStyles.caption.copyWith(
                color: _notificationPrimary,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterTabs extends StatelessWidget {
  const _FilterTabs({
    required this.tabs,
    required this.activeTab,
    required this.onChanged,
  });

  final List<TradeCopyNotificationTab> tabs;
  final String activeTab;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.buttonStandard,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        separatorBuilder: (_, _) =>
            const SizedBox(width: AppSpacing.statusPillHorizontalPaddingMd),
        itemBuilder: (context, index) {
          final tab = tabs[index];
          final active = tab.id == activeTab;
          return _FilterPill(
            key: CopyNotificationsPage.tabKey(tab.id),
            tab: tab,
            active: active,
            onTap: () => onChanged(tab.id),
          );
        },
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({
    super.key,
    required this.tab,
    required this.active,
    required this.onTap,
  });

  final TradeCopyNotificationTab tab;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.large,
      width: AppSpacing.buttonStandard - AppSpacing.hairlineStroke,
      height: AppSpacing.buttonStandard - AppSpacing.hairlineStroke,
      alignment: Alignment.center,
      padding: AppSpacing.zeroInsets,
      borderColor: active ? _notificationPrimary : AppColors.transparent,
      background: ColoredBox(
        color: active
            ? _notificationPrimary.withValues(alpha: .16)
            : _notificationChip,
      ),
      onTap: onTap,
      child: Text(
        _tabLabel(tab.label),
        textAlign: TextAlign.center,
        style: AppTextStyles.caption.copyWith(
          color: active ? _notificationPrimary : _notificationMuted,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }

  String _tabLabel(String label) {
    return switch (label) {
      'Tất cả' => 'Tất\ncả',
      'Chưa đọc' => 'Chưa\nđọc',
      'Cập nhật' => 'Cập\nnhật',
      'Hệ thống' => 'Hệ\nthống',
      _ => label,
    };
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
  });

  final TradeCopyNotification notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _notificationColor(notification);
    final read = notification.read;
    return VitCard(
      variant: read ? VitCardVariant.standard : VitCardVariant.inner,
      padding: AppSpacing.cardPaddingCompact,
      borderColor: read ? AppColors.cardBorder : color,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipOval(
            child: ColoredBox(
              color: color.withValues(alpha: .18),
              child: SizedBox.square(
                dimension: AppSpacing.walletAddressIconSize,
                child: Icon(
                  _notificationIcon(notification),
                  color: color,
                  size: AppSpacing.homeNextActionIconSize,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Opacity(
              opacity: read ? .7 : 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: AppTextStyles.baseMedium.copyWith(
                            fontWeight: read
                                ? AppTextStyles.bold
                                : AppTextStyles.extraBold,
                          ),
                        ),
                      ),
                      if (!read) ...[
                        const SizedBox(width: AppSpacing.x2),
                        const ClipOval(
                          child: ColoredBox(
                            color: _notificationPrimary,
                            child: SizedBox.square(dimension: AppSpacing.x2),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  Text(
                    notification.message,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      fontWeight: AppTextStyles.normal,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  Wrap(
                    spacing: AppSpacing.statusPillHorizontalPaddingMd,
                    runSpacing: AppSpacing.statusPillGapMd,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _MetaItem(
                        icon: Icons.access_time_rounded,
                        label: notification.timestamp,
                      ),
                      if (notification.providerName != null)
                        _MetaItem(
                          icon: Icons.group_outlined,
                          label: notification.providerName!,
                        ),
                      if (notification.pnl != null)
                        Text(
                          _formatPnl(notification.pnl!),
                          style: AppTextStyles.caption.copyWith(
                            color: notification.pnl! >= 0
                                ? AppColors.buy
                                : AppColors.sell,
                            fontWeight: AppTextStyles.extraBold,
                          ),
                        ),
                    ],
                  ),
                  if (notification.pair != null) ...[
                    const SizedBox(height: AppSpacing.x2),
                    _PairChip(notification: notification, color: color),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  const _MetaItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: AppColors.text3,
          size: AppSpacing.statusPillIconSizeMd,
        ),
        const SizedBox(width: AppSpacing.statusPillGapMd),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _PairChip extends StatelessWidget {
  const _PairChip({required this.notification, required this.color});

  final TradeCopyNotification notification;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final side = notification.side == TradeOrderSide.sell ? 'SELL' : 'BUY';
    return VitAccentPill(
      label: '$side ${notification.pair}',
      accentColor: color,
      size: VitStatusPillSize.md,
    );
  }
}
