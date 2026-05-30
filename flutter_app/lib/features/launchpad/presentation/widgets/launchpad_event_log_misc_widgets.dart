part of '../pages/launchpad_event_log_page.dart';

class _FilterChipButton extends StatelessWidget {
  const _FilterChipButton({
    super.key,
    required this.label,
    required this.active,
    required this.color,
    required this.onTap,
    this.count,
  });

  final String label;
  final int? count;
  final bool active;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppRadii.xlRadius,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x3,
          vertical: AppSpacing.x2,
        ),
        decoration: BoxDecoration(
          color: active ? color.withValues(alpha: .12) : AppColors.surface2,
          border: Border.all(
            color: active
                ? color.withValues(alpha: .36)
                : AppColors.transparent,
          ),
          borderRadius: AppRadii.xlRadius,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: active ? color : AppColors.text3,
                fontWeight: active ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
            if (count != null) ...[
              const SizedBox(width: AppSpacing.x1),
              Text(
                '($count)',
                style: AppTextStyles.micro.copyWith(
                  color: active ? color : AppColors.text3,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SmallActionButton extends StatelessWidget {
  const _SmallActionButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.trailing,
    this.active = false,
    this.compact = false,
  });

  final String label;
  final IconData? icon;
  final IconData? trailing;
  final bool active;
  final bool compact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppModuleAccents.launchpad : AppColors.text3;
    return InkWell(
      borderRadius: AppRadii.inputRadius,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? AppSpacing.x2 : AppSpacing.x3,
          vertical: AppSpacing.x2,
        ),
        decoration: BoxDecoration(
          color: active ? AppColors.primary12 : AppColors.surface2,
          border: Border.all(
            color: active ? AppColors.primary30 : AppColors.cardBorder,
          ),
          borderRadius: AppRadii.inputRadius,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, color: color, size: 14),
              const SizedBox(width: AppSpacing.x1),
            ],
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: active ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: AppSpacing.x1),
              Icon(trailing, color: color, size: 14),
            ],
          ],
        ),
      ),
    );
  }
}

class _SelectBox extends StatelessWidget {
  const _SelectBox({
    super.key,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  final bool selected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppRadii.xsRadius,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          color: selected ? color : AppColors.transparent,
          border: Border.all(color: selected ? color : AppColors.borderSolid),
          borderRadius: AppRadii.xsRadius,
        ),
        child: selected
            ? const Icon(
                Icons.check_rounded,
                color: AppColors.onAccent,
                size: 13,
              )
            : null,
      ),
    );
  }
}

class _EventIcon extends StatelessWidget {
  const _EventIcon({required this.level});

  final LaunchpadEventLogLevel level;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: level.color.withValues(alpha: .16),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Icon(level.icon, color: level.color, size: 16),
    );
  }
}

class _LevelBadge extends StatelessWidget {
  const _LevelBadge({required this.level});

  final LaunchpadEventLogLevel level;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x1,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: level.color.withValues(alpha: .16),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Text(
        level.label.toUpperCase(),
        style: AppTextStyles.micro.copyWith(
          color: level.color,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _TagPill extends StatelessWidget {
  const _TagPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.xsRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(color: AppColors.text3),
      ),
    );
  }
}

class _EmptyEvents extends StatelessWidget {
  const _EmptyEvents();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadEventLogPage.emptyKey,
      padding: const EdgeInsets.all(AppSpacing.x6),
      child: Column(
        children: [
          const Icon(
            Icons.search_off_rounded,
            color: AppColors.text3,
            size: 34,
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            'Khong tim thay event',
            style: AppTextStyles.base.copyWith(
              color: AppColors.text1,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            'Thu thay doi bo loc hoac tu khoa tim kiem',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

extension _EventLevelUi on LaunchpadEventLogLevel {
  String get value {
    return switch (this) {
      LaunchpadEventLogLevel.info => 'info',
      LaunchpadEventLogLevel.success => 'success',
      LaunchpadEventLogLevel.warning => 'warning',
      LaunchpadEventLogLevel.error => 'error',
      LaunchpadEventLogLevel.debug => 'debug',
      LaunchpadEventLogLevel.tx => 'tx',
    };
  }

  String get label {
    return switch (this) {
      LaunchpadEventLogLevel.info => 'Info',
      LaunchpadEventLogLevel.success => 'Success',
      LaunchpadEventLogLevel.warning => 'Warning',
      LaunchpadEventLogLevel.error => 'Error',
      LaunchpadEventLogLevel.debug => 'Debug',
      LaunchpadEventLogLevel.tx => 'Transaction',
    };
  }

  Color get color {
    return switch (this) {
      LaunchpadEventLogLevel.info => AppModuleAccents.launchpad,
      LaunchpadEventLogLevel.success => AppColors.buy,
      LaunchpadEventLogLevel.warning => AppColors.warn,
      LaunchpadEventLogLevel.error => AppColors.sell,
      LaunchpadEventLogLevel.debug => AppColors.text2,
      LaunchpadEventLogLevel.tx => AppColors.accent,
    };
  }

  IconData get icon {
    return switch (this) {
      LaunchpadEventLogLevel.info => Icons.info_outline_rounded,
      LaunchpadEventLogLevel.success => Icons.check_circle_outline_rounded,
      LaunchpadEventLogLevel.warning => Icons.warning_amber_rounded,
      LaunchpadEventLogLevel.error => Icons.error_outline_rounded,
      LaunchpadEventLogLevel.debug => Icons.bug_report_outlined,
      LaunchpadEventLogLevel.tx => Icons.bolt_rounded,
    };
  }
}

IconData _formatIcon(String iconKey) {
  return switch (iconKey) {
    'json' => Icons.data_object_rounded,
    'csv' => Icons.table_chart_outlined,
    _ => Icons.description_outlined,
  };
}
