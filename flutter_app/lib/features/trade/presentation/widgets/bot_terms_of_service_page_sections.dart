part of '../pages/bot_terms_of_service_page.dart';

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.snapshot});

  final TradeBotTermsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      constraints: const BoxConstraints(minHeight: 96),
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 16),
      borderColor: _termsPrimary.withValues(alpha: .24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 3),
            child: Icon(
              Icons.description_outlined,
              color: _termsPrimary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.infoTitle,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  snapshot.infoDescription,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.55,
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

class _TermsCard extends StatelessWidget {
  const _TermsCard({required this.snapshot, required this.controller});

  final TradeBotTermsSnapshot snapshot;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      height: 575,
      borderColor: AppColors.cardBorder,
      child: ClipRRect(
        borderRadius: AppRadii.cardRadius,
        child: SingleChildScrollView(
          key: BotTermsOfServicePage.termsScrollKey,
          controller: controller,
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                snapshot.title,
                style: AppTextStyles.sectionTitle.copyWith(
                  color: AppColors.text1,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 22),
              Text(
                snapshot.lastUpdatedLabel,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text3,
                  height: 1,
                ),
              ),
              const SizedBox(height: 30),
              for (final section in snapshot.sections) ...[
                _TermsSection(section: section),
                if (section != snapshot.sections.last)
                  const SizedBox(height: 26),
              ],
              const Divider(color: AppColors.borderSolid, height: 32),
              Center(
                child: Text(
                  '-- End of Terms --',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TermsSection extends StatelessWidget {
  const _TermsSection({required this.section});

  final TradeBotTermsSection section;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          section.title,
          style: AppTextStyles.baseMedium.copyWith(
            color: AppColors.text1,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 14),
        if (section.warningTitle != null && section.warningBody != null) ...[
          _CriticalWarning(section: section),
          const SizedBox(height: 16),
        ],
        for (final paragraph in section.paragraphs) ...[
          Text(
            paragraph,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text2,
              height: 1.68,
            ),
          ),
          if (paragraph != section.paragraphs.last) const SizedBox(height: 12),
        ],
        if (section.bullets.isNotEmpty) ...[
          const SizedBox(height: 12),
          for (final bullet in section.bullets)
            Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 8),
              child: Text(
                '- $bullet',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.text2,
                  height: 1.45,
                ),
              ),
            ),
        ],
      ],
    );
  }
}

class _CriticalWarning extends StatelessWidget {
  const _CriticalWarning({required this.section});

  final TradeBotTermsSection section;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      padding: const EdgeInsets.fromLTRB(13, 14, 13, 13),
      borderColor: _termsRed.withValues(alpha: .35),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.warning_amber_rounded,
              color: _termsRed,
              size: 17,
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppTextStyles.caption.copyWith(
                  color: _termsRed,
                  height: 1.5,
                ),
                children: [
                  TextSpan(
                    text: '${section.warningTitle} ',
                    style: AppTextStyles.caption.copyWith(
                      color: _termsRed,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  TextSpan(text: section.warningBody),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScrollWarning extends StatelessWidget {
  const _ScrollWarning({required this.snapshot});

  final TradeBotTermsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      constraints: const BoxConstraints(minHeight: 45),
      padding: const EdgeInsets.fromLTRB(12, 11, 12, 11),
      borderColor: _termsAmber.withValues(alpha: .32),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: _termsAmber, size: 16),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              snapshot.scrollWarning,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AgreementCard extends StatelessWidget {
  const _AgreementCard({
    required this.snapshot,
    required this.enabled,
    required this.agreed,
    required this.onTap,
  });

  final TradeBotTermsSnapshot snapshot;
  final bool enabled;
  final bool agreed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : .5,
      child: InkWell(
        key: BotTermsOfServicePage.agreementKey,
        onTap: enabled ? onTap : null,
        borderRadius: AppRadii.inputRadius,
        child: Container(
          constraints: const BoxConstraints(minHeight: 122),
          padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
          decoration: BoxDecoration(
            color: enabled ? _termsPanel2 : _termsPanel,
            borderRadius: AppRadii.inputRadius,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 24,
                height: 24,
                margin: const EdgeInsets.only(top: 2),
                decoration: BoxDecoration(
                  color: agreed ? AppColors.primary : AppColors.transparent,
                  border: Border.all(
                    color: agreed ? AppColors.primary : AppColors.borderSolid,
                  ),
                  borderRadius: AppRadii.mdRadius,
                ),
                child: agreed
                    ? const Icon(
                        Icons.check_circle_outline_rounded,
                        color: AppColors.onAccent,
                        size: 16,
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snapshot.agreementTitle,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      snapshot.agreementDescription,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
