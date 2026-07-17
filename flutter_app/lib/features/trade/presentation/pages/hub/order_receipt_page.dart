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
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_formatters.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_compliance_hero.dart';

part '../../widgets/hub/order_receipt_page_sections.dart';
part '../../widgets/hub/order_receipt_page_common.dart';

const _footerBackground = AppColors.surface;
const double _receiptFramedFooterClearance =
    AppSpacing.buttonStandard + AppSpacing.x5;
const double _receiptNativeFooterClearance =
    AppSpacing.buttonStandard + AppSpacing.x3;
const double _receiptCopyActionExtent = AppSpacing.buttonCompact;
const double _receiptFooterHeight = AppSpacing.buttonStandard + AppSpacing.x4;

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
        tradeScrollBottomInset(context, shellRenderMode: mode) +
        _receiptFooterHeight +
        footerSafePadding;
    final sideLabel = receipt.side == TradeOrderSide.buy ? 'Mua' : 'Bán';

    return VitTradeDetailScaffold(
      title: 'Chi tiết lệnh',
      semanticLabel: 'Chi tiết lệnh giao dịch',
      semanticIdentifier: 'SC-051',
      contentKey: OrderReceiptPage.contentKey,
      shellRenderMode: mode,
      bottomInset: scrollEndClearance,
      showProductTabs: false,
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.trade,
        mode: BackNavigationMode.historyThenFallback,
      ),
      footer: _ReceiptFooter(
        sharePressed: _sharePressed,
        onShare: () => setState(() => _sharePressed = true),
        onContinue: () => context.go(AppRoutePaths.tradePair('btcusdt')),
        bottomPadding: footerSafePadding,
      ),
      children: [
        VitTradeComplianceHero(
          title: 'Đặt lệnh thành công!',
          description: 'Lệnh $sideLabel ${receipt.symbol} đang được xử lý',
          icon: Icons.check_circle_outline_rounded,
          accentColor: AppColors.buy,
        ),
        _ReceiptCard(receipt: receipt),
        VitTradeSection(title: 'Lưu ý', child: _WarningNotice()),
        VitTradeSection(
          title: 'Hỗ trợ',
          child: _OrderSupportLink(supportRoute: snapshot.supportRoute),
        ),
      ],
    );
  }
}
