import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

enum StakingApiDocumentationTab { endpoints, examples, auth }

final class StakingApiDocumentationKeys {
  const StakingApiDocumentationKeys._();

  static const info = Key('sc379_info');
  static const stats = Key('sc379_stats');
  static const tabs = Key('sc379_tabs');
  static const endpoints = Key('sc379_endpoints');
  static const detail = Key('sc379_detail');
  static const examples = Key('sc379_examples');
  static const auth = Key('sc379_auth');
  static const footer = Key('sc379_footer');
  static const copyResponse = Key('sc379_copy_response');
  static const copyExample = Key('sc379_copy_example');
  static const sandbox = Key('sc379_sandbox');

  static Key tab(String id) => Key('sc379_tab_$id');

  static Key endpoint(String method, String path) =>
      Key('sc379_endpoint_${method}_$path');

  static Key language(String id) => Key('sc379_language_$id');
}

class StakingApiDocumentationMethodBadge extends StatelessWidget {
  const StakingApiDocumentationMethodBadge({super.key, required this.method});

  final String method;

  @override
  Widget build(BuildContext context) {
    final color = method == 'POST' ? AppColors.buy : AppColors.primarySoft;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: AppRadii.smRadius,
      ),
      child: Text(
        method,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class StakingApiDocumentationStatusPill extends StatelessWidget {
  const StakingApiDocumentationStatusPill({
    super.key,
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: AppRadii.smRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class StakingApiDocumentationCopyButton extends StatelessWidget {
  const StakingApiDocumentationCopyButton({
    super.key,
    required this.copied,
    required this.onTap,
  });

  final bool copied;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: copied
          ? AppColors.buy.withValues(alpha: 0.12)
          : AppColors.surface2,
      borderRadius: AppRadii.smRadius,
      child: InkWell(
        borderRadius: AppRadii.smRadius,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x2,
            vertical: AppSpacing.x1,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                copied
                    ? Icons.check_circle_outline_rounded
                    : Icons.content_copy_rounded,
                color: copied ? AppColors.buy : AppColors.text3,
                size: 12,
              ),
              const SizedBox(width: AppSpacing.x1),
              Text(
                copied ? 'Copied' : 'Copy',
                style: AppTextStyles.micro.copyWith(
                  color: copied ? AppColors.buy : AppColors.text3,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StakingApiDocumentationCodeBlock extends StatelessWidget {
  const StakingApiDocumentationCodeBlock({
    super.key,
    required this.text,
    this.tall = false,
  });

  final String text;
  final bool tall;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.x3),
      decoration: BoxDecoration(
        color: AppColors.surface3,
        borderRadius: AppRadii.inputRadius,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(
          text,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            height: tall ? 1.65 : 1.5,
          ),
        ),
      ),
    );
  }
}

class StakingApiDocumentationFooterNote extends StatelessWidget {
  const StakingApiDocumentationFooterNote({super.key, required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingApiDocumentationKeys.footer,
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Text(
        note,
        textAlign: TextAlign.center,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          height: 1.55,
        ),
      ),
    );
  }
}

StakingApiDocumentationTab stakingApiDocumentationTabFromId(String id) {
  return switch (id) {
    'examples' => StakingApiDocumentationTab.examples,
    'auth' => StakingApiDocumentationTab.auth,
    _ => StakingApiDocumentationTab.endpoints,
  };
}

String stakingApiDocumentationTabLabel(StakingApiDocumentationTab tab) {
  return switch (tab) {
    StakingApiDocumentationTab.endpoints => 'Endpoints',
    StakingApiDocumentationTab.examples => 'Examples',
    StakingApiDocumentationTab.auth => 'Auth & Limits',
  };
}

String stakingApiDocumentationFormatInt(int value) {
  final raw = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    if (i > 0 && (raw.length - i) % 3 == 0) buffer.write(',');
    buffer.write(raw[i]);
  }
  return buffer.toString();
}
