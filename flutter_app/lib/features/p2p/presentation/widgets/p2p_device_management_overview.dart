part of '../pages/p2p_device_management_page.dart';

class _DeviceStatsCard extends StatelessWidget {
  const _DeviceStatsCard({
    required this.total,
    required this.trusted,
    required this.untrusted,
  });

  final int total;
  final int trusted;
  final int untrusted;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PDeviceManagementPage.statsKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          Expanded(
            child: _DeviceStat(
              icon: Icons.desktop_windows_rounded,
              value: '$total',
              label: 'Tổng số',
              color: AppModuleAccents.p2p,
            ),
          ),
          Expanded(
            child: _DeviceStat(
              icon: Icons.shield_outlined,
              value: '$trusted',
              label: 'Tin cậy',
              color: AppColors.buy,
            ),
          ),
          Expanded(
            child: _DeviceStat(
              icon: Icons.warning_amber_rounded,
              value: '$untrusted',
              label: 'Chưa tin cậy',
              color: AppColors.warn,
            ),
          ),
        ],
      ),
    );
  }
}

class _DeviceStat extends StatelessWidget {
  const _DeviceStat({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: AppSpacing.inputHeight,
          height: AppSpacing.inputHeight,
          decoration: BoxDecoration(
            color: color.withValues(alpha: .12),
            borderRadius: AppRadii.lgRadius,
          ),
          child: Icon(icon, color: color, size: AppSpacing.iconMd),
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(value, style: AppTextStyles.amountSm.copyWith(color: color)),
        const SizedBox(height: AppSpacing.x1),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _TrustedDeviceNotice extends StatelessWidget {
  const _TrustedDeviceNotice({required this.snapshot});

  final P2PDeviceManagementSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      key: P2PDeviceManagementPage.infoKey,
      decoration: BoxDecoration(
        color: AppColors.primary08,
        borderRadius: AppRadii.lgRadius,
        border: Border.all(color: AppColors.primary20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.info_outline_rounded,
              color: AppModuleAccents.p2p,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.infoTitle,
                    style: AppTextStyles.caption.copyWith(
                      color: AppModuleAccents.p2p,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    snapshot.infoBody,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text2,
                      height: 1.5,
                    ),
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
