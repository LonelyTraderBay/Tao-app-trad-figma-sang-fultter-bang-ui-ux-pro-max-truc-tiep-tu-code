import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

part 'staking_liquid_staking_page_part_01.dart';
part 'staking_liquid_staking_page_part_02.dart';
part 'staking_liquid_staking_page_part_03.dart';

enum _LiquidTab { stake, swap, holdings }

class StakingLiquidStakingPage extends ConsumerStatefulWidget {
  const StakingLiquidStakingPage({super.key, this.shellRenderMode});

  static const infoKey = Key('sc364_info_banner');
  static const tabsKey = Key('sc364_tabs');
  static const detailSheetKey = Key('sc364_detail_sheet');
  static const swapCardKey = Key('sc364_swap_card');
  static const swapAmountKey = Key('sc364_swap_amount');
  static const swapSummaryKey = Key('sc364_swap_summary');
  static const holdingsKey = Key('sc364_holdings');
  static const emptyKey = Key('sc364_empty_holdings');
  static const benefitsKey = Key('sc364_benefits');

  static Key tabKey(String id) => Key('sc364_tab_$id');

  static Key tokenKey(String id) => Key('sc364_token_$id');

  static Key detailButtonKey(String id) => Key('sc364_detail_$id');

  static Key stakeButtonKey(String id) => Key('sc364_stake_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingLiquidStakingPage> createState() =>
      _StakingLiquidStakingPageState();
}
