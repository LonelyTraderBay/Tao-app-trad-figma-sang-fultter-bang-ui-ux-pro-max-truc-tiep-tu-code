import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/dev/presentation/widgets/design_system_common.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class DesignSystemPlayground extends StatelessWidget {
  const DesignSystemPlayground({
    super.key,
    required this.sectionKey,
    required this.label,
    required this.variant,
    required this.disabled,
    required this.loading,
    required this.fullWidth,
    required this.inputPrefix,
    required this.inputSuffix,
    required this.inputError,
    required this.inputController,
    required this.labelController,
    required this.errorController,
    required this.onVariantChanged,
    required this.onLabelChanged,
    required this.onToggleDisabled,
    required this.onToggleLoading,
    required this.onToggleFullWidth,
    required this.onTogglePrefix,
    required this.onToggleSuffix,
    required this.onErrorChanged,
  });

  final Key sectionKey;
  final String label;
  final String variant;
  final bool disabled;
  final bool loading;
  final bool fullWidth;
  final bool inputPrefix;
  final bool inputSuffix;
  final String inputError;
  final TextEditingController inputController;
  final TextEditingController labelController;
  final TextEditingController errorController;
  final ValueChanged<String> onVariantChanged;
  final ValueChanged<String> onLabelChanged;
  final VoidCallback onToggleDisabled;
  final VoidCallback onToggleLoading;
  final VoidCallback onToggleFullWidth;
  final VoidCallback onTogglePrefix;
  final VoidCallback onToggleSuffix;
  final ValueChanged<String> onErrorChanged;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: sectionKey,
      label: 'Interactive Playground',
      children: [
        VitCard(
          padding: AppSpacing.devCardPadding,
          radius: VitCardRadius.lg,
          borderColor: AppColors.primary20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _PlaygroundTitle(
                icon: Icons.bolt_rounded,
                title: 'CTAButton Playground',
                color: AppColors.primary,
              ),
              const SizedBox(height: AppSpacing.x4),
              VitCard(
                variant: VitCardVariant.inner,
                padding: AppSpacing.devCardPaddingLarge,
                child: Center(
                  child: VitCtaButton(
                    variant: designSystemVariantFromString(variant),
                    fullWidth: fullWidth,
                    loading: loading,
                    onPressed: disabled ? null : () {},
                    child: Text(label.isEmpty ? 'Button' : label),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.x4),
              _SegmentControls(
                label: 'variant',
                options: const ['primary', 'success', 'danger', 'ghost'],
                selected: variant,
                onChanged: onVariantChanged,
              ),
              const SizedBox(height: AppSpacing.x3),
              VitInput(
                controller: labelController,
                label: 'children (text)',
                onChanged: onLabelChanged,
              ),
              const SizedBox(height: AppSpacing.x3),
              Wrap(
                spacing: AppSpacing.x3,
                runSpacing: AppSpacing.x3,
                children: [
                  _ToggleChip(
                    label: 'disabled',
                    active: disabled,
                    onTap: onToggleDisabled,
                  ),
                  _ToggleChip(
                    label: 'loading',
                    active: loading,
                    onTap: onToggleLoading,
                  ),
                  _ToggleChip(
                    label: 'fullWidth',
                    active: fullWidth,
                    onTap: onToggleFullWidth,
                  ),
                ],
              ),
            ],
          ),
        ),
        VitCard(
          padding: AppSpacing.devCardPadding,
          radius: VitCardRadius.lg,
          borderColor: AppColors.buy20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _PlaygroundTitle(
                icon: Icons.trending_up_rounded,
                title: 'InputField Playground',
                color: AppColors.buy,
              ),
              const SizedBox(height: AppSpacing.x4),
              VitCard(
                variant: VitCardVariant.inner,
                padding: AppSpacing.devCardPaddingLarge,
                child: VitInput(
                  controller: inputController,
                  label: 'Email',
                  hintText: 'you@example.com',
                  prefix: inputPrefix
                      ? const Icon(Icons.mail_outline_rounded)
                      : null,
                  suffix: inputSuffix
                      ? const Icon(
                          Icons.check_circle_outline_rounded,
                          color: AppColors.buy,
                        )
                      : null,
                  errorText: inputError.isEmpty ? null : inputError,
                ),
              ),
              const SizedBox(height: AppSpacing.x4),
              VitInput(
                controller: errorController,
                label: 'error',
                hintText: 'Leave empty for no error',
                onChanged: onErrorChanged,
              ),
              const SizedBox(height: AppSpacing.x3),
              Wrap(
                spacing: AppSpacing.x3,
                runSpacing: AppSpacing.x3,
                children: [
                  _ToggleChip(
                    label: 'prefix (Mail)',
                    active: inputPrefix,
                    onTap: onTogglePrefix,
                    color: AppColors.buy,
                  ),
                  _ToggleChip(
                    label: 'suffix (Check)',
                    active: inputSuffix,
                    onTap: onToggleSuffix,
                    color: AppColors.buy,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlaygroundTitle extends StatelessWidget {
  const _PlaygroundTitle({
    required this.icon,
    required this.title,
    required this.color,
  });

  final IconData icon;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: AppSpacing.iconMd),
        const SizedBox(width: AppSpacing.x2),
        Text(
          title,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _SegmentControls extends StatelessWidget {
  const _SegmentControls({
    required this.label,
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  final String label;
  final List<String> options;
  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DesignSystemCaption(label),
        const SizedBox(height: AppSpacing.x2),
        Wrap(
          spacing: AppSpacing.x2,
          runSpacing: AppSpacing.x2,
          children: [
            for (final option in options)
              _ChoiceChip(
                label: option,
                selected: selected == option,
                onTap: () => onChanged(option),
              ),
          ],
        ),
      ],
    );
  }
}

class _ChoiceChip extends StatelessWidget {
  const _ChoiceChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      label: label,
      selected: selected,
      onTap: onTap,
      height: AppSpacing.buttonCompact,
      padding: AppSpacing.devChipPadding,
    );
  }
}

class _ToggleChip extends StatelessWidget {
  const _ToggleChip({
    required this.label,
    required this.active,
    required this.onTap,
    this.color = AppColors.primary,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      label: label,
      selected: active,
      onTap: onTap,
      accentColor: color,
      height: AppSpacing.buttonCompact,
      padding: AppSpacing.devChipPadding,
      leading: Icon(
        active ? Icons.check_box_rounded : Icons.check_box_outline_blank,
      ),
    );
  }
}
