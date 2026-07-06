import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_asset_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/features/home/domain/entities/home_entities.dart';
import 'package:vit_trade_flutter/features/home/presentation/pages/home_page.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/home_formatters.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

const double _assetAvatarExtent = AppSpacing.iconMd + AppSpacing.x1;

class HomeMarketTickerSection extends StatelessWidget {
  const HomeMarketTickerSection({
    super.key,
    required this.pairs,
    required this.onNavigate,
  });

  final List<HomeCryptoPair> pairs;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return VitMarketTickerStrip(
      key: HomePage.marketTickerKey,
      items: [
        for (final pair in pairs)
          VitMarketTickerData(
            leading: VitAssetAvatar(
              label: pair.baseAsset,
              accentColor: AppAssetColors.forSymbol(pair.baseAsset),
              size: _assetAvatarExtent,
            ),
            title: pair.symbol,
            price: formatUsd(pair.price),
            changeLabel: formatPct(pair.change24h),
            trend: pair.change24h >= 0
                ? VitTrendDirection.positive
                : VitTrendDirection.negative,
            onTap: () => onNavigate('/pair/${pair.id}'),
          ),
      ],
    );
  }
}
