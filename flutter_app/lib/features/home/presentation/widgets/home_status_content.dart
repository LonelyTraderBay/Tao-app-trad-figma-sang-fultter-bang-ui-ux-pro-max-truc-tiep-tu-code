import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/features/home/presentation/pages/home_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

// Mirrors the loaded page's block order (portfolio, next action, products
// grid, recent products, market) so the first paint doesn't pop/reflow once
// data resolves.
class HomeLoadingContent extends StatelessWidget {
  const HomeLoadingContent({super.key});

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      padding: VitContentPadding.compact,
      rhythm: VitPageRhythm.compact,
      children: const [
        HomePortfolioSkeleton(),
        HomeNextActionSkeleton(),
        HomeProductsSkeleton(),
        HomeRecentProductsSkeleton(),
        HomeMarketSkeleton(),
      ],
    );
  }
}

class HomeErrorContent extends StatelessWidget {
  const HomeErrorContent({super.key, required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return VitInsetScrollView(
      key: HomePage.contentKey,
      physics: const AlwaysScrollableScrollPhysics(),
      child: VitErrorState(
        title: 'Không tải được dữ liệu',
        message: 'Vui lòng kiểm tra kết nối và thử lại.',
        actionLabel: 'Thử lại',
        onAction: () => onRetry(),
      ),
    );
  }
}

class HomePortfolioSkeleton extends StatelessWidget {
  const HomePortfolioSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: AppSpacing.homeCardPaddingDefault,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VitSkeleton(width: 160, height: AppSpacing.x3),
          SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitSkeleton(width: double.infinity, height: AppSpacing.x6),
          SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitSkeleton(width: 120, height: AppSpacing.x3),
        ],
      ),
    );
  }
}

class HomeNextActionSkeleton extends StatelessWidget {
  const HomeNextActionSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsetsDirectional.all(
        AppSpacing.homeNextActionCardPadding,
      ),
      child: const Row(
        children: [
          VitSkeleton(
            width: AppSpacing.homeNextActionIconContainer,
            height: AppSpacing.homeNextActionIconContainer,
            borderRadius: AppRadii.smRadius,
          ),
          SizedBox(width: AppSpacing.homeCommandRowSpacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VitSkeleton(width: 160, height: 14),
                SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                VitSkeleton(width: 220, height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HomeProductsSkeleton extends StatelessWidget {
  const HomeProductsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return VitActionTileGrid(
      density: VitDensity.compact,
      itemCount: AppSpacing.homeQuickActionCompactCount,
      itemBuilder: (context, index, tileDensity) => const VitSkeleton(
        width: double.infinity,
        height: double.infinity,
        borderRadius: AppRadii.cardRadius,
      ),
    );
  }
}

class HomeRecentProductsSkeleton extends StatelessWidget {
  const HomeRecentProductsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.homeRecentProductHeight,
      child: const Row(
        children: [
          Expanded(
            child: VitSkeleton(
              width: double.infinity,
              height: double.infinity,
              borderRadius: AppRadii.cardRadius,
            ),
          ),
          SizedBox(width: AppSpacing.x3),
          Expanded(
            child: VitSkeleton(
              width: double.infinity,
              height: double.infinity,
              borderRadius: AppRadii.cardRadius,
            ),
          ),
          SizedBox(width: AppSpacing.x3),
          Expanded(
            child: VitSkeleton(
              width: double.infinity,
              height: double.infinity,
              borderRadius: AppRadii.cardRadius,
            ),
          ),
        ],
      ),
    );
  }
}

class HomeMarketSkeleton extends StatelessWidget {
  const HomeMarketSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitSkeleton(width: 120, height: AppSpacing.x4),
        SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        VitSkeletonList(rows: 3),
      ],
    );
  }
}
