part of '../pages/network_status_page.dart';

class _LegendCard extends StatelessWidget {
  const _LegendCard();

  @override
  Widget build(BuildContext context) {
    final rows = [
      ('operational', 'Ho\u1EA1t \u0111\u1ED9ng t\u1ED1t'),
      ('degraded', 'Ch\u1EADm'),
      ('congested', 'T\u1EAFc ngh\u1EBDn'),
      ('down', 'B\u1EA3o tr\u00EC'),
    ];
    return VitCard(
      padding: AppSpacing.cardPadding,
      borderColor: _networkBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ch\u00FA th\u00EDch tr\u1EA1ng th\u00E1i',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.rowGapRegular),
          Row(
            children: [
              for (var col = 0; col < 2; col++) ...[
                Expanded(
                  child: Column(
                    children: [
                      for (var row = 0; row < 2; row++) ...[
                        _LegendItem(
                          health: rows[col + row * 2].$1,
                          label: rows[col + row * 2].$2,
                        ),
                        if (row == 0)
                          const SizedBox(height: AppSpacing.rowGapRegular),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.health, required this.label});

  final String health;
  final String label;

  @override
  Widget build(BuildContext context) {
    final color = _healthColor(health);
    return Row(
      children: [
        Container(
          width: AppSpacing.walletNetworkLegendIcon,
          height: AppSpacing.walletNetworkLegendIcon,
          decoration: BoxDecoration(
            color: color.withValues(alpha: .08),
            borderRadius: AppRadii.mdRadius,
          ),
          alignment: Alignment.center,
          child: Icon(
            _healthIcon(health),
            color: color,
            size: AppSpacing.walletNetworkLegendIconGlyph,
          ),
        ),
        const SizedBox(width: AppSpacing.walletTokenApprovalHeaderGap),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
        ),
      ],
    );
  }
}

class _DisclaimerCard extends StatelessWidget {
  const _DisclaimerCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.walletNetworkDisclaimerPadding,
      borderColor: _networkPrimary.withValues(alpha: .25),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: _networkPrimary,
            size: AppSpacing.walletTokenNoticeIcon,
          ),
          const SizedBox(width: AppSpacing.walletTokenApprovalHeaderGap),
          Expanded(
            child: Text(
              'D\u1EEF li\u1EC7u tr\u1EA1ng th\u00E1i m\u1EA1ng \u0111\u01B0\u1EE3c c\u1EADp nh\u1EADt t\u1EF1 \u0111\u1ED9ng. Th\u1EDDi gian x\u00E1c nh\u1EADn th\u1EF1c t\u1EBF c\u00F3 th\u1EC3 kh\u00E1c t\u00F9y thu\u1ED9c v\u00E0o ph\u00ED gas v\u00E0 m\u1EE9c t\u1EA3i m\u1EA1ng t\u1EA1i th\u1EDDi \u0111i\u1EC3m giao d\u1ECBch.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TokenLogo extends StatelessWidget {
  const _TokenLogo({required this.symbol, required this.color});

  final String symbol;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.walletAddressIconSize,
      height: AppSpacing.walletAddressIconSize,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .1),
        borderRadius: AppRadii.cardRadius,
      ),
      alignment: Alignment.center,
      child: Text(
        symbol,
        maxLines: 1,
        overflow: TextOverflow.clip,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _HealthPill extends StatelessWidget {
  const _HealthPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.walletNetworkHealthPillPadding,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(
          AppSpacing.walletNetworkHealthPillRadius,
        ),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

String _healthLabel(String health) {
  return switch (health) {
    'operational' => 'Ho\u1EA1t \u0111\u1ED9ng t\u1ED1t',
    'degraded' => 'Ch\u1EADm',
    'congested' => 'T\u1EAFc ngh\u1EBDn',
    'down' => 'B\u1EA3o tr\u00EC',
    _ => health,
  };
}

Color _healthColor(String health) {
  return switch (health) {
    'operational' => _networkGreen,
    'degraded' => _networkAmber,
    'congested' => _networkOrange,
    'down' => _networkRed,
    _ => _networkMuted,
  };
}

IconData _healthIcon(String health) {
  return switch (health) {
    'operational' => Icons.check_circle_outline_rounded,
    'degraded' => Icons.access_time_rounded,
    'congested' => Icons.warning_amber_rounded,
    'down' => Icons.wifi_off_rounded,
    _ => Icons.info_outline_rounded,
  };
}

Color _congestionColor(int pct) {
  if (pct > 70) return _networkOrange;
  if (pct > 40) return _networkAmber;
  return _networkGreen;
}

String _formatInt(int value) {
  final raw = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    if (i > 0 && (raw.length - i) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(raw[i]);
  }
  return buffer.toString();
}
