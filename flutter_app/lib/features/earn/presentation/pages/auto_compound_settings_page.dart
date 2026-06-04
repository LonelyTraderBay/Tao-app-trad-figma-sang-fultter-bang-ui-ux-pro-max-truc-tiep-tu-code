import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
import 'package:vit_trade_flutter/app/providers/earn_controller_providers.dart';

part 'auto_compound_settings_page_part_01.dart';
part 'auto_compound_settings_page_part_02.dart';
part 'auto_compound_settings_page_part_03.dart';

class AutoCompoundSettingsPage extends ConsumerStatefulWidget {
  const AutoCompoundSettingsPage({super.key, this.shellRenderMode});

  static const summaryKey = Key('sc341_summary');
  static const infoButtonKey = Key('sc341_info_button');
  static const infoSheetKey = Key('sc341_info_sheet');
  static const saveButtonKey = Key('sc341_save_button');
  static const successToastKey = Key('sc341_success_toast');
  static const calculatorKey = Key('sc341_calculator');

  static Key positionKey(String id) => Key('sc341_position_$id');
  static Key toggleKey(String id) => Key('sc341_toggle_$id');
  static Key settingsButtonKey(String id) => Key('sc341_settings_$id');
  static Key frequencyKey(String id) => Key('sc341_frequency_$id');
  static Key thresholdKey(double value) => Key('sc341_threshold_$value');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<AutoCompoundSettingsPage> createState() =>
      _AutoCompoundSettingsPageState();
}
