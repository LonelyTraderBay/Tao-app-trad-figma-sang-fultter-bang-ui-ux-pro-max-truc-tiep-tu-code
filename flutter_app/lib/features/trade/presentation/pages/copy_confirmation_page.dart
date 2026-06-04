import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

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
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 84 : 24);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-073 CopyConfirmationPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Xác nhận Copy',
            showBack: true,
            onBack: () => context.go(
              AppRoutePaths.tradeCopyProviderConfiguration(widget.providerId),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: CopyConfirmationPage.contentKey,
                  padding: EdgeInsets.fromLTRB(20, 16, 20, bottomInset),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _CriticalWarning(snapshot: snapshot),
                      const SizedBox(height: 16),
                      _ProviderSummary(provider: snapshot.provider!),
                      const SizedBox(height: 16),
                      _SuitabilityReviewCard(snapshot: snapshot),
                      const SizedBox(height: 16),
                      _ConfigurationSummary(snapshot: snapshot),
                      const SizedBox(height: 16),
                      _FeeBreakdown(snapshot: snapshot),
                      const SizedBox(height: 16),
                      _ScenarioSection(scenarios: snapshot.scenarios),
                      const SizedBox(height: 16),
                      _MaxLossCard(snapshot: snapshot),
                      const SizedBox(height: 16),
                      _ConsentSection(
                        items: snapshot.consentItems,
                        acceptedIds: _acceptedConsentIds,
                        onToggle: _toggleConsent,
                      ),
                      const SizedBox(height: 16),
                      _CoolingOffCard(hours: snapshot.coolingOffHours),
                      const SizedBox(height: 16),
                      _NextStepsCard(snapshot: snapshot),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: bottomChrome + MediaQuery.paddingOf(context).bottom,
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
                        leading: const Icon(Icons.shield_outlined),
                        child: const Text('Xác nhận & Bắt đầu Copy'),
                      ),
                      if (!allRequiredAccepted) ...[
                        const SizedBox(height: 8),
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
        ),
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
