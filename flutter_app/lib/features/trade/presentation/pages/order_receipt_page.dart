import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

import '../widgets/trade_body_review_widgets.dart';

part '../widgets/order_receipt_page_sections.dart';
part '../widgets/order_receipt_page_common.dart';

const _tradePrimary = AppColors.primary;
const _footerBackground = AppColors.surface;
const double _receiptFramedScrollClearance =
    AppSpacing.buttonStandard + AppSpacing.x7;
const double _receiptNativeScrollClearance =
    AppSpacing.buttonStandard + AppSpacing.x5;
const double _receiptFramedFooterClearance =
    AppSpacing.buttonStandard + AppSpacing.x5;
const double _receiptNativeFooterClearance =
    AppSpacing.buttonStandard + AppSpacing.x3;
const double _receiptHeroExtent = AppSpacing.buttonCompact + AppSpacing.x3;
const double _receiptCopyActionExtent = AppSpacing.buttonCompact;

class OrderReceiptPage extends ConsumerStatefulWidget {
  const OrderReceiptPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc051_order_receipt_content');
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
    final footerSafePadding =
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame
            ? _receiptFramedFooterClearance
            : _receiptNativeFooterClearance);
    final scrollEndClearance =
        (mode.usesVisualQaFrame
            ? _receiptFramedScrollClearance
            : _receiptNativeScrollClearance) +
        footerSafePadding;

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
                child: VitInsetScrollView(
                  key: OrderReceiptPage.contentKey,
                  bottomInset: scrollEndClearance,
                  child: VitPageContent(
                    padding: VitContentPadding.compact,
                    density: VitDensity.compact,
                    children: [
                      _SuccessHero(receipt: receipt),
                      const VitCard(
                        variant: VitCardVariant.inner,
                        padding: EdgeInsetsDirectional.symmetric(
                          horizontal: AppSpacing.x3,
                          vertical: AppSpacing.x2,
                        ),
                        child: VitHighRiskStatePanel(
                          state: VitHighRiskUiState.success,
                          title: 'Order receipt confirmed',
                          message:
                              'Order id, fill status, fees, risk impact, support path and next steps are available after execution.',
                          contractId: 'order-receipt-success',
                          density: VitDensity.compact,
                        ),
                      ),
                      _ReceiptCard(receipt: receipt),
                      _WarningNotice(),
                      _OrderSupportLink(supportRoute: snapshot.supportRoute),
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
                bottomPadding: footerSafePadding,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
