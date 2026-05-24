import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../data/wallet_repository.dart';

const _dustBackground = AppColors.bg;
const _dustPanel = AppColors.surface;
const _dustPanel2 = AppColors.surface3;
const _dustHero = AppColors.surface;
const _dustHeroBorder = AppColors.primary20;
const _dustBorder = Color(0x14FFFFFF);
const _dustPrimary = AppColors.primary;
const _dustGreen = Color(0xFF10B981);
const _dustAmber = Color(0xFFF59E0B);
const _dustMuted = Color(0xFF667085);

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
    final snapshot = ref.watch(walletRepositoryProvider).getDustConverter();
    final assets = snapshot.eligibleAssets(_targetSymbol);
    final selectedAssets = assets
        .where((asset) => _selectedIds.contains(asset.id))
        .toList(growable: false);
    final selectedTotal = _sumUsd(selectedAssets);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomSpace =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome
            : DeviceMetrics.nativeBottomChrome) +
        MediaQuery.paddingOf(context).bottom;
    final inlineFooter =
        mode.usesVisualQaFrame && MediaQuery.sizeOf(context).height > 1000;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-154 DustConverterPage',
      child: Material(
        color: _dustBackground,
        child: Column(
          children: [
            VitHeader(
              title: 'Chuy\u1EC3n \u0111\u1ED5i s\u1ED1 d\u01B0 nh\u1ECF',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.wallet),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: DustConverterPage.contentKey,
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_converted) ...[
                      _ConvertedBanner(targetSymbol: _targetSymbol),
                      const SizedBox(height: 12),
                    ],
                    _DustHero(
                      snapshot: snapshot,
                      targetSymbol: _targetSymbol,
                      foundCount: assets.length,
                      selectedCount: _selectedIds.length,
                      selectedValue: selectedTotal,
                    ),
                    const SizedBox(height: 18),
                    const _SectionLabel(
                      label: 'Chuy\u1EC3n \u0111\u1ED5i sang',
                    ),
                    const SizedBox(height: 10),
                    _TargetSelector(
                      targets: snapshot.targets,
                      selected: _targetSymbol,
                      onSelected: (symbol) => setState(() {
                        _targetSymbol = symbol;
                        _selectedIds.clear();
                        _converted = false;
                      }),
                    ),
                    const SizedBox(height: 18),
                    _SectionLabel(
                      label: 'S\u1ED1 d\u01B0 nh\u1ECF (${assets.length})',
                    ),
                    const SizedBox(height: 10),
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
                    const SizedBox(height: 16),
                    for (final asset in assets) ...[
                      _DustAssetRow(
                        asset: asset,
                        selected: _selectedIds.contains(asset.id),
                        onTap: () => _toggleAsset(asset.id),
                      ),
                      if (asset != assets.last) const SizedBox(height: 8),
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
                      const SizedBox(height: DeviceMetrics.bottomChrome + 96),
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

    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: _dustPanel,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: Container(
            key: DustConverterPage.confirmSheetKey,
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'X\u00E1c nh\u1EADn chuy\u1EC3n \u0111\u1ED5i',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.baseMedium.copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _dustBackground,
                    borderRadius: AppRadii.cardRadius,
                    border: Border.all(color: _dustBorder),
                  ),
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
                const SizedBox(height: 14),
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

class _DustHero extends StatelessWidget {
  const _DustHero({
    required this.snapshot,
    required this.targetSymbol,
    required this.foundCount,
    required this.selectedCount,
    required this.selectedValue,
  });

  final WalletDustConverterSnapshot snapshot;
  final String targetSymbol;
  final int foundCount;
  final int selectedCount;
  final double selectedValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: BoxDecoration(
        color: _dustHero,
        borderRadius: AppRadii.lgRadius,
        border: Border.all(color: _dustHeroBorder),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _dustAmber.withValues(alpha: .14),
                  borderRadius: AppRadii.cardRadius,
                  border: Border.all(color: _dustAmber.withValues(alpha: .5)),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: _dustAmber,
                  size: 25,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'D\u1ECDn d\u1EB9p v\u00ED',
                      style: AppTextStyles.body.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Chuy\u1EC3n \u0111\u1ED5i s\u1ED1 d\u01B0 nh\u1ECF (d\u01B0\u1EDBi ${_formatUsd(snapshot.dustThresholdUsd)}) sang $targetSymbol',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: _dustMuted,
                        fontSize: 11,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 11),
          Row(
            children: [
              _HeroStat(
                value: foundCount.toString(),
                label: 'Dust t\u00ECm th\u1EA5y',
                color: _dustAmber,
              ),
              const SizedBox(width: 8),
              _HeroStat(
                value: selectedCount.toString(),
                label: '\u0110\u00E3 ch\u1ECDn',
                color: _dustPrimary,
              ),
              const SizedBox(width: 8),
              _HeroStat(
                value: _formatUsd(selectedValue),
                label: 'Gi\u00E1 tr\u1ECB',
                color: _dustGreen,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
        decoration: BoxDecoration(
          color: AppColors.surface3,
          borderRadius: AppRadii.cardRadius,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  height: 1,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                fontSize: 9,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TargetSelector extends StatelessWidget {
  const _TargetSelector({
    required this.targets,
    required this.selected,
    required this.onSelected,
  });

  final List<WalletDustTarget> targets;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final target in targets) ...[
          Expanded(
            child: _TargetCard(
              target: target,
              selected: target.symbol == selected,
              onTap: () => onSelected(target.symbol),
            ),
          ),
          if (target != targets.last) const SizedBox(width: 10),
        ],
      ],
    );
  }
}

class _TargetCard extends StatelessWidget {
  const _TargetCard({
    required this.target,
    required this.selected,
    required this.onTap,
  });

  final WalletDustTarget target;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Color(target.colorHex);
    return GestureDetector(
      key: DustConverterPage.targetKey(target.symbol),
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: AppSpacing.buttonStandard + AppSpacing.x2,
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: .11) : _dustPanel2,
          borderRadius: AppRadii.cardRadius,
          border: Border.all(
            color: selected ? color.withValues(alpha: .7) : _dustBorder,
          ),
        ),
        child: Row(
          children: [
            _TokenLogo(symbol: target.symbol, color: color, size: 34),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    target.symbol,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    target.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: _dustMuted,
                      fontSize: 10,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              const Icon(
                Icons.check_circle_outline,
                color: _dustGreen,
                size: 18,
              ),
          ],
        ),
      ),
    );
  }
}

class _SelectAllRow extends StatelessWidget {
  const _SelectAllRow({
    required this.selectedAll,
    required this.selectedCount,
    required this.totalCount,
    required this.onTap,
  });

  final bool selectedAll;
  final int selectedCount;
  final int totalCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final label = selectedAll && totalCount > 0
        ? 'B\u1ECF ch\u1ECDn t\u1EA5t c\u1EA3'
        : 'Ch\u1ECDn t\u1EA5t c\u1EA3';
    return GestureDetector(
      key: DustConverterPage.selectAllKey,
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: _dustPanel2,
          borderRadius: AppRadii.cardRadius,
        ),
        child: Row(
          children: [
            Icon(
              selectedAll && totalCount > 0
                  ? Icons.check_box_rounded
                  : Icons.check_box_outline_blank_rounded,
              color: selectedCount > 0 ? _dustPrimary : _dustMuted,
              size: 17,
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontSize: 12,
                fontWeight: FontWeight.w800,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DustAssetRow extends StatelessWidget {
  const _DustAssetRow({
    required this.asset,
    required this.selected,
    required this.onTap,
  });

  final WalletDustAsset asset;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Color(asset.colorHex);
    return GestureDetector(
      key: DustConverterPage.assetKey(asset.id),
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 59,
        padding: const EdgeInsets.fromLTRB(12, 11, 12, 11),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: .07) : _dustPanel2,
          borderRadius: AppRadii.cardRadius,
          border: Border.all(
            color: selected ? color.withValues(alpha: .45) : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.check_box_rounded
                  : Icons.check_box_outline_blank_rounded,
              color: selected ? _dustPrimary : _dustMuted,
              size: 18,
            ),
            const SizedBox(width: 13),
            _TokenLogo(symbol: asset.symbol, color: color, size: 34),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    asset.symbol,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    asset.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: _dustMuted,
                      fontSize: 10,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  asset.availableLabel,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    height: 1,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '\u2248 ${_formatUsd(asset.usdValue, preciseSmall: true)}',
                  style: AppTextStyles.micro.copyWith(
                    color: _dustMuted,
                    fontSize: 10,
                    height: 1,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ConvertFooter extends StatelessWidget {
  const _ConvertFooter({
    required this.bottomSpace,
    required this.selectedCount,
    required this.targetSymbol,
    required this.enabled,
    required this.onTap,
    this.horizontalPadding = 20,
  });

  final double bottomSpace;
  final int selectedCount;
  final String targetSymbol;
  final bool enabled;
  final VoidCallback onTap;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        16,
        horizontalPadding,
        bottomSpace + 6,
      ),
      decoration: const BoxDecoration(
        color: Color(0xF2080C14),
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: _PrimaryButton(
        key: DustConverterPage.ctaKey,
        enabled: enabled,
        label: enabled
            ? 'Chuy\u1EC3n \u0111\u1ED5i $selectedCount t\u00E0i s\u1EA3n \u2192 $targetSymbol'
            : 'Ch\u1ECDn t\u00E0i s\u1EA3n \u0111\u1EC3 chuy\u1EC3n \u0111\u1ED5i',
        onTap: onTap,
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    super.key,
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  final String label;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: enabled ? _dustPrimary : AppColors.surface3,
          borderRadius: AppRadii.inputRadius,
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.baseMedium.copyWith(
            color: enabled ? Colors.white : AppColors.text3,
            fontSize: 16,
            fontWeight: FontWeight.w900,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _PreviewRow extends StatelessWidget {
  const _PreviewRow({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
    this.last = false,
  });

  final String label;
  final String value;
  final Color valueColor;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : 11),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontSize: 12,
              ),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: valueColor,
              fontSize: 12,
              fontWeight: FontWeight.w900,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _ConvertedBanner extends StatelessWidget {
  const _ConvertedBanner({required this.targetSymbol});

  final String targetSymbol;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: _dustGreen.withValues(alpha: .1),
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: _dustGreen.withValues(alpha: .28)),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: _dustGreen, size: 19),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '\u0110\u00E3 chuy\u1EC3n \u0111\u1ED5i sang $targetSymbol',
              style: AppTextStyles.caption.copyWith(
                color: _dustGreen,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 15,
          decoration: BoxDecoration(
            color: _dustPrimary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 7),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontSize: 11,
            fontWeight: FontWeight.w900,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _TokenLogo extends StatelessWidget {
  const _TokenLogo({
    required this.symbol,
    required this.color,
    required this.size,
  });

  final String symbol;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .18),
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: .42)),
      ),
      alignment: Alignment.center,
      child: Text(
        symbol.length > 3 ? symbol.substring(0, 3) : symbol,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w900,
          height: 1,
        ),
      ),
    );
  }
}

double _sumUsd(List<WalletDustAsset> assets) {
  return assets.fold<double>(0, (sum, asset) => sum + asset.usdValue);
}

String _formatAmount(double value) => value.toStringAsFixed(4);

String _formatUsd(double value, {bool preciseSmall = false}) {
  final fixed = value.toStringAsFixed(
    preciseSmall && value < 1 && value > 0 ? 4 : 2,
  );
  final parts = fixed.split('.');
  final integer = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < integer.length; i++) {
    if (i > 0 && (integer.length - i) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(integer[i]);
  }
  return '\$${buffer.toString()}.${parts.last}';
}
