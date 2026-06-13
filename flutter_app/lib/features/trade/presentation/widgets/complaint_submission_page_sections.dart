part of '../pages/complaint_submission_page.dart';

class _ProcessNotice extends StatelessWidget {
  const _ProcessNotice({required this.snapshot});

  final TradeComplaintSubmissionSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 10, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.text1,
            size: 16,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.processTitle,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  snapshot.processDescription,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    height: 1.35,
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
        const SizedBox(height: 9),
        PopupMenuButton<String>(
          color: _submissionPanel,
          elevation: 8,
          onSelected: onChanged,
          padding: EdgeInsets.zero,
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
                    height: 1.2,
                  ),
                ),
              ),
          ],
          child: Container(
            key: ComplaintSubmissionPage.categoryKey,
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: _submissionPanel2,
              border: Border.all(
                color: _submissionBorder.withValues(alpha: .76),
              ),
              borderRadius: AppRadii.cardRadius,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value ?? 'Select category',
                    style: AppTextStyles.base.copyWith(
                      color: AppColors.text1,
                      height: 1,
                    ),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.text1,
                  size: 21,
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
    final height = multiline ? 169.0 : 48.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label),
        const SizedBox(height: 9),
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
                height: multiline ? 1.35 : 1,
              ),
              decoration: InputDecoration(
                counterText: '',
                hintText: hint,
                hintMaxLines: multiline ? 3 : 1,
                hintStyle: AppTextStyles.base.copyWith(
                  color: AppColors.text3,
                  fontWeight: AppTextStyles.bold,
                  height: multiline ? 1.4 : 1,
                ),
                filled: true,
                fillColor: _submissionPanel2,
                contentPadding: multiline
                    ? const EdgeInsets.fromLTRB(12, 15, 12, 12)
                    : const EdgeInsets.symmetric(horizontal: 12),
                enabledBorder: _inputBorder,
                focusedBorder: _inputBorder,
              ),
            ),
          ),
        const SizedBox(height: 5),
        Text(
          '${controller.text.length}/$maxLength characters (min $minLength)',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: 1,
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
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: SizedBox(
        height: 139,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _submissionPanel2,
                borderRadius: AppRadii.inputRadius,
              ),
              child: const Icon(
                Icons.upload_rounded,
                color: AppColors.text3,
                size: 22,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Upload Evidence (Optional)',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Screenshots, emails, or other supporting documents',
              textAlign: TextAlign.center,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                height: 1,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 30,
              padding: const EdgeInsets.symmetric(horizontal: 17),
              decoration: BoxDecoration(
                color: _submissionPanel2,
                borderRadius: AppRadii.cardRadius,
              ),
              alignment: Alignment.center,
              child: Text(
                'Choose Files',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
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
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
      child: InkWell(
        key: ComplaintSubmissionPage.acceptKey,
        onTap: () => onChanged(!accepted),
        borderRadius: AppRadii.cardRadius,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 22,
              height: 22,
              child: Checkbox(
                value: accepted,
                onChanged: (value) => onChanged(value ?? false),
                visualDensity: VisualDensity.compact,
                side: const BorderSide(color: AppColors.text3),
                activeColor: _submissionPrimary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.termsIntro,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 5),
                  for (final term in snapshot.terms)
                    Text(
                      '- $term',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        height: 1.5,
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


