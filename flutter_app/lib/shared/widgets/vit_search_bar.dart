import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_icon_button.dart';

enum VitSearchBarVariant { defaultSearch, header, compact }

class VitSearchBar extends StatefulWidget {
  const VitSearchBar({
    super.key,
    this.controller,
    this.focusNode,
    this.placeholder = 'Search',
    this.variant = VitSearchBarVariant.defaultSearch,
    this.autofocus = false,
    this.enabled = true,
    this.filterActive = false,
    this.filterInline = false,
    this.trailing,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.onBack,
    this.onFilterTap,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String placeholder;
  final VitSearchBarVariant variant;
  final bool autofocus;
  final bool enabled;
  final bool filterActive;
  final bool filterInline;
  final Widget? trailing;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final VoidCallback? onBack;
  final VoidCallback? onFilterTap;

  @override
  State<VitSearchBar> createState() => _VitSearchBarState();
}

class _VitSearchBarState extends State<VitSearchBar> {
  late final TextEditingController _internalController;
  late final FocusNode _internalFocusNode;

  TextEditingController get _controller {
    return widget.controller ?? _internalController;
  }

  FocusNode get _focusNode {
    return widget.focusNode ?? _internalFocusNode;
  }

  double get _height {
    switch (widget.variant) {
      case VitSearchBarVariant.compact:
        return 44;
      case VitSearchBarVariant.defaultSearch:
      case VitSearchBarVariant.header:
        return AppSpacing.inputHeight;
    }
  }

  BorderRadius get _radius {
    return widget.variant == VitSearchBarVariant.compact
        ? AppRadii.smRadius
        : AppRadii.inputRadius;
  }

  @override
  void initState() {
    super.initState();
    _internalController = TextEditingController();
    _internalFocusNode = FocusNode();
    _controller.addListener(_handleTextChanged);
    _focusNode.addListener(_handleFocusChanged);
  }

  @override
  void didUpdateWidget(covariant VitSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldController = oldWidget.controller ?? _internalController;
    final newController = widget.controller ?? _internalController;
    if (oldController != newController) {
      oldController.removeListener(_handleTextChanged);
      newController.addListener(_handleTextChanged);
    }
    final oldFocusNode = oldWidget.focusNode ?? _internalFocusNode;
    final newFocusNode = widget.focusNode ?? _internalFocusNode;
    if (oldFocusNode != newFocusNode) {
      oldFocusNode.removeListener(_handleFocusChanged);
      newFocusNode.addListener(_handleFocusChanged);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChanged);
    _focusNode.removeListener(_handleFocusChanged);
    _internalFocusNode.dispose();
    _internalController.dispose();
    super.dispose();
  }

  void _handleTextChanged() {
    if (mounted) setState(() {});
  }

  void _handleFocusChanged() {
    if (mounted) setState(() {});
  }

  void _clear() {
    _controller.clear();
    widget.onChanged?.call('');
    widget.onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    final hasValue = _controller.text.isNotEmpty;
    final fontSize = widget.variant == VitSearchBarVariant.compact
        ? 13.0
        : 14.0;

    return Row(
      children: [
        if (widget.variant == VitSearchBarVariant.header &&
            widget.onBack != null) ...[
          VitIconButton(
            icon: Icons.arrow_back_rounded,
            tooltip: 'Back',
            onPressed: widget.onBack,
            variant: VitIconButtonVariant.transparent,
            size: VitIconButtonSize.lg,
          ),
          const SizedBox(width: AppSpacing.x3),
        ],
        Expanded(
          child: Container(
            height: _height,
            padding: const EdgeInsets.only(left: 12, right: 8),
            decoration: BoxDecoration(
              color: AppColors.searchBg,
              border: Border.all(
                color: _focusNode.hasFocus
                    ? AppColors.primary
                    : AppColors.searchBorder,
                width: _focusNode.hasFocus ? 1.5 : 1,
              ),
              borderRadius: _radius,
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.search_rounded,
                  color: AppColors.text3,
                  size: 18,
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    autofocus: widget.autofocus,
                    enabled: widget.enabled,
                    onChanged: widget.onChanged,
                    onSubmitted: widget.onSubmitted,
                    textInputAction: TextInputAction.search,
                    cursorColor: AppColors.primary,
                    style: AppTextStyles.body.copyWith(fontSize: fontSize),
                    decoration: InputDecoration.collapsed(
                      hintText: widget.placeholder,
                      hintStyle: AppTextStyles.body.copyWith(
                        color: AppColors.searchPlaceholder,
                        fontSize: fontSize,
                      ),
                    ),
                  ),
                ),
                if (hasValue && widget.enabled)
                  VitIconButton(
                    icon: Icons.close_rounded,
                    tooltip: 'Clear search',
                    onPressed: _clear,
                    variant: VitIconButtonVariant.defaultAction,
                    size: VitIconButtonSize.sm,
                  ),
                if (widget.onFilterTap != null && widget.filterInline)
                  VitIconButton(
                    icon: Icons.tune_rounded,
                    tooltip: widget.filterActive
                        ? 'Disable filters'
                        : 'Enable filters',
                    onPressed: widget.onFilterTap,
                    variant: widget.filterActive
                        ? VitIconButtonVariant.primary
                        : VitIconButtonVariant.defaultAction,
                    size: VitIconButtonSize.sm,
                  ),
              ],
            ),
          ),
        ),
        if (widget.onFilterTap != null &&
            widget.trailing == null &&
            !widget.filterInline) ...[
          const SizedBox(width: AppSpacing.x3),
          VitIconButton(
            icon: Icons.tune_rounded,
            tooltip: widget.filterActive ? 'Disable filters' : 'Enable filters',
            onPressed: widget.onFilterTap,
            variant: widget.filterActive
                ? VitIconButtonVariant.primary
                : VitIconButtonVariant.ghost,
            size: widget.variant == VitSearchBarVariant.compact
                ? VitIconButtonSize.md
                : VitIconButtonSize.lg,
          ),
        ],
        if (widget.trailing != null) ...[
          const SizedBox(width: AppSpacing.x3),
          widget.trailing!,
        ],
      ],
    );
  }
}
