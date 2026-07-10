import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/launchpad_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/accent_tone_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/launchpad_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';

part 'launchpad_staking_page_part_01.dart';
part 'launchpad_staking_page_part_02.dart';
part 'launchpad_staking_page_part_03.dart';

class LaunchpadStakingPage extends ConsumerStatefulWidget {
  const LaunchpadStakingPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc298_launchpad_staking_content');
  static const heroKey = Key('sc298_launchpad_staking_hero');
  static const tabsKey = Key('sc298_launchpad_staking_tabs');
  static const batchClaimKey = Key('sc298_launchpad_staking_batch_claim');
  static const calculatorKey = Key('sc298_launchpad_staking_calculator');
  static const disclaimerKey = Key('sc298_launchpad_staking_disclaimer');

  static Key tabKey(String id) => Key('sc298_launchpad_staking_tab_$id');
  static Key poolKey(String id) => Key('sc298_launchpad_staking_pool_$id');
  static Key positionKey(String id) =>
      Key('sc298_launchpad_staking_position_$id');
  static Key claimKey(String id) => Key('sc298_launchpad_staking_claim_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<LaunchpadStakingPage> createState() =>
      _LaunchpadStakingPageState();
}
