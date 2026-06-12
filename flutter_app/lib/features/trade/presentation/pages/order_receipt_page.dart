import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

import '../widgets/trade_body_review_widgets.dart';

part '../widgets/order_receipt_page_sections.dart';
part '../widgets/order_receipt_page_common.dart';

const _tradePrimary = AppColors.primary;
const _cardBackground = AppColors.surface2;
const _footerBackground = AppColors.surface;

class OrderReceiptPage extends ConsumerStatefulWidget {
  const OrderReceiptPage({super.key, this.shellRenderMode});

  static const openOrdersKey = Key('sc051_open_orders');
  static const copyOrderIdKey = Key('sc051_copy_order_id');
  static const shareKey = Key('sc051_share');
  static const continueTradingKey = Key('sc051_continue_trading');
  static const supportKey = Key('sc051_support');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<OrderReceiptPage> createState() => _OrderReceiptPageState();
}

class _OrderReceiptPageState extends ConsumerState<OrderReceiptPage> {
  bool _sharePressed = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getOrderReceipt();
    final receipt = snapshot.receipt;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-051 OrderReceiptPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Chi tiết lệnh',
            showBack: true,
            onBack: () =>
                goBackOrFallback(context, fallbackPath: AppRoutePaths.trade),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(
                    bottom: AppSpacing.tradeReceiptScrollBottom,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _SuccessHero(receipt: receipt),
                      const VitCard(
                        variant: VitCardVariant.inner,
                        padding: AppSpacing.tradeReceiptRiskPadding,
                        child: VitHighRiskStatePanel(
                          state: VitHighRiskUiState.success,
                          title: 'Order receipt confirmed',
                          message:
                              'Order id, fill status, fees, risk impact, support path and next steps are available after execution.',
                          contractId: 'order-receipt-success',
                        ),
                      ),
                      _ReceiptCard(receipt: receipt),
                      const SizedBox(height: AppSpacing.tradeSectionGap),
                      _WarningNotice(),
                      const SizedBox(height: AppSpacing.tradeReceiptFooterGap),
                      _OrderSupportLink(supportRoute: snapshot.supportRoute),
                      const SizedBox(height: AppSpacing.tradeReceiptFooterGap),
                      const TradeBodyReviewSection(
                        title: 'Receipt body review',
                        message: 'Order receipt body reviewed',
                        detail:
                            'Fill status, fees, risk impact, support, copy, share, and next-step states stay visible.',
                        primary:
                            'Execution success remains above receipt details and warnings.',
                        secondary:
                            'Support path stays visible before footer actions.',
                        tertiary:
                            'Continue-trading CTA remains separated from receipt verification.',
                      ),
                    ],
                  ),
                ),
              ),
              _ReceiptFooter(
                sharePressed: _sharePressed,
                onShare: () => setState(() => _sharePressed = true),
                onContinue: () =>
                    context.go(AppRoutePaths.tradePair('btcusdt')),
              ),
              SizedBox(height: bottomChrome),
            ],
          ),
        ),
      ),
    );
  }
}
