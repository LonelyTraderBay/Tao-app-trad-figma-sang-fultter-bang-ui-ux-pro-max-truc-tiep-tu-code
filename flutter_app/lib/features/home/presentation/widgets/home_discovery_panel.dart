import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Tablet sidebar equivalent of Home's private `_HomeDiscoverySection`
/// (`home_page_sections.dart`, phone-only — not importable outside
/// `home_page.dart`'s `part` family). Same Prediction Markets / Arena promo
/// cards and risk note, built as its own public widget so `HomeTabletPage`
/// can place it in the secondary column without touching the pinned SC-007
/// phone reference.
class HomeDiscoveryPanel extends StatelessWidget {
  const HomeDiscoveryPanel({super.key, required this.onNavigate});

  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitSectionHeader(
          title: 'Dự đoán & Thách đấu',
          bottomGap: AppSpacing.pageRhythmCompactInnerGap,
        ),
        VitDiscoveryActionCard(
          title: 'Thị trường dự đoán',
          badgeLabel: 'Ví / PnL',
          subtitle: 'Thị trường xác suất, vị thế và danh mục',
          actionLabel: 'Khám phá thị trường',
          icon: Icons.adjust_rounded,
          accentColor: AppColors.accent,
          borderColor: AppColors.accent20,
          variant: VitDiscoveryActionCardVariant.compact,
          background: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.accent15, AppColors.primary08],
          ),
          onTap: () => onNavigate('/markets/predictions'),
        ),
        const SizedBox(height: SharedSpacingTokens.homeSectionInnerGap),
        VitDiscoveryActionCard(
          title: 'Arena',
          badgeLabel: 'Chỉ điểm Arena',
          subtitle: 'Tạo chế độ chơi, mở phòng, dùng điểm Arena',
          actionLabel: 'Vào Arena',
          icon: Icons.sports_esports_outlined,
          accentColor: AppColors.riskWarning,
          borderColor: AppColors.warningBorder,
          badgeStatus: VitStatusPillStatus.warning,
          variant: VitDiscoveryActionCardVariant.compact,
          background: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.riskWarning15, AppColors.riskWarning10],
          ),
          onTap: () => onNavigate('/arena'),
        ),
        const SizedBox(height: SharedSpacingTokens.homeSectionInnerGap),
        const VitRiskDisclaimerNote(
          message:
              'Dự đoán dùng vị thế thật. Arena chỉ dùng điểm (không phải tiền thật).',
          semanticsLabel:
              'Lưu ý rủi ro: Dự đoán dùng vị thế thật. Arena chỉ dùng điểm '
              '(không phải tiền thật).',
        ),
      ],
    );
  }
}
