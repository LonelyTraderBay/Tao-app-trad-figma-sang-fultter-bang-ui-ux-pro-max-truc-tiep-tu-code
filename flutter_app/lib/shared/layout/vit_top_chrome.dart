import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/app_top_header_tokens.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';

enum VitTopChromeType {
  detail,
  rootBrand,
  rootModule,
  instrument,
  fullscreenTool,
  authOnboarding,
}

class VitTopChrome extends StatelessWidget {
  const VitTopChrome({
    super.key,
    required this.type,
    this.title,
    this.subtitle,
    this.showBack = false,
    this.onBack,
    this.actions = const [],
    this.leading,
    this.body,
    this.trailing,
    this.statusSlot,
    this.transparent = false,
    this.backKey,
  });

  static const double detailMinHeight = AppTopHeaderTokens.detailMinHeight;
  static const double rootMinHeight = AppTopHeaderTokens.rootMinHeight;
  static const double instrumentMinHeight =
      AppTopHeaderTokens.instrumentMinHeight;
  static const double horizontalPadding = AppTopHeaderTokens.horizontalPadding;
  static const double rootTopPadding = AppTopHeaderTokens.rootTopPadding;
  static const double rootBottomPadding = AppTopHeaderTokens.rootBottomPadding;
  static const double actionGap = AppTopHeaderTokens.actionGap;
  final VitTopChromeType type;
  final String? title;
  final String? subtitle;
  final bool showBack;
  final VoidCallback? onBack;
  final List<VitHeaderActionItem> actions;
  final Widget? leading;
  final Widget? body;
  final Widget? trailing;
  final Widget? statusSlot;
  final bool transparent;
  final Key? backKey;

  @override
  Widget build(BuildContext context) {
    assert(
      actions.length <= 3,
      'VitTopChrome.actions supports up to 3 actions. Use more overflow.',
    );
    assert(
      type == VitTopChromeType.fullscreenTool ||
          type == VitTopChromeType.authOnboarding ||
          !showBack ||
          onBack != null,
      'VitTopChrome.showBack requires onBack so visible back buttons are actionable.',
    );

    final chrome = switch (type) {
      VitTopChromeType.detail => _buildDetail(),
      VitTopChromeType.rootBrand => _buildRoot(),
      VitTopChromeType.rootModule => _buildRoot(),
      VitTopChromeType.instrument => _buildInstrument(),
      VitTopChromeType.fullscreenTool => body ?? const SizedBox.shrink(),
      VitTopChromeType.authOnboarding => body ?? const SizedBox.shrink(),
    };

    if (statusSlot == null) return chrome;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [chrome, statusSlot!],
    );
  }

  Widget _buildDetail() {
    return VitHeader(
      title: title,
      subtitle: subtitle,
      showBack: showBack,
      onBack: onBack,
      backKey: backKey,
      actions: actions,
      transparent: transparent,
    );
  }

  Widget _buildRoot() {
    return _TopChromeSurface(
      transparent: transparent,
      minHeight: rootMinHeight,
      padding: const EdgeInsetsDirectional.fromSTEB(
        AppTopHeaderTokens.horizontalPadding,
        AppTopHeaderTokens.rootTopPadding,
        AppTopHeaderTokens.horizontalPadding,
        AppTopHeaderTokens.rootBottomPadding,
      ),
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: AppTopHeaderTokens.leadingGap),
          ],
          if (showBack) ...[
            _TopChromeBackButton(buttonKey: backKey, onPressed: onBack!),
            const SizedBox(width: AppTopHeaderTokens.leadingGap),
          ],
          Expanded(
            child: body ?? _RootTitleBlock(title: title, subtitle: subtitle),
          ),
          if (trailing != null) ...[
            const SizedBox(width: AppTopHeaderTokens.actionGap),
            trailing!,
          ] else if (actions.isNotEmpty) ...[
            const SizedBox(width: AppTopHeaderTokens.actionGap),
            _TopChromeActionRow(actions: actions),
          ],
        ],
      ),
    );
  }

  Widget _buildInstrument() {
    return _TopChromeSurface(
      transparent: transparent,
      minHeight: instrumentMinHeight,
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppTopHeaderTokens.horizontalPadding,
      ),
      child: Row(
        children: [
          if (showBack) ...[
            _TopChromeBackButton(buttonKey: backKey, onPressed: onBack!),
            const SizedBox(width: AppTopHeaderTokens.instrumentGap),
          ],
          if (leading != null) ...[
            leading!,
            const SizedBox(width: AppTopHeaderTokens.instrumentGap),
          ],
          Expanded(
            child:
                body ?? _InstrumentTitleBlock(title: title, subtitle: subtitle),
          ),
          if (trailing != null) ...[
            const SizedBox(width: AppTopHeaderTokens.instrumentGap),
            trailing!,
          ] else if (actions.isNotEmpty) ...[
            const SizedBox(width: AppTopHeaderTokens.instrumentGap),
            _TopChromeActionRow(actions: actions),
          ],
        ],
      ),
    );
  }
}

class _TopChromeSurface extends StatelessWidget {
  const _TopChromeSurface({
    required this.transparent,
    required this.minHeight,
    required this.padding,
    required this.child,
  });

  final bool transparent;
  final double minHeight;
  final EdgeInsetsGeometry padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: transparent
            ? AppTopHeaderTokens.transparentSurfaceColor
            : AppTopHeaderTokens.surfaceColor,
        shape: transparent
            ? const Border()
            : const Border(
                bottom: BorderSide(color: AppTopHeaderTokens.dividerColor),
              ),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: minHeight),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

class _RootTitleBlock extends StatelessWidget {
  const _RootTitleBlock({required this.title, required this.subtitle});

  final String? title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Semantics(
            header: true,
            child: FittedBox(
              alignment: Alignment.centerLeft,
              fit: BoxFit.scaleDown,
              child: Text(
                title!,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.visible,
                style: AppTextStyles.pageTitle,
              ),
            ),
          ),
        if (subtitle != null && subtitle!.isNotEmpty) ...[
          const SizedBox(height: AppTopHeaderTokens.titleGap),
          FittedBox(
            alignment: Alignment.centerLeft,
            fit: BoxFit.scaleDown,
            child: Text(
              subtitle!,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.visible,
              style: AppTextStyles.caption,
            ),
          ),
        ],
      ],
    );
  }
}

class _InstrumentTitleBlock extends StatelessWidget {
  const _InstrumentTitleBlock({required this.title, required this.subtitle});

  final String? title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          FittedBox(
            alignment: Alignment.centerLeft,
            fit: BoxFit.scaleDown,
            child: Text(
              title!,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.visible,
              style: AppTextStyles.sectionTitle,
            ),
          ),
        if (subtitle != null && subtitle!.isNotEmpty)
          FittedBox(
            alignment: Alignment.centerLeft,
            fit: BoxFit.scaleDown,
            child: Text(
              subtitle!,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.visible,
              style: AppTextStyles.micro,
            ),
          ),
      ],
    );
  }
}

class _TopChromeBackButton extends StatelessWidget {
  const _TopChromeBackButton({this.buttonKey, required this.onPressed});

  final Key? buttonKey;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return VitHeaderActionButton(
      key: buttonKey,
      type: VitHeaderActionType.back,
      tone: VitHeaderActionTone.transparent,
      onPressed: onPressed,
    );
  }
}

class _TopChromeActionRow extends StatelessWidget {
  const _TopChromeActionRow({required this.actions});

  final List<VitHeaderActionItem> actions;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var index = 0; index < actions.length; index++) ...[
          if (index > 0) const SizedBox(width: AppTopHeaderTokens.actionGap),
          VitHeaderActionButton.fromItem(actions[index]),
        ],
      ],
    );
  }
}
