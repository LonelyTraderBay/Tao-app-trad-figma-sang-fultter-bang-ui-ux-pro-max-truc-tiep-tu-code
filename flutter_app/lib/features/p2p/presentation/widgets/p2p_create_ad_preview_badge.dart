import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_accent_pill.dart';

class P2PCreateAdPreviewBadge extends StatelessWidget {
  const P2PCreateAdPreviewBadge({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return VitAccentPill(
      label: label,
      accentColor: AppColors.buy,
    );
  }
}
