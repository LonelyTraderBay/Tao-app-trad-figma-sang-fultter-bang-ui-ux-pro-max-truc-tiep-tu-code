import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
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
import 'package:vit_trade_flutter/app/providers/arena_controller_providers.dart';
import 'package:vit_trade_flutter/features/arena/presentation/controllers/arena_controller.dart';

part 'arena_points_page_part_01.dart';
part 'arena_points_page_part_02.dart';
part 'arena_points_page_part_03.dart';

class ArenaPointsPage extends ConsumerStatefulWidget {
  const ArenaPointsPage({
    super.key,
    this.shellRenderMode,
    this.snapshotOverride,
    this.semanticLabel = 'SC-196 ArenaPointsPage',
    this.backRoute = AppRoutePaths.arena,
    this.referralRoute = AppRoutePaths.referral,
    this.leaderboardRoute = AppRoutePaths.arenaLeaderboard,
    this.initialFilter,
  });

  static const contentKey = Key('sc196_arena_points_content');
  static const claimAllKey = Key('sc196_claim_all');
  static const referralKey = Key('sc196_referral');
  static const leaderboardKey = Key('sc196_leaderboard_all');

  static Key filterKey(String label) => Key('sc196_filter_$label');
  static Key activeFilterKey(String label) => Key('sc196_active_filter_$label');
  static Key taskKey(String id) => Key('sc196_task_$id');

  final ShellRenderMode? shellRenderMode;
  final ArenaPointsSnapshot? snapshotOverride;
  final String semanticLabel;
  final String backRoute;
  final String referralRoute;
  final String leaderboardRoute;
  final String? initialFilter;

  @override
  ConsumerState<ArenaPointsPage> createState() => _ArenaPointsPageState();
}
