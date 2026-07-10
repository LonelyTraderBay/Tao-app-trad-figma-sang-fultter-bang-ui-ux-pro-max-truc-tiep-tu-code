import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/earn_custody_risk_banner.dart';
import 'package:vit_trade_flutter/app/providers/earn_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';

part 'staking_analytics_page_part_01.dart';
part 'staking_analytics_page_part_02.dart';
part 'staking_analytics_page_part_03.dart';

const double _stakingAnalyticsEarningsChartHeight = 158;
const double _stakingAnalyticsChartHeight = 164;
const double _stakingAnalyticsCaptionLineHeight = 1.22;
const double _stakingAnalyticsInsightLineHeight = 1.22;
const double _stakingAnalyticsFooterLineHeight = 1.18;
const double _stakingAnalyticsLegendMarkerHeight = 6;
const EdgeInsetsDirectional _stakingAnalyticsCardPadding =
    EdgeInsetsDirectional.all(AppSpacing.x3);

class StakingAnalyticsPage extends ConsumerStatefulWidget {
  const StakingAnalyticsPage({super.key, this.shellRenderMode});

  static const summaryKey = Key('sc359_summary_card');
  static const calculateButtonKey = Key('sc359_calculate_button');
  static const exportButtonKey = Key('sc359_export_button');
  static const tabBarKey = Key('sc359_tab_bar');
  static const earningsChartKey = Key('sc359_earnings_chart');
  static const assetGridKey = Key('sc359_asset_grid');
  static const calculatorKey = Key('sc359_calculator');
  static const apyChartKey = Key('sc359_apy_chart');
  static const roiChartKey = Key('sc359_roi_chart');
  static const productListKey = Key('sc359_product_list');

  static Key assetKey(String asset) => Key('sc359_asset_$asset');
  static Key productKey(String asset) => Key('sc359_product_$asset');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingAnalyticsPage> createState() =>
      _StakingAnalyticsPageState();
}
