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

part 'staking_withdrawal_policy_page_part_01.dart';
part 'staking_withdrawal_policy_page_part_02.dart';
part 'staking_withdrawal_policy_page_part_03.dart';

class StakingWithdrawalPolicyPage extends ConsumerStatefulWidget {
  const StakingWithdrawalPolicyPage({super.key, this.shellRenderMode});

  static const infoKey = Key('sc355_withdrawal_info');
  static const processKey = Key('sc355_withdrawal_process');
  static const calculatorCtaKey = Key('sc355_withdrawal_calculator_cta');
  static const calculatorResultKey = Key('sc355_withdrawal_calculator_result');
  static const emergencyKey = Key('sc355_withdrawal_emergency');

  static Key tabKey(String id) => Key('sc355_withdrawal_tab_$id');
  static Key timelineKey(String product) =>
      Key('sc355_withdrawal_timeline_$product');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingWithdrawalPolicyPage> createState() =>
      _StakingWithdrawalPolicyPageState();
}
