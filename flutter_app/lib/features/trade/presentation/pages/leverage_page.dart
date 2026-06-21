import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

part '../widgets/leverage_header_hero_risk.dart';
part '../widgets/leverage_controls_presets.dart';
part '../widgets/leverage_impact_confirm.dart';

const _tradePrimary = AppColors.primary;
const _chipBackground = AppColors.surface2;
const _leverageSpace = AppSpacing.x2;
const _leverageCardSpace = AppSpacing.x3;
const _leverageVisualScrollClearance = 108.0;
const _leverageNativeScrollClearance = 72.0;
const _leverageHeroHeight = 138.0;
const _leverageHeroValueLineHeight = .95;
const _leverageMeterSegmentHeight = 8.0;
const _leverageControlHeight = 40.0;
const _leverageControlLineHeight = 1.0;
const _leverageImpactRowLineHeight = 1.12;
const _leverageConfirmHeight = 44.0;

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
    final scrollEndClearance =
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame
            ? _leverageVisualScrollClearance
            : _leverageNativeScrollClearance);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-058 LeveragePage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: _LeverageTopChromeHeader(
            currentLeverage: snapshot.currentLeverage,
            onBack: _returnToFutures,
          ),
          child: SingleChildScrollView(
            key: LeveragePage.contentKey,
            padding: EdgeInsetsDirectional.only(bottom: scrollEndClearance),
            child: VitPageContent(
              padding: VitContentPadding.compact,
              density: VitDensity.compact,
              children: [
                _LeverageHero(preview: preview, riskColor: riskColor),
                _RiskMeter(preview: preview, riskColor: riskColor),
                _LeverageSlider(
                  leverage: _leverage,
                  stops: snapshot.sliderStops,
                  riskColor: riskColor,
                  onChanged: _setLeverage,
                ),
                _PresetGrid(
                  presets: snapshot.presets,
                  active: _leverage,
                  onChanged: _setLeverage,
                ),
                _ImpactCard(margin: snapshot.exampleMargin, preview: preview),
                _WarningCard(preview: preview),
                if (preview.showRiskTips) const _RiskTipsCard(),
                _ConfirmButton(
                  leverage: _leverage,
                  onPressed: () => _confirm(controller),
                ),
              ],
            ),
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
    goBackOrFallback(
      context,
      fallbackPath: AppRoutePaths.tradeFutures(widget.pairId),
    );
  }
}
