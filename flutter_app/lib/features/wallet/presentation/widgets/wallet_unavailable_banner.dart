import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/shared/widgets/vit_offline_banner.dart';

class WalletUnavailableBanner extends StatelessWidget {
  const WalletUnavailableBanner({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return VitBanner(
      variant: VitBannerVariant.warning,
      icon: Icons.lock_outline_rounded,
      message: message,
    );
  }
}
