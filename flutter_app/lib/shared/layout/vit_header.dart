import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_text_styles.dart';

enum VitHeaderVariant { page, standard, custom }

enum VitHeaderAction { none, bell, search, more }

class VitHeader extends StatelessWidget {
  const VitHeader({
    super.key,
    this.variant = VitHeaderVariant.page,
    this.title,
    this.subtitle,
    this.showBack = false,
    this.trailing,
    this.action = VitHeaderAction.none,
    this.badgeCount = 0,
    this.transparent = false,
    this.onBack,
    this.onAction,
    this.child,
  });

  final VitHeaderVariant variant;
  final String? title;
  final String? subtitle;
  final bool showBack;
  final Widget? trailing;
  final VitHeaderAction action;
  final int badgeCount;
  final bool transparent;
  final VoidCallback? onBack;
  final VoidCallback? onAction;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    if (variant == VitHeaderVariant.custom) {
      return child ?? const SizedBox.shrink();
    }

    final hasSubtitle = subtitle != null && subtitle!.isNotEmpty;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: transparent ? Colors.transparent : AppColors.navBg,
        border: transparent
            ? null
            : const Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 52),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.contentPad,
            vertical: hasSubtitle ? 8 : 0,
          ),
          child: variant == VitHeaderVariant.standard
              ? _StandardHeaderContent(header: this, hasSubtitle: hasSubtitle)
              : _PageHeaderContent(header: this, hasSubtitle: hasSubtitle),
        ),
      ),
    );
  }
}

class _PageHeaderContent extends StatelessWidget {
  const _PageHeaderContent({required this.header, required this.hasSubtitle});

  final VitHeader header;
  final bool hasSubtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: hasSubtitle
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        if (header.showBack) ...[
          _BackButton(onPressed: header.onBack),
          const SizedBox(width: 12),
        ],
        Expanded(child: _TitleBlock(header: header, alignCenter: false)),
        _HeaderTrailing(header: header, isPageVariant: true),
      ],
    );
  }
}

class _StandardHeaderContent extends StatelessWidget {
  const _StandardHeaderContent({
    required this.header,
    required this.hasSubtitle,
  });

  final VitHeader header;
  final bool hasSubtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: hasSubtitle
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: header.showBack
                ? _BackButton(onPressed: header.onBack)
                : const SizedBox(width: 36),
          ),
        ),
        Expanded(
          flex: 2,
          child: _TitleBlock(header: header, alignCenter: true),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: _HeaderTrailing(header: header, isPageVariant: false),
          ),
        ),
      ],
    );
  }
}

class _TitleBlock extends StatelessWidget {
  const _TitleBlock({required this.header, required this.alignCenter});

  final VitHeader header;
  final bool alignCenter;

  @override
  Widget build(BuildContext context) {
    final title = header.title;
    final subtitle = header.subtitle;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: alignCenter
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        if (title != null)
          Row(
            mainAxisSize: alignCenter ? MainAxisSize.min : MainAxisSize.max,
            children: [
              Flexible(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.baseMedium.copyWith(
                    fontSize: 17,
                    height: 1.3,
                  ),
                ),
              ),
              if (header.badgeCount > 0) ...[
                const SizedBox(width: 6),
                _CountBadge(count: header.badgeCount),
              ],
            ],
          ),
        if (subtitle != null)
          Text(
            subtitle,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(fontSize: 12, height: 1.3),
          ),
      ],
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 36,
      child: IconButton(
        onPressed: onPressed ?? () {},
        padding: EdgeInsets.zero,
        icon: const Icon(
          Icons.chevron_left_rounded,
          color: AppColors.text1,
          size: 28,
        ),
      ),
    );
  }
}

class _HeaderTrailing extends StatelessWidget {
  const _HeaderTrailing({required this.header, required this.isPageVariant});

  final VitHeader header;
  final bool isPageVariant;

  @override
  Widget build(BuildContext context) {
    if (header.trailing != null) return header.trailing!;
    if (header.action == VitHeaderAction.none) {
      return isPageVariant
          ? const SizedBox.shrink()
          : const SizedBox(width: 36);
    }

    final icon = switch (header.action) {
      VitHeaderAction.bell => Icons.notifications_none_rounded,
      VitHeaderAction.search => Icons.search_rounded,
      VitHeaderAction.more => Icons.more_vert_rounded,
      VitHeaderAction.none => Icons.more_vert_rounded,
    };

    return SizedBox(
      width: 36,
      height: 36,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.searchBg,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: IconButton(
                onPressed: header.onAction,
                padding: EdgeInsets.zero,
                icon: Icon(icon, color: AppColors.text1, size: 18),
              ),
            ),
            if (header.badgeCount > 0)
              Positioned(
                top: -5,
                right: -5,
                child: _CountBadge(count: header.badgeCount),
              ),
          ],
        ),
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 16),
      height: 16,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: AppColors.sell,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: AppColors.sell20,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        count > 99 ? '99+' : '$count',
        style: AppTextStyles.micro.copyWith(
          color: Colors.white,
          fontSize: 9,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}
