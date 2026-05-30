import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_controller_providers.dart';

class SavingsRiskAssessmentPage extends ConsumerStatefulWidget {
  const SavingsRiskAssessmentPage({super.key, this.shellRenderMode});

  static const questionCardKey = Key('sc339_question_card');
  static const firstOptionKey = Key('sc339_first_option');
  static const previousButtonKey = Key('sc339_previous_button');
  static const resultCardKey = Key('sc339_result_card');
  static const recommendationsButtonKey = Key('sc339_recommendations_button');
  static const productsButtonKey = Key('sc339_products_button');
  static const resetButtonKey = Key('sc339_reset_button');

  static Key optionKey(String questionId, int value) {
    return Key('sc339_option_${questionId}_$value');
  }

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SavingsRiskAssessmentPage> createState() =>
      _SavingsRiskAssessmentPageState();
}

class _SavingsRiskAssessmentPageState
    extends ConsumerState<SavingsRiskAssessmentPage> {
  int _currentQuestion = 0;
  bool _showResult = false;
  final Map<String, int> _answers = {};

  int get _score {
    return ref.read(savingsRiskAssessmentControllerProvider).score(_answers);
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(savingsRiskAssessmentControllerProvider);
    final snapshot = controller.state.snapshot;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-339 SavingsRiskAssessmentPage',
      child: Material(
        color: AppColors.bg,
        child: Column(
          children: [
            VitHeader(
              title: _showResult ? snapshot.resultTitle : snapshot.title,
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: bottomInset),
                child: VitPageContent(
                  padding: VitContentPadding.compact,
                  gap: VitContentGap.defaultGap,
                  children: _showResult
                      ? [
                          _ResultView(
                            snapshot: snapshot,
                            result: controller.resultForAnswers(_answers),
                            score: _score,
                            onReset: _reset,
                          ),
                        ]
                      : [
                          _ProgressHeader(
                            currentQuestion: _currentQuestion,
                            totalQuestions: snapshot.questions.length,
                          ),
                          _QuestionCard(
                            question: snapshot.questions[_currentQuestion],
                            index: _currentQuestion,
                            selectedValue:
                                _answers[snapshot
                                    .questions[_currentQuestion]
                                    .id],
                            onSelected: _selectOption,
                            onPrevious: _previous,
                          ),
                          _InfoBanner(text: snapshot.infoText),
                        ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectOption(SavingsRiskQuestionDraft question, int value) {
    HapticFeedback.selectionClick();
    setState(() {
      _answers[question.id] = value;
      if (_currentQuestion < _questionsLength - 1) {
        _currentQuestion += 1;
      } else {
        _showResult = true;
      }
    });
  }

  int get _questionsLength {
    return ref
        .read(savingsRiskAssessmentControllerProvider)
        .state
        .snapshot
        .questions
        .length;
  }

  void _previous() {
    HapticFeedback.selectionClick();
    setState(() {
      if (_currentQuestion > 0) _currentQuestion -= 1;
    });
  }

  void _reset() {
    HapticFeedback.selectionClick();
    setState(() {
      _currentQuestion = 0;
      _showResult = false;
      _answers.clear();
    });
  }
}

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({
    required this.currentQuestion,
    required this.totalQuestions,
  });

  final int currentQuestion;
  final int totalQuestions;

  @override
  Widget build(BuildContext context) {
    final progress = totalQuestions <= 1
        ? 1.0
        : currentQuestion / (totalQuestions - 1);
    final percent = (progress * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Câu hỏi ${currentQuestion + 1}/$totalQuestions',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            Text(
              '$percent%',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x3),
        ClipRRect(
          borderRadius: AppRadii.xlRadius,
          child: SizedBox(
            height: AppSpacing.x2,
            child: Stack(
              fit: StackFit.expand,
              children: [
                const ColoredBox(color: AppColors.surface3),
                FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progress.clamp(0, 1),
                  child: const ColoredBox(color: AppColors.primary),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    required this.question,
    required this.index,
    required this.selectedValue,
    required this.onSelected,
    required this.onPrevious,
  });

  final SavingsRiskQuestionDraft question;
  final int index;
  final int? selectedValue;
  final void Function(SavingsRiskQuestionDraft question, int value) onSelected;
  final VoidCallback onPrevious;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: SavingsRiskAssessmentPage.questionCardKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _QuestionNumber(number: index + 1),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(question.question, style: AppTextStyles.baseMedium),
                    if (question.helpText != null) ...[
                      const SizedBox(height: AppSpacing.x2),
                      Text(
                        question.helpText!,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                          height: 1.55,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          for (final option in question.options) ...[
            _RiskOptionTile(
              key: option.value == 0
                  ? SavingsRiskAssessmentPage.firstOptionKey
                  : null,
              semanticKey: SavingsRiskAssessmentPage.optionKey(
                question.id,
                option.value,
              ),
              option: option,
              selected: selectedValue == option.value,
              onTap: () => onSelected(question, option.value),
            ),
            if (option != question.options.last)
              const SizedBox(height: AppSpacing.x3),
          ],
          if (index > 0) ...[
            const SizedBox(height: AppSpacing.x4),
            VitCtaButton(
              key: SavingsRiskAssessmentPage.previousButtonKey,
              variant: VitCtaButtonVariant.ghost,
              height: AppSpacing.buttonCompact,
              leading: const Icon(Icons.chevron_left_rounded),
              onPressed: onPrevious,
              child: const Text('Quay lại câu trước'),
            ),
          ],
        ],
      ),
    );
  }
}

class _QuestionNumber extends StatelessWidget {
  const _QuestionNumber({required this.number});

  final int number;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.primary12,
        borderRadius: AppRadii.xlRadius,
      ),
      child: SizedBox(
        width: AppSpacing.x7,
        height: AppSpacing.x7,
        child: Center(
          child: Text(
            '$number',
            style: AppTextStyles.sectionTitle.copyWith(
              color: AppColors.primary,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ),
      ),
    );
  }
}

class _RiskOptionTile extends StatelessWidget {
  const _RiskOptionTile({
    super.key,
    required this.semanticKey,
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final Key semanticKey;
  final SavingsRiskOptionDraft option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: semanticKey,
      child: Material(
        color: selected ? AppColors.primary12 : AppColors.surface2,
        borderRadius: AppRadii.lgRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.lgRadius,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(
                color: selected ? AppColors.primary : AppColors.borderSolid,
              ),
              borderRadius: AppRadii.lgRadius,
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _OptionMarker(value: option.value, selected: selected),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          option.label,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        if (option.description != null) ...[
                          const SizedBox(height: AppSpacing.x1),
                          Text(
                            option.description!,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text3,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.text3,
                    size: AppSpacing.iconMd,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OptionMarker extends StatelessWidget {
  const _OptionMarker({required this.value, required this.selected});

  final int value;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : AppColors.surface3,
        borderRadius: AppRadii.mdRadius,
      ),
      child: SizedBox(
        width: AppSpacing.x6,
        height: AppSpacing.x6,
        child: Center(
          child: Text(
            '${value + 1}',
            style: AppTextStyles.caption.copyWith(
              color: selected ? AppColors.onAccent : AppColors.text2,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.primary20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.primary,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultView extends StatelessWidget {
  const _ResultView({
    required this.snapshot,
    required this.result,
    required this.score,
    required this.onReset,
  });

  final SavingsRiskAssessmentSnapshot snapshot;
  final SavingsRiskProfileResultDraft result;
  final int score;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final accent = _profileAccent(result.level);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCard(
          key: SavingsRiskAssessmentPage.resultCardKey,
          radius: VitCardRadius.lg,
          borderColor: accent,
          padding: const EdgeInsets.all(AppSpacing.x5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  _ResultIcon(color: accent),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          result.label,
                          style: AppTextStyles.sectionTitle.copyWith(
                            color: accent,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x1),
                        Text(
                          'Điểm hồ sơ: $score',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text3,
                            fontFeatures: AppTextStyles.tabularFigures,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x4),
              Text(
                result.description,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: 1.55,
                ),
              ),
              const SizedBox(height: AppSpacing.x4),
              _StrategyMatchCard(strategyMatch: result.strategyMatch),
            ],
          ),
        ),
        VitPageSection(
          label: 'Gợi ý danh mục',
          accentColor: accent,
          children: [
            for (final recommendation in result.recommendations)
              _BulletRow(text: recommendation, color: accent),
          ],
        ),
        VitPageSection(
          label: 'Sản phẩm phù hợp',
          accentColor: AppColors.buy,
          children: [
            for (final product in result.products)
              _ProductResultTile(product: product),
          ],
        ),
        VitPageSection(
          label: 'Lưu ý rủi ro',
          accentColor: AppColors.warn,
          children: [
            for (final warning in result.warnings)
              _BulletRow(text: warning, color: AppColors.warn),
          ],
        ),
        _InfoBanner(text: snapshot.footerDisclaimer),
        VitCtaButton(
          key: SavingsRiskAssessmentPage.recommendationsButtonKey,
          onPressed: () {
            HapticFeedback.selectionClick();
            context.go(snapshot.recommendationsRoute);
          },
          trailing: const Icon(Icons.arrow_forward_rounded),
          child: const Text('Xem gợi ý cá nhân hóa'),
        ),
        Row(
          children: [
            Expanded(
              child: VitCtaButton(
                key: SavingsRiskAssessmentPage.productsButtonKey,
                variant: VitCtaButtonVariant.secondary,
                height: AppSpacing.buttonCompact,
                onPressed: () {
                  HapticFeedback.selectionClick();
                  context.go(snapshot.savingsRoute);
                },
                leading: const Icon(Icons.savings_outlined),
                child: const Text('Sản phẩm'),
              ),
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: VitCtaButton(
                key: SavingsRiskAssessmentPage.resetButtonKey,
                variant: VitCtaButtonVariant.ghost,
                height: AppSpacing.buttonCompact,
                onPressed: onReset,
                leading: const Icon(Icons.refresh_rounded),
                child: const Text('Làm lại'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ResultIcon extends StatelessWidget {
  const _ResultIcon({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color.withValues(alpha: 0.25)),
        borderRadius: AppRadii.xlRadius,
      ),
      child: SizedBox(
        width: AppSpacing.x7,
        height: AppSpacing.x7,
        child: Icon(
          Icons.shield_outlined,
          color: color,
          size: AppSpacing.iconMd,
        ),
      ),
    );
  }
}

class _StrategyMatchCard extends StatelessWidget {
  const _StrategyMatchCard({required this.strategyMatch});

  final String strategyMatch;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          const Icon(
            Icons.auto_awesome_rounded,
            color: AppColors.primary,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chiến lược phù hợp',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  strategyMatch,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
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

class _ProductResultTile extends StatelessWidget {
  const _ProductResultTile({required this.product});

  final SavingsRiskProductDraft product;

  @override
  Widget build(BuildContext context) {
    final accent = _assetColor(product.asset);

    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          _AssetBadge(asset: product.asset, color: accent),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Row(
                  children: [
                    Icon(
                      product.type == SavingsStrategyAllocationType.flexible
                          ? Icons.lock_open_rounded
                          : Icons.lock_outline_rounded,
                      color:
                          product.type == SavingsStrategyAllocationType.flexible
                          ? AppColors.buy
                          : AppColors.warn,
                      size: AppSpacing.iconSm,
                    ),
                    const SizedBox(width: AppSpacing.x1),
                    Expanded(
                      child: Text(
                        '${product.type == SavingsStrategyAllocationType.flexible ? 'Linh hoạt' : 'Cố định'} - ${product.risk}',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Text(
            product.apy,
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.buy,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _BulletRow extends StatelessWidget {
  const _BulletRow({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: AppSpacing.x3),
          child: SizedBox(
            width: AppSpacing.x1,
            height: AppSpacing.x1,
            child: DecoratedBox(
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _AssetBadge extends StatelessWidget {
  const _AssetBadge({required this.asset, required this.color});

  final String asset;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color.withValues(alpha: 0.25)),
        borderRadius: AppRadii.xlRadius,
      ),
      child: SizedBox(
        width: AppSpacing.x7,
        height: AppSpacing.x7,
        child: Center(
          child: Text(
            asset,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}

Color _profileAccent(SavingsRiskProfileLevel level) {
  return switch (level) {
    SavingsRiskProfileLevel.conservative => AppColors.buy,
    SavingsRiskProfileLevel.moderate => AppColors.warn,
    SavingsRiskProfileLevel.aggressive => AppColors.sell,
  };
}

Color _assetColor(String asset) {
  return switch (asset) {
    'USDT' => AppColors.buy,
    'BTC' => AppColors.warn,
    'SOL' => AppColors.accent,
    'ETH' => AppColors.primary,
    _ => AppColors.primary,
  };
}
