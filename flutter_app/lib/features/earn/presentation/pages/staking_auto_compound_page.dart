import 'dart:math' as math;

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

part 'staking_auto_compound_page_part_01.dart';
part 'staking_auto_compound_page_part_02.dart';
part 'staking_auto_compound_page_part_03.dart';

class StakingAutoCompoundPage extends ConsumerStatefulWidget {
  const StakingAutoCompoundPage({super.key, this.shellRenderMode});

  static const infoKey = Key('sc363_info_banner');
  static const summaryKey = Key('sc363_summary_card');
  static const settingsKey = Key('sc363_settings_card');
  static const thresholdKey = Key('sc363_threshold_field');
  static const gasOptimizationKey = Key('sc363_gas_optimization');
  static const simulationKey = Key('sc363_simulation_card');
  static const principalKey = Key('sc363_principal_field');
  static const apyKey = Key('sc363_apy_field');
  static const monthsKey = Key('sc363_months_field');
  static const saveButtonKey = Key('sc363_save_button');
  static const successToastKey = Key('sc363_success_toast');
  static const footerKey = Key('sc363_footer_note');

  static Key frequencyKey(String id) => Key('sc363_frequency_$id');

  static Key positionKey(String id) => Key('sc363_position_$id');

  static Key toggleKey(String id) => Key('sc363_toggle_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingAutoCompoundPage> createState() =>
      _StakingAutoCompoundPageState();
}
