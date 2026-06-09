part of '../pages/network_status_page.dart';

class _NetworkCard extends StatelessWidget {
  const _NetworkCard({required this.network});

  final WalletNetworkInfo network;

  @override
  Widget build(BuildContext context) {
    final tokenColor = Color(network.colorHex);
    final healthColor = _healthColor(network.health);
    final congestionColor = _congestionColor(network.congestionPct);
    return VitCard(
      key: NetworkStatusPage.networkKey(network.id),
      padding: const EdgeInsets.all(16),
      borderColor: _networkBorder,
      child: Column(
        children: [
          Row(
            children: [
              _TokenLogo(symbol: network.symbol, color: tokenColor),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            network.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              height: 1,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _HealthPill(
                          label: _healthLabel(network.health),
                          color: healthColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Block #${_formatInt(network.blockHeight)}',
                      style: AppTextStyles.micro.copyWith(
                        color: _networkMuted,
                        fontSize: 10,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: healthColor.withValues(alpha: .08),
                  borderRadius: AppRadii.cardRadius,
                ),
                alignment: Alignment.center,
                child: Icon(
                  _healthIcon(network.health),
                  color: healthColor,
                  size: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  'M\u1EE9c t\u1EA3i m\u1EA1ng',
                  style: AppTextStyles.micro.copyWith(
                    color: _networkMuted,
                    fontSize: 10,
                    height: 1,
                  ),
                ),
              ),
              Text(
                '${network.congestionPct}%',
                style: AppTextStyles.micro.copyWith(
                  color: congestionColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          _CongestionBar(
            percent: network.congestionPct,
            color: congestionColor,
          ),
          const SizedBox(height: 12),
          _StatsGrid(network: network),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _AvailabilityChip(
                  label: 'N\u1EA1p',
                  enabled: network.depositEnabled,
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: _AvailabilityChip(
                  label: 'R\u00FAt',
                  enabled: network.withdrawEnabled,
                ),
              ),
            ],
          ),
          if (network.notes != null) ...[
            const SizedBox(height: 12),
            _NetworkNote(note: network.notes!),
          ],
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.network});

  final WalletNetworkInfo network;

  @override
  Widget build(BuildContext context) {
    final stats = [
      (
        icon: Icons.schedule_rounded,
        label: 'X\u00E1c nh\u1EADn',
        value: network.avgConfirmTime,
      ),
      (
        icon: Icons.monitor_heart_outlined,
        label: 'TX \u0111ang ch\u1EDD',
        value: _formatInt(network.txPending),
      ),
      (
        icon: Icons.bolt_rounded,
        label: 'Gas / Ph\u00ED',
        value: network.gasFee,
      ),
      (
        icon: Icons.trending_up_rounded,
        label: 'Block m\u1EDBi',
        value: network.lastBlock,
      ),
    ];

    return Column(
      children: [
        for (var row = 0; row < 2; row++) ...[
          Row(
            children: [
              for (var col = 0; col < 2; col++) ...[
                Expanded(child: _StatTile(stat: stats[row * 2 + col])),
                if (col == 0) const SizedBox(width: 9),
              ],
            ],
          ),
          if (row == 0) const SizedBox(height: 9),
        ],
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.stat});

  final ({IconData icon, String label, String value}) stat;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderColor: AppColors.divider,
      child: Row(
        children: [
          Icon(stat.icon, color: _networkMuted, size: 13),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stat.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: _networkMuted,
                    fontSize: 9,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  stat.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text1,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    height: 1,
                    fontFeatures: AppTextStyles.tabularFigures,
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

class _CongestionBar extends StatelessWidget {
  const _CongestionBar({required this.percent, required this.color});

  final int percent;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: LinearProgressIndicator(
        minHeight: 5,
        value: (percent / 100).clamp(0, 1).toDouble(),
        color: color.withValues(alpha: .55),
        backgroundColor: color.withValues(alpha: .08),
      ),
    );
  }
}

class _AvailabilityChip extends StatelessWidget {
  const _AvailabilityChip({required this.label, required this.enabled});

  final String label;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final color = enabled ? _networkGreen : _networkRed;
    return Container(
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .05),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            enabled ? Icons.check_circle_outline : Icons.wifi_off_rounded,
            color: color,
            size: 12,
          ),
          const SizedBox(width: 6),
          Text(
            '$label ${enabled ? 'OK' : 'T\u1EA1m d\u1EEBng'}',
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _NetworkNote extends StatelessWidget {
  const _NetworkNote({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: _networkAmber.withValues(alpha: .06),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: _networkAmber,
            size: 13,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              note,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                fontSize: 10,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
