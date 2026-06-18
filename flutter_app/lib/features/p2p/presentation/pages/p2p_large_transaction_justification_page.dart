import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
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
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';

class P2PLargeTransactionJustificationPage extends ConsumerStatefulWidget {
  const P2PLargeTransactionJustificationPage({
    super.key,
    this.amount = 100000000,
    this.shellRenderMode,
  });

  static const heroKey = Key('sc270_p2p_large_tx_hero');
  static const purposeListKey = Key('sc270_p2p_large_tx_purposes');
  static const customPurposeInputKey = Key(
    'sc270_p2p_large_tx_custom_purpose_input',
  );
  static const detailsInputKey = Key('sc270_p2p_large_tx_details_input');
  static const ctaKey = Key('sc270_p2p_large_tx_cta');

  static Key purposeKey(String purpose) =>
      Key('sc270_p2p_large_tx_purpose_${purpose.hashCode}');

  final double amount;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PLargeTransactionJustificationPage> createState() =>
      _P2PLargeTransactionJustificationPageState();
}

class _P2PLargeTransactionJustificationPageState
    extends ConsumerState<P2PLargeTransactionJustificationPage> {
  final TextEditingController _customPurposeController =
      TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  String? _purpose;

  @override
  void dispose() {
    _customPurposeController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(
      p2pLargeTransactionJustificationProvider(widget.amount),
    );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;
    final needsCustomPurpose = _purpose == _otherPurposeLabel;
    final hasPurpose =
        _purpose != null &&
        (!needsCustomPurpose ||
            _customPurposeController.text.trim().isNotEmpty);
    final canSubmit = hasPurpose && _detailsController.text.trim().isNotEmpty;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-270 P2PLargeTransactionJustificationPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: snapshot.title,
            subtitle: snapshot.subtitle,
            showBack: true,
            onBack: () => context.go(snapshot.parentRoute),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: AppSpacing.p2pFinancialSafetyScrollPadding(
                      bottomInset,
                    ),
                    child: VitPageContent(
                      padding: VitContentPadding.none,
                      fullBleed: true,
                      customGap: 0,
                      children: [
                        _LargeTransactionHero(snapshot: snapshot),
                        const SizedBox(height: AppSpacing.x5),
                        Text(
                          snapshot.purposeTitle,
                          style: AppTextStyles.baseMedium.copyWith(
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x3),
                        _PurposeList(
                          purposes: snapshot.purposes,
                          selectedPurpose: _purpose,
                          onSelected: (purpose) {
                            HapticFeedback.selectionClick();
                            setState(() => _purpose = purpose);
                          },
                        ),
                        if (needsCustomPurpose) ...[
                          const SizedBox(height: AppSpacing.x5),
                          VitInput(
                            controller: _customPurposeController,
                            fieldKey: P2PLargeTransactionJustificationPage
                                .customPurposeInputKey,
                            label: snapshot.customPurposeLabel,
                            hintText: snapshot.customPurposePlaceholder,
                            textInputAction: TextInputAction.next,
                            onChanged: (_) => setState(() {}),
                          ),
                        ],
                        const SizedBox(height: AppSpacing.x5),
                        VitInput(
                          controller: _detailsController,
                          fieldKey: P2PLargeTransactionJustificationPage
                              .detailsInputKey,
                          label: snapshot.detailsLabel,
                          hintText: snapshot.detailsPlaceholder,
                          textInputAction: TextInputAction.done,
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: AppSpacing.x5),
                        VitCtaButton(
                          key: P2PLargeTransactionJustificationPage.ctaKey,
                          onPressed: canSubmit
                              ? () {
                                  HapticFeedback.mediumImpact();
                                  context.go(snapshot.successRoute);
                                }
                              : null,
                          trailing: const Icon(Icons.chevron_right_rounded),
                          child: Text(snapshot.ctaLabel),
                        ),
                      ],
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
}

class _LargeTransactionHero extends StatelessWidget {
  const _LargeTransactionHero({required this.snapshot});

  final P2PLargeTransactionJustificationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PLargeTransactionJustificationPage.heroKey,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      borderColor: AppColors.warningBorder,
      padding: AppSpacing.p2pFinancialSafetyCardPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VitCard(
            width: AppSpacing.p2pFinancialSafetyIconBox,
            height: AppSpacing.p2pFinancialSafetyIconBox,
            variant: VitCardVariant.ghost,
            radius: VitCardRadius.lg,
            background: const ColoredBox(color: AppColors.warn15),
            clip: true,
            child: const Icon(
              Icons.error_outline_rounded,
              color: AppColors.warn,
              size: AppSpacing.iconMd,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.heroTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: AppColors.warn,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  snapshot.heroSubtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: AppSpacing.p2pFinancialSafetyBodyLineHeight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PurposeList extends StatelessWidget {
  const _PurposeList({
    required this.purposes,
    required this.selectedPurpose,
    required this.onSelected,
  });

  final List<String> purposes;
  final String? selectedPurpose;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PLargeTransactionJustificationPage.purposeListKey,
      children: [
        for (var index = 0; index < purposes.length; index++) ...[
          _PurposeTile(
            purpose: purposes[index],
            selected: selectedPurpose == purposes[index],
            onTap: () => onSelected(purposes[index]),
          ),
          if (index != purposes.length - 1)
            const SizedBox(height: AppSpacing.x2),
        ],
      ],
    );
  }
}

class _PurposeTile extends StatelessWidget {
  const _PurposeTile({
    required this.purpose,
    required this.selected,
    required this.onTap,
  });

  final String purpose;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      key: P2PLargeTransactionJustificationPage.purposeKey(purpose),
      color: selected
          ? AppModuleAccents.p2p.withValues(alpha: .10)
          : AppColors.bg,
      borderRadius: AppRadii.inputRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: VitCard(
          variant: VitCardVariant.ghost,
          radius: VitCardRadius.sm,
          borderColor: selected ? AppModuleAccents.p2p : AppColors.borderSolid,
          constraints: const BoxConstraints(minHeight: AppSpacing.ctaHeight),
          alignment: Alignment.centerLeft,
          padding: AppSpacing.p2pFinancialSafetyTilePadding,
          child: Text(
            purpose,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: selected ? AppModuleAccents.p2p : AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}

const String _otherPurposeLabel = 'Khác (ghi rõ)';
