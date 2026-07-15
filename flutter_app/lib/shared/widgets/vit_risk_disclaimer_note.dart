import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';

/// A centered, muted compliance note (e.g. risk/product-boundary disclaimers)
/// with an optional distinct Semantics label for assistive tech.
class VitRiskDisclaimerNote extends StatelessWidget {
  const VitRiskDisclaimerNote({
    super.key,
    required this.message,
    this.semanticsLabel,
    this.height,
  });

  final String message;
  final String? semanticsLabel;

  /// Optional line-height override applied to the caption style.
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticsLabel ?? message,
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          height: height,
        ),
      ),
    );
  }
}
