import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
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

part 'staking_proof_of_reserves_page_part_01.dart';
part 'staking_proof_of_reserves_page_part_02.dart';
part 'staking_proof_of_reserves_page_part_03.dart';

enum _ReserveTab { overview, assets, verify }

class StakingProofOfReservesPage extends ConsumerStatefulWidget {
  const StakingProofOfReservesPage({super.key, this.shellRenderMode});

  static const infoKey = Key('sc380_info');
  static const tabsKey = Key('sc380_tabs');
  static const overviewKey = Key('sc380_overview');
  static const reserveStatusKey = Key('sc380_reserve_status');
  static const trendKey = Key('sc380_trend');
  static const auditsKey = Key('sc380_audits');
  static const assetsKey = Key('sc380_assets');
  static const verifyKey = Key('sc380_verify');
  static const verifySheetKey = Key('sc380_verify_sheet');
  static const userIdFieldKey = Key('sc380_user_id_field');
  static const balanceFieldKey = Key('sc380_balance_field');
  static const verifySubmitKey = Key('sc380_verify_submit');
  static const proofResultKey = Key('sc380_proof_result');
  static const footerKey = Key('sc380_footer');

  static Key tabKey(String id) => Key('sc380_tab_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingProofOfReservesPage> createState() =>
      _StakingProofOfReservesPageState();
}
