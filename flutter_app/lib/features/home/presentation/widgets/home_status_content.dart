import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/features/home/presentation/pages/home_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class HomeLoadingContent extends StatelessWidget {
  const HomeLoadingContent({super.key});

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      padding: VitContentPadding.compact,
      density: VitDensity.compact,
      children: const [
        HomePortfolioSkeleton(),
        SizedBox(height: AppSpacing.x3),
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
      padding: AppSpacing.homePortfolioCardPadding,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VitSkeleton(width: 160, height: AppSpacing.x3),
          SizedBox(height: AppSpacing.x3),
          VitSkeleton(width: double.infinity, height: AppSpacing.x6),
          SizedBox(height: AppSpacing.x3),
          VitSkeleton(width: 120, height: AppSpacing.x3),
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
        SizedBox(height: AppSpacing.x3),
        VitSkeletonList(rows: 3),
      ],
    );
  }
}
