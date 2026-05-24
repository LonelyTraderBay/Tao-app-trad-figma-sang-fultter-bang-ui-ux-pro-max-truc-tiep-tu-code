import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_content.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/arena_repository.dart';

class ArenaResolutionCenterPage extends ConsumerWidget {
  const ArenaResolutionCenterPage({super.key, this.shellRenderMode});

  final ShellRenderMode? shellRenderMode;

  static const emptyKey = Key('sc192_resolution_empty');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref
        .watch(arenaRepositoryProvider)
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
        child: Column(
          children: [
            VitHeader(
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
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: VitEmptyState(
                          key: emptyKey,
                          icon: Icons.warning_amber_rounded,
                          title: snapshot.emptyTitle,
                          message: snapshot.emptySubtitle,
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
    );
  }
}
