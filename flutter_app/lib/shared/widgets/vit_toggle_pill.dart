import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';

/// Custom pill-shaped switch: animated knob position with configurable
/// colors, optionally tappable when [onChanged] is provided.
class VitTogglePill extends StatelessWidget {
  const VitTogglePill({
    super.key,
    required this.enabled,
    this.width = SharedSpacingTokens.walletAddressSwitchWidth,
    this.height = SharedSpacingTokens.walletAddressSwitchHeight,
    this.knobSize = SharedSpacingTokens.walletAddressSwitchKnob,
    this.knobMargin = SharedSpacingTokens.walletAddressSwitchKnobMargin,
    this.activeColor = AppColors.buy,
    this.inactiveColor = AppColors.surface2,
    this.activeKnobColor = AppColors.onAccent,
    this.inactiveKnobColor = AppColors.textDisabledBlue,
    this.inactiveBorderColor = AppColors.borderSolid,
    this.duration = const Duration(milliseconds: 160),
    this.onChanged,
    this.semanticLabel,
  });

  final bool enabled;
  final double width;
  final double height;
  final double knobSize;
  final EdgeInsetsGeometry knobMargin;
  final Color activeColor;
  final Color inactiveColor;
  final Color activeKnobColor;
  final Color inactiveKnobColor;
  final Color inactiveBorderColor;
  final Duration duration;

  /// When non-null, wraps the pill in a tappable, toggle-semantics region.
  /// Leave null to keep the current presentation-only (no tap) behavior.
  final ValueChanged<bool>? onChanged;

  /// Accessibility label applied when [onChanged] is non-null.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final pill = _buildPill();
    final changed = onChanged;
    if (changed == null) {
      return pill;
    }
    return Semantics(
      label: semanticLabel,
      toggled: enabled,
      button: true,
      child: GestureDetector(onTap: () => changed(!enabled), child: pill),
    );
  }

  Widget _buildPill() {
    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: enabled ? activeColor : inactiveColor,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: enabled ? activeColor : inactiveBorderColor,
            ),
            borderRadius: AppRadii.inputRadius,
          ),
        ),
        child: AnimatedAlign(
          alignment: enabled ? Alignment.centerRight : Alignment.centerLeft,
          duration: duration,
          child: Padding(
            padding: knobMargin,
            child: SizedBox(
              width: knobSize,
              height: knobSize,
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  color: enabled ? activeKnobColor : inactiveKnobColor,
                  shape: const CircleBorder(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
