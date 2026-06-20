import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';

enum VitTabBarVariant { pill, segment, underline }

class VitTabItem {
  const VitTabItem({
    required this.key,
    required this.label,
    this.icon,
    this.widgetKey,
  });

  final String key;
  final String label;
  final IconData? icon;
  final Key? widgetKey;
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
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: AppSpacing.rowGapRegular,
                vertical: AppSpacing.tabBarPillVertical,
              ),
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
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: AppSpacing.rowGapRegular,
              vertical: AppSpacing.tabBarPillVertical,
            ),
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
    required this.padding,
  });

  final VitTabItem tab;
  final bool active;
  final ValueChanged<String> onChanged;
  final bool fillParent;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final content = DecoratedBox(
      decoration: ShapeDecoration(
        color: active ? AppColors.primary12 : AppColors.surface2,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.smRadius,
          side: BorderSide(
            color: active ? AppColors.primary20 : AppColors.cardBorder,
          ),
        ),
      ),
      child: Padding(
        padding: padding,
        child: Row(
          mainAxisSize: fillParent ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (tab.icon != null) ...[
              Icon(
                tab.icon,
                color: active ? AppColors.primary : AppColors.text2,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
            ],
            if (fillParent)
              Flexible(
                child: _PillTabLabel(tab: tab, active: active),
              )
            else
              _PillTabLabel(tab: tab, active: active),
          ],
        ),
      ),
    );

    final button = Material(
      key: tab.widgetKey,
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

class _PillTabLabel extends StatelessWidget {
  const _PillTabLabel({required this.tab, required this.active});

  final VitTabItem tab;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Text(
      tab.label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyles.control.copyWith(
        color: active ? AppColors.primary : AppColors.text2,
        fontWeight: active ? AppTextStyles.medium : AppTextStyles.normal,
      ),
    );
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
      key: tab.widgetKey,
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () => onChanged(tab.key),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(
                vertical: AppSpacing.x3,
              ),
              child: Text(
                tab.label,
                style: AppTextStyles.control.copyWith(
                  color: active ? AppColors.primary : AppColors.text2,
                  fontWeight: active
                      ? AppTextStyles.medium
                      : AppTextStyles.normal,
                ),
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 180),
              alignment: Alignment.center,
              child: SizedBox(
                height: AppSpacing.tabBarUnderlineHeight,
                width: active ? AppSpacing.tabBarUnderlineWidth : 0,
                child: const DecoratedBox(
                  decoration: ShapeDecoration(
                    color: AppColors.primary,
                    shape: StadiumBorder(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
