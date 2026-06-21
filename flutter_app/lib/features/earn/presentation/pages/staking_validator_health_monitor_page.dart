import 'package:flutter/material.dart';
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

part '../widgets/staking_validator_health_monitor_page_sections.dart';
part '../widgets/staking_validator_health_monitor_page_common.dart';

class StakingValidatorHealthMonitorPage extends ConsumerStatefulWidget {
  const StakingValidatorHealthMonitorPage({super.key, this.shellRenderMode});

  static const statsKey = Key('sc383_stats');
  static const validatorsKey = Key('sc383_validators');
  static const trendKey = Key('sc383_trend');
  static const actionKey = Key('sc383_action');
  static const footerKey = Key('sc383_footer');

  static Key validatorKey(String id) => Key('sc383_validator_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingValidatorHealthMonitorPage> createState() =>
      _StakingValidatorHealthMonitorPageState();
}

class _StakingValidatorHealthMonitorPageState
    extends ConsumerState<StakingValidatorHealthMonitorPage> {
  String? _selectedValidatorId;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(stakingValidatorHealthMonitorRepositoryProvider)
        .getValidatorHealth();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollTailReserve =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x3
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x3) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-383 StakingValidatorHealthMonitorPage',
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
                  physics: const ClampingScrollPhysics(),
                  padding: EdgeInsetsDirectional.only(
                    bottom: scrollTailReserve,
                  ),
                  child: VitPageContent(
                    padding: VitContentPadding.compact,
                    gap: VitContentGap.tight,
                    children: [
                      _SummaryStats(snapshot: snapshot),
                      VitPageSection(
                        key: StakingValidatorHealthMonitorPage.validatorsKey,
                        label: 'Active Validators',
                        accentColor: AppColors.primarySoft,
                        children: [
                          for (final validator in snapshot.validators)
                            _ValidatorCard(
                              validator: validator,
                              selected: _selectedValidatorId == validator.id,
                              onTap: () {
                                setState(() {
                                  _selectedValidatorId =
                                      _selectedValidatorId == validator.id
                                      ? null
                                      : validator.id;
                                });
                              },
                            ),
                        ],
                      ),
                      _TrendSection(points: snapshot.uptimeHistory),
                      if (snapshot.warningCount > 0)
                        _ActionRequiredCard(snapshot: snapshot),
                      _FooterNote(note: snapshot.footerNote),
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
