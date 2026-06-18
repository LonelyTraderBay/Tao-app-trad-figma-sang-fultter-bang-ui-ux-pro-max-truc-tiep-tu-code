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
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';

part 'advanced_charts_page_part_01.dart';
part 'advanced_charts_page_part_02.dart';
part 'advanced_charts_page_part_03.dart';

const _marketPrimary = AppColors.primary;

class AdvancedChartsPage extends ConsumerStatefulWidget {
  const AdvancedChartsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc023_advanced_charts_scroll_content');
  static const indicatorsTabKey = Key('sc023_tab_indicators');
  static const drawingTabKey = Key('sc023_tab_drawing');
  static const signalsTabKey = Key('sc023_tab_signals');
  static const clearAllKey = Key('sc023_clear_all');
  static const categoryAllKey = Key('sc023_category_all');
  static const categoryTrendKey = Key('sc023_category_trend');
  static const drawingLineKey = Key('sc023_drawing_category_line');

  static Key indicatorKey(String id) => Key('sc023_indicator_$id');
  static Key indicatorToggleKey(String id) => Key('sc023_indicator_toggle_$id');
  static Key drawingToolKey(String id) => Key('sc023_drawing_tool_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<AdvancedChartsPage> createState() => _AdvancedChartsPageState();
}
