import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_controller_providers.dart';

class SavingsReceiptPage extends ConsumerWidget {
  const SavingsReceiptPage({super.key, this.shellRenderMode});

  static const savingsButtonKey = Key('sc332_back_to_savings_button');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(savingsReceiptRepositoryProvider).getReceipt();

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-332 SavingsReceiptPage',
      child: Material(
        color: AppColors.bg,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: snapshot.title,
            showBack: true,
            onBack: () => context.go(snapshot.backRoute),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              VitPageContent(
                rhythm: VitPageRhythm.standard,
                grow: true,
                padding: VitContentPadding.compact,
                children: [
                  VitCard(
                    variant: VitCardVariant.standard,
                    radius: VitCardRadius.standard,
                    padding: AppSpacing.zeroInsets,
                    child: _EmptyReceiptState(snapshot: snapshot),
                  ),
                  const Spacer(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyReceiptState extends StatelessWidget {
  const _EmptyReceiptState({required this.snapshot});

  final SavingsReceiptSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VitHighRiskStatePanel(
          state: VitHighRiskUiState.empty,
          title: 'Chưa có biên nhận',
          message: snapshot.emptyMessage,
          contractId: 'savings-receipt-empty',
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        Align(
          alignment: Alignment.center,
          child: VitCtaButton(
            key: SavingsReceiptPage.savingsButtonKey,
            fullWidth: false,
            height: AppSpacing.savingsFlowHeroHeight,
            onPressed: () {
              HapticFeedback.selectionClick();
              context.go(snapshot.backRoute);
            },
            child: const Text('Về Tiết kiệm'),
          ),
        ),
      ],
    );
  }
}
