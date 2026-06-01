import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

part 'trade_page_part_01.dart';
part 'trade_page_part_02.dart';
part 'trade_page_part_03.dart';

const _tradePrimary = AppColors.primary;
const _fieldBackground = AppColors.surface2;

enum TradeChartVariant { defaultRoute, pairRoute }

class TradePage extends ConsumerStatefulWidget {
  const TradePage({
    super.key,
    this.pairId = 'btcusdt',
    this.chartVariant = TradeChartVariant.defaultRoute,
    this.initialSide = TradeOrderSide.buy,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc048_trade_scroll_content');
  static const chartTabKey = Key('sc048_trade_chart_tab');
  static const orderBookTabKey = Key('sc048_trade_orderbook_tab');
  static const tradesTabKey = Key('sc048_trade_trades_tab');
  static const orderTabKey = Key('sc048_trade_order_tab');
  static const openOrdersTabKey = Key('sc048_trade_open_orders_tab');
  static const historyTabKey = Key('sc048_trade_history_tab');
  static const buySideKey = Key('sc048_trade_buy_side');
  static const sellSideKey = Key('sc048_trade_sell_side');
  static const amountFieldKey = Key('sc048_trade_amount_field');
  static const submitKey = Key('sc048_trade_submit');

  static Key orderTypeKey(TradeOrderType type) =>
      Key('sc048_order_${type.name}');
  static Key quickNavKey(String id) => Key('sc048_quick_$id');
  static Key pctKey(int pct) => Key('sc048_pct_$pct');

  final String pairId;
  final TradeChartVariant chartVariant;
  final TradeOrderSide initialSide;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<TradePage> createState() => _TradePageState();
}
