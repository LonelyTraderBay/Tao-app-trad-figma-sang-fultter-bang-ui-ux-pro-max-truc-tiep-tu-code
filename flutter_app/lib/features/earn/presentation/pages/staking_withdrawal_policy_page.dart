import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
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

const double _stakingWithdrawalVisualNavClearance = 112;
const double _stakingWithdrawalNativeNavClearance = 88;
const double _stakingWithdrawalInfoMinHeight = 88;
const double _stakingWithdrawalTabMinHeight = AppSpacing.inputHeight;
const double _stakingWithdrawalBorderWidth = AppSpacing.hairlineStroke;
const double _stakingWithdrawalInfoIcon = AppSpacing.iconMd;
const double _stakingWithdrawalProcessIconBox = AppSpacing.inputHeight;
const double _stakingWithdrawalProcessIcon = AppSpacing.iconSm;
const double _stakingWithdrawalTimelineMinHeight = 96;
const double _stakingWithdrawalTimelineMinHeightTall = 116;
const double _stakingWithdrawalEmergencyIconBox = AppSpacing.inputHeight;
const double _stakingWithdrawalEmergencyStepBox = AppSpacing.x6;
const double _stakingWithdrawalTimerIcon = AppSpacing.iconSm;
const double _stakingWithdrawalFeeTileWidth = 156;
const double _stakingWithdrawalFeeTileMinHeight = 68;
const double _stakingWithdrawalFormulaIcon = AppSpacing.iconSm;
const double _stakingWithdrawalSheetHandleWidth = AppSpacing.inputHeight;
const double _stakingWithdrawalSheetHandleHeight = AppSpacing.x1;
const double _stakingWithdrawalNoticeIcon = AppSpacing.iconSm;
const double _stakingWithdrawalBulletSize =
    AppSpacing.x1 + AppSpacing.hairlineStroke;
const double _stakingWithdrawalInfoLineHeight = 1.35;
const double _stakingWithdrawalProcessLineHeight = 1.3;
const double _stakingWithdrawalTimelineValueLineHeight = 1.25;
const double _stakingWithdrawalPenaltyBodyLineHeight = 1.4;
const double _stakingWithdrawalEmergencyStepLineHeight = 1.28;
const double _stakingWithdrawalFeeLineHeight = 1.2;
const double _stakingWithdrawalNoticeLineHeight = 1.3;
const double _stakingWithdrawalBulletLineHeight = 1.3;
const double _stakingWithdrawalBadgeLineHeight = 1.15;
const EdgeInsets _stakingWithdrawalCardPadding = EdgeInsets.all(AppSpacing.x3);
const EdgeInsets _stakingWithdrawalBulletPadding = EdgeInsets.only(
  top: AppSpacing.x2,
);
const EdgeInsets _stakingWithdrawalBadgePadding = EdgeInsets.symmetric(
  horizontal: AppSpacing.x2,
  vertical: AppSpacing.x1,
);

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
