import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/app_top_header_tokens.dart';

/// The kind of trailing header action button being rendered, driving its
/// default icon, tooltip, and tone via [VitHeaderActionTypeDefaults].
enum VitHeaderActionType {
  back,
  close,
  search,
  notifications,
  news,
  filter,
  settings,
  export,
  share,
  favoriteOn,
  favoriteOff,
  add,
  history,
  analytics,
  portfolio,
  overview,
  sectors,
  refresh,
  help,
  emergency,
  more,
}

/// Color treatment for a [VitHeaderActionButton].
enum VitHeaderActionTone {
  neutral,
  primary,
  success,
  danger,
  warning,
  transparent,
}

/// Tap-target size of a [VitHeaderActionButton].
enum VitHeaderActionSize { sm, md }

/// Declarative description of one [VitHeader]/[VitTopChrome] trailing
/// action, converted to a [VitHeaderActionButton] via [VitHeaderActionButton.fromItem].
final class VitHeaderActionItem {
  const VitHeaderActionItem({
    this.key,
    required this.type,
    required this.onPressed,
    this.tooltip,
    this.tone,
    this.active = false,
    this.badgeCount = 0,
    this.size = VitHeaderActionSize.md,
  });

  final Key? key;
  final VitHeaderActionType type;
  final VoidCallback? onPressed;
  final String? tooltip;
  final VitHeaderActionTone? tone;
  final bool active;
  final int badgeCount;
  final VitHeaderActionSize size;
}

/// A single square icon button used in header/top-chrome trailing action
/// slots, with tone, size, active state, and an optional unread badge.
class VitHeaderActionButton extends StatelessWidget {
  const VitHeaderActionButton({
    super.key,
    required this.type,
    required this.onPressed,
    this.tooltip,
    this.tone,
    this.active = false,
    this.badgeCount = 0,
    this.size = VitHeaderActionSize.md,
  });

  factory VitHeaderActionButton.fromItem(VitHeaderActionItem item) {
    return VitHeaderActionButton(
      key: item.key,
      type: item.type,
      onPressed: item.onPressed,
      tooltip: item.tooltip,
      tone: item.tone,
      active: item.active,
      badgeCount: item.badgeCount,
      size: item.size,
    );
  }

  final VitHeaderActionType type;
  final VoidCallback? onPressed;
  final String? tooltip;
  final VitHeaderActionTone? tone;
  final bool active;
  final int badgeCount;
  final VitHeaderActionSize size;

  bool get _enabled => onPressed != null;

  @override
  Widget build(BuildContext context) {
    final metrics = _metricsFor(size);
    final effectiveTooltip = tooltip ?? type.defaultTooltip;
    final effectiveTone = tone ?? type.defaultTone;
    final style = _enabled
        ? _styleFor(effectiveTone, active: active)
        : const _HeaderActionStyle(
            background: AppColors.surface2,
            foreground: AppColors.text3,
            border: AppColors.cardBorder,
          );

    return Tooltip(
      message: effectiveTooltip,
      child: Semantics(
        button: true,
        label: effectiveTooltip,
        enabled: _enabled,
        child: Material(
          color: AppColors.transparent,
          borderRadius: AppRadii.inputRadius,
          child: InkWell(
            onTap: _enabled ? onPressed : null,
            borderRadius: AppRadii.inputRadius,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: AppTopHeaderTokens.minTapTarget,
                minHeight: AppTopHeaderTokens.minTapTarget,
              ),
              child: Center(
                // widthFactor/heightFactor: 1 makes Center shrink-wrap to
                // its child's size instead of its Flutter default of
                // expanding to fill any *bounded* incoming constraint —
                // without this, the tap target would grow to whatever the
                // surrounding layout happens to allow instead of stopping
                // at the ConstrainedBox minimum above.
                widthFactor: 1,
                heightFactor: 1,
                child: SizedBox(
                  width: metrics.size,
                  height: metrics.size,
                  child: Ink(
                    decoration: ShapeDecoration(
                      color: style.background,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadii.inputRadius,
                        side: style.border == null
                            ? BorderSide.none
                            : BorderSide(color: style.border!),
                      ),
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Center(
                          child: Icon(
                            type.icon,
                            color: style.foreground,
                            size: metrics.iconSize,
                          ),
                        ),
                        if (badgeCount > 0)
                          Positioned(
                            top: AppTopHeaderTokens.badgeOffset,
                            right: AppTopHeaderTokens.badgeOffset,
                            child: _HeaderActionBadge(count: badgeCount),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Default icon, tooltip label, and tone for each [VitHeaderActionType].
extension VitHeaderActionTypeDefaults on VitHeaderActionType {
  IconData get icon {
    return switch (this) {
      VitHeaderActionType.back => Icons.chevron_left_rounded,
      VitHeaderActionType.close => Icons.close_rounded,
      VitHeaderActionType.search => Icons.search_rounded,
      VitHeaderActionType.notifications => Icons.notifications_none_rounded,
      VitHeaderActionType.news => Icons.newspaper_rounded,
      VitHeaderActionType.filter => Icons.tune_rounded,
      VitHeaderActionType.settings => Icons.settings_outlined,
      VitHeaderActionType.export => Icons.download_rounded,
      VitHeaderActionType.share => Icons.share_outlined,
      VitHeaderActionType.favoriteOn => Icons.star_rounded,
      VitHeaderActionType.favoriteOff => Icons.star_border_rounded,
      VitHeaderActionType.add => Icons.add_rounded,
      VitHeaderActionType.history => Icons.history_rounded,
      VitHeaderActionType.analytics => Icons.bar_chart_rounded,
      VitHeaderActionType.portfolio => Icons.business_center_outlined,
      VitHeaderActionType.overview => Icons.monitor_heart_outlined,
      VitHeaderActionType.sectors => Icons.layers_rounded,
      VitHeaderActionType.refresh => Icons.refresh_rounded,
      VitHeaderActionType.help => Icons.help_outline_rounded,
      VitHeaderActionType.emergency => Icons.error_outline_rounded,
      VitHeaderActionType.more => Icons.more_vert_rounded,
    };
  }

  String get defaultTooltip {
    return switch (this) {
      VitHeaderActionType.back => 'Quay lại',
      VitHeaderActionType.close => 'Đóng',
      VitHeaderActionType.search => 'Tìm kiếm',
      VitHeaderActionType.notifications => 'Thông báo',
      VitHeaderActionType.news => 'Tin tức',
      VitHeaderActionType.filter => 'Bộ lọc',
      VitHeaderActionType.settings => 'Cài đặt',
      VitHeaderActionType.export => 'Xuất dữ liệu',
      VitHeaderActionType.share => 'Chia sẻ',
      VitHeaderActionType.favoriteOn => 'Bỏ theo dõi',
      VitHeaderActionType.favoriteOff => 'Theo dõi',
      VitHeaderActionType.add => 'Tạo mới',
      VitHeaderActionType.history => 'Lịch sử',
      VitHeaderActionType.analytics => 'Phân tích',
      VitHeaderActionType.portfolio => 'Portfolio',
      VitHeaderActionType.overview => 'Tổng quan',
      VitHeaderActionType.sectors => 'Ngành',
      VitHeaderActionType.refresh => 'Làm mới',
      VitHeaderActionType.help => 'Hướng dẫn',
      VitHeaderActionType.emergency => 'Khẩn cấp',
      VitHeaderActionType.more => 'Thêm',
    };
  }

  VitHeaderActionTone get defaultTone {
    return switch (this) {
      VitHeaderActionType.add => VitHeaderActionTone.primary,
      VitHeaderActionType.emergency => VitHeaderActionTone.danger,
      VitHeaderActionType.favoriteOn => VitHeaderActionTone.warning,
      _ => VitHeaderActionTone.neutral,
    };
  }
}

final class _HeaderActionMetrics {
  const _HeaderActionMetrics({required this.size, required this.iconSize});

  final double size;
  final double iconSize;
}

final class _HeaderActionStyle {
  const _HeaderActionStyle({
    required this.background,
    required this.foreground,
    this.border,
  });

  final Color background;
  final Color foreground;
  final Color? border;
}

_HeaderActionMetrics _metricsFor(VitHeaderActionSize size) {
  return switch (size) {
    VitHeaderActionSize.sm => const _HeaderActionMetrics(
      size: AppTopHeaderTokens.compactButtonSize,
      iconSize: AppTopHeaderTokens.compactButtonIconSize,
    ),
    VitHeaderActionSize.md => const _HeaderActionMetrics(
      size: AppTopHeaderTokens.buttonSize,
      iconSize: AppTopHeaderTokens.buttonIconSize,
    ),
  };
}

_HeaderActionStyle _styleFor(VitHeaderActionTone tone, {required bool active}) {
  return switch (tone) {
    VitHeaderActionTone.neutral =>
      active
          ? const _HeaderActionStyle(
              background: AppColors.surface3,
              foreground: AppColors.text1,
              border: AppColors.borderSolid,
            )
          : const _HeaderActionStyle(
              background: AppColors.searchBg,
              foreground: AppColors.text2,
              border: AppColors.border,
            ),
    VitHeaderActionTone.primary => const _HeaderActionStyle(
      background: AppColors.primary12,
      foreground: AppColors.primary,
      border: AppColors.primary20,
    ),
    VitHeaderActionTone.success => const _HeaderActionStyle(
      background: AppColors.buy15,
      foreground: AppColors.buy,
      border: AppColors.buy20,
    ),
    VitHeaderActionTone.danger => const _HeaderActionStyle(
      background: AppColors.sell15,
      foreground: AppColors.sell,
      border: AppColors.sell20,
    ),
    VitHeaderActionTone.warning => const _HeaderActionStyle(
      background: AppColors.warn10,
      foreground: AppColors.warn,
      border: AppColors.warningBorder,
    ),
    VitHeaderActionTone.transparent => _HeaderActionStyle(
      background: AppColors.transparent,
      foreground: active ? AppColors.text1 : AppColors.text2,
    ),
  };
}

class _HeaderActionBadge extends StatelessWidget {
  const _HeaderActionBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final label = count > 99 ? '99+' : count.toString();
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: AppTopHeaderTokens.badgeMinSize,
        minHeight: AppTopHeaderTokens.badgeMinSize,
      ),
      child: DecoratedBox(
        decoration: const ShapeDecoration(
          color: AppColors.sell,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadii.pillRadius,
            side: BorderSide(
              color: AppColors.bg,
              width: AppTopHeaderTokens.badgeBorderWidth,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: AppTopHeaderTokens.badgeHorizontalPadding,
          ),
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
