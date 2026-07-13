import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class TransactionReportingNoticePanel extends StatelessWidget {
  const TransactionReportingNoticePanel({
    required this.text,
    required this.onClose,
    super.key,
  });

  final String text;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: AppSpacing.contentPad,
      right: AppSpacing.contentPad,
      bottom:
          AppSpacing.bottomNavCapsuleHeightVisual +
          AppSpacing.x7 +
          MediaQuery.paddingOf(context).bottom,
      child: VitBanner(
        variant: VitBannerVariant.success,
        message: text,
        onDismiss: onClose,
      ),
    );
  }
}
