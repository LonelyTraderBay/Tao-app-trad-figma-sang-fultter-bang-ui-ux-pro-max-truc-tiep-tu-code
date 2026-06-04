import 'dart:math' as math;

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

part 'savings_goal_page_part_01.dart';
part 'savings_goal_page_part_02.dart';
part 'savings_goal_page_part_03.dart';

class SavingsGoalPage extends ConsumerStatefulWidget {
  const SavingsGoalPage({super.key, this.shellRenderMode});

  static const summaryKey = Key('sc342_summary');
  static const createButtonKey = Key('sc342_create_goal_button');
  static const createSheetKey = Key('sc342_create_goal_sheet');
  static const detailSheetKey = Key('sc342_goal_detail_sheet');

  static Key goalKey(String id) => Key('sc342_goal_$id');
  static Key templateKey(String id) => Key('sc342_template_$id');
  static Key tipKey(String title) => Key('sc342_tip_$title');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SavingsGoalPage> createState() => _SavingsGoalPageState();
}
