import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/shared/widgets/vit_notice_sheet.dart';

/// [VitBanner] preconfigured for the offline/reconnecting state, swapping
/// icon and message automatically based on [reconnecting].
class VitOfflineBanner extends StatelessWidget {
  const VitOfflineBanner({
    super.key,
    this.variant = VitBannerVariant.warning,
    this.message = 'Offline. Showing latest cached data.',
    this.detail,
    this.reconnecting = false,
  });

  final VitBannerVariant variant;
  final String message;
  final String? detail;
  final bool reconnecting;

  @override
  Widget build(BuildContext context) {
    return VitBanner(
      variant: reconnecting ? VitBannerVariant.info : variant,
      icon: reconnecting ? Icons.wifi_rounded : Icons.wifi_off_rounded,
      message: reconnecting ? 'Reconnecting...' : message,
      detail: reconnecting ? 'Retrying automatically.' : detail,
    );
  }
}
