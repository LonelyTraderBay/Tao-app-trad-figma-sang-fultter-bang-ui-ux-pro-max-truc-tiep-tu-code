import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

const _assessmentPrimary = AppColors.primary;

class PreCopyAssessmentPage extends ConsumerStatefulWidget {
  const PreCopyAssessmentPage({
    super.key,
    required this.providerId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc071_pre_copy_assessment_content');
  static const startKey = Key('sc071_pre_copy_assessment_start');
  static const continueKey = Key('sc071_pre_copy_assessment_continue');

  final String providerId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PreCopyAssessmentPage> createState() =>
      _PreCopyAssessmentPageState();
}

class _PreCopyAssessmentPageState extends ConsumerState<PreCopyAssessmentPage> {
  bool _started = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(
      tradePreCopyAssessmentProvider(widget.providerId),
    );

    if (snapshot.isNotFound) {
      return const VitPageLayout(
        variant: VitPageVariant.flush,
        semanticLabel: 'SC-071 PreCopyAssessmentPage blank',
        child: SizedBox.expand(),
      );
    }

    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 104 : 28);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-071 PreCopyAssessmentPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: _started ? 'Câu hỏi đánh giá' : 'Đánh giá rủi ro',
            showBack: true,
            onBack: () =>
                context.go(AppRoutePaths.tradeCopyProvider(widget.providerId)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: PreCopyAssessmentPage.contentKey,
                  padding: EdgeInsets.fromLTRB(20, 16, 20, bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    customGap: 14,
                    fullBleed: true,
                    children: [
                      _started
                          ? _QuestionsSummary(snapshot: snapshot)
                          : _WelcomeAssessment(
                              snapshot: snapshot,
                              onStart: () => setState(() => _started = true),
                            ),
                    ],
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

class _WelcomeAssessment extends StatelessWidget {
  const _WelcomeAssessment({required this.snapshot, required this.onStart});

  final TradePreCopyAssessmentSnapshot snapshot;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final provider = snapshot.provider!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _NoticeCard(
          title: 'Đánh giá bắt buộc (MiFID II)',
          text:
              'Chúng tôi cần đánh giá sự phù hợp của Copy Trading với kiến thức, kinh nghiệm và mục tiêu đầu tư của bạn.',
        ),
        const SizedBox(height: 14),
        VitCard(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: _assessmentPrimary.withValues(alpha: .16),
                child: Text(
                  provider.avatar,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: _assessmentPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      provider.name,
                      style: AppTextStyles.baseMedium.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ROI +${provider.totalPnlPct.toStringAsFixed(1)}% · Max DD ${provider.maxDrawdown.toStringAsFixed(1)}%',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        for (final item in [
          (
            'Trả lời câu hỏi',
            '${snapshot.questions.length} câu hỏi về kinh nghiệm và rủi ro',
          ),
          (
            'Đọc tài liệu',
            '${snapshot.educationDocs.length} tài liệu bắt buộc',
          ),
          ('Nhận kết quả', 'Khuyến nghị phân bổ vốn và cooling-off'),
        ]) ...[
          _ProcessRow(title: item.$1, description: item.$2),
          const SizedBox(height: 12),
        ],
        VitCtaButton(
          key: PreCopyAssessmentPage.startKey,
          onPressed: onStart,
          trailing: const Icon(Icons.chevron_right_rounded, size: 18),
          child: Text(
            'Bắt đầu đánh giá',
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.onAccent,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

class _QuestionsSummary extends StatelessWidget {
  const _QuestionsSummary({required this.snapshot});

  final TradePreCopyAssessmentSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitHighRiskStatePanel(
          state: VitHighRiskUiState.riskReview,
          title: 'Review suitability result',
          message:
              'Confirm risk, limits, cooling-off requirements, and next steps before configuring copy trading.',
        ),
        const SizedBox(height: 14),
        for (final question in snapshot.questions) ...[
          VitCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question.question,
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  question.description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 12),
                for (final option in question.options)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _OptionRow(option: option),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
        VitCtaButton(
          key: PreCopyAssessmentPage.continueKey,
          onPressed: () => context.go(
            AppRoutePaths.tradeCopyProviderConfiguration(snapshot.providerId),
          ),
          variant: VitCtaButtonVariant.success,
          trailing: const Icon(Icons.chevron_right_rounded, size: 18),
          child: Text(
            'Tiếp tục cấu hình',
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.onAccent,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

class _NoticeCard extends StatelessWidget {
  const _NoticeCard({required this.title, required this.text});

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return VitHighRiskStatePanel(
      state: VitHighRiskUiState.riskReview,
      title: title,
      message: text,
    );
  }
}

class _ProcessRow extends StatelessWidget {
  const _ProcessRow({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 16,
          backgroundColor: AppColors.primary15,
          child: Icon(Icons.check_rounded, color: _assessmentPrimary, size: 17),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.baseMedium.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text3,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OptionRow extends StatelessWidget {
  const _OptionRow({required this.option});

  final TradePreCopyOption option;

  @override
  Widget build(BuildContext context) {
    return VitCardStat(
      padding: const EdgeInsets.all(12),
      child: Text(
        option.label,
        style: AppTextStyles.caption.copyWith(color: AppColors.text2),
      ),
    );
  }
}
