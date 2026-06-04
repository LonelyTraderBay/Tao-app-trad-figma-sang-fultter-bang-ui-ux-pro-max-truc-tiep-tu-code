import 'dart:math' as math;

import 'package:flutter/material.dart';
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
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/dca_controller_providers.dart';

part 'dca_dynamic_amount_page_part_01.dart';
part 'dca_dynamic_amount_page_part_02.dart';
part 'dca_dynamic_amount_page_part_03.dart';
part 'dca_dynamic_amount_page_part_04.dart';

class DCADynamicAmount extends ConsumerStatefulWidget {
  const DCADynamicAmount({super.key, this.shellRenderMode});

  static const contentKey = Key('sc175_dynamic_amount_content');
  static const applyKey = Key('sc175_apply_strategy');
  static const settingsKey = Key('sc175_dynamic_settings');

  static Key strategyKey(DcaDynamicStrategy strategy) {
    return Key('sc175_strategy_${strategy.name}');
  }

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<DCADynamicAmount> createState() => _DCADynamicAmountState();
}

class _DCADynamicAmountState extends ConsumerState<DCADynamicAmount> {
  DcaDynamicStrategy _activeStrategy = DcaDynamicStrategy.volatility;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(dcaDynamicAmountProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final floatingBottom =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.tabBar + AppSpacing.x2
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x2) +
        MediaQuery.paddingOf(context).bottom;
    final contentBottom = floatingBottom + AppSpacing.buttonStandard;
    final activeOption = _strategyOption(snapshot.strategies, _activeStrategy);
    final adjustment = _adjustmentFor(_activeStrategy, snapshot.adjustment);

    return VitPageLayout(
      semanticLabel: 'SC-175 DCADynamicAmount',
      child: VitAutoHideHeaderScaffold(
        header: VitHeader(
          title: 'Dynamic Amount',
          subtitle: 'Số tiền · DCA',
          showBack: true,
          onBack: _close,
          actions: [
            VitHeaderActionItem(
              key: DCADynamicAmount.settingsKey,
              type: VitHeaderActionType.settings,
              onPressed: _showSettingsNotice,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ScrollConfiguration(
                    behavior: ScrollConfiguration.of(
                      context,
                    ).copyWith(scrollbars: false),
                    child: SingleChildScrollView(
                      key: DCADynamicAmount.contentKey,
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.only(bottom: contentBottom),
                      child: VitPageContent(
                        customGap: AppSpacing.x5,
                        children: [
                          _DynamicHero(
                            option: activeOption,
                            adjustment: adjustment,
                            onChangeStrategy: _showStrategyNotice,
                          ),
                          _StrategyStrip(
                            strategies: snapshot.strategies,
                            activeStrategy: _activeStrategy,
                            onChanged: (strategy) {
                              setState(() => _activeStrategy = strategy);
                            },
                          ),
                          _StrategyVisualization(
                            strategy: _activeStrategy,
                            option: activeOption,
                            volatilityHistory: snapshot.volatilityHistory,
                          ),
                          _AmountHistoryCard(entries: snapshot.amountHistory),
                          _RecentDetailsCard(entries: snapshot.amountHistory),
                          _ConfigSection(
                            option: activeOption,
                            items:
                                _activeStrategy == DcaDynamicStrategy.volatility
                                ? snapshot.configItems
                                : _configItemsFor(_activeStrategy),
                          ),
                          _StrategyExplainer(option: activeOption),
                          const _DynamicDisclaimer(),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: AppSpacing.contentPad,
                    right: AppSpacing.contentPad,
                    bottom: floatingBottom,
                    child: _FloatingActions(
                      onSettings: _showSettingsNotice,
                      onApply: () => context.go(AppRoutePaths.dca),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _close() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.dca);
  }

  void _showSettingsNotice() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Dynamic amount settings ready')),
    );
  }

  void _showStrategyNotice() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Chọn chiến lược trong thanh bên dưới')),
    );
  }
}
