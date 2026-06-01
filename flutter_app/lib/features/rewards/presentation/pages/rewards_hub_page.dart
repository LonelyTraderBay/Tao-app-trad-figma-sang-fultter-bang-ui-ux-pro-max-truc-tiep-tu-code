import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/feature_bridges/rewards_arena_points_bridge.dart';
import 'package:vit_trade_flutter/app/providers/rewards_controller_providers.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

class RewardsHubPage extends ConsumerWidget {
  const RewardsHubPage({super.key, this.shellRenderMode});

  static const contentKey = RewardsArenaPointsBridge.contentKey;
  static const claimAllKey = RewardsArenaPointsBridge.claimAllKey;
  static const referralKey = RewardsArenaPointsBridge.referralKey;
  static const leaderboardKey = RewardsArenaPointsBridge.leaderboardKey;

  static Key filterKey(String label) =>
      RewardsArenaPointsBridge.filterKey(label);
  static Key taskKey(String id) => RewardsArenaPointsBridge.taskKey(id);

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(rewardsControllerProvider).getHub();

    return RewardsArenaPointsBridge(
      shellRenderMode: shellRenderMode,
      snapshot: snapshot,
    );
  }
}
