import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/rewards_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
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
import 'package:vit_trade_flutter/app/theme/spacing/arena_spacing_tokens.dart';

part 'rewards_hub_page_part_01.dart';
part 'rewards_hub_page_part_02.dart';
part 'rewards_hub_page_part_03.dart';

class RewardsHubPage extends ConsumerStatefulWidget {
  const RewardsHubPage({super.key, this.shellRenderMode, this.initialFilter});

  static const contentKey = Key('sc319_rewards_content');
  static const claimAllKey = Key('sc319_claim_all');
  static const referralKey = Key('sc319_referral');
  static const leaderboardKey = Key('sc319_leaderboard_all');
  static const emptyKey = Key('sc319_rewards_empty');
  static const loadingKey = Key('sc319_rewards_loading');
  static const errorKey = Key('sc319_rewards_error');
  static const offlineKey = Key('sc319_rewards_offline');

  static Key filterKey(String label) => Key('sc319_filter_$label');
  static Key activeFilterKey(String label) => Key('sc319_active_filter_$label');
  static Key taskKey(String id) => Key('sc319_task_$id');

  final ShellRenderMode? shellRenderMode;
  final String? initialFilter;

  @override
  ConsumerState<RewardsHubPage> createState() => _RewardsHubPageState();
}

String _formatRewardPoints(int value) {
  if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
  return value.toString();
}
