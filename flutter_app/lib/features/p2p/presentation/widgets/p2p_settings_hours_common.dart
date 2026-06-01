part of '../pages/p2p_settings_page.dart';

class _HoursSection extends StatelessWidget {
  const _HoursSection({required this.mode, required this.onChanged});

  final String mode;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PSettingsPage.hoursKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel(
          icon: Icons.schedule_rounded,
          label: 'Giờ giao dịch',
          color: AppColors.buy,
        ),
        const SizedBox(height: AppSpacing.x3),
        VitCard(
          radius: VitCardRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.x1),
                decoration: BoxDecoration(
                  color: AppColors.surface2,
                  borderRadius: AppRadii.inputRadius,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _SegmentButton(
                        label: '24/7',
                        selected: mode == '247',
                        onTap: () => onChanged('247'),
                      ),
                    ),
                    Expanded(
                      child: _SegmentButton(
                        label: 'Tùy chỉnh',
                        selected: mode == 'custom',
                        onTap: () => onChanged('custom'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.x3),
              Text(
                mode == '247'
                    ? 'Quảng cáo của bạn hiển thị mọi lúc.'
                    : 'Quảng cáo chỉ hiển thị từ 08:00 đến 22:00 (GMT+7).',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AutoReplySection extends StatelessWidget {
  const _AutoReplySection({
    required this.autoReply,
    required this.enabled,
    required this.onToggle,
  });

  final P2PSettingsAutoReplyDraft autoReply;
  final bool enabled;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PSettingsPage.autoReplyKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel(
          icon: Icons.chat_bubble_outline_rounded,
          label: 'Tin nhắn tự động',
          color: AppColors.primary,
        ),
        const SizedBox(height: AppSpacing.x3),
        VitCard(
          radius: VitCardRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SettingToggleRow(
                toggle: const P2PSettingsToggleDraft(
                  id: 'auto_reply',
                  label: 'Tự động gửi tin nhắn',
                  description: 'Gửi ngay khi đối tác tạo đơn',
                  iconKey: 'message',
                  toneKey: 'primary',
                  enabled: true,
                ),
                value: enabled,
                onToggle: onToggle,
                last: true,
              ),
              if (enabled) ...[
                const SizedBox(height: AppSpacing.x3),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Mẫu tin nhắn MUA',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text2,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    Text(
                      'Sửa',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.primary,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x2),
                VitCard(
                  variant: VitCardVariant.inner,
                  padding: const EdgeInsets.all(AppSpacing.x3),
                  child: Text(
                    autoReply.buyTemplate,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({
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
        Text(
          label,
          style: AppTextStyles.caption.copyWith(fontWeight: AppTextStyles.bold),
        ),
      ],
    );
  }
}

class _SettingIcon extends StatelessWidget {
  const _SettingIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.buttonCompact,
      height: AppSpacing.buttonCompact,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .10),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Icon(icon, color: color, size: AppSpacing.iconSm),
    );
  }
}

class _SwitchButton extends StatelessWidget {
  const _SwitchButton({
    super.key,
    required this.value,
    required this.color,
    required this.onTap,
  });

  final bool value;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 44,
        height: 24,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: value ? color : AppColors.surface2,
          border: Border.all(color: value ? color : AppColors.borderSolid),
          borderRadius: AppRadii.mdRadius,
        ),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: const DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.onAccent,
            shape: BoxShape.circle,
          ),
          child: SizedBox(width: 18, height: 18),
        ),
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary12 : AppColors.transparent,
      borderRadius: AppRadii.inputRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.x3),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(
              color: selected ? AppColors.primary : AppColors.text3,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}

IconData _settingsIcon(String iconKey) {
  return switch (iconKey) {
    'bell' => Icons.notifications_none_rounded,
    'message' => Icons.chat_bubble_outline_rounded,
    'alert' => Icons.report_problem_outlined,
    'globe' => Icons.public_rounded,
    'volume' => Icons.volume_up_outlined,
    'eye' => Icons.visibility_outlined,
    'shield' => Icons.shield_outlined,
    'wallet' => Icons.account_balance_wallet_outlined,
    'clock' => Icons.schedule_rounded,
    'lock' => Icons.lock_outline_rounded,
    'fingerprint' => Icons.fingerprint_rounded,
    _ => Icons.tune_rounded,
  };
}

Color _toneColor(String toneKey) {
  return switch (toneKey) {
    'success' => AppColors.buy,
    'danger' => AppColors.sell,
    'accent' => AppColors.accent,
    'warning' => AppColors.warn,
    _ => AppColors.primary,
  };
}
