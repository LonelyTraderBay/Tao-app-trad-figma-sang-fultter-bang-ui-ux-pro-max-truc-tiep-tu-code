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
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_controller_providers.dart';

part 'staking_insurance_page_part_01.dart';
part 'staking_insurance_page_part_02.dart';
part 'staking_insurance_page_part_03.dart';

enum _InsuranceTab { overview, plans, positions, claims }

class StakingInsurancePage extends ConsumerStatefulWidget {
  const StakingInsurancePage({super.key, this.shellRenderMode});

  static const infoKey = Key('sc365_info_banner');
  static const tabsKey = Key('sc365_tabs');
  static const overviewSummaryKey = Key('sc365_overview_summary');
  static const benefitsKey = Key('sc365_benefits');
  static const warningKey = Key('sc365_warning');
  static const planSheetKey = Key('sc365_plan_sheet');
  static const claimSheetKey = Key('sc365_claim_sheet');
  static const positionsKey = Key('sc365_positions');
  static const claimsKey = Key('sc365_claims');

  static Key tabKey(String id) => Key('sc365_tab_$id');

  static Key planKey(String id) => Key('sc365_plan_$id');

  static Key positionKey(String id) => Key('sc365_position_$id');

  static Key claimKey(String id) => Key('sc365_claim_$id');

  static Key addInsuranceKey(String id) => Key('sc365_add_insurance_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingInsurancePage> createState() =>
      _StakingInsurancePageState();
}
