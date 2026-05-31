import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class ArenaModeActions extends StatelessWidget {
  const ArenaModeActions({
    super.key,
    required this.useModeKey,
    required this.createRoomKey,
    required this.onUseMode,
    required this.onCreateRoom,
  });

  final Key useModeKey;
  final Key createRoomKey;
  final VoidCallback onUseMode;
  final VoidCallback onCreateRoom;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCtaButton(
          key: useModeKey,
          onPressed: onUseMode,
          child: const Text('Dùng mode này'),
        ),
        const SizedBox(height: AppSpacing.x3),
        VitCtaButton(
          key: createRoomKey,
          onPressed: onCreateRoom,
          variant: VitCtaButtonVariant.secondary,
          child: const Text('Tạo room mới'),
        ),
      ],
    );
  }
}
