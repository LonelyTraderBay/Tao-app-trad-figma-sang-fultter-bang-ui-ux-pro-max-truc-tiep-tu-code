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
            height: 1,
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: 10)),
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
    this.height = 52,
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
                  padding: EdgeInsets.fromLTRB(20, 28, 20, bottomInset),
                  physics: const BouncingScrollPhysics(),
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    customGap: 18,
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
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: _apiGreen.withValues(alpha: .1),
            borderRadius: AppRadii.cardLargeRadius,
            border: Border.all(color: _apiGreen.withValues(alpha: .25)),
          ),
          alignment: Alignment.center,
          child: const Icon(
            Icons.check_circle_outline_rounded,
            color: _apiGreen,
            size: 42,
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: 14)),
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
      padding: const EdgeInsets.all(16),
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
              const Divider(height: 18, color: AppColors.divider),
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
      padding: const EdgeInsets.all(14),
      borderColor: color.withValues(alpha: .22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: color, size: 17),
          const SizedBox(width: 10),
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
      padding: const EdgeInsets.all(16),
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
          const Padding(padding: EdgeInsets.only(top: 8)),
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
