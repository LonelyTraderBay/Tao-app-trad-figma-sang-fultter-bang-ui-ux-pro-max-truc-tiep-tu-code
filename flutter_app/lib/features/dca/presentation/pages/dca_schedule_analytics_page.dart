import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/features/dca/data/dca_repository.dart';

class DCAScheduleAnalytics extends ConsumerWidget {
  const DCAScheduleAnalytics({
    super.key,
    required this.configId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc173_schedule_analytics_content');
  static const missingConfigKey = Key('sc173_missing_config');

  final String configId;
  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref
        .watch(dcaRepositoryProvider)
        .getScheduleAnalytics(configId);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-173 DCAScheduleAnalytics',
      child: VitPageContent(
        key: contentKey,
        padding: VitContentPadding.none,
        children: [
          Center(
            child: Text(
              snapshot.message,
              key: missingConfigKey,
              style: AppTextStyles.base.copyWith(color: AppColors.text2),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
