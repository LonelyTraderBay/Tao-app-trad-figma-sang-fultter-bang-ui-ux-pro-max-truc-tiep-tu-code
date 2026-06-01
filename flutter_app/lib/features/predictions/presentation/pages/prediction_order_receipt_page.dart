import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/predictions_controller_providers.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/controllers/predictions_controller.dart';

part '../widgets/prediction_order_receipt_page_sections.dart';
part '../widgets/prediction_order_receipt_page_common.dart';

const _predictionPrimary = AppColors.primary;

class PredictionOrderReceiptPage extends ConsumerWidget {
  const PredictionOrderReceiptPage({
    super.key,
    required this.receiptId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc035_prediction_receipt_content');
  static const missingReceiptKey = Key('sc035_prediction_receipt_missing');
  static const shareKey = Key('sc035_share_receipt');
  static const viewEventKey = Key('sc035_view_event');
  static const viewPortfolioKey = Key('sc035_view_portfolio');

  final String receiptId;
  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref
        .watch(predictionsReadModelControllerProvider)
        .getOrderReceipt(receiptId);
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 54 : 20);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-035 PredictionOrderReceiptPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Chi tiết lệnh',
              subtitle: 'Biên lai · Prediction',
              showBack: true,
              onBack: () =>
                  context.go(AppRoutePaths.marketsPredictionsPortfolio),
            ),
            Expanded(
              child: snapshot.found
                  ? _ReceiptContent(
                      snapshot: snapshot,
                      bottomInset: bottomInset,
                    )
                  : _MissingReceipt(bottomInset: bottomInset),
            ),
          ],
        ),
      ),
    );
  }
}
