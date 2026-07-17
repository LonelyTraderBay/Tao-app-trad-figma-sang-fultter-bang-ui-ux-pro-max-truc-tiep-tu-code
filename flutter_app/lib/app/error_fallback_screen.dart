import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_error_state.dart';

/// Brand fallback rendered by [ErrorWidget.builder] in place of Flutter's
/// default red/gray error screen. Deliberately independent of Riverpod/
/// router state — a build error can happen anywhere in the tree, including
/// above any `ProviderScope`/router this app relies on.
class VitErrorFallbackScreen extends StatelessWidget {
  const VitErrorFallbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.bg,
      child: Center(
        child: VitErrorState(
          title: 'Đã xảy ra lỗi',
          message: 'Vui lòng thử lại hoặc quay lại màn trước.',
        ),
      ),
    );
  }
}
