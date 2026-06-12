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
import 'package:vit_trade_flutter/shared/widgets/vit_status_pill.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

part 'advanced_analytics_page_part_01.dart';
part 'advanced_analytics_page_part_02.dart';
part 'advanced_analytics_page_part_03.dart';
part 'advanced_analytics_page_part_04.dart';

const _advancedBackground = AppColors.bg;
const _advancedBorder = AppColors.borderSolid;
const _advancedPrimary = AppColors.primary;
const _advancedGreen = AppColors.buy;
const _advancedRed = AppColors.sell;
const _advancedPurple = AppColors.accent;
const _advancedAmber = AppColors.caution;

class AdvancedAnalyticsPage extends ConsumerStatefulWidget {
  const AdvancedAnalyticsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc092_advanced_analytics_content');
  static Key tabKey(String id) => Key('sc092_advanced_tab_$id');
  static Key filterKey(String id) => Key('sc092_advanced_filter_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<AdvancedAnalyticsPage> createState() =>
      _AdvancedAnalyticsPageState();
}
