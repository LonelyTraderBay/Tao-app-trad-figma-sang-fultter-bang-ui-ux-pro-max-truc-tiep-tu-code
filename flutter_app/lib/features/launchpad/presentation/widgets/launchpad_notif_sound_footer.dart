part of '../pages/launchpad_notif_sound_page.dart';

class _InfoBanner extends StatelessWidget {
  const _InfoBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: LaunchpadNotifSoundPage.infoKey,
      padding: const EdgeInsets.all(AppSpacing.x3),
      decoration: BoxDecoration(
        color: AppColors.primary08,
        border: Border.all(color: AppColors.primary20),
        borderRadius: AppRadii.lgRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppModuleAccents.launchpad,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              'Âm thanh chỉ phát khi ứng dụng đang hoạt động. Thông báo push ngoài app sử dụng cài đặt hệ thống thiết bị.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SaveFooter extends StatelessWidget {
  const _SaveFooter({
    required this.saved,
    required this.hasChanges,
    required this.onSave,
  });

  final bool saved;
  final bool hasChanges;
  final VoidCallback? onSave;

  @override
  Widget build(BuildContext context) {
    return VitStickyFooter(
      key: LaunchpadNotifSoundPage.footerKey,
      backgroundColor: AppColors.surface.withValues(alpha: .94),
      child: Column(
        children: [
          if (saved) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle_outline_rounded,
                  color: AppColors.buy,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: AppSpacing.x2),
                Text(
                  'Đã lưu cài đặt',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.buy,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x3),
          ],
          VitCtaButton(
            key: LaunchpadNotifSoundPage.saveKey,
            onPressed: onSave,
            leading: const Icon(Icons.notifications_none_rounded),
            child: Text(
              saved
                  ? 'Lưu cài đặt âm thanh'
                  : hasChanges
                  ? 'Lưu cài đặt âm thanh'
                  : 'Lưu cài đặt âm thanh',
            ),
          ),
        ],
      ),
    );
  }
}

class _SoundSwitch extends StatelessWidget {
  const _SoundSwitch({
    super.key,
    required this.enabled,
    required this.onTap,
    this.small = false,
  });

  final bool enabled;
  final VoidCallback onTap;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final width = small ? 38.0 : 46.0;
    final height = small ? 22.0 : 26.0;
    final knob = small ? 18.0 : 22.0;
    return Semantics(
      button: true,
      toggled: enabled,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: width,
          height: height,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: enabled ? AppModuleAccents.launchpad : AppColors.surface3,
            borderRadius: AppRadii.inputRadius,
            border: Border.all(
              color: enabled
                  ? AppModuleAccents.launchpad
                  : AppColors.borderSolid,
            ),
          ),
          child: Align(
            alignment: enabled ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: knob,
              height: knob,
              decoration: const BoxDecoration(
                color: AppColors.onAccent,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IconBubble extends StatelessWidget {
  const _IconBubble({
    required this.icon,
    required this.accent,
    this.small = false,
  });

  final IconData icon;
  final Color accent;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final size = small ? AppSpacing.x6 : AppSpacing.x7;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: accent.withValues(alpha: .12),
        borderRadius: small ? AppRadii.mdRadius : AppRadii.lgRadius,
      ),
      child: Icon(
        icon,
        color: accent,
        size: small ? AppSpacing.iconSm : AppSpacing.iconMd,
      ),
    );
  }
}

IconData _categoryIcon(String iconKey) {
  return switch (iconKey) {
    'chart' => Icons.query_stats_rounded,
    'check' => Icons.check_box_rounded,
    'unlock' => Icons.lock_open_rounded,
    'bridge' => Icons.compare_arrows_rounded,
    'gift' => Icons.card_giftcard_rounded,
    'shield' => Icons.shield_outlined,
    'chat' => Icons.chat_bubble_outline_rounded,
    'settings' => Icons.settings_rounded,
    _ => Icons.notifications_none_rounded,
  };
}

String _hourLabel(int hour) {
  return '${hour.toString().padLeft(2, '0')}:00';
}
