import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/launchpad/domain/entities/launchpad_entities.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/widgets/launchpad_dca_builder_common.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class LaunchpadDcaCreateSection extends StatelessWidget {
  const LaunchpadDcaCreateSection({
    super.key,
    required this.sectionKey,
    required this.tokenFieldKey,
    required this.amountFieldKey,
    required this.budgetFieldKey,
    required this.startDateFieldKey,
    required this.previewKey,
    required this.reviewStateKey,
    required this.frequencyKey,
    required this.tokenController,
    required this.amountController,
    required this.budgetController,
    required this.startDateController,
    required this.frequency,
    required this.submissionMessage,
    required this.onFrequencyChanged,
    required this.onInputChanged,
  });

  final Key sectionKey;
  final Key tokenFieldKey;
  final Key amountFieldKey;
  final Key budgetFieldKey;
  final Key startDateFieldKey;
  final Key previewKey;
  final Key reviewStateKey;
  final Key Function(LaunchpadDcaFrequency frequency) frequencyKey;
  final TextEditingController tokenController;
  final TextEditingController amountController;
  final TextEditingController budgetController;
  final TextEditingController startDateController;
  final LaunchpadDcaFrequency frequency;
  final String? submissionMessage;
  final ValueChanged<LaunchpadDcaFrequency> onFrequencyChanged;
  final VoidCallback onInputChanged;

  @override
  Widget build(BuildContext context) {
    final hasPreview =
        amountController.text.trim().isNotEmpty &&
        budgetController.text.trim().isNotEmpty;
    return KeyedSubtree(
      key: sectionKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VitPageSection(
            label: 'Token',
            accentColor: AppColors.primary,
            children: [
              VitCard(
                padding: AppSpacing.launchpadPaddingX4,
                child: _LabeledField(
                  fieldKey: tokenFieldKey,
                  label: 'Chon token',
                  controller: tokenController,
                  hintText: 'ARB, OP, MATIC...',
                  onChanged: onInputChanged,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          VitPageSection(
            label: 'Tan suat mua',
            accentColor: AppColors.primary,
            children: [
              GridView.count(
                crossAxisCount: AppSpacing.launchpadGridColumns,
                mainAxisSpacing: AppSpacing.x3,
                crossAxisSpacing: AppSpacing.x3,
                childAspectRatio: AppSpacing.launchpadGridAspectCompact,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                children: [
                  for (final option in LaunchpadDcaFrequency.values)
                    _FrequencyChoice(
                      choiceKey: frequencyKey(option),
                      frequency: option,
                      active: option == frequency,
                      onTap: () => onFrequencyChanged(option),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          VitPageSection(
            label: 'So tien',
            accentColor: AppColors.primary,
            children: [
              VitCard(
                padding: AppSpacing.launchpadPaddingX4,
                child: Column(
                  children: [
                    _LabeledField(
                      fieldKey: amountFieldKey,
                      label: 'So tien moi lan (USD)',
                      controller: amountController,
                      hintText: '100',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      prefixIcon: Icons.attach_money_rounded,
                      onChanged: onInputChanged,
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    _LabeledField(
                      fieldKey: budgetFieldKey,
                      label: 'Tong ngan sach (USD)',
                      controller: budgetController,
                      hintText: '1000',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      prefixIcon: Icons.attach_money_rounded,
                      onChanged: onInputChanged,
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    _LabeledField(
                      fieldKey: startDateFieldKey,
                      label: 'Ngay bat dau',
                      controller: startDateController,
                      hintText: '2026-05-25',
                      prefixIcon: Icons.calendar_today_outlined,
                      onChanged: onInputChanged,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (hasPreview) ...[
            const SizedBox(height: AppSpacing.x4),
            _StrategyPreview(
              previewKey: previewKey,
              token: tokenController.text.trim(),
              frequency: frequency,
              amount: amountController.text.trim(),
              totalBudget: budgetController.text.trim(),
            ),
            const SizedBox(height: AppSpacing.x4),
            VitHighRiskStatePanel(
              key: reviewStateKey,
              state: VitHighRiskUiState.riskReview,
              title: 'Review DCA plan',
              message: 'Check token, amount, budget, start date, and cadence.',
              contractId: 'SC-316 / ${tokenController.text.trim()}',
            ),
          ],
          if (submissionMessage != null) ...[
            const SizedBox(height: AppSpacing.x4),
            VitCard(
              padding: AppSpacing.launchpadPaddingX3,
              borderColor: AppColors.buy20,
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_outline_rounded,
                    color: AppColors.buy,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: Text(
                      submissionMessage!,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                        height: AppSpacing.launchpadLineHeightReadable,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _FrequencyChoice extends StatelessWidget {
  const _FrequencyChoice({
    required this.choiceKey,
    required this.frequency,
    required this.active,
    required this.onTap,
  });

  final Key choiceKey;
  final LaunchpadDcaFrequency frequency;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: choiceKey,
      radius: VitCardRadius.md,
      borderColor: active ? AppColors.primary : AppColors.cardBorder,
      padding: AppSpacing.launchpadPaddingX4,
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            launchpadDcaFrequencyIcon(frequency),
            color: active ? AppColors.primary : AppColors.text3,
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            launchpadDcaFrequencyLabel(frequency),
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: active ? AppColors.primary : AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.fieldKey,
    required this.label,
    required this.controller,
    required this.hintText,
    required this.onChanged,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
  });

  final Key fieldKey;
  final String label;
  final TextEditingController controller;
  final String hintText;
  final VoidCallback onChanged;
  final TextInputType keyboardType;
  final IconData? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return VitInput(
      fieldKey: fieldKey,
      label: label,
      controller: controller,
      hintText: hintText,
      keyboardType: keyboardType,
      inputFormatters: keyboardType == TextInputType.text
          ? const []
          : [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
      prefix: prefixIcon == null ? null : Icon(prefixIcon),
      onChanged: (_) => onChanged(),
    );
  }
}

class _StrategyPreview extends StatelessWidget {
  const _StrategyPreview({
    required this.previewKey,
    required this.token,
    required this.frequency,
    required this.amount,
    required this.totalBudget,
  });

  final Key previewKey;
  final String token;
  final LaunchpadDcaFrequency frequency;
  final String amount;
  final String totalBudget;

  @override
  Widget build(BuildContext context) {
    final perOrder = double.tryParse(amount) ?? 0;
    final budget = double.tryParse(totalBudget) ?? 0;
    final estimatedOrders = perOrder == 0 ? 0 : (budget / perOrder).floor();
    return VitCard(
      key: previewKey,
      variant: VitCardVariant.ghost,
      borderColor: AppColors.buy20,
      padding: AppSpacing.launchpadPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Xem truoc chien luoc',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              _PreviewMetric(label: 'Token', value: token),
              _PreviewMetric(
                label: 'Frequency',
                value: launchpadDcaFrequencyLabel(frequency),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              _PreviewMetric(label: 'Per Order', value: '\$$amount'),
              _PreviewMetric(label: 'Est. Orders', value: '$estimatedOrders'),
            ],
          ),
        ],
      ),
    );
  }
}

class _PreviewMetric extends StatelessWidget {
  const _PreviewMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}
