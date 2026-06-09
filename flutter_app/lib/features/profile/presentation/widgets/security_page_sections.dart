part of '../pages/security_page.dart';

class _ScoreCard extends StatelessWidget {
  const _ScoreCard({required this.snapshot});

  final ProfileSecuritySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final scoreColor = Color(snapshot.scoreColorHex);

    return VitCard(
      key: SecurityPage.scoreCardKey,
      height: 140,
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 16),
      borderColor: _securityBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                '\u0110i\u1EC3m b\u1EA3o m\u1EADt',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontSize: 13,
                  height: 1,
                ),
              ),
              const Spacer(),
              Text(
                '${snapshot.scoreLabel} (${snapshot.score}/4)',
                style: AppTextStyles.caption.copyWith(
                  color: scoreColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 17),
          Row(
            children: [
              for (var i = 0; i < 4; i++) ...[
                Expanded(
                  child: Container(
                    height: 7,
                    decoration: BoxDecoration(
                      color: i < snapshot.score
                          ? scoreColor
                          : AppColors.surface3,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                if (i < 3) const SizedBox(width: 8),
              ],
            ],
          ),
          const SizedBox(height: 13),
          Container(
            height: 53,
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
            decoration: BoxDecoration(
              color: _securityAmber.withValues(alpha: .12),
              borderRadius: AppRadii.cardRadius,
              border: Border.all(color: _securityAmber.withValues(alpha: .28)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: _securityAmber,
                  size: 14,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'B\u1EADt t\u1EA5t c\u1EA3 t\u00EDnh n\u0103ng b\u1EA3o m\u1EADt \u0111\u1EC3 b\u1EA3o v\u1EC7 t\u00E0i s\u1EA3n c\u1EE7a b\u1EA1n\n'
                    't\u1ED1t nh\u1EA5t.',
                    style: AppTextStyles.micro.copyWith(
                      color: _securityAmber,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      height: 1.48,
                    ),
                  ),
                ),
              ],
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
                const Divider(height: 1, color: _securityDivider),
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

    return GestureDetector(
      key: SecurityPage.itemKey(item.id),
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 76,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: .13),
                borderRadius: AppRadii.lgRadius,
              ),
              alignment: Alignment.center,
              child: Icon(_iconFor(item.iconKey), color: accent, size: 21),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: _securityMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      height: 1.12,
                    ),
                  ),
                ],
              ),
            ),
            if (item.status != null) ...[
              const SizedBox(width: 8),
              _StatusPill(label: item.status!, color: Color(item.statusHex!)),
            ],
            const SizedBox(width: 11),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.text3,
              size: 19,
            ),
          ],
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w900,
          height: 1,
        ),
      ),
    );
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
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontSize: 11,
            fontWeight: FontWeight.w900,
            height: 1,
          ),
        ),
        const SizedBox(height: 8),
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
                    const Divider(height: 1, color: _securityDivider),
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
    return Container(
      constraints: const BoxConstraints(minHeight: 73),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.laptop_mac_rounded,
            color: AppColors.text3,
            size: 20,
          ),
          const SizedBox(width: 12),
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
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          height: 1,
                        ),
                      ),
                    ),
                    if (device.isCurrent) ...[
                      const SizedBox(width: 8),
                      _StatusPill(
                        label: 'Hi\u1EC7n t\u1EA1i',
                        color: _securityGreen,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 7),
                Text(
                  '${device.os} \u2022 ${device.location}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: _securityMuted,
                    fontSize: 11,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  device.lastSeen,
                  style: AppTextStyles.micro.copyWith(
                    color: _securityMuted,
                    fontSize: 11,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          if (!device.isCurrent) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: _securityRed.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Text(
                '\u0110\u0103ng xu\u1EA5t',
                style: AppTextStyles.micro.copyWith(
                  color: _securityRed,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
