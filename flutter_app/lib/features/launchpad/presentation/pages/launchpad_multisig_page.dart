import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/accent_tone_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/launchpad_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/launchpad_spacing_tokens.dart';

part 'launchpad_multisig_page_part_01.dart';
part 'launchpad_multisig_page_part_02.dart';
part 'launchpad_multisig_page_part_03.dart';

enum _MultisigTab { queue, history, safes }

class LaunchpadMultisigPage extends ConsumerStatefulWidget {
  const LaunchpadMultisigPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc313_launchpad_multisig_content');
  static const safeSelectorKey = Key('sc313_launchpad_multisig_safes');
  static const statsKey = Key('sc313_launchpad_multisig_stats');
  static const tabsKey = Key('sc313_launchpad_multisig_tabs');
  static const createKey = Key('sc313_launchpad_multisig_create');
  static const queueKey = Key('sc313_launchpad_multisig_queue');
  static const historyKey = Key('sc313_launchpad_multisig_history');
  static const ownersKey = Key('sc313_launchpad_multisig_owners');
  static const noticeKey = Key('sc313_launchpad_multisig_notice');
  static const createSheetKey = Key('sc313_launchpad_multisig_create_sheet');
  static const submitCreateKey = Key('sc313_launchpad_multisig_submit');
  static const cancelCreateKey = Key('sc313_launchpad_multisig_cancel');
  static const signKey = Key('sc313_launchpad_multisig_sign');
  static const executeKey = Key('sc313_launchpad_multisig_execute');

  static Key safeKey(String address) =>
      Key('sc313_launchpad_multisig_safe_$address');
  static Key txKey(String id) => Key('sc313_launchpad_multisig_tx_$id');
  static Key txToggleKey(String id) =>
      Key('sc313_launchpad_multisig_toggle_$id');
  static Key copyKey(String id, String field) =>
      Key('sc313_launchpad_multisig_copy_${id}_$field');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<LaunchpadMultisigPage> createState() =>
      _LaunchpadMultisigPageState();
}
