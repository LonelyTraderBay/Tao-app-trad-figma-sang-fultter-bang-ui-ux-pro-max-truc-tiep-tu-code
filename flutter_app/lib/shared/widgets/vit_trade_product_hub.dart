import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_action_tile_grid.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_bottom_sheet.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_module_components.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_section_header.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_sheet_handle.dart';

/// Hub tile descriptor for trade product launcher.
final class VitTradeHubItem {
  const VitTradeHubItem({
    required this.id,
    required this.label,
    required this.badge,
    required this.icon,
    required this.accentColor,
    required this.onTap,
    this.tileKey,
  });

  final String id;
  final String label;
  final String badge;
  final IconData icon;
  final Color accentColor;
  final VoidCallback onTap;
  final Key? tileKey;
}

class VitTradeProductHub extends StatelessWidget {
  const VitTradeProductHub({
    super.key,
    required this.items,
    this.primaryCount = AppSpacing.tradeHubPrimaryCount,
    this.density = VitDensity.compact,
    this.sectionTitle = 'Sản phẩm giao dịch',
    this.moreSheetTitle = 'Thêm sản phẩm',
  });

  final List<VitTradeHubItem> items;
  final int primaryCount;
  final VitDensity density;
  final String sectionTitle;
  final String moreSheetTitle;

  List<VitTradeHubItem> get _primaryItems =>
      items.take(primaryCount).toList(growable: false);

  List<VitTradeHubItem> get _overflowItems =>
      items.length > primaryCount
          ? items.skip(primaryCount).toList(growable: false)
          : const [];

  void _openMoreSheet(BuildContext context) {
    final overflow = _overflowItems;
    if (overflow.isEmpty) return;
    showVitBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bg,
      builder: (sheetContext) {
        return VitSheetPanel(
          title: moreSheetTitle,
          child: VitActionTileGrid(
            density: density,
            crossAxisSpacing: AppSpacing.x3,
            mainAxisSpacing: AppSpacing.x3,
            physics: const ClampingScrollPhysics(),
            itemCount: overflow.length,
            itemBuilder: (context, index, tileDensity) {
              final item = overflow[index];
              return VitServiceTile(
                key: item.tileKey,
                density: tileDensity,
                icon: item.icon,
                label: item.label,
                accentColor: item.accentColor,
                badgeLabel: item.badge,
                onTap: item.onTap,
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final overflow = _overflowItems;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitSectionHeader(
          title: sectionTitle,
          actionLabel: overflow.isEmpty ? null : 'Xem thêm',
          onAction: overflow.isEmpty ? null : () => _openMoreSheet(context),
        ),
        const SizedBox(height: AppSpacing.x3),
        VitActionTileGrid(
          density: density,
          itemCount: _primaryItems.length,
          itemBuilder: (context, index, tileDensity) {
            final item = _primaryItems[index];
            return VitServiceTile(
              key: item.tileKey,
              density: tileDensity,
              icon: item.icon,
              label: item.label,
              accentColor: item.accentColor,
              badgeLabel: item.badge,
              onTap: item.onTap,
            );
          },
        ),
      ],
    );
  }
}
