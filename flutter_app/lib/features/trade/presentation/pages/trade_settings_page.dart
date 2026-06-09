import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_cta_button.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_high_risk_state_panel.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

part '../widgets/trade_settings_page_sections.dart';
part '../widgets/trade_settings_page_common.dart';

const _tradePrimary = AppColors.primary;
const _chipBackground = AppColors.surface2;

class TradeSettingsPage extends ConsumerStatefulWidget {
  const TradeSettingsPage({super.key, this.shellRenderMode});

  static const resetKey = Key('sc052_reset');
  static const confirmOrdersKey = Key('sc052_confirm_orders');
  static const skipConfirmSmallKey = Key('sc052_skip_confirm_small');
  static const soundOnFillKey = Key('sc052_sound_on_fill');
  static const hapticOnFillKey = Key('sc052_haptic_on_fill');
  static const showTpslKey = Key('sc052_show_tpsl');
  static const showOrderBookKey = Key('sc052_show_order_book');
  static const showRecentTradesKey = Key('sc052_show_recent_trades');
  static const defaultPctButtonsKey = Key('sc052_default_pct_buttons');

  static Key orderTypeKey(String id) => Key('sc052_order_type_$id');
  static Key slippageKey(double value) => Key('sc052_slippage_$value');
  static Key timeframeKey(String value) => Key('sc052_timeframe_$value');
  static Key decimalsKey(String value) => Key('sc052_decimals_$value');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<TradeSettingsPage> createState() => _TradeSettingsPageState();
}

class _TradeSettingsPageState extends ConsumerState<TradeSettingsPage> {
  late TradeSettings _settings;

  @override
  void initState() {
    super.initState();
    _settings = ref
        .read(tradeReadModelControllerProvider)
        .getTradeSettings()
        .settings;
  }

  @override
  Widget build(BuildContext context) {
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-052 TradeSettingsPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Cài đặt giao dịch',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.trade),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(20, 14, 20, bottomChrome + 32),
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    fullBleed: true,
                    customGap: 0,
                    children: [
                      const VitHighRiskStatePanel(
                        state: VitHighRiskUiState.riskReview,
                        title: 'Trade settings safety review',
                        message:
                            'Confirm order preview, small-order confirmation limits, slippage, chart defaults, and next steps before using these settings for live trading.',
                        contractId: 'SC-052 settings review',
                      ),
                      const SizedBox(height: 20),
                      _SettingsSection(
                        title: 'Mặc định lệnh',
                        child: _OrderDefaultsCard(
                          settings: _settings,
                          onChanged: _updateSettings,
                        ),
                      ),
                      const SizedBox(height: 26),
                      _SettingsSection(
                        title: 'Xác nhận lệnh',
                        child: _ConfirmationCard(
                          settings: _settings,
                          onChanged: _updateSettings,
                        ),
                      ),
                      const SizedBox(height: 26),
                      _SettingsSection(
                        title: 'Phản hồi',
                        child: _FeedbackCard(
                          settings: _settings,
                          onChanged: _updateSettings,
                        ),
                      ),
                      const SizedBox(height: 26),
                      _SettingsSection(
                        title: 'Hiển thị',
                        child: _DisplayCard(
                          settings: _settings,
                          onChanged: _updateSettings,
                        ),
                      ),
                      const SizedBox(height: 26),
                      _ResetButton(onReset: _resetSettings),
                      const SizedBox(height: 24),
                      const _InfoNote(),
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

  void _updateSettings(TradeSettings settings) {
    final updated = ref
        .read(tradeReadModelControllerProvider)
        .patchTradeSettings(settings);
    setState(() => _settings = updated);
  }

  void _resetSettings() {
    _updateSettings(
      ref.read(tradeReadModelControllerProvider).getTradeSettings().settings,
    );
  }
}
