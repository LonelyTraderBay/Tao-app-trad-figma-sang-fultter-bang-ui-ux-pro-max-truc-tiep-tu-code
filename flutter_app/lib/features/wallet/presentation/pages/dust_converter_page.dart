import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

part '../widgets/wallet_dust_converter_hero.dart';
part '../widgets/wallet_dust_converter_targets.dart';
part '../widgets/wallet_dust_converter_assets.dart';
part '../widgets/wallet_dust_converter_confirm.dart';

const _dustBackground = AppColors.bg;
const _dustPanel = AppColors.surface;
const _dustPanel2 = AppColors.surface3;
const _dustHeroBorder = AppColors.primary20;
const _dustBorder = AppColors.overlayStroke;
const _dustPrimary = AppColors.primary;
const _dustGreen = AppColors.buy;
const _dustAmber = AppColors.caution;
const _dustMuted = AppColors.text3;
const _dustNativeBottomClearance = 88.0;
const _dustVisualBottomClearance = 112.0;
const _dustScrollTopPad = 0.0;
const _dustGap = 8.0;
const _dustTinyGap = 4.0;
const _dustInlineGap = 8.0;
const _dustHeroIconBox = 40.0;
const _dustHeroStatHeight = 48.0;
const _dustTargetHeight = 54.0;
const _dustSelectAllHeight = 40.0;
const _dustAssetRowHeight = 58.0;
const _dustTokenLogo = 34.0;
const _dustButtonHeight = 46.0;
const _dustHeroPadding = EdgeInsets.all(12);
const _dustHeroStatPadding = EdgeInsets.symmetric(horizontal: 8, vertical: 4);
const _dustTargetPadding = EdgeInsets.symmetric(horizontal: 10, vertical: 6);
const _dustSelectAllPadding = EdgeInsets.symmetric(horizontal: 12, vertical: 8);
const _dustAssetRowPadding = EdgeInsets.symmetric(horizontal: 12, vertical: 8);
const _dustFooterPadding = EdgeInsets.fromLTRB(16, 8, 16, 8);
const _dustSheetPadding = EdgeInsets.fromLTRB(16, 14, 16, 16);
const _dustPreviewPadding = EdgeInsets.symmetric(horizontal: 12, vertical: 12);
const _dustConvertedPadding = EdgeInsets.symmetric(
  horizontal: 12,
  vertical: 10,
);

double _dustBottomSpace(BuildContext context, ShellRenderMode mode) {
  return (mode.usesVisualQaFrame
          ? _dustVisualBottomClearance
          : _dustNativeBottomClearance) +
      MediaQuery.paddingOf(context).bottom;
}

class DustConverterPage extends ConsumerStatefulWidget {
  const DustConverterPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc154_dust_converter_content');
  static const selectAllKey = Key('sc154_dust_converter_select_all');
  static const ctaKey = Key('sc154_dust_converter_cta');
  static const confirmSheetKey = Key('sc154_dust_converter_confirm_sheet');
  static const confirmButtonKey = Key('sc154_dust_converter_confirm_button');
  static Key targetKey(String symbol) =>
      Key('sc154_dust_converter_target_$symbol');
  static Key assetKey(String id) => Key('sc154_dust_converter_asset_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<DustConverterPage> createState() => _DustConverterPageState();
}

class _DustConverterPageState extends ConsumerState<DustConverterPage> {
  String _targetSymbol = 'USDT';
  final Set<String> _selectedIds = {};
  bool _converted = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(walletDustConverterProvider);
    final assets = snapshot.eligibleAssets(_targetSymbol);
    final selectedAssets = assets
        .where((asset) => _selectedIds.contains(asset.id))
        .toList(growable: false);
    final selectedTotal = _sumUsd(selectedAssets);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomSpace = _dustBottomSpace(context, mode);
    final inlineFooter =
        mode.usesVisualQaFrame &&
        MediaQuery.sizeOf(context).height >
            AppSpacing.walletDustInlineFooterHeightThreshold;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-154 DustConverterPage',
      child: Material(
        color: _dustBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Chuy\u1EC3n \u0111\u1ED5i s\u1ED1 d\u01B0 nh\u1ECF',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.wallet),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: DustConverterPage.contentKey,
                  padding: AppSpacing.contentInsets.copyWith(
                    top: _dustScrollTopPad,
                    bottom: _dustGap,
                  ),
                  physics: const BouncingScrollPhysics(),
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    density: VitDensity.compact,
                    fullBleed: true,
                    children: [
                      if (_converted)
                        _ConvertedBanner(targetSymbol: _targetSymbol),
                      VitHighRiskStatePanel(
                        state: VitHighRiskUiState.riskReview,
                        title: 'Review dust conversion',
                        message:
                            'Confirm selected assets, conversion fee, receive amount, and target asset before submitting.',
                        contractId:
                            '${_selectedIds.length} selected / $_targetSymbol',
                      ),
                      _DustHero(
                        snapshot: snapshot,
                        targetSymbol: _targetSymbol,
                        foundCount: assets.length,
                        selectedCount: _selectedIds.length,
                        selectedValue: selectedTotal,
                      ),
                      const _SectionLabel(
                        label: 'Chuy\u1EC3n \u0111\u1ED5i sang',
                      ),
                      _TargetSelector(
                        targets: snapshot.targets,
                        selected: _targetSymbol,
                        onSelected: (symbol) => setState(() {
                          _targetSymbol = symbol;
                          _selectedIds.clear();
                          _converted = false;
                        }),
                      ),
                      _SectionLabel(
                        label: 'S\u1ED1 d\u01B0 nh\u1ECF (${assets.length})',
                      ),
                      _SelectAllRow(
                        selectedAll: _selectedIds.length == assets.length,
                        selectedCount: _selectedIds.length,
                        totalCount: assets.length,
                        onTap: () => setState(() {
                          _converted = false;
                          if (_selectedIds.length == assets.length) {
                            _selectedIds.clear();
                          } else {
                            _selectedIds
                              ..clear()
                              ..addAll(assets.map((asset) => asset.id));
                          }
                        }),
                      ),
                      const SizedBox(height: _dustGap),
                      for (final asset in assets) ...[
                        _DustAssetRow(
                          asset: asset,
                          selected: _selectedIds.contains(asset.id),
                          onTap: () => _toggleAsset(asset.id),
                        ),
                        if (asset != assets.last)
                          const SizedBox(height: _dustTinyGap),
                      ],
                      if (inlineFooter) ...[
                        _ConvertFooter(
                          bottomSpace: 0,
                          horizontalPadding: 0,
                          selectedCount: _selectedIds.length,
                          targetSymbol: _targetSymbol,
                          enabled: _selectedIds.isNotEmpty,
                          onTap: () => _showConfirmSheet(
                            context,
                            snapshot,
                            selectedAssets,
                            selectedTotal,
                          ),
                        ),
                        const SizedBox(height: _dustVisualBottomClearance),
                      ],
                    ],
                  ),
                ),
              ),
              if (!inlineFooter)
                _ConvertFooter(
                  bottomSpace: bottomSpace,
                  selectedCount: _selectedIds.length,
                  targetSymbol: _targetSymbol,
                  enabled: _selectedIds.isNotEmpty,
                  onTap: () => _showConfirmSheet(
                    context,
                    snapshot,
                    selectedAssets,
                    selectedTotal,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleAsset(String id) {
    setState(() {
      _converted = false;
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _showConfirmSheet(
    BuildContext context,
    WalletDustConverterSnapshot snapshot,
    List<WalletDustAsset> selectedAssets,
    double selectedTotal,
  ) {
    if (selectedAssets.isEmpty) return;
    final fee = selectedTotal * snapshot.conversionFeePct / 100;
    final received = selectedTotal - fee;

    showVitBottomSheet<void>(
      context: context,
      backgroundColor: _dustPanel,
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadii.sheetTopRadius,
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            key: DustConverterPage.confirmSheetKey,
            padding: _dustSheetPadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'X\u00E1c nh\u1EADn chuy\u1EC3n \u0111\u1ED5i',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: _dustGap),
                VitCard(
                  variant: VitCardVariant.inner,
                  radius: VitCardRadius.sm,
                  padding: _dustPreviewPadding,
                  borderColor: _dustBorder,
                  child: Column(
                    children: [
                      _PreviewRow(
                        label: 'S\u1ED1 t\u00E0i s\u1EA3n',
                        value: '${selectedAssets.length} lo\u1EA1i',
                      ),
                      _PreviewRow(
                        label: 'T\u1ED5ng gi\u00E1 tr\u1ECB',
                        value: _formatUsd(selectedTotal),
                      ),
                      _PreviewRow(
                        label: 'Ph\u00ED chuy\u1EC3n \u0111\u1ED5i',
                        value:
                            '${_formatUsd(fee)} (${snapshot.conversionFeePct}%)',
                      ),
                      _PreviewRow(
                        label: 'Nh\u1EADn \u0111\u01B0\u1EE3c',
                        value: '${_formatAmount(received)} $_targetSymbol',
                        valueColor: _dustGreen,
                        last: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: _dustGap),
                _PrimaryButton(
                  key: DustConverterPage.confirmButtonKey,
                  label: 'Chuy\u1EC3n \u0111\u1ED5i sang $_targetSymbol',
                  enabled: true,
                  onTap: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _converted = true;
                      _selectedIds.clear();
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
