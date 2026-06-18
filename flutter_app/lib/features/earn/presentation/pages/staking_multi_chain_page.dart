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

part '../widgets/staking_multi_chain_page_sections.dart';
part '../widgets/staking_multi_chain_page_common.dart';

class StakingMultiChainPage extends ConsumerWidget {
  const StakingMultiChainPage({super.key, this.shellRenderMode});

  static const infoKey = Key('sc367_info_banner');
  static const totalStatsKey = Key('sc367_total_stats');
  static const allocationKey = Key('sc367_allocation_chart');
  static const positionsKey = Key('sc367_positions');
  static const quickActionsKey = Key('sc367_quick_actions');
  static const apyComparisonKey = Key('sc367_apy_comparison');
  static const benefitsKey = Key('sc367_benefits');
  static const technicalNoteKey = Key('sc367_technical_note');

  static Key chainKey(StakingChainId id) => Key('sc367_chain_${id.name}');

  static Key manageKey(StakingChainId id) => Key('sc367_manage_${id.name}');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref
        .watch(stakingMultiChainRepositoryProvider)
        .getMultiChain();
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-367 StakingMultiChainPage',
      child: Material(
        color: AppColors.bg,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: snapshot.title,
            showBack: true,
            onBack: () => context.go(snapshot.backRoute),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: AppSpacing.earnBottomInsetPadding(bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.compact,
                    gap: VitContentGap.defaultGap,
                    children: [
                      _InfoBanner(snapshot: snapshot),
                      _TotalStats(snapshot: snapshot),
                      _AllocationCard(snapshot: snapshot),
                      _PositionsSection(snapshot: snapshot),
                      _QuickActions(snapshot: snapshot),
                      _ApyComparison(snapshot: snapshot),
                      _Benefits(snapshot: snapshot),
                      _TechnicalNote(snapshot: snapshot),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
