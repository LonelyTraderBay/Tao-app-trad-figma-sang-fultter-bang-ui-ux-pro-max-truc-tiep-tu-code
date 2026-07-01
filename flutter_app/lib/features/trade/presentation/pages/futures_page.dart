import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/vit_trade_terminal_layout.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

part 'futures_page_part_01.dart';
part 'futures_page_part_02.dart';
part 'futures_page_part_03.dart';

const _tradePrimary = AppColors.primary;
const _futuresRed = AppColors.sell;
const _futuresGreen = AppColors.buy;

class FuturesPage extends ConsumerStatefulWidget {
  const FuturesPage({super.key, required this.pairId, this.shellRenderMode});

  static const closeKey = Key('sc057_close');
  static const chartKey = Key('sc057_chart');
  static const viewModeChartsKey = Key('sc057_view_charts');
  static const viewModeTradeKey = Key('sc057_view_trade');
  static const orderBookTabKey = Key('sc057_orderbook_tab');
  static const tradesTabKey = Key('sc057_trades_tab');
  static const leverageKey = Key('sc057_leverage');
  static const marginFieldKey = Key('sc057_margin_field');
  static const takeProfitKey = Key('sc057_take_profit');
  static const stopLossKey = Key('sc057_stop_loss');
  static const submitKey = Key('sc057_submit');
  static const portfolioExpandKey = Key('sc057_portfolio_expand');

  static Key tabKey(String id) => Key('sc057_tab_$id');
  static Key sideKey(String id) => Key('sc057_side_$id');
  static Key orderTypeKey(String id) => Key('sc057_order_type_$id');
  static Key pctKey(int pct) => Key('sc057_pct_$pct');

  final String pairId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<FuturesPage> createState() => _FuturesPageState();
}
