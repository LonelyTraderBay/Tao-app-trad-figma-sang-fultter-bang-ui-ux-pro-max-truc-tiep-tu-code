import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
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

class ArenaResolutionCenterPage extends ConsumerWidget {
  const ArenaResolutionCenterPage({super.key, this.shellRenderMode});

  final ShellRenderMode? shellRenderMode;

  static const emptyKey = Key('sc192_resolution_empty');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref
        .watch(arenaReadModelControllerProvider)
        .getArenaResolutionCenter();
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-192 ArenaResolutionCenterPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Chốt kết quả',
            subtitle: 'Resolution · Open Arena',
            showBack: true,
            onBack: () {
              if (context.canPop()) {
                context.pop();
                return;
              }
              context.go(AppRoutePaths.arena);
            },
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
                    physics: const NeverScrollableScrollPhysics(),
                    padding: AppSpacing.arenaBottomScrollPadding(bottomInset),
                    child: VitPageContent(
                      padding: VitContentPadding.none,
                      children: [
                        VitCard(
                          padding: AppSpacing.zeroInsets,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: VitEmptyState(
                              key: emptyKey,
                              icon: Icons.warning_amber_rounded,
                              title: snapshot.emptyTitle,
                              message: snapshot.emptySubtitle,
                            ),
                          ),
                        ),
                        const _ResolutionStatusCard(
                          icon: Icons.rule_folder_outlined,
                          title: 'Resolution scope',
                          body:
                              'Creator evidence, oracle review, and moderation outcomes are grouped here when a challenge needs a final result.',
                        ),
                        const VitCard(
                          child: _ResolutionStatusContent(
                            icon: Icons.verified_user_outlined,
                            title: 'Points integrity',
                            body:
                                'Open Arena keeps point changes paused until the review closes and records the final decision in the points ledger.',
                          ),
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

class _ResolutionStatusCard extends StatelessWidget {
  const _ResolutionStatusCard({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      child: _ResolutionStatusContent(icon: icon, title: title, body: body),
    );
  }
}

class _ResolutionStatusContent extends StatelessWidget {
  const _ResolutionStatusContent({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.accent, size: AppSpacing.iconMd),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.baseMedium.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const Padding(padding: AppSpacing.arenaTopPaddingX1),
              Text(
                body,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: AppSpacing.arenaResolutionBodyLineHeight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
