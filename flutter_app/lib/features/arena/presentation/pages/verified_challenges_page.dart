import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
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
import 'package:vit_trade_flutter/app/providers/arena_controller_providers.dart';
import 'package:vit_trade_flutter/features/arena/presentation/controllers/arena_controller.dart';

class VerifiedChallengesPage extends ConsumerWidget {
  const VerifiedChallengesPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc195_verified_content');
  static const infoCardKey = Key('sc195_verified_info');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref
        .watch(arenaReadModelControllerProvider)
        .getVerifiedChallenges();
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-195 VerifiedChallengesPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Verified Challenges',
            subtitle: 'Release-gated preview - Open Arena',
            showBack: true,
            onBack: () => _close(context),
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
                    key: contentKey,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: bottomInset),
                    child: VitPageContent(
                      padding: VitContentPadding.defaultPadding,
                      customGap: AppSpacing.x6,
                      children: [
                        VitCard(child: _VerifiedHero(snapshot: snapshot)),
                        VitCard(
                          padding: EdgeInsets.zero,
                          child: _VerifiedInfoCard(snapshot: snapshot),
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

  void _close(BuildContext context) {
    HapticFeedback.selectionClick();
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.arena);
  }
}

class _VerifiedHero extends StatelessWidget {
  const _VerifiedHero({required this.snapshot});

  final VerifiedChallengesSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(padding: EdgeInsets.only(top: AppSpacing.x1)),
        Container(
          width: AppSpacing.x7 + AppSpacing.x5,
          height: AppSpacing.x7 + AppSpacing.x5,
          decoration: BoxDecoration(
            color: AppColors.accent12,
            border: Border.all(color: AppColors.accent20),
            borderRadius: AppRadii.cardLargeRadius,
          ),
          child: const Icon(
            Icons.lock_outline_rounded,
            color: AppColors.accent,
            size: AppSpacing.iconLg,
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: AppSpacing.x6)),
        Text(
          snapshot.title,
          textAlign: TextAlign.center,
          style: AppTextStyles.sectionTitle.copyWith(color: AppColors.text1),
        ),
        const Padding(padding: EdgeInsets.only(top: AppSpacing.x3)),
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSpacing.arenaVerifiedHeroTextMaxWidth,
          ),
          child: Text(
            snapshot.subtitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: AppSpacing.arenaVerifiedHeroLineHeight,
            ),
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: AppSpacing.x5)),
        VitStatusPill(
          label: snapshot.statusLabel,
          status: VitStatusPillStatus.purple,
          size: VitStatusPillSize.lg,
        ),
      ],
    );
  }
}

class _VerifiedInfoCard extends StatelessWidget {
  const _VerifiedInfoCard({required this.snapshot});

  final VerifiedChallengesSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: VerifiedChallengesPage.infoCardKey,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.primary,
            size: AppSpacing.arenaVerifiedInfoIcon,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.infoTitle,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: AppSpacing.x2)),
                for (final feature in snapshot.features) ...[
                  _FeatureRow(feature: feature),
                  if (feature != snapshot.features.last)
                    const Padding(padding: EdgeInsets.only(top: AppSpacing.x1)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.feature});

  final VerifiedChallengeFeatureDraft feature;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: AppSpacing.x1),
          child: Icon(
            _featureIcon(feature.kind),
            color: AppColors.accent,
            size: AppSpacing.arenaVerifiedFeatureIcon,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            feature.label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: AppSpacing.arenaVerifiedFeatureLineHeight,
            ),
          ),
        ),
      ],
    );
  }
}

IconData _featureIcon(VerifiedChallengeFeatureKind kind) {
  return switch (kind) {
    VerifiedChallengeFeatureKind.oracle => Icons.shield_outlined,
    VerifiedChallengeFeatureKind.escrow => Icons.lock_clock_outlined,
    VerifiedChallengeFeatureKind.leaderboard => Icons.leaderboard_outlined,
    VerifiedChallengeFeatureKind.trust => Icons.verified_user_outlined,
  };
}
