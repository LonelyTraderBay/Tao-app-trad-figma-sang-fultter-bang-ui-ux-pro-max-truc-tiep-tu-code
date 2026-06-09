import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_high_risk_state_panel.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

part 'market_data_analytics_page_part_01.dart';
part 'market_data_analytics_page_part_02.dart';
part 'market_data_analytics_page_part_03.dart';
part 'market_data_analytics_page_part_04.dart';

const _analyticsBackground = AppColors.bg;
const _analyticsPanel2 = AppColors.surface2;
const _analyticsSurface3 = AppColors.surfaceNavyDeep;
const _analyticsBorder = AppColors.analyticsBorder;
const _analyticsPrimary = AppColors.primary;
const _analyticsGreen = AppColors.buy;
const _analyticsRed = AppColors.sell;
const _analyticsPurple = AppColors.accent;
const _analyticsAmber = AppColors.caution;

class MarketDataAnalyticsPage extends ConsumerStatefulWidget {
  const MarketDataAnalyticsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc089_market_data_analytics_content');
  static Key tabKey(String id) => Key('sc089_market_tab_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<MarketDataAnalyticsPage> createState() =>
      _MarketDataAnalyticsPageState();
}
