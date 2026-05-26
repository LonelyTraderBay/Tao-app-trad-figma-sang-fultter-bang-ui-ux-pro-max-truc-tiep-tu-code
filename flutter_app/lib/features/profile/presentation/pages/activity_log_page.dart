import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/features/profile/data/profile_repository.dart';

const _activityBackground = AppColors.bg;
const _activityPanel = AppColors.surface;
const _activityPanel2 = AppColors.surface2;
const _activityBorder = AppColors.cardBorder;
const _activityDivider = AppColors.divider;
const _activityPrimary = AppColors.primary;
const _activityGreen = AppColors.buy;
const _activityRed = AppColors.sell;
const _activityAmber = AppColors.warn;
const _activityGray = AppColors.text2;
const _activityPurple = AppColors.accent;
const _activityMuted = AppColors.text3;

class ActivityLogPage extends ConsumerStatefulWidget {
  const ActivityLogPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc161_activity_content');
  static const warningKey = Key('sc161_activity_warning');
  static Key filterKey(String id) => Key('sc161_activity_filter_$id');
  static Key logKey(String id) => Key('sc161_activity_log_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ActivityLogPage> createState() => _ActivityLogPageState();
}

class _ActivityLogPageState extends ConsumerState<ActivityLogPage> {
  String _activeFilter = 'all';

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(profileRepositoryProvider).getActivity();
    final logs = _filteredLogs(snapshot.logs);
    final suspiciousCount = snapshot.logs
        .where((log) => log.status == 'suspicious')
        .length;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 126
            : DeviceMetrics.nativeBottomChrome + 32) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-161 ActivityLogPage',
      child: Material(
        color: _activityBackground,
        child: Column(
          children: [
            VitHeader(
              title: 'Nh\u1EADt k\u00FD ho\u1EA1t \u0111\u1ED9ng',
              subtitle: 'Ho\u1EA1t \u0111\u1ED9ng \u00B7 Profile',
              showBack: true,
              onBack: _close,
            ),
            Expanded(
              child: SingleChildScrollView(
                key: ActivityLogPage.contentKey,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _FilterPanel(
                      filters: snapshot.filters,
                      activeFilter: _activeFilter,
                      suspiciousCount: suspiciousCount,
                      onChanged: _setFilter,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 32, 20, 37),
                      child: logs.isEmpty
                          ? const _EmptyActivity()
                          : Column(
                              children: [
                                for (final log in logs) ...[
                                  _ActivityCard(log: log),
                                  if (log != logs.last)
                                    const SizedBox(height: 13),
                                ],
                              ],
                            ),
                    ),
                    const _ActivityFooter(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<ProfileActivityLog> _filteredLogs(List<ProfileActivityLog> logs) {
    return switch (_activeFilter) {
      'login' =>
        logs
            .where((log) => log.type == 'login' || log.type == 'logout')
            .toList(),
      'security' =>
        logs
            .where((log) => log.type != 'login' && log.type != 'logout')
            .toList(),
      _ => logs,
    };
  }

  void _setFilter(String id) {
    HapticFeedback.selectionClick();
    setState(() => _activeFilter = id);
  }

  void _close() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.profile);
  }
}

class _FilterPanel extends StatelessWidget {
  const _FilterPanel({
    required this.filters,
    required this.activeFilter,
    required this.suspiciousCount,
    required this.onChanged,
  });

  final List<ProfileActivityFilter> filters;
  final String activeFilter;
  final int suspiciousCount;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 146,
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 13),
      decoration: const BoxDecoration(
        color: _activityPanel,
        border: Border(bottom: BorderSide(color: _activityDivider)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (suspiciousCount > 0)
            _SuspiciousBanner(count: suspiciousCount)
          else
            const SizedBox(height: 64),
          const SizedBox(height: 13),
          SizedBox(
            height: 30,
            child: Row(
              children: [
                for (final filter in filters) ...[
                  _FilterChip(
                    filter: filter,
                    selected: filter.id == activeFilter,
                    onTap: () => onChanged(filter.id),
                  ),
                  if (filter != filters.last) const SizedBox(width: 12),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SuspiciousBanner extends StatelessWidget {
  const _SuspiciousBanner({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ActivityLogPage.warningKey,
      height: 64,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: _activityAmber.withValues(alpha: .1),
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: _activityAmber.withValues(alpha: .34)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: _activityAmber,
            size: 17,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ph\u00E1t hi\u1EC7n $count ho\u1EA1t \u0111\u1ED9ng \u0111\u00E1ng ng\u1EDD',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: _activityAmber,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Vui l\u00F2ng ki\u1EC3m tra v\u00E0 \u0111\u1ED5i m\u1EADt kh\u1EA9u n\u1EBFu kh\u00F4ng ph\u1EA3i b\u1EA1n',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: _activityAmber,
                    fontSize: 11,
                    height: 1,
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

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.filter,
    required this.selected,
    required this.onTap,
  });

  final ProfileActivityFilter filter;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: ActivityLogPage.filterKey(filter.id),
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 13),
        decoration: BoxDecoration(
          color: selected
              ? _activityPrimary.withValues(alpha: .2)
              : Colors.white.withValues(alpha: .04),
          borderRadius: AppRadii.inputRadius,
          border: Border.all(
            color: selected
                ? _activityPrimary.withValues(alpha: .6)
                : Colors.white.withValues(alpha: .08),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          filter.label,
          style: AppTextStyles.micro.copyWith(
            color: selected ? _activityPrimary : AppColors.text2,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({required this.log});

  final ProfileActivityLog log;

  @override
  Widget build(BuildContext context) {
    final type = _typeConfig(log.type);
    final status = _statusConfig(log.status);
    final suspicious = log.status == 'suspicious';

    return Container(
      key: ActivityLogPage.logKey(log.id),
      height: 223,
      padding: const EdgeInsets.fromLTRB(16, 13, 16, 12),
      decoration: BoxDecoration(
        color: suspicious
            ? _activityAmber.withValues(alpha: .05)
            : _activityPanel,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(
          color: suspicious
              ? _activityAmber.withValues(alpha: .32)
              : _activityBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ActivityIcon(config: type),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            type.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              height: 1,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _StatusPill(config: status),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      log.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                        fontSize: 12,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
              if (suspicious) ...[
                const SizedBox(width: 8),
                const Icon(
                  Icons.warning_amber_rounded,
                  color: _activityAmber,
                  size: 17,
                ),
              ],
            ],
          ),
          const SizedBox(height: 13),
          _ActivityDetails(log: log),
          const SizedBox(height: 8),
          const Divider(height: 1, color: _activityDivider),
          const SizedBox(height: 11),
          Text(
            log.timestamp,
            style: AppTextStyles.micro.copyWith(
              color: _activityMuted,
              fontSize: 11,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityIcon extends StatelessWidget {
  const _ActivityIcon({required this.config});

  final _ActivityTypeConfig config;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: config.color.withValues(alpha: .16),
        borderRadius: AppRadii.lgRadius,
      ),
      alignment: Alignment.center,
      child: Icon(config.icon, color: config.color, size: 19),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.config});

  final _ActivityStatusConfig config;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: config.color.withValues(alpha: .15),
        borderRadius: BorderRadius.circular(4),
      ),
      alignment: Alignment.center,
      child: Text(
        config.label,
        style: AppTextStyles.micro.copyWith(
          color: config.color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          height: 1,
        ),
      ),
    );
  }
}

class _ActivityDetails extends StatelessWidget {
  const _ActivityDetails({required this.log});

  final ProfileActivityLog log;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 108,
      padding: const EdgeInsets.fromLTRB(13, 12, 13, 12),
      decoration: BoxDecoration(
        color: _activityPanel2.withValues(alpha: .72),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: _DetailBlock(
                  icon: Icons.location_on_outlined,
                  label: 'V\u1ECA TR\u00CD',
                  value: log.location,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _DetailBlock(
                  icon: Icons.desktop_windows_outlined,
                  label: 'THI\u1EBET B\u1ECA',
                  value: log.device,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _DetailBlock(label: 'IP ADDRESS', value: log.ipAddress),
        ],
      ),
    );
  }
}

class _DetailBlock extends StatelessWidget {
  const _DetailBlock({required this.label, required this.value, this.icon});

  final IconData? icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: _activityMuted, size: 12),
              const SizedBox(width: 5),
            ],
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(
                  color: _activityMuted,
                  fontSize: 10,
                  height: 1,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text1,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _EmptyActivity extends StatelessWidget {
  const _EmptyActivity();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppColors.borderSolid,
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            'Kh\u00F4ng c\u00F3 ho\u1EA1t \u0111\u1ED9ng n\u00E0o',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityFooter extends StatelessWidget {
  const _ActivityFooter();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      decoration: const BoxDecoration(
        color: _activityPanel,
        border: Border(top: BorderSide(color: _activityDivider)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.shield_outlined, color: _activityPrimary, size: 14),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Nh\u1EADt k\u00FD ho\u1EA1t \u0111\u1ED9ng gi\u00FAp b\u1EA1n theo d\u00F5i t\u1EA5t c\u1EA3 thao t\u00E1c tr\u00EAn t\u00E0i kho\u1EA3n. N\u1EBFu\n'
              'ph\u00E1t hi\u1EC7n ho\u1EA1t \u0111\u1ED9ng \u0111\u00E1ng ng\u1EDD, vui l\u00F2ng \u0111\u1ED5i m\u1EADt kh\u1EA9u ngay l\u1EADp t\u1EE9c.',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                fontSize: 11,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final class _ActivityTypeConfig {
  const _ActivityTypeConfig({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;
}

final class _ActivityStatusConfig {
  const _ActivityStatusConfig({required this.label, required this.color});

  final String label;
  final Color color;
}

_ActivityTypeConfig _typeConfig(String type) {
  return switch (type) {
    'logout' => const _ActivityTypeConfig(
      label: '\u0110\u0103ng xu\u1EA5t',
      icon: Icons.check_circle_outline_rounded,
      color: _activityGray,
    ),
    'password_change' => const _ActivityTypeConfig(
      label: '\u0110\u1ED5i m\u1EADt kh\u1EA9u',
      icon: Icons.shield_outlined,
      color: _activityPrimary,
    ),
    '2fa_enable' => const _ActivityTypeConfig(
      label: 'B\u1EADt 2FA',
      icon: Icons.shield_outlined,
      color: _activityGreen,
    ),
    '2fa_disable' => const _ActivityTypeConfig(
      label: 'T\u1EAFt 2FA',
      icon: Icons.warning_amber_rounded,
      color: _activityRed,
    ),
    'kyc_submit' => const _ActivityTypeConfig(
      label: 'N\u1ED9p KYC',
      icon: Icons.check_circle_outline_rounded,
      color: _activityPrimary,
    ),
    'api_create' => const _ActivityTypeConfig(
      label: 'T\u1EA1o API Key',
      icon: Icons.check_circle_outline_rounded,
      color: _activityPurple,
    ),
    'api_delete' => const _ActivityTypeConfig(
      label: 'X\u00F3a API Key',
      icon: Icons.cancel_outlined,
      color: _activityRed,
    ),
    _ => const _ActivityTypeConfig(
      label: '\u0110\u0103ng nh\u1EADp',
      icon: Icons.check_circle_outline_rounded,
      color: _activityGreen,
    ),
  };
}

_ActivityStatusConfig _statusConfig(String status) {
  return switch (status) {
    'failed' => const _ActivityStatusConfig(
      label: 'Th\u1EA5t b\u1EA1i',
      color: _activityRed,
    ),
    'suspicious' => const _ActivityStatusConfig(
      label: '\u0110\u00E1ng ng\u1EDD',
      color: _activityAmber,
    ),
    _ => const _ActivityStatusConfig(
      label: 'Th\u00E0nh c\u00F4ng',
      color: _activityGreen,
    ),
  };
}
