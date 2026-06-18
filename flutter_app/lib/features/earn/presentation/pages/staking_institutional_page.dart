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

part '../widgets/staking_institutional_overview_batches.dart';
part '../widgets/staking_institutional_signers_features.dart';
part '../widgets/staking_institutional_sheet_painter.dart';

enum _InstitutionalBatchTab { pending, executed }

class StakingInstitutionalPage extends ConsumerStatefulWidget {
  const StakingInstitutionalPage({super.key, this.shellRenderMode});

  static const infoKey = Key('sc368_info_banner');
  static const statsKey = Key('sc368_stats');
  static const createButtonKey = Key('sc368_create_batch');
  static const createSheetKey = Key('sc368_create_sheet');
  static const tabsKey = Key('sc368_tabs');
  static const signersKey = Key('sc368_signers');
  static const featuresKey = Key('sc368_features');
  static const complianceKey = Key('sc368_compliance');

  static Key tabKey(String id) => Key('sc368_tab_$id');

  static Key batchKey(String id) => Key('sc368_batch_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingInstitutionalPage> createState() =>
      _StakingInstitutionalPageState();
}

class _StakingInstitutionalPageState
    extends ConsumerState<StakingInstitutionalPage> {
  _InstitutionalBatchTab _tab = _InstitutionalBatchTab.pending;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(stakingInstitutionalRepositoryProvider)
        .getInstitutional();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;
    final batches = _tab == _InstitutionalBatchTab.pending
        ? snapshot.pendingBatches
        : snapshot.executedBatches;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-368 StakingInstitutionalPage',
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
                      _StatsCard(snapshot: snapshot),
                      VitCtaButton(
                        key: StakingInstitutionalPage.createButtonKey,
                        onPressed: () => _showCreateBatch(snapshot),
                        child: const Text('Create Batch Operation'),
                      ),
                      _BatchTabs(
                        active: _tab,
                        onChanged: (tab) {
                          HapticFeedback.selectionClick();
                          setState(() => _tab = tab);
                        },
                      ),
                      VitPageSection(
                        label: _tab == _InstitutionalBatchTab.pending
                            ? 'Pending Approvals'
                            : 'Executed Batches',
                        accentColor: AppColors.primarySoft,
                        children: [
                          for (final batch in batches)
                            _BatchOperationCard(batch: batch),
                        ],
                      ),
                      _AuthorizedSigners(snapshot: snapshot),
                      _EnterpriseFeatures(snapshot: snapshot),
                      _ComplianceNote(snapshot: snapshot),
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

  Future<void> _showCreateBatch(StakingInstitutionalSnapshot snapshot) async {
    HapticFeedback.selectionClick();
    await showVitBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) =>
          _SheetFrame(child: _CreateBatchSheet(snapshot: snapshot)),
    );
  }
}
