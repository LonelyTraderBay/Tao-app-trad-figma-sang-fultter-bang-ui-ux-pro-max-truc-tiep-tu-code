part of '../pages/device_management_page.dart';

class _MetaItem extends StatelessWidget {
  const _MetaItem({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: _devicesMuted, size: 12),
        const SizedBox(width: 4),
        Text(
          value,
          style: AppTextStyles.micro.copyWith(color: _devicesMuted, height: 1),
        ),
      ],
    );
  }
}

class _TrustButton extends StatelessWidget {
  const _TrustButton({required this.device, required this.onTap});

  final ProfileManagedDevice device;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final trusted = device.isTrusted;
    final color = trusted ? _devicesGreen : _devicesAmber;

    return GestureDetector(
      key: DeviceManagementPage.trustKey(device.id),
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: AppSpacing.buttonCompact,
        decoration: BoxDecoration(
          color: color.withValues(alpha: .12),
          borderRadius: AppRadii.cardRadius,
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              trusted ? Icons.shield_outlined : Icons.warning_amber_rounded,
              color: color,
              size: 14,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                trusted
                    ? 'Tin c\u1EADy'
                    : '\u0110\u00E1nh d\u1EA5u tin c\u1EADy',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(
                  color: color,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({required this.deviceId, required this.onTap});

  final String deviceId;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: DeviceManagementPage.logoutKey(deviceId),
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: AppSpacing.buttonCompact,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: AppColors.sell10,
          borderRadius: AppRadii.cardRadius,
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.delete_outline_rounded,
              color: _devicesRed,
              size: 15,
            ),
            const SizedBox(width: 6),
            Text(
              '\u0110\u0103ng xu\u1EA5t',
              style: AppTextStyles.micro.copyWith(
                color: _devicesRed,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TinyPill extends StatelessWidget {
  const _TinyPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: FontWeight.w900,
          height: 1,
        ),
      ),
    );
  }
}

IconData _deviceIcon(String type) {
  return switch (type) {
    'mobile' => Icons.phone_iphone_rounded,
    'tablet' => Icons.tablet_mac_rounded,
    _ => Icons.desktop_windows_outlined,
  };
}

String _locationLabel(String value) {
  return switch (value) {
    'Ho Chi Minh, VN' => 'H\u1ED3 Ch\u00ED Minh, VN',
    'Ha Noi, VN' => 'H\u00E0 N\u1ED9i, VN',
    _ => value,
  };
}

String _lastActiveLabel(String value) {
  return switch (value) {
    'Dang hoat dong' => '\u0110ang ho\u1EA1t \u0111\u1ED9ng',
    '2 gio truoc' => '2 gi\u1EDD tr\u01B0\u1EDBc',
    '3 ngay truoc' => '3 ng\u00E0y tr\u01B0\u1EDBc',
    '5 ngay truoc' => '5 ng\u00E0y tr\u01B0\u1EDBc',
    _ => value,
  };
}
