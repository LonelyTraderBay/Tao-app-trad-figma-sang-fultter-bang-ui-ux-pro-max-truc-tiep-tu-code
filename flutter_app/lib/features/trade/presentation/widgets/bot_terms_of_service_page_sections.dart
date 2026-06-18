part of '../pages/bot_terms_of_service_page.dart';

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.snapshot});

  final TradeBotTermsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      constraints: const BoxConstraints(minHeight: 96),
      padding: AppSpacing.tradeBotCardPaddingLoose,
      borderColor: _termsPrimary.withValues(alpha: .24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: AppSpacing.tradeBotIntroIconTopPadding,
            child: Icon(
              Icons.description_outlined,
              color: _termsPrimary,
              size: AppSpacing.tradeBotActionIcon,
            ),
          ),
          const SizedBox(width: AppSpacing.tradeBotCardIconGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.infoTitle,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    height: AppSpacing.tradeBotLineHeightShort,
                  ),
                ),
                const SizedBox(height: AppSpacing.tradeBotSmallGap),
                Text(
                  snapshot.infoDescription,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: AppSpacing.tradeBotLineHeightRelaxed,
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
      height: AppSpacing.tradeBotTermsCardHeight,
      borderColor: AppColors.cardBorder,
      child: ClipRRect(
        borderRadius: AppRadii.cardRadius,
        child: SingleChildScrollView(
          key: BotTermsOfServicePage.termsScrollKey,
          controller: controller,
          padding: AppSpacing.tradeBotTermsScrollPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                snapshot.title,
                style: AppTextStyles.sectionTitle.copyWith(
                  color: AppColors.text1,
                  height: AppSpacing.tradeBotLineHeightShort,
                ),
              ),
              const SizedBox(height: AppSpacing.x5),
              Text(
                snapshot.lastUpdatedLabel,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text3,
                  height: AppSpacing.tradeBotLineHeightTight,
                ),
              ),
              const SizedBox(height: AppSpacing.x6),
              for (final section in snapshot.sections) ...[
                _TermsSection(section: section),
                if (section != snapshot.sections.last)
                  const SizedBox(height: AppSpacing.x5),
              ],
              const Divider(
                color: AppColors.borderSolid,
                height: AppSpacing.x6,
              ),
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
            height: AppSpacing.tradeBotLineHeightShort,
          ),
        ),
        const SizedBox(height: AppSpacing.tradeBotStatusGap),
        if (section.warningTitle != null && section.warningBody != null) ...[
          _CriticalWarning(section: section),
          const SizedBox(height: AppSpacing.contentPad),
        ],
        for (final paragraph in section.paragraphs) ...[
          Text(
            paragraph,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text2,
              height: AppSpacing.tradeBotLineHeightLegal,
            ),
          ),
          if (paragraph != section.paragraphs.last)
            const SizedBox(height: AppSpacing.tradeBotCardGap),
        ],
        if (section.bullets.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.tradeBotCardGap),
          for (final bullet in section.bullets)
            Padding(
              padding: AppSpacing.tradeBotTermsBulletPadding,
              child: Text(
                '- $bullet',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.text2,
                  height: AppSpacing.tradeBotLineHeightReadable,
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
      padding: AppSpacing.tradeBotTermsWarningPadding,
      borderColor: _termsRed.withValues(alpha: .35),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: AppSpacing.tradeBotIntroIconTopPadding,
            child: Icon(
              Icons.warning_amber_rounded,
              color: _termsRed,
              size: AppSpacing.tradeBotMediumIcon,
            ),
          ),
          const SizedBox(width: AppSpacing.tradeBotDisclosureGap),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppTextStyles.caption.copyWith(
                  color: _termsRed,
                  height: AppSpacing.tradeBotLineHeightLoose,
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
      padding: AppSpacing.tradeBotCompactCardPadding,
      borderColor: _termsAmber.withValues(alpha: .32),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: _termsAmber,
            size: AppSpacing.tradeBotCheckboxIcon,
          ),
          const SizedBox(width: AppSpacing.tradeBotDisclosureGap),
          Expanded(
            child: Text(
              snapshot.scrollWarning,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                height: AppSpacing.tradeBotLineHeightCompact,
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
      child: VitCard(
        key: BotTermsOfServicePage.agreementKey,
        onTap: enabled ? onTap : null,
        constraints: const BoxConstraints(minHeight: 122),
        padding: AppSpacing.tradeBotAgreementPadding,
        variant: enabled ? VitCardVariant.inner : VitCardVariant.standard,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: AppSpacing.tradeBotAgreementIconMargin,
              child: Icon(
                agreed
                    ? Icons.check_circle_outline_rounded
                    : Icons.radio_button_unchecked_rounded,
                color: agreed ? AppColors.primary : AppColors.borderSolid,
                size: AppSpacing.tradeBotCheckbox,
              ),
            ),
            const SizedBox(width: AppSpacing.tradeBotCardIconGap),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.agreementTitle,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                      height: AppSpacing.tradeBotLineHeightBody,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.tradeBotLabelGap),
                  Text(
                    snapshot.agreementDescription,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                      height: AppSpacing.tradeBotLineHeightReadable,
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
