import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

part 'regulatory_reports_dashboard_page_part_01.dart';
part 'regulatory_reports_dashboard_page_part_02.dart';
part 'regulatory_reports_dashboard_page_part_03.dart';

const _dashBackground = AppColors.bg;
const _dashPanel2 = AppColors.surface2;
const _dashBorder = AppColors.borderSolid;
const _dashGreen = AppColors.buy;
const _dashRed = AppColors.sell;
const _dashAmber = AppColors.caution;
const _dashPrimary = AppColors.primary;

class RegulatoryReportsDashboardPage extends ConsumerStatefulWidget {
  const RegulatoryReportsDashboardPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc094_regulatory_reports_content');
  static const kpiGridKey = Key('sc094_regulatory_reports_kpi_grid');
  static Key tabKey(String id) => Key('sc094_regulatory_tab_$id');
  static Key rangeKey(String id) => Key('sc094_regulatory_range_$id');
  static Key actionKey(String id) => Key('sc094_regulatory_action_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<RegulatoryReportsDashboardPage> createState() =>
      _RegulatoryReportsDashboardPageState();
}
