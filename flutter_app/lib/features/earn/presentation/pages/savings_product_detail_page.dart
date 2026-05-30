import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_controller_providers.dart';

class SavingsProductDetailPage extends ConsumerWidget {
  const SavingsProductDetailPage({
    super.key,
    required this.productId,
    this.shellRenderMode,
  });

  static const backButtonKey = Key('sc330_back_to_savings_button');

  final String productId;
  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref
        .watch(savingsProductDetailRepositoryProvider)
        .getProductDetail(productId: productId);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-330 SavingsProductDetailPage',
      child: Material(
        color: AppColors.bg,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
            ),
            VitPageContent(
              grow: true,
              padding: VitContentPadding.compact,
              children: [
                const SizedBox(height: AppSpacing.x7 + AppSpacing.x6),
                _NotFoundProductState(snapshot: snapshot),
                const Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NotFoundProductState extends StatelessWidget {
  const _NotFoundProductState({required this.snapshot});

  final SavingsProductDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.warning_amber_rounded,
          color: AppColors.text3,
          size: AppSpacing.iconLg,
        ),
        const SizedBox(height: AppSpacing.x4),
        Text(
          snapshot.notFoundMessage,
          textAlign: TextAlign.center,
          style: AppTextStyles.base.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.x5),
        Align(
          alignment: Alignment.center,
          child: VitCtaButton(
            key: SavingsProductDetailPage.backButtonKey,
            fullWidth: false,
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x5),
            onPressed: () {
              HapticFeedback.selectionClick();
              context.go(snapshot.backRoute);
            },
            child: const Text('Quay lại'),
          ),
        ),
      ],
    );
  }
}
