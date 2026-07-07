part of '../pages/security_page.dart';

class _ScoreCard extends StatelessWidget {
  const _ScoreCard({required this.snapshot});

  final ProfileSecuritySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final scoreColor = Color(snapshot.scoreColorHex);

    return VitCard(
      key: SecurityPage.scoreCardKey,
      density: VitDensity.compact,
      borderColor: _securityBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '\u0110i\u1EC3m b\u1EA3o m\u1EADt',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.control.copyWith(color: AppColors.text2),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Text(
                '${snapshot.scoreLabel} (${snapshot.score}/4)',
                style: AppTextStyles.control.copyWith(
                  color: scoreColor,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              for (var i = 0; i < 4; i++) ...[
                Expanded(
                  child: SizedBox(height: AppSpacing.pageRhythmCompactInnerGap,
                    child: Material(
                      color: i < snapshot.score
                          ? scoreColor
                          : AppColors.surface3,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadii.pillRadius,
                      ),
                    ),
                  ),
                ),
                if (i < 3)
                  const SizedBox(width: AppSpacing.securityScoreBarGap),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Material(
            color: _securityAmber.withValues(alpha: .12),
            shape: RoundedRectangleBorder(
              borderRadius: AppRadii.cardRadius,
              side: BorderSide(color: _securityAmber.withValues(alpha: .28)),
            ),
            child: Padding(
              padding: AppSpacing.securityScoreAlertPadding,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: _securityAmber,
                    size: AppSpacing.securitySmallIcon,
                  ),
                  const SizedBox(width: AppSpacing.securityIconGap),
                  Expanded(
                    child: Text(
                      'B\u1EADt t\u1EA5t c\u1EA3 t\u00EDnh n\u0103ng b\u1EA3o m\u1EADt \u0111\u1EC3 b\u1EA3o v\u1EC7 t\u00E0i s\u1EA3n c\u1EE7a b\u1EA1n\n'
                      't\u1ED1t nh\u1EA5t.',
                      style: AppTextStyles.numericMicro.copyWith(
                        color: _securityAmber,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SecurityList extends StatelessWidget {
  const _SecurityList({required this.items, required this.onItemTap});

  final List<ProfileSecurityItem> items;
  final ValueChanged<ProfileSecurityItem> onItemTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: _securityBorder,
      clip: true,
      child: ClipRRect(
        borderRadius: AppRadii.cardRadius,
        child: Column(
          children: [
            for (final item in items) ...[
              _SecurityRow(item: item, onTap: () => onItemTap(item)),
              if (item != items.last)
                const Divider(
                  height: AppSpacing.dividerHairline,
                  color: _securityDivider,
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SecurityRow extends StatelessWidget {
  const _SecurityRow({required this.item, required this.onTap});

  final ProfileSecurityItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = item.danger ? _securityRed : _securityPrimary;

    return VitCard(
      key: SecurityPage.itemKey(item.id),
      onTap: onTap,
      variant: VitCardVariant.ghost,
      borderColor: AppColors.transparent,
      padding: EdgeInsets.zero,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: VitDensity.compact.controlHeight + AppSpacing.x5,
        ),
        child: Padding(
          padding: AppSpacing.securityRowPadding,
          child: Row(
            children: [
              SizedBox(
                width: AppSpacing.securityRowIconBox,
                height: AppSpacing.securityRowIconBox,
                child: Material(
                  color: accent.withValues(alpha: .13),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadii.lgRadius,
                  ),
                  child: Icon(
                    _iconFor(item.iconKey),
                    color: accent,
                    size: AppSpacing.securityRowIcon,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.securityRowGap),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.control.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      item.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.numericMicro.copyWith(
                        color: _securityMuted,
                        fontWeight: AppTextStyles.medium,
                      ),
                    ),
                  ],
                ),
              ),
              if (item.status != null) ...[
                const SizedBox(width: AppSpacing.securityStatusGap),
                _StatusPill(label: item.status!, color: Color(item.statusHex!)),
              ],
              const SizedBox(width: AppSpacing.securityChevronGap),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.text3,
                size: AppSpacing.securityChevron,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitAccentPill(label: label, accentColor: color);
  }
}

class _DeviceList extends StatelessWidget {
  const _DeviceList({required this.devices});

  final List<ProfileDevice> devices;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'THI\u1EBET B\u1ECA \u0110\u0102NG NH\u1EACP',
          style: AppTextStyles.badge.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        VitCard(
          borderColor: _securityBorder,
          clip: true,
          child: ClipRRect(
            borderRadius: AppRadii.cardRadius,
            child: Column(
              children: [
                for (final device in devices) ...[
                  _DeviceRow(device: device),
                  if (device != devices.last)
                    const Divider(
                      height: AppSpacing.dividerHairline,
                      color: _securityDivider,
                    ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DeviceRow extends StatelessWidget {
  const _DeviceRow({required this.device});

  final ProfileDevice device;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: AppSpacing.securityDeviceMinHeight,
      ),
      child: Padding(
        padding: AppSpacing.securityDevicePadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.laptop_mac_rounded,
              color: AppColors.text3,
              size: AppSpacing.securityDeviceIcon,
            ),
            const SizedBox(width: AppSpacing.securityDeviceGap),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          device.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.control.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                      if (device.isCurrent) ...[
                        const SizedBox(width: AppSpacing.securityStatusGap),
                        _StatusPill(
                          label: 'Hi\u1EC7n t\u1EA1i',
                          color: _securityGreen,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                  Text(
                    '${device.os} \u2022 ${device.location}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.numericMicro.copyWith(
                      color: _securityMuted,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    device.lastSeen,
                    style: AppTextStyles.numericMicro.copyWith(
                      color: _securityMuted,
                    ),
                  ),
                ],
              ),
            ),
            if (!device.isCurrent) ...[
              const SizedBox(width: AppSpacing.securityStatusGap),
              const _StatusPill(
                label: '\u0110\u0103ng xu\u1EA5t',
                color: _securityRed,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
