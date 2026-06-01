part of '../pages/activity_log_page.dart';

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
              : AppColors.onAccent.withValues(alpha: .04),
          borderRadius: AppRadii.inputRadius,
          border: Border.all(
            color: selected
                ? _activityPrimary.withValues(alpha: .6)
                : AppColors.onAccent.withValues(alpha: .08),
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
