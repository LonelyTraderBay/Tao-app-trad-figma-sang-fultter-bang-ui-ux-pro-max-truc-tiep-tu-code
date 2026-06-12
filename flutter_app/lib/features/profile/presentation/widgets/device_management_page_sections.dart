part of '../pages/device_management_page.dart';

class _SecuritySummaryCard extends StatelessWidget {
  const _SecuritySummaryCard({
    required this.totalDevices,
    required this.trustedCount,
    required this.untrustedCount,
    required this.activeCount,
    this.compactBorder = false,
  });

  final int totalDevices;
  final int trustedCount;
  final int untrustedCount;
  final int activeCount;
  final bool compactBorder;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: compactBorder ? null : DeviceManagementPage.summaryKey,
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 16),
      borderColor: compactBorder ? _devicesBorder : AppColors.primary20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary15,
                  borderRadius: AppRadii.lgRadius,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.shield_outlined,
                  color: _devicesPrimary,
                  size: 23,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'B\u1EA3o m\u1EADt thi\u1EBFt b\u1ECB',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.baseMedium.copyWith(
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 7)),
                    Text(
                      '$totalDevices thi\u1EBFt b\u1ECB \u0111\u00E3 \u0111\u0103ng nh\u1EADp',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Padding(padding: EdgeInsets.only(top: 16)),
          Row(
            children: [
              Expanded(
                child: _SummaryStat(
                  label: 'Tin c\u1EADy',
                  value: '$trustedCount',
                  color: _devicesGreen,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SummaryStat(
                  label: 'Kh\u00F4ng tin c\u1EADy',
                  value: '$untrustedCount',
                  color: _devicesAmber,
                ),
              ),
              const SizedBox(width: 12),
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
    return Container(
      height: 58,
      padding: const EdgeInsets.fromLTRB(12, 10, 8, 8),
      decoration: BoxDecoration(
        color: _devicesPanel3.withValues(alpha: .82),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: _devicesMuted,
              height: 1,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyles.micro.copyWith(
        color: AppColors.text2,
        fontWeight: FontWeight.w900,
        height: 1,
      ),
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
        GestureDetector(
          key: DeviceManagementPage.logoutAllKey,
          onTap: onLogoutAll,
          behavior: HitTestBehavior.opaque,
          child: Opacity(
            opacity: onLogoutAll == null ? .45 : 1,
            child: Text(
              '\u0110\u0103ng xu\u1EA5t t\u1EA5t c\u1EA3',
              style: AppTextStyles.micro.copyWith(
                color: _devicesRed,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
            ),
          ),
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
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      borderColor: suspicious
          ? _devicesAmber.withValues(alpha: .42)
          : _devicesBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: .14),
                  borderRadius: AppRadii.lgRadius,
                ),
                alignment: Alignment.center,
                child: Icon(_deviceIcon(device.type), color: accent, size: 21),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _DeviceDetails(device: device, suspicious: suspicious),
              ),
            ],
          ),
          if (showActions) ...[
            const Padding(padding: EdgeInsets.only(top: 14)),
            const Divider(height: 1, color: _devicesDivider),
            const Padding(padding: EdgeInsets.only(top: 13)),
            Row(
              children: [
                Expanded(
                  child: _TrustButton(device: device, onTap: onToggleTrust),
                ),
                const SizedBox(width: 9),
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
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
            ),
            if (device.isCurrent) ...[
              const SizedBox(width: 8),
              const _TinyPill(
                label: 'Hi\u1EC7n t\u1EA1i',
                color: _devicesGreen,
              ),
            ],
            if (suspicious) ...[
              const SizedBox(width: 8),
              const Icon(
                Icons.warning_amber_rounded,
                color: _devicesAmber,
                size: 15,
              ),
            ],
          ],
        ),
        const Padding(padding: EdgeInsets.only(top: 7)),
        Text(
          '${device.browser} \u2022 ${device.os}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontWeight: FontWeight.w700,
            height: 1,
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: 8)),
        Wrap(
          spacing: 11,
          runSpacing: 5,
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
        const Padding(padding: EdgeInsets.only(top: 7)),
        Text(
          'IP: ${device.ip}',
          style: AppTextStyles.micro.copyWith(color: _devicesMuted, height: 1),
        ),
      ],
    );
  }
}
