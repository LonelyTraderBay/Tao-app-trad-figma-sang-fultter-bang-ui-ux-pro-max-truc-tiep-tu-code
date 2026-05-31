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
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: _apiRed),
                ),
              if (optional != null)
                TextSpan(
                  text: ' ($optional)',
                  style: const TextStyle(
                    color: _apiMuted,
                    fontWeight: FontWeight.w400,
                  ),
                ),
            ],
          ),
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            height: 1,
          ),
        ),
        const SizedBox(height: 10),
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
      child: TextField(
        controller: controller,
        maxLength: maxLength,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        cursorColor: _apiPrimary,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.text1,
          fontSize: 14,
          fontWeight: FontWeight.w700,
          height: 1,
        ),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: _apiPanel2,
          hintText: hint,
          hintStyle: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            height: 1,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          border: _inputBorder(_apiBorder),
          enabledBorder: _inputBorder(_apiBorder),
          focusedBorder: _inputBorder(_apiPrimary, width: 1.5),
        ),
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
    return GestureDetector(
      onTap: enabled ? onTap : null,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: AppSpacing.inputHeight,
        decoration: BoxDecoration(
          color: enabled ? _apiPrimary : _apiPanel2,
          borderRadius: AppRadii.cardRadius,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTextStyles.baseMedium.copyWith(
            color: enabled ? AppColors.onAccent : AppColors.borderSolid,
            fontSize: 16,
            fontWeight: FontWeight.w800,
            height: 1,
          ),
        ),
      ),
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
        child: Column(
          children: [
            VitHeader(
              title: title,
              subtitle: subtitle,
              showBack: showBack,
              onBack: onBack,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20, 28, 20, bottomInset),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final child in children) ...[
                      child,
                      if (child != children.last) const SizedBox(height: 18),
                    ],
                  ],
                ),
              ),
            ),
          ],
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
        const SizedBox(height: 14),
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTextStyles.sectionTitle.copyWith(fontSize: 20),
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _apiPanel,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: _apiBorder),
      ),
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
                      fontSize: 13,
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    row.value,
                    textAlign: TextAlign.right,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontSize: 13,
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
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .08),
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: color.withValues(alpha: .22)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: color, size: 17),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontSize: 12,
                height: 1.45,
              ),
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _apiPanel,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: _apiBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontSize: 12,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

OutlineInputBorder _inputBorder(Color color, {double width = 1.5}) {
  return OutlineInputBorder(
    borderRadius: AppRadii.cardRadius,
    borderSide: BorderSide(color: color, width: width),
  );
}

IconData _apiPermissionIcon(String key) {
  return switch (key) {
    'refresh' => Icons.refresh_rounded,
    'lock' => Icons.lock_outline_rounded,
    _ => Icons.remove_red_eye_outlined,
  };
}
