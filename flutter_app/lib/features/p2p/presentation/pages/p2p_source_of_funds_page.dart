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

class P2PSourceOfFundsPage extends ConsumerStatefulWidget {
  const P2PSourceOfFundsPage({super.key, this.shellRenderMode});

  static const heroKey = Key('sc269_p2p_sof_hero');
  static const sourceListKey = Key('sc269_p2p_sof_sources');
  static const inputKey = Key('sc269_p2p_sof_input');
  static const ctaKey = Key('sc269_p2p_sof_cta');

  static Key sourceKey(String id) => Key('sc269_p2p_sof_source_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PSourceOfFundsPage> createState() =>
      _P2PSourceOfFundsPageState();
}

class _P2PSourceOfFundsPageState extends ConsumerState<P2PSourceOfFundsPage> {
  final TextEditingController _detailsController = TextEditingController();
  String? _selectedSource;

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(p2pSourceOfFundsProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;
    final canSubmit =
        _selectedSource != null && _detailsController.text.trim().isNotEmpty;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-269 P2PSourceOfFundsPage',
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
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.contentPad,
                      AppSpacing.x4,
                      AppSpacing.contentPad,
                      bottomInset,
                    ),
                    child: VitPageContent(
                      padding: VitContentPadding.none,
                      fullBleed: true,
                      customGap: 0,
                      children: [
                        _SourceHero(snapshot: snapshot),
                        const SizedBox(height: AppSpacing.x5),
                        Text(
                          snapshot.sourceTitle,
                          style: AppTextStyles.baseMedium.copyWith(
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x3),
                        _FundSourceList(
                          sources: snapshot.sources,
                          selectedSource: _selectedSource,
                          onSelected: (source) {
                            HapticFeedback.selectionClick();
                            setState(() => _selectedSource = source.id);
                          },
                        ),
                        const SizedBox(height: AppSpacing.x5),
                        VitInput(
                          controller: _detailsController,
                          fieldKey: P2PSourceOfFundsPage.inputKey,
                          label: snapshot.inputLabel,
                          hintText: snapshot.inputPlaceholder,
                          textInputAction: TextInputAction.done,
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: AppSpacing.x5),
                        VitCtaButton(
                          key: P2PSourceOfFundsPage.ctaKey,
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

class _SourceHero extends StatelessWidget {
  const _SourceHero({required this.snapshot});

  final P2PSourceOfFundsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PSourceOfFundsPage.heroKey,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      borderColor: AppModuleAccents.p2p.withValues(alpha: .24),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppModuleAccents.p2p,
              borderRadius: AppRadii.lgRadius,
            ),
            child: const SizedBox(
              width: AppSpacing.inputHeight,
              height: AppSpacing.inputHeight,
              child: Icon(
                Icons.attach_money_rounded,
                color: AppColors.onAccent,
                size: AppSpacing.iconMd,
              ),
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
                    color: AppModuleAccents.p2p,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  snapshot.heroSubtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.45,
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

class _FundSourceList extends StatelessWidget {
  const _FundSourceList({
    required this.sources,
    required this.selectedSource,
    required this.onSelected,
  });

  final List<P2PFundSourceDraft> sources;
  final String? selectedSource;
  final ValueChanged<P2PFundSourceDraft> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PSourceOfFundsPage.sourceListKey,
      children: [
        for (var index = 0; index < sources.length; index++) ...[
          _FundSourceTile(
            source: sources[index],
            selected: selectedSource == sources[index].id,
            onTap: () => onSelected(sources[index]),
          ),
          if (index != sources.length - 1)
            const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _FundSourceTile extends StatelessWidget {
  const _FundSourceTile({
    required this.source,
    required this.selected,
    required this.onTap,
  });

  final P2PFundSourceDraft source;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppModuleAccents.p2p : AppColors.text3;

    return Material(
      key: P2PSourceOfFundsPage.sourceKey(source.id),
      color: selected
          ? AppModuleAccents.p2p.withValues(alpha: .10)
          : AppColors.bg,
      borderRadius: AppRadii.cardLargeRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.cardLargeRadius,
        child: VitCard(
          variant: VitCardVariant.ghost,
          radius: VitCardRadius.lg,
          borderColor: selected ? AppModuleAccents.p2p : AppColors.borderSolid,
          constraints: const BoxConstraints(minHeight: AppSpacing.ctaHeight),
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Row(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: selected
                      ? AppModuleAccents.p2p.withValues(alpha: .16)
                      : AppColors.surface2,
                  borderRadius: AppRadii.lgRadius,
                ),
                child: SizedBox(
                  width: AppSpacing.buttonCompact,
                  height: AppSpacing.buttonCompact,
                  child: Icon(
                    _fundIcon(source.iconKey),
                    color: color,
                    size: AppSpacing.iconMd,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  source.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: selected ? AppModuleAccents.p2p : AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              if (selected) ...[
                const SizedBox(width: AppSpacing.x3),
                const Icon(
                  Icons.check_circle_outline_rounded,
                  color: AppModuleAccents.p2p,
                  size: AppSpacing.iconMd,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

IconData _fundIcon(String key) {
  return switch (key) {
    'briefcase' => Icons.business_center_outlined,
    'trend' => Icons.trending_up_rounded,
    'home' => Icons.home_outlined,
    'gift' => Icons.card_giftcard_rounded,
    _ => Icons.attach_money_rounded,
  };
}
