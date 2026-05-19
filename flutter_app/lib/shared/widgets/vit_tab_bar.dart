import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radii.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_text_styles.dart';

enum VitTabBarVariant { pill, segment, underline }

class VitTabItem {
  const VitTabItem({required this.key, required this.label, this.icon});

  final String key;
  final String label;
  final IconData? icon;
}

class VitTabBar extends StatelessWidget {
  const VitTabBar({
    super.key,
    required this.tabs,
    required this.activeKey,
    required this.onChanged,
    this.variant = VitTabBarVariant.pill,
  });

  final List<VitTabItem> tabs;
  final String activeKey;
  final ValueChanged<String> onChanged;
  final VitTabBarVariant variant;

  @override
  Widget build(BuildContext context) {
    if (variant == VitTabBarVariant.underline) {
      return Row(
        children: [
          for (final tab in tabs)
            Expanded(
              child: _UnderlineTab(
                tab: tab,
                active: tab.key == activeKey,
                onChanged: onChanged,
              ),
            ),
        ],
      );
    }

    if (variant == VitTabBarVariant.segment) {
      return Row(
        children: [
          for (final tab in tabs)
            _PillTab(
              tab: tab,
              active: tab.key == activeKey,
              onChanged: onChanged,
              fillParent: true,
            ),
        ],
      );
    }

    return Wrap(
      spacing: AppSpacing.x3,
      runSpacing: AppSpacing.x3,
      children: [
        for (final tab in tabs)
          _PillTab(
            tab: tab,
            active: tab.key == activeKey,
            onChanged: onChanged,
            fillParent: false,
          ),
      ],
    );
  }
}

class _PillTab extends StatelessWidget {
  const _PillTab({
    required this.tab,
    required this.active,
    required this.onChanged,
    required this.fillParent,
  });

  final VitTabItem tab;
  final bool active;
  final ValueChanged<String> onChanged;
  final bool fillParent;

  @override
  Widget build(BuildContext context) {
    final content = AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: active ? AppColors.primary12 : AppColors.surface2,
        border: Border.all(
          color: active ? AppColors.primary20 : AppColors.cardBorder,
        ),
        borderRadius: AppRadii.smRadius,
      ),
      child: Row(
        mainAxisSize: fillParent ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (tab.icon != null) ...[
            Icon(
              tab.icon,
              color: active ? AppColors.primary : AppColors.text2,
              size: 14,
            ),
            const SizedBox(width: AppSpacing.x2),
          ],
          Text(
            tab.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: active ? AppColors.primary : AppColors.text2,
              fontWeight: active ? AppTextStyles.medium : AppTextStyles.normal,
              height: 1,
            ),
          ),
        ],
      ),
    );

    final button = Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () => onChanged(tab.key),
        borderRadius: AppRadii.smRadius,
        child: content,
      ),
    );

    if (!fillParent) return button;
    return Expanded(child: button);
  }
}

class _UnderlineTab extends StatelessWidget {
  const _UnderlineTab({
    required this.tab,
    required this.active,
    required this.onChanged,
  });

  final VitTabItem tab;
  final bool active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () => onChanged(tab.key),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.x3),
              child: Text(
                tab.label,
                style: AppTextStyles.caption.copyWith(
                  color: active ? AppColors.primary : AppColors.text2,
                  fontWeight: active
                      ? AppTextStyles.medium
                      : AppTextStyles.normal,
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: 2,
              width: active ? 28 : 0,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
