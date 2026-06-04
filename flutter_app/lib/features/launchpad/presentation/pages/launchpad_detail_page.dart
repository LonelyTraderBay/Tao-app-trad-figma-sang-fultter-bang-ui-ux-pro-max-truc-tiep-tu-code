import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/launchpad_controller_providers.dart';

class LaunchpadDetailPage extends ConsumerWidget {
  const LaunchpadDetailPage({
    super.key,
    this.projectId = 'sample',
    this.shellRenderMode,
  });

  static const contentKey = Key('sc318_launchpad_detail_content');
  static const errorKey = Key('sc318_launchpad_detail_error');
  static const summaryKey = Key('sc318_launchpad_detail_summary');

  final String projectId;
  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref
        .watch(launchpadControllerProvider)
        .getDetail(projectId);
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-318 LaunchpadDetailPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          bottomInset: bottomInset,
          semanticLabel: 'SC-318 LaunchpadDetailPage scroll surface',
          header: VitHeader(
            title: snapshot.title,
            showBack: true,
            onBack: () => context.go(snapshot.backRoute),
          ),
          child: SingleChildScrollView(
            key: contentKey,
            physics: const BouncingScrollPhysics(),
            child: VitPageContent(
              padding: VitContentPadding.defaultPadding,
              children: [
                if (snapshot.project == null)
                  const _LaunchpadDetailError()
                else
                  _LaunchpadDetailSummary(snapshot: snapshot),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LaunchpadDetailError extends StatelessWidget {
  const _LaunchpadDetailError();

  @override
  Widget build(BuildContext context) {
    return VitErrorState(
      key: LaunchpadDetailPage.errorKey,
      title: 'Không tải được dữ liệu',
      message: 'Vui lòng kiểm tra kết nối mạng và thử lại.',
      icon: Icons.error_outline_rounded,
      iconContainerSize: 48,
      iconSize: 24,
      iconShape: BoxShape.circle,
      verticalPadding: AppSpacing.x7,
      horizontalPadding: AppSpacing.x6,
      titleStyle: AppTextStyles.baseMedium.copyWith(
        color: AppColors.text1,
        fontWeight: AppTextStyles.bold,
      ),
      messageStyle: AppTextStyles.caption.copyWith(
        color: AppColors.text3,
        height: 1.5,
      ),
    );
  }
}

class _LaunchpadDetailSummary extends StatelessWidget {
  const _LaunchpadDetailSummary({required this.snapshot});

  final LaunchpadDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final project = snapshot.project!;
    return VitCard(
      key: LaunchpadDetailPage.summaryKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: AppSpacing.x7,
                height: AppSpacing.x7,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: project.accent.withValues(alpha: .12),
                  border: Border.all(
                    color: project.accent.withValues(alpha: .24),
                  ),
                  borderRadius: AppRadii.cardRadius,
                ),
                child: Text(
                  project.logo,
                  style: AppTextStyles.base.copyWith(
                    color: project.accent,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.name,
                      style: AppTextStyles.baseMedium.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      '${project.symbol} · ${project.chain}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            project.description,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x4),
          VitCtaButton(
            onPressed: () => context.go(snapshot.stakingRoute),
            leading: const Icon(Icons.rocket_launch_outlined),
            child: const Text('Mở Launchpad staking'),
          ),
        ],
      ),
    );
  }
}
