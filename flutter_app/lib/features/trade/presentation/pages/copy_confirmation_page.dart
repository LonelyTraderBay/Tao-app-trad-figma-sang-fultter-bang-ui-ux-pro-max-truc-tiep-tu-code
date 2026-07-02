import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/trade_module_layout.dart';

part '../widgets/copy_confirmation_page_sections.dart';
part '../widgets/copy_confirmation_page_common.dart';

const _confirmationPrimary = AppColors.primary;
const _confirmationGreen = AppColors.buy;
const _confirmationRed = AppColors.sell;

class CopyConfirmationPage extends ConsumerStatefulWidget {
  const CopyConfirmationPage({
    super.key,
    required this.providerId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc073_copy_confirmation_content');
  static const submitKey = Key('sc073_copy_confirmation_submit');
  static const suitabilityKey = Key('sc073_copy_confirmation_suitability');

  static Key consentKey(String id) =>
      Key('sc073_copy_confirmation_consent_$id');

  final String providerId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<CopyConfirmationPage> createState() =>
      _CopyConfirmationPageState();
}

class _CopyConfirmationPageState extends ConsumerState<CopyConfirmationPage> {
  final Set<String> _acceptedConsentIds = <String>{};
  bool _submitting = false;

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(
      tradeCopyConfirmationControllerProvider((
        providerId: widget.providerId,
        acceptedConsentIds: _acceptedConsentIds.toList(growable: false),
      )),
    );
    final snapshot = controller.state.snapshot;

    if (snapshot.isNotFound) {
      return const VitPageLayout(
        variant: VitPageVariant.flush,
        semanticLabel: 'SC-073 CopyConfirmationPage blank',
        child: SizedBox.expand(),
      );
    }

    final allRequiredAccepted = controller.allRequiredAccepted;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollClearance = copyTradingScrollBottomInset(
      context,
      shellRenderMode: mode,
    );

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-073 CopyConfirmationPage',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VitHeader(
            title: 'Xác nhận Copy',
            showBack: true,
            onBack: () => context.go(
              AppRoutePaths.tradeCopyProviderConfiguration(widget.providerId),
            ),
          ),
          Expanded(
            child: VitInsetScrollView(
              key: CopyConfirmationPage.contentKey,
              bottomInset: scrollClearance,
              child: VitPageContent(
                padding: VitContentPadding.compact,
                density: VitDensity.compact,
                children: [
                  VitTradeSection(
                    title: 'Cảnh báo',
                    child: _CriticalWarning(snapshot: snapshot),
                  ),
                  VitTradeSection(
                    title: 'Provider',
                    child: _ProviderSummary(provider: snapshot.provider!),
                  ),
                  _SuitabilityReviewCard(snapshot: snapshot),
                  _ConfigurationSummary(snapshot: snapshot),
                  _FeeBreakdown(snapshot: snapshot),
                  _ScenarioSection(scenarios: snapshot.scenarios),
                  VitTradeSection(
                    title: 'Mất vốn tối đa',
                    child: _MaxLossCard(snapshot: snapshot),
                  ),
                  VitFinancialSafetySummary(
                    title: 'Xem lại trước khi copy',
                    contractId: 'SC-073 Copy confirmation',
                    density: VitDensity.compact,
                    footer:
                        'Confirm capital at risk, fees, max loss, required consents, and cooling-off before starting copy trading.',
                    items: [
                      VitFinancialSafetyItem(
                        label: 'Capital at risk',
                        value:
                            '\$${snapshot.configuration.copyCapital.toStringAsFixed(0)}',
                        leading: const Icon(
                          Icons.account_balance_wallet_outlined,
                        ),
                        valueColor: _confirmationRed,
                      ),
                      VitFinancialSafetyItem(
                        label: 'Max loss scenario',
                        value: '\$${snapshot.maxLossAmount.toStringAsFixed(0)}',
                        leading: const Icon(Icons.trending_down_rounded),
                        valueColor: _confirmationRed,
                      ),
                      VitFinancialSafetyItem(
                        label: 'Fixed fees (month 1)',
                        value:
                            '\$${snapshot.feePreview.totalFixedFees.toStringAsFixed(2)}',
                        leading: const Icon(Icons.receipt_long_outlined),
                        valueColor: AppColors.text2,
                      ),
                      VitFinancialSafetyItem(
                        label: 'Cooling-off',
                        value: '${snapshot.coolingOffHours} hours',
                        leading: const Icon(Icons.schedule_rounded),
                        valueColor: _confirmationPrimary,
                      ),
                      VitFinancialSafetyItem(
                        label: 'Required consents',
                        value: allRequiredAccepted ? 'Complete' : 'Pending',
                        leading: const Icon(Icons.verified_user_outlined),
                        valueColor: allRequiredAccepted
                            ? AppColors.buy
                            : AppColors.warn,
                      ),
                    ],
                  ),
                  _ConsentSection(
                    items: snapshot.consentItems,
                    acceptedIds: _acceptedConsentIds,
                    onToggle: _toggleConsent,
                  ),
                  VitTradeSection(
                    title: 'Cooling-off',
                    child: _CoolingOffCard(hours: snapshot.coolingOffHours),
                  ),
                  VitTradeSection(
                    title: 'Bước tiếp theo',
                    child: _NextStepsCard(snapshot: snapshot),
                  ),
                  const VitHighRiskStatePanel(
                    state: VitHighRiskUiState.riskReview,
                    title: 'Copy confirmation state review',
                    message:
                        'Critical warning, suitability review, fees, scenarios, max loss, required consents, cooling-off period, next steps, and submitting state remain visible before starting copy trading.',
                    contractId: 'SC-073',
                    density: VitDensity.compact,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: AppSpacing.copyConfirmationFooterPadding(
              copyTradingScrollBottomInset(context, shellRenderMode: mode),
            ),
            child: VitStickyFooter(
              child: Column(
                children: [
                  VitCtaButton(
                    key: CopyConfirmationPage.submitKey,
                    onPressed: allRequiredAccepted && !_submitting
                        ? () => _submit(context, controller)
                        : null,
                    loading: _submitting,
                    variant: VitCtaButtonVariant.danger,
                    density: VitDensity.compact,
                    leading: const Icon(Icons.shield_outlined),
                    child: const Text('Xác nhận & Bắt đầu Copy'),
                  ),
                  if (!allRequiredAccepted) ...[
                    const SizedBox(height: AppSpacing.x3),
                    Text(
                      'Bạn cần đồng ý với tất cả điều khoản để tiếp tục',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleConsent(String id) {
    setState(() {
      if (_acceptedConsentIds.contains(id)) {
        _acceptedConsentIds.remove(id);
      } else {
        _acceptedConsentIds.add(id);
      }
    });
  }

  Future<void> _submit(
    BuildContext context,
    TradeCopyConfirmationController controller,
  ) async {
    setState(() => _submitting = true);
    final result = controller.submit();
    await Future<void>.delayed(const Duration(milliseconds: 180));
    if (!context.mounted) return;
    if (result.status == 'pending_cooling_off') {
      context.go(result.activeCopiesPath);
    } else {
      setState(() => _submitting = false);
    }
  }
}
