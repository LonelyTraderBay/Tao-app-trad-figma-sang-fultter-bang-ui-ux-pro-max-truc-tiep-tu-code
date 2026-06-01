import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

part '../widgets/leverage_header_hero_risk.dart';
part '../widgets/leverage_controls_presets.dart';
part '../widgets/leverage_impact_confirm.dart';

const _tradePrimary = AppColors.primary;
const _tradePrimaryDark = AppColors.primaryDark;
const _panelBackground = AppColors.surface;
const _chipBackground = AppColors.surface2;

class LeveragePage extends ConsumerStatefulWidget {
  const LeveragePage({super.key, required this.pairId, this.shellRenderMode});

  static const contentKey = Key('sc058_leverage_scroll_content');
  static const backKey = Key('sc058_back');
  static const sliderKey = Key('sc058_slider');
  static const confirmKey = Key('sc058_confirm');

  static Key stopKey(int leverage) => Key('sc058_stop_$leverage');
  static Key presetKey(int leverage) => Key('sc058_preset_$leverage');

  final String pairId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<LeveragePage> createState() => _LeveragePageState();
}

class _LeveragePageState extends ConsumerState<LeveragePage> {
  late int _leverage;

  @override
  void initState() {
    super.initState();
    final snapshot = ref
        .read(
          tradeLeverageControllerProvider((pairId: widget.pairId, leverage: 1)),
        )
        .state
        .snapshot;
    _leverage = snapshot.currentLeverage;
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(
      tradeLeverageControllerProvider((
        pairId: widget.pairId,
        leverage: _leverage,
      )),
    );
    final snapshot = controller.state.snapshot;
    final preview = controller.state.preview;
    final riskColor = Color(preview.riskColorHex);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 34 : 20);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-058 LeveragePage',
      child: Material(
        type: MaterialType.transparency,
        child: SingleChildScrollView(
          key: LeveragePage.contentKey,
          padding: EdgeInsets.only(bottom: bottomInset),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: _LeverageHeader(
                  currentLeverage: snapshot.currentLeverage,
                  onBack: _returnToFutures,
                ),
              ),
              const SizedBox(height: 12),
              const Divider(height: 1, thickness: 1, color: AppColors.divider),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _LeverageHero(preview: preview, riskColor: riskColor),
                    const SizedBox(height: 20),
                    _RiskMeter(preview: preview, riskColor: riskColor),
                    const SizedBox(height: 19),
                    _LeverageSlider(
                      leverage: _leverage,
                      stops: snapshot.sliderStops,
                      riskColor: riskColor,
                      onChanged: _setLeverage,
                    ),
                    const SizedBox(height: 19),
                    _PresetGrid(
                      presets: snapshot.presets,
                      active: _leverage,
                      onChanged: _setLeverage,
                    ),
                    const SizedBox(height: 20),
                    _ImpactCard(
                      margin: snapshot.exampleMargin,
                      preview: preview,
                    ),
                    const SizedBox(height: 20),
                    _WarningCard(preview: preview),
                    if (preview.showRiskTips) ...[
                      const SizedBox(height: 12),
                      const _RiskTipsCard(),
                    ],
                    const SizedBox(height: 38),
                    _ConfirmButton(
                      leverage: _leverage,
                      onPressed: () => _confirm(controller),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _setLeverage(int leverage) {
    setState(() => _leverage = TradeLeverageController.sanitize(leverage));
  }

  void _confirm(TradeLeverageController controller) {
    controller.submit();
    _returnToFutures();
  }

  void _returnToFutures() {
    context.go(AppRoutePaths.tradeFutures(widget.pairId));
  }
}
