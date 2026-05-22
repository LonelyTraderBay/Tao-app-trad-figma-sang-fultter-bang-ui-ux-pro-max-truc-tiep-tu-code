import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../data/wallet_repository.dart';

const _networkBg = Color(0xFF080C14);
const _networkSurface = Color(0xFF151A23);
const _networkSurface2 = Color(0xFF1D2436);
const _networkBorder = Color(0x14FFFFFF);
const _networkBlue = Color(0xFF3B82F6);
const _networkGreen = Color(0xFF10B981);
const _networkAmber = Color(0xFFF59E0B);
const _networkOrange = Color(0xFFF97316);
const _networkRed = Color(0xFFEF4444);
const _networkMuted = Color(0xFF667085);

class NetworkStatusPage extends ConsumerWidget {
  const NetworkStatusPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc155_network_status_content');
  static const refreshKey = Key('sc155_network_status_refresh');
  static Key networkKey(String id) => Key('sc155_network_status_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(walletRepositoryProvider).getNetworkStatus();
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 92
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-155 NetworkStatusPage',
      child: Material(
        color: _networkBg,
        child: Column(
          children: [
            VitHeader(
              title: 'Tr\u1EA1ng th\u00E1i m\u1EA1ng',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.wallet),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: NetworkStatusPage.contentKey,
                padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _SummaryCard(snapshot: snapshot),
                    const SizedBox(height: 18),
                    for (final network in snapshot.networks) ...[
                      _NetworkCard(network: network),
                      if (network != snapshot.networks.last)
                        const SizedBox(height: 14),
                    ],
                    const SizedBox(height: 18),
                    const _LegendCard(),
                    const SizedBox(height: 18),
                    const _DisclaimerCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.snapshot});

  final WalletNetworkStatusSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final summaryColor = snapshot.downCount > 0
        ? _networkRed
        : snapshot.issueCount > 0
        ? _networkAmber
        : _networkGreen;
    final summaryMessage = snapshot.downCount > 0
        ? '${snapshot.downCount} m\u1EA1ng \u0111ang b\u1EA3o tr\u00EC'
        : snapshot.issueCount > 0
        ? '${snapshot.issueCount} m\u1EA1ng \u0111ang ch\u1EADm'
        : 'T\u1EA5t c\u1EA3 m\u1EA1ng ho\u1EA1t \u0111\u1ED9ng t\u1ED1t';

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 21, 20, 20),
      decoration: BoxDecoration(
        color: _networkSurface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: .3)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: .05),
            summaryColor.withValues(alpha: .04),
            _networkSurface2,
          ],
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: summaryColor.withValues(alpha: .08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: summaryColor.withValues(alpha: .42),
                  ),
                ),
                alignment: Alignment.center,
                child: Icon(
                  snapshot.downCount > 0
                      ? Icons.wifi_off_rounded
                      : Icons.wifi_rounded,
                  color: summaryColor,
                  size: 23,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      summaryMessage,
                      style: AppTextStyles.body.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'C\u1EADp nh\u1EADt t\u1EF1 \u0111\u1ED9ng m\u1ED7i ${snapshot.refreshIntervalSeconds} gi\u00E2y',
                      style: AppTextStyles.micro.copyWith(
                        color: _networkMuted,
                        fontSize: 11,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                key: NetworkStatusPage.refreshKey,
                onTap: () {},
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: _networkSurface,
                    borderRadius: BorderRadius.circular(17),
                    border: Border.all(color: _networkBorder),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.refresh_rounded,
                    color: AppColors.text2,
                    size: 17,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _SummaryStat(
                value: snapshot.operationalCount.toString(),
                label: 'Ho\u1EA1t \u0111\u1ED9ng',
                color: _networkGreen,
              ),
              const SizedBox(width: 8),
              _SummaryStat(
                value: snapshot.issueCount.toString(),
                label: 'Ch\u1EADm / T\u1EAFc',
                color: _networkAmber,
              ),
              const SizedBox(width: 8),
              _SummaryStat(
                value: snapshot.downCount.toString(),
                label: 'B\u1EA3o tr\u00EC',
                color: _networkRed,
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
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 59,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _networkSurface.withValues(alpha: .75),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: .32)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: AppTextStyles.baseMedium.copyWith(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
            ),
            const SizedBox(height: 9),
            Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: _networkMuted,
                fontSize: 9,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NetworkCard extends StatelessWidget {
  const _NetworkCard({required this.network});

  final WalletNetworkInfo network;

  @override
  Widget build(BuildContext context) {
    final tokenColor = Color(network.colorHex);
    final healthColor = _healthColor(network.health);
    final congestionColor = _congestionColor(network.congestionPct);
    return Container(
      key: NetworkStatusPage.networkKey(network.id),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _networkSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _networkBorder),
      ),
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
                  borderRadius: BorderRadius.circular(16),
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
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _networkSurface2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
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
        borderRadius: BorderRadius.circular(15),
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
        borderRadius: BorderRadius.circular(14),
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _networkSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _networkBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ch\u00FA th\u00EDch tr\u1EA1ng th\u00E1i',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
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
                        if (row == 0) const SizedBox(height: 12),
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
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: color.withValues(alpha: .08),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Icon(_healthIcon(health), color: color, size: 12),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontSize: 12,
              height: 1,
            ),
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
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: _networkBlue.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _networkBlue.withValues(alpha: .25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: _networkBlue,
            size: 14,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'D\u1EEF li\u1EC7u tr\u1EA1ng th\u00E1i m\u1EA1ng \u0111\u01B0\u1EE3c c\u1EADp nh\u1EADt t\u1EF1 \u0111\u1ED9ng. Th\u1EDDi gian x\u00E1c nh\u1EADn th\u1EF1c t\u1EBF c\u00F3 th\u1EC3 kh\u00E1c t\u00F9y thu\u1ED9c v\u00E0o ph\u00ED gas v\u00E0 m\u1EE9c t\u1EA3i m\u1EA1ng t\u1EA1i th\u1EDDi \u0111i\u1EC3m giao d\u1ECBch.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontSize: 11,
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
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      child: Text(
        symbol,
        maxLines: 1,
        overflow: TextOverflow.clip,
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

class _HealthPill extends StatelessWidget {
  const _HealthPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 8.5,
          fontWeight: FontWeight.w900,
          height: 1,
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
