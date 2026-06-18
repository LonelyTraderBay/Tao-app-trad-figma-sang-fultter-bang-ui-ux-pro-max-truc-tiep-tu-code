part of '../pages/api_key_create_page.dart';

class _FieldSection extends StatelessWidget {
  const _FieldSection({
    required this.label,
    required this.child,
    this.required = false,
    this.optional,
  });

  final String label;
  final Widget child;
  final bool required;
  final String? optional;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text.rich(
          TextSpan(
            text: label,
            children: [
              if (required)
                TextSpan(
                  text: ' *',
                  style: AppTextStyles.caption.copyWith(color: _apiRed),
                ),
              if (optional != null)
                TextSpan(
                  text: ' ($optional)',
                  style: AppTextStyles.caption.copyWith(
                    color: _apiMuted,
                    fontWeight: AppTextStyles.normal,
                  ),
                ),
            ],
          ),
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.profileApiCreateFieldGap),
        child,
      ],
    );
  }
}

class _TextInput extends StatelessWidget {
  const _TextInput({
    super.key,
    required this.controller,
    required this.hint,
    this.height = AppSpacing.inputHeight,
    this.maxLength,
    this.onChanged,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String hint;
  final double height;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: VitInput(
        fieldKey: key,
        controller: controller,
        hintText: hint,
        inputFormatters: maxLength == null
            ? null
            : [LengthLimitingTextInputFormatter(maxLength!)],
        onChanged: onChanged,
        onSubmitted: onSubmitted,
      ),
    );
  }
}

class _PrimaryCta extends StatelessWidget {
  const _PrimaryCta({
    super.key,
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  final String label;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      onPressed: enabled ? onTap : null,
      height: AppSpacing.inputHeight,
      child: Text(label),
    );
  }
}

class _SimpleStepScaffold extends StatelessWidget {
  const _SimpleStepScaffold({
    required this.title,
    required this.subtitle,
    required this.bottomInset,
    required this.children,
    this.onBack,
    this.showBack = true,
  });

  final String title;
  final String subtitle;
  final double bottomInset;
  final List<Widget> children;
  final VoidCallback? onBack;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return VitPageLayout(
      variant: VitPageVariant.flush,
      child: Material(
        color: _apiBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: title,
            subtitle: subtitle,
            showBack: showBack,
            onBack: onBack,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: AppSpacing.profileApiCreateStepScrollPadding(
                    bottomInset,
                  ),
                  physics: const BouncingScrollPhysics(),
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    customGap: AppSpacing.profileApiCreateStepGap,
                    fullBleed: true,
                    children: children,
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

class _SuccessIcon extends StatelessWidget {
  const _SuccessIcon({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: AppSpacing.profileApiCreateSuccessIconBox,
          height: AppSpacing.profileApiCreateSuccessIconBox,
          child: Material(
            color: _apiGreen.withValues(alpha: .1),
            shape: RoundedRectangleBorder(
              borderRadius: AppRadii.cardLargeRadius,
              side: BorderSide(color: _apiGreen.withValues(alpha: .25)),
            ),
            child: const Icon(
              Icons.check_circle_outline_rounded,
              color: _apiGreen,
              size: AppSpacing.profileApiCreateSuccessIcon,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.profileApiCreateSuccessTitleGap),
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTextStyles.sectionTitleSm,
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.rows});

  final List<ProfileInfoRow> rows;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.profileApiCreateSummaryPadding,
      borderColor: _apiBorder,
      child: Column(
        children: [
          for (final row in rows) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    row.label,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    row.value,
                    textAlign: TextAlign.right,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            if (row != rows.last)
              const Divider(
                height: AppSpacing.profileApiCreateSummaryDivider,
                color: AppColors.divider,
              ),
          ],
        ],
      ),
    );
  }
}

class _WarningCard extends StatelessWidget {
  const _WarningCard({required this.text, this.amber = false});

  final String text;
  final bool amber;

  @override
  Widget build(BuildContext context) {
    final color = amber ? _apiAmber : _apiRed;
    return VitCard(
      padding: AppSpacing.profileApiCreateWarningPadding,
      borderColor: color.withValues(alpha: .22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: color,
            size: AppSpacing.profileApiCreateWarningIcon,
          ),
          const SizedBox(width: AppSpacing.profileApiCreateWarningGap),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(color: color, height: 1.45),
            ),
          ),
        ],
      ),
    );
  }
}

class _KeyResultCard extends StatelessWidget {
  const _KeyResultCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.profileApiCreateResultCardPadding,
      borderColor: _apiBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.profileApiCreateResultValueGap),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

IconData _apiPermissionIcon(String key) {
  return switch (key) {
    'refresh' => Icons.refresh_rounded,
    'lock' => Icons.lock_outline_rounded,
    _ => Icons.remove_red_eye_outlined,
  };
}
