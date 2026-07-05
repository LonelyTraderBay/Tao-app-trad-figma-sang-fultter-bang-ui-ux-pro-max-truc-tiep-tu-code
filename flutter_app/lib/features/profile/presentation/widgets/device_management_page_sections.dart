part of '../pages/device_management_page.dart';

class _SecuritySummaryCard extends StatelessWidget {
  const _SecuritySummaryCard({
    required this.totalDevices,
    required this.trustedCount,
    required this.untrustedCount,
    required this.activeCount,
  });

  final int totalDevices;
  final int trustedCount;
  final int untrustedCount;
  final int activeCount;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: DeviceManagementPage.summaryKey,
      density: VitDensity.compact,
      borderColor: AppColors.primary20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              SizedBox(
                width: AppSpacing.profileDevicesSummaryIconBox,
                height: AppSpacing.profileDevicesSummaryIconBox,
                child: Material(
                  color: AppColors.primary15,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadii.lgRadius,
                  ),
                  child: const Icon(
                    Icons.shield_outlined,
                    color: _devicesPrimary,
                    size: AppSpacing.profileDevicesSummaryIcon,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.profileDevicesSummaryGapInline),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'B\u1EA3o m\u1EADt thi\u1EBFt b\u1ECB',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.baseMedium.copyWith(
                        fontWeight: AppTextStyles.heavy,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '$totalDevices thi\u1EBFt b\u1ECB \u0111\u00E3 \u0111\u0103ng nh\u1EADp',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: _SummaryStat(
                  label: 'Tin c\u1EADy',
                  value: '$trustedCount',
                  color: _devicesGreen,
                ),
              ),
              const SizedBox(width: AppSpacing.profileDevicesSummaryStatGap),
              Expanded(
                child: _SummaryStat(
                  label: 'Kh\u00F4ng tin c\u1EADy',
                  value: '$untrustedCount',
                  color: _devicesAmber,
                ),
              ),
              const SizedBox(width: AppSpacing.profileDevicesSummaryStatGap),
              Expanded(
                child: _SummaryStat(
                  label: '\u0110ang ho\u1EA1t \u0111\u1ED9ng',
                  value: '$activeCount',
                  color: _devicesPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryStat extends StatelessWidget {
  const _SummaryStat({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _devicesPanel3.withValues(alpha: .82),
      shape: RoundedRectangleBorder(borderRadius: AppRadii.cardRadius),
      child: Padding(
        padding: const EdgeInsetsDirectional.all(AppSpacing.x2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(color: _devicesMuted),
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(
              value,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: AppTextStyles.heavy,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return VitSectionHeader(
      title: label,
      variant: VitSectionHeaderVariant.accentBar,
      accentColor: _devicesPrimary,
      density: VitDensity.compact,
    );
  }
}

class _OtherDevicesHeader extends StatelessWidget {
  const _OtherDevicesHeader({required this.count, required this.onLogoutAll});

  final int count;
  final VoidCallback? onLogoutAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SectionHeader(
            label: 'C\u00C1C THI\u1EBET B\u1ECA KH\u00C1C ($count)',
          ),
        ),
        VitCtaButton(
          key: DeviceManagementPage.logoutAllKey,
          onPressed: onLogoutAll,
          variant: VitCtaButtonVariant.destructive,
          fullWidth: false,
          height: AppSpacing.buttonCompact,
          child: const Text('\u0110\u0103ng xu\u1EA5t t\u1EA5t c\u1EA3'),
        ),
      ],
    );
  }
}

class _DeviceCard extends StatelessWidget {
  const _DeviceCard({
    required this.device,
    required this.showActions,
    required this.onToggleTrust,
    required this.onLogout,
  });

  final ProfileManagedDevice device;
  final bool showActions;
  final VoidCallback onToggleTrust;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final suspicious = !device.isTrusted && !device.isCurrent;
    final accent = suspicious ? _devicesAmber : _devicesPrimary;

    return VitCard(
      key: DeviceManagementPage.deviceCardKey(device.id),
      density: VitDensity.compact,
      borderColor: suspicious
          ? _devicesAmber.withValues(alpha: .42)
          : _devicesBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: AppSpacing.profileDevicesIconBox,
                height: AppSpacing.profileDevicesIconBox,
                child: Material(
                  color: accent.withValues(alpha: .14),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadii.lgRadius,
                  ),
                  child: Icon(
                    _deviceIcon(device.type),
                    color: accent,
                    size: AppSpacing.profileDevicesIcon,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.profileDevicesIconGap),
              Expanded(
                child: _DeviceDetails(device: device, suspicious: suspicious),
              ),
            ],
          ),
          if (showActions) ...[
            const SizedBox(height: AppSpacing.x3),
            const Divider(
              height: AppSpacing.dividerHairline,
              color: _devicesDivider,
            ),
            const SizedBox(height: AppSpacing.x2),
            Row(
              children: [
                Expanded(
                  child: _TrustButton(device: device, onTap: onToggleTrust),
                ),
                const SizedBox(width: AppSpacing.profileDevicesActionGap),
                _LogoutButton(deviceId: device.id, onTap: onLogout),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _DeviceDetails extends StatelessWidget {
  const _DeviceDetails({required this.device, required this.suspicious});

  final ProfileManagedDevice device;
  final bool suspicious;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                device.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.heavy,
                ),
              ),
            ),
            if (device.isCurrent) ...[
              const SizedBox(width: AppSpacing.profileDevicesNamePillGap),
              const _TinyPill(
                label: 'Hi\u1EC7n t\u1EA1i',
                color: _devicesGreen,
              ),
            ],
            if (suspicious) ...[
              const SizedBox(width: AppSpacing.profileDevicesNamePillGap),
              const Icon(
                Icons.warning_amber_rounded,
                color: _devicesAmber,
                size: AppSpacing.profileDevicesWarningIcon,
              ),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          '${device.browser} \u2022 ${device.os}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.x2),
        Wrap(
          spacing: AppSpacing.profileDevicesMetaSpacing,
          runSpacing: AppSpacing.profileDevicesMetaRunSpacing,
          children: [
            _MetaItem(
              icon: Icons.location_on_outlined,
              value: _locationLabel(device.location),
            ),
            _MetaItem(
              icon: Icons.access_time_rounded,
              value: _lastActiveLabel(device.lastActive),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          'IP: ${device.ip}',
          style: AppTextStyles.micro.copyWith(color: _devicesMuted),
        ),
      ],
    );
  }
}
