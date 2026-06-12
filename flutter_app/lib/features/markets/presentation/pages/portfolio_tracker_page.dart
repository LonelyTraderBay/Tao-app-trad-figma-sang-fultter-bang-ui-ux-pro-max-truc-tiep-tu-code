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
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';
import '../widgets/market_body_review_widgets.dart';

part 'portfolio_tracker_page_part_01.dart';
part 'portfolio_tracker_page_part_02.dart';
part 'portfolio_tracker_page_part_03.dart';

const _marketPrimary = AppColors.primary;
const _heroPrimary = AppColors.heroNavy;

class PortfolioTrackerPage extends ConsumerStatefulWidget {
  const PortfolioTrackerPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc021_portfolio_tracker_scroll_content');
  static const overviewTabKey = Key('sc021_tab_overview');
  static const assetsTabKey = Key('sc021_tab_assets');
  static const performanceTabKey = Key('sc021_tab_performance');
  static const hideBalanceKey = Key('sc021_hide_balance');

  static Key sortKey(MarketPortfolioSort sort) =>
      Key('sc021_sort_${sort.name}');

  static Key holdingKey(String id) => Key('sc021_holding_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PortfolioTrackerPage> createState() =>
      _PortfolioTrackerPageState();
}
