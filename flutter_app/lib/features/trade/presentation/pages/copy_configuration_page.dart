import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

part '../widgets/copy_configuration_provider_capital_mode.dart';
part '../widgets/copy_configuration_risk_summary.dart';
part '../widgets/copy_configuration_validation_common.dart';

const _configurationPrimary = AppColors.primary;
const _configurationGreen = AppColors.buy;
const _configurationRed = AppColors.sell;

class CopyConfigurationPage extends ConsumerStatefulWidget {
  const CopyConfigurationPage({
    super.key,
    required this.providerId,
    this.backPath,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc072_copy_configuration_content');
  static const confirmKey = Key('sc072_copy_configuration_confirm');
  static const capitalFieldKey = Key('sc072_copy_configuration_capital');

  static Key modeKey(TradeCopyConfigurationMode mode) =>
      Key('sc072_copy_configuration_mode_${mode.name}');

  final String providerId;
  final String? backPath;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<CopyConfigurationPage> createState() =>
      _CopyConfigurationPageState();
}

class _CopyConfigurationPageState extends ConsumerState<CopyConfigurationPage> {
  final TextEditingController _capitalController = TextEditingController();
  TradeCopyConfigurationDraft? _draft;
  String? _draftProviderId;

  @override
  void dispose() {
    _capitalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(
      tradeCopyConfigurationProvider(widget.providerId),
    );

    if (snapshot.isNotFound) {
      return const VitPageLayout(
        variant: VitPageVariant.flush,
        semanticLabel: 'SC-072 CopyConfigurationPage blank',
        child: SizedBox.expand(),
      );
    }

    _ensureDraft(snapshot);
    final draft = _draft!;
    final controller = ref.watch(
      tradeCopyConfigurationControllerProvider((
        providerId: widget.providerId,
        draft: draft,
      )),
    );
    final preview = controller.state.preview;
    final provider = snapshot.provider!;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame
            ? AppSpacing.copyConfigurationBottomInsetVisual
            : AppSpacing.copyConfigurationBottomInsetNative);
    final allocationPercent = draft.copyCapital / snapshot.totalPortfolio * 100;
    final resolvedBackPath = resolveSafeBackPath(
      candidate: widget.backPath,
      fallbackPath: AppRoutePaths.tradeCopyProvider(widget.providerId),
      allowedPrefixes: const [AppRoutePaths.trade],
    );

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-072 CopyConfigurationPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Cấu hình Copy',
            showBack: true,
            onBack: () =>
                goBackOrFallback(context, fallbackPath: resolvedBackPath),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: CopyConfigurationPage.contentKey,
                  padding: AppSpacing.copyConfigurationScrollPadding(
                    bottomInset,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _ProviderCard(provider: provider),
                      const SizedBox(
                        height: AppSpacing.copyConfigurationPrimaryGap,
                      ),
                      _CapitalSection(
                        controller: _capitalController,
                        allocationPercent: allocationPercent,
                        availableCapital: snapshot.availableCapital,
                        totalPortfolio: snapshot.totalPortfolio,
                        onChanged: _updateCapital,
                        onPreset: _setCapitalPercent,
                      ),
                      const SizedBox(
                        height: AppSpacing.copyConfigurationPrimaryGap,
                      ),
                      _ModeSection(
                        selected: draft.copyMode,
                        copyRatio: draft.copyRatio,
                        onModeChanged: _setMode,
                        onRatioChanged: _setCopyRatio,
                      ),
                      const SizedBox(
                        height: AppSpacing.copyConfigurationPrimaryGap,
                      ),
                      _RiskSection(draft: draft, onDraftChanged: _setDraft),
                      const SizedBox(
                        height: AppSpacing.copyConfigurationPrimaryGap,
                      ),
                      _FeeSection(preview: preview),
                      const SizedBox(
                        height: AppSpacing.copyConfigurationPrimaryGap,
                      ),
                      if (preview.validations.isNotEmpty) ...[
                        _ValidationList(items: preview.validations),
                        const SizedBox(
                          height: AppSpacing.copyConfigurationPrimaryGap,
                        ),
                      ],
                      _SummaryCard(draft: draft),
                      const SizedBox(
                        height: AppSpacing.copyConfigurationPrimaryGap,
                      ),
                      const VitHighRiskStatePanel(
                        state: VitHighRiskUiState.riskReview,
                        title: 'Copy configuration state review',
                        message:
                            'Provider summary, capital allocation, copy mode, risk controls, fee preview, validation messages, and disabled confirmation state remain visible before copy-trading confirmation.',
                        contractId: 'SC-072',
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: AppSpacing.copyConfigurationFooterPadding(
                  bottomChrome + MediaQuery.paddingOf(context).bottom,
                ),
                child: VitStickyFooter(
                  child: VitCtaButton(
                    key: CopyConfigurationPage.confirmKey,
                    onPressed: preview.hasBlockingErrors
                        ? null
                        : () => context.go(
                            AppRoutePaths.tradeCopyProviderConfirmation(
                              widget.providerId,
                            ),
                          ),
                    variant: VitCtaButtonVariant.auth,
                    trailing: const Icon(Icons.chevron_right_rounded),
                    child: const Text('Xem xác nhận'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _ensureDraft(TradeCopyConfigurationSnapshot snapshot) {
    if (_draftProviderId == snapshot.providerId) return;
    _draftProviderId = snapshot.providerId;
    _draft = snapshot.defaultDraft;
    _capitalController.text = snapshot.defaultDraft.copyCapital.toStringAsFixed(
      0,
    );
  }

  void _setDraft(TradeCopyConfigurationDraft draft) {
    setState(() => _draft = draft);
  }

  void _updateCapital(String rawValue) {
    final value = double.tryParse(rawValue);
    if (value == null) return;
    _setDraft(_draft!.copyWith(copyCapital: value));
  }

  void _setCapitalPercent(double percent) {
    final capital = 25000 * percent / 100;
    _capitalController.text = capital.toStringAsFixed(0);
    _setDraft(_draft!.copyWith(copyCapital: capital));
  }

  void _setMode(TradeCopyConfigurationMode mode) {
    _setDraft(_draft!.copyWith(copyMode: mode));
  }

  void _setCopyRatio(double ratio) {
    _setDraft(_draft!.copyWith(copyRatio: ratio));
  }
}
