import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

const _assessmentPrimary = AppColors.primary;
const _assessmentGreen = AppColors.buy;

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
                  child: _started
                      ? _QuestionsSummary(snapshot: snapshot)
                      : _WelcomeAssessment(
                          snapshot: snapshot,
                          onStart: () => setState(() => _started = true),
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
          icon: Icons.shield_outlined,
          title: 'Đánh giá bắt buộc (MiFID II)',
          text:
              'Chúng tôi cần đánh giá sự phù hợp của Copy Trading với kiến thức, kinh nghiệm và mục tiêu đầu tư của bạn.',
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadii.cardRadius,
          ),
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
        FilledButton.icon(
          key: PreCopyAssessmentPage.startKey,
          onPressed: onStart,
          style: FilledButton.styleFrom(
            backgroundColor: _assessmentPrimary,
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(borderRadius: AppRadii.inputRadius),
          ),
          icon: const Icon(Icons.chevron_right_rounded, size: 18),
          label: Text(
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
        for (final question in snapshot.questions) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadii.cardRadius,
            ),
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
        FilledButton.icon(
          key: PreCopyAssessmentPage.continueKey,
          onPressed: () => context.go(
            AppRoutePaths.tradeCopyProviderConfiguration(snapshot.providerId),
          ),
          style: FilledButton.styleFrom(
            backgroundColor: _assessmentGreen,
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(borderRadius: AppRadii.inputRadius),
          ),
          icon: const Icon(Icons.chevron_right_rounded, size: 18),
          label: Text(
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
  const _NoticeCard({
    required this.icon,
    required this.title,
    required this.text,
  });

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _assessmentPrimary.withValues(alpha: .12),
        border: Border.all(color: _assessmentPrimary.withValues(alpha: .55)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: _assessmentPrimary, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: _assessmentPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  text,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.mdRadius,
      ),
      child: Text(
        option.label,
        style: AppTextStyles.caption.copyWith(color: AppColors.text2),
      ),
    );
  }
}
