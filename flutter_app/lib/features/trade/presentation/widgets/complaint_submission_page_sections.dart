part of '../pages/complaint_submission_page.dart';

class _ProcessNotice extends StatelessWidget {
  const _ProcessNotice({required this.snapshot});

  final TradeComplaintSubmissionSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: AppSpacing.complaintSubmissionNoticePadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.text1,
            size: AppSpacing.inputPrefixIcon,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.processTitle,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    height: AppSpacing.complaintSubmissionLineHeightTight,
                  ),
                ),
                const SizedBox(height: AppSpacing.x3),
                Text(
                  snapshot.processDescription,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    height: AppSpacing.complaintSubmissionLineHeightBody,
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

class _CategoryField extends StatelessWidget {
  const _CategoryField({
    required this.value,
    required this.categories,
    required this.onChanged,
  });

  final String? value;
  final List<String> categories;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FieldLabel('Category *'),
        const SizedBox(height: AppSpacing.x3),
        PopupMenuButton<String>(
          color: _submissionPanel,
          elevation: 8,
          onSelected: onChanged,
          padding: AppSpacing.zeroInsets,
          position: PopupMenuPosition.under,
          shape: RoundedRectangleBorder(borderRadius: AppRadii.cardRadius),
          itemBuilder: (_) => [
            for (final category in categories)
              PopupMenuItem(
                value: category,
                child: Text(
                  category,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    height: AppSpacing.complaintSubmissionLineHeightShort,
                  ),
                ),
              ),
          ],
          child: VitCard(
            key: ComplaintSubmissionPage.categoryKey,
            height: AppSpacing.inputHeight,
            variant: VitCardVariant.inner,
            padding: AppSpacing.complaintSubmissionCategoryPadding,
            borderColor: _submissionBorder.withValues(alpha: .76),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value ?? 'Select category',
                    style: AppTextStyles.base.copyWith(
                      color: AppColors.text1,
                      height: AppSpacing.complaintSubmissionLineHeightTight,
                    ),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.text1,
                  size: AppSpacing.iconMd,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TextInputBlock extends StatelessWidget {
  const _TextInputBlock({
    required this.label,
    required this.controller,
    required this.hint,
    required this.maxLength,
    required this.minLength,
    required this.onChanged,
    this.multiline = false,
  });

  final String label;
  final TextEditingController controller;
  final String hint;
  final int maxLength;
  final int minLength;
  final ValueChanged<String> onChanged;
  final bool multiline;

  @override
  Widget build(BuildContext context) {
    final height = multiline
        ? AppSpacing.complaintSubmissionMultilineHeight
        : AppSpacing.complaintSubmissionSingleLineHeight;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label),
        const SizedBox(height: AppSpacing.x3),
        if (!multiline)
          VitInput(
            controller: controller,
            fieldKey: ComplaintSubmissionPage.subjectKey,
            hintText: hint,
            inputFormatters: [LengthLimitingTextInputFormatter(maxLength)],
            onChanged: onChanged,
          )
        else
          SizedBox(
            height: height,
            child: TextField(
              key: multiline
                  ? ComplaintSubmissionPage.descriptionKey
                  : ComplaintSubmissionPage.subjectKey,
              controller: controller,
              onChanged: onChanged,
              maxLength: maxLength,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              maxLines: multiline ? null : 1,
              expands: multiline,
              textAlignVertical: multiline
                  ? TextAlignVertical.top
                  : TextAlignVertical.center,
              style: AppTextStyles.base.copyWith(
                color: AppColors.text1,
                height: multiline
                    ? AppSpacing.complaintSubmissionLineHeightBody
                    : AppSpacing.complaintSubmissionLineHeightTight,
              ),
              decoration: InputDecoration(
                counterText: '',
                hintText: hint,
                hintMaxLines: multiline ? 3 : 1,
                hintStyle: AppTextStyles.base.copyWith(
                  color: AppColors.text3,
                  fontWeight: AppTextStyles.bold,
                  height: multiline
                      ? AppSpacing.complaintSubmissionLineHeightHint
                      : AppSpacing.complaintSubmissionLineHeightTight,
                ),
                filled: true,
                fillColor: _submissionPanel2,
                contentPadding: multiline
                    ? AppSpacing.complaintSubmissionMultilineContentPadding
                    : AppSpacing.complaintSubmissionSingleLineContentPadding,
                enabledBorder: _inputBorder,
                focusedBorder: _inputBorder,
              ),
            ),
          ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          '${controller.text.length}/$maxLength characters (min $minLength)',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: AppSpacing.complaintSubmissionLineHeightTight,
          ),
        ),
      ],
    );
  }
}

class _EvidenceUploadCard extends StatelessWidget {
  const _EvidenceUploadCard();

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: AppSpacing.complaintSubmissionEvidencePadding,
      child: SizedBox(
        height: AppSpacing.complaintSubmissionEvidenceHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const VitCard(
              width: AppSpacing.searchBarCompactHeight,
              height: AppSpacing.searchBarCompactHeight,
              variant: VitCardVariant.inner,
              radius: VitCardRadius.sm,
              alignment: Alignment.center,
              child: Icon(
                Icons.upload_rounded,
                color: AppColors.text3,
                size: AppSpacing.iconMd,
              ),
            ),
            const SizedBox(height: AppSpacing.x4),
            Text(
              'Upload Evidence (Optional)',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
                height: AppSpacing.complaintSubmissionLineHeightTight,
              ),
            ),
            const SizedBox(height: AppSpacing.formFieldLabelGap),
            Text(
              'Screenshots, emails, or other supporting documents',
              textAlign: TextAlign.center,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                height: AppSpacing.complaintSubmissionLineHeightTight,
              ),
            ),
            const SizedBox(height: AppSpacing.x4),
            const VitAccentPill(
              label: 'Choose Files',
              accentColor: AppColors.text1,
              size: VitStatusPillSize.md,
            ),
          ],
        ),
      ),
    );
  }
}

class _TermsCard extends StatelessWidget {
  const _TermsCard({
    required this.snapshot,
    required this.accepted,
    required this.onChanged,
  });

  final TradeComplaintSubmissionSnapshot snapshot;
  final bool accepted;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: AppSpacing.complaintSubmissionTermsPadding,
      child: InkWell(
        key: ComplaintSubmissionPage.acceptKey,
        onTap: () => onChanged(!accepted),
        borderRadius: AppRadii.cardRadius,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: AppSpacing.complaintSubmissionCheckboxSize,
              height: AppSpacing.complaintSubmissionCheckboxSize,
              child: Checkbox(
                value: accepted,
                onChanged: (value) => onChanged(value ?? false),
                visualDensity: VisualDensity.compact,
                side: const BorderSide(color: AppColors.text3),
                activeColor: _submissionPrimary,
              ),
            ),
            const SizedBox(width: AppSpacing.x4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.termsIntro,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      height: AppSpacing.complaintSubmissionLineHeightReadable,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  for (final term in snapshot.terms)
                    Text(
                      '- $term',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        height: AppSpacing.complaintSubmissionLineHeightLong,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
