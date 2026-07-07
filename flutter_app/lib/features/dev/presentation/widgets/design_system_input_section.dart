import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/dev/domain/entities/dev_tools_entities.dart';
import 'package:vit_trade_flutter/features/dev/presentation/widgets/design_system_common.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class DesignSystemInputSection extends StatelessWidget {
  const DesignSystemInputSection({
    super.key,
    required this.sectionKey,
    required this.demos,
    required this.emailController,
    required this.passwordController,
    required this.searchController,
    required this.errorController,
  });

  final Key sectionKey;
  final List<DesignInputDemoDraft> demos;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController searchController;
  final TextEditingController errorController;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: sectionKey,
      label: 'InputField Component',
      children: [
        for (final demo in demos)
          _InputDemo(
            demo: demo,
            controller: switch (demo.id) {
              'password' => passwordController,
              'search' => searchController,
              'error' => errorController,
              _ => emailController,
            },
          ),
        const _InputWrapperDemo(
          caption: 'InputWrapper (dropdown-like)',
          label: 'Chọn mạng',
          value: 'BEP-20 (BSC)',
          icon: Icons.shield_outlined,
        ),
        const _InputWrapperDemo(
          caption: 'InputWrapper with error',
          label: 'Chọn phương thức thanh toán',
          value: 'Chọn...',
          error: 'Vui lòng chọn phương thức thanh toán',
        ),
      ],
    );
  }
}

class _InputDemo extends StatelessWidget {
  const _InputDemo({required this.demo, required this.controller});

  final DesignInputDemoDraft demo;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DesignSystemCaption(demo.caption),
        const SizedBox(height: AppSpacing.x2),
        VitInput(
          controller: controller,
          label: demo.label.isEmpty ? null : demo.label,
          hintText: demo.placeholder,
          errorText: demo.error,
          obscureText: demo.obscure,
          prefix: demo.prefix ? designSystemPrefixForInput(demo.id) : null,
          suffix: demo.suffix ? designSystemSuffixForInput(demo.id) : null,
        ),
      ],
    );
  }
}

class _InputWrapperDemo extends StatelessWidget {
  const _InputWrapperDemo({
    required this.caption,
    required this.label,
    required this.value,
    this.icon,
    this.error,
  });

  final String caption;
  final String label;
  final String value;
  final IconData? icon;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final hasError = error != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DesignSystemCaption(caption),
        const SizedBox(height: AppSpacing.x2),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.x2),
        DecoratedBox(
          decoration: ShapeDecoration(
            color: AppColors.surface2,
            shape: RoundedRectangleBorder(
              borderRadius: AppRadii.inputRadius,
              side: BorderSide(
                color: hasError ? AppColors.sell : AppColors.borderSolid,
              ),
            ),
          ),
          child: Padding(
            padding: AppSpacing.devInputPadding,
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, color: AppColors.primary, size: AppSpacing.iconMd),
                  const SizedBox(width: AppSpacing.x3),
                ],
                Expanded(
                  child: Text(
                    value,
                    style: AppTextStyles.body.copyWith(
                      color: hasError ? AppColors.text3 : AppColors.text1,
                    ),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.text3,
                  size: AppSpacing.iconMd,
                ),
              ],
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: AppSpacing.x2),
          Text(
            error!,
            style: AppTextStyles.caption.copyWith(color: AppColors.sell),
          ),
        ],
      ],
    );
  }
}
