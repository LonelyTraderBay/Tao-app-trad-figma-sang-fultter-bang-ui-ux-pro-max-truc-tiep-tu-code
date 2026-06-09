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
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

part 'futures_page_part_01.dart';
part 'futures_page_part_02.dart';
part 'futures_page_part_03.dart';

const _tradePrimary = AppColors.primary;
const _futuresRed = AppColors.sell;
const _futuresGreen = AppColors.buy;
const _panelBackground = AppColors.surface;
const _chipBackground = AppColors.surface2;
const _warningBackground = AppColors.caution10;
const _warningBorder = AppColors.caution20;

class FuturesPage extends ConsumerStatefulWidget {
  const FuturesPage({super.key, required this.pairId, this.shellRenderMode});

  static const closeKey = Key('sc057_close');
  static const chartKey = Key('sc057_chart');
  static const leverageKey = Key('sc057_leverage');
  static const marginFieldKey = Key('sc057_margin_field');
  static const takeProfitKey = Key('sc057_take_profit');
  static const stopLossKey = Key('sc057_stop_loss');
  static const submitKey = Key('sc057_submit');

  static Key tabKey(String id) => Key('sc057_tab_$id');
  static Key sideKey(String id) => Key('sc057_side_$id');
  static Key orderTypeKey(String id) => Key('sc057_order_type_$id');
  static Key pctKey(int pct) => Key('sc057_pct_$pct');

  final String pairId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<FuturesPage> createState() => _FuturesPageState();
}
