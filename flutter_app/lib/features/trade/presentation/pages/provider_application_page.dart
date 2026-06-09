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
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_cta_button.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_high_risk_state_panel.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_input.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

part '../widgets/provider_application_progress_intro.dart';
part '../widgets/provider_application_steps.dart';
part '../widgets/provider_application_common.dart';

const _providerPrimary = AppColors.primary;
const _providerGreen = AppColors.buy;
const _providerWarning = AppColors.caution;
const _providerField = AppColors.surface3;

class ProviderApplicationPage extends ConsumerStatefulWidget {
  const ProviderApplicationPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc069_provider_application_scroll_content');
  static const nextKey = Key('sc069_provider_application_next');
  static const submitKey = Key('sc069_provider_application_submit');
  static const kycKey = Key('sc069_provider_application_kyc');
  static const disclosureKey = Key('sc069_provider_application_disclosure');
  static const fiduciaryKey = Key('sc069_provider_application_fiduciary');
  static const termsKey = Key('sc069_provider_application_terms');
  static const monthsFieldKey = Key('sc069_provider_application_months');
  static const strategyFieldKey = Key('sc069_provider_application_strategy');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ProviderApplicationPage> createState() =>
      _ProviderApplicationPageState();
}

class _ProviderApplicationPageState
    extends ConsumerState<ProviderApplicationPage> {
  TradeProviderApplicationStep? _step;
  TradeProviderApplicationDraft? _draft;
  late final TextEditingController _monthsController;
  late final TextEditingController _strategyController;
  bool _controllersReady = false;

  @override
  void dispose() {
    if (_controllersReady) {
      _monthsController.dispose();
      _strategyController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(tradeProviderApplicationControllerProvider);
    final snapshot = controller.state.snapshot;
    _step ??= snapshot.defaultStep;
    _draft ??= snapshot.defaultDraft;
    if (!_controllersReady) {
      _monthsController = TextEditingController(
        text: _draft!.tradingMonths.toString(),
      );
      _strategyController = TextEditingController(
        text: _draft!.strategyDescription,
      );
      _controllersReady = true;
    }

    final step = _step!;
    final draft = _draft!;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-069 ProviderApplicationPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Đăng ký Provider',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.tradeCopyTrading),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: ProviderApplicationPage.contentKey,
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    fullBleed: true,
                    customGap: 0,
                    children: [
                      _ProgressBars(steps: snapshot.steps, activeStep: step),
                      const SizedBox(height: 58),
                      switch (step) {
                        TradeProviderApplicationStep.intro => _IntroStep(
                          snapshot: snapshot,
                        ),
                        TradeProviderApplicationStep.requirements =>
                          _RequirementsStep(
                            draft: draft,
                            onChanged: _updateDraft,
                            monthsController: _monthsController,
                          ),
                        TradeProviderApplicationStep.disclosure =>
                          _DisclosureStep(
                            draft: draft,
                            onChanged: _updateDraft,
                          ),
                        TradeProviderApplicationStep.fees => _FeesStep(
                          draft: draft,
                          onChanged: _updateDraft,
                          strategyController: _strategyController,
                        ),
                        TradeProviderApplicationStep.review => _ReviewStep(
                          draft: draft,
                          onChanged: _updateDraft,
                        ),
                      },
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: DeviceMetrics.nativeBottomChrome + 20,
                  ),
                  child: VitStickyFooter(
                    backgroundColor: AppColors.bg,
                    child: _FooterButton(
                      step: step,
                      enabled: _canProceed(step, draft),
                      onPressed: () => _handlePrimaryAction(controller),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateDraft(TradeProviderApplicationDraft draft) {
    setState(() => _draft = draft);
  }

  bool _canProceed(
    TradeProviderApplicationStep step,
    TradeProviderApplicationDraft draft,
  ) {
    return switch (step) {
      TradeProviderApplicationStep.intro => true,
      TradeProviderApplicationStep.requirements =>
        draft.hasKyc && draft.tradingMonths >= 6 && draft.minCapital >= 10000,
      TradeProviderApplicationStep.disclosure =>
        draft.agreedToDisclosure && draft.agreedToFiduciary,
      TradeProviderApplicationStep.fees =>
        draft.performanceFee >= 0 &&
            draft.performanceFee <= 30 &&
            draft.strategyDescription.length >= 100,
      TradeProviderApplicationStep.review => draft.agreedToTerms,
    };
  }

  void _handlePrimaryAction(TradeProviderApplicationController controller) {
    final step = _step!;
    final draft = _draft!;
    if (!_canProceed(step, draft)) return;

    switch (step) {
      case TradeProviderApplicationStep.intro:
        setState(() => _step = TradeProviderApplicationStep.requirements);
      case TradeProviderApplicationStep.requirements:
        setState(() => _step = TradeProviderApplicationStep.disclosure);
      case TradeProviderApplicationStep.disclosure:
        setState(() => _step = TradeProviderApplicationStep.fees);
      case TradeProviderApplicationStep.fees:
        setState(() => _step = TradeProviderApplicationStep.review);
      case TradeProviderApplicationStep.review:
        controller.submit(draft);
        context.go(AppRoutePaths.tradeCopyTrading);
    }
  }
}
