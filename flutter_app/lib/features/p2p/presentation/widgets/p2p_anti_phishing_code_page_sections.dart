part of '../pages/p2p_anti_phishing_code_page.dart';

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.snapshot});

  final P2PAntiPhishingCodeSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final color = snapshot.hasCode ? AppColors.buy : AppColors.warn;

    return DecoratedBox(
      key: P2PAntiPhishingCodePage.statusKey,
      decoration: BoxDecoration(
        color: color,
        borderRadius: AppRadii.cardLargeRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: AppSpacing.inputHeight,
              height: AppSpacing.inputHeight,
              decoration: BoxDecoration(
                color: AppColors.onAccent.withValues(alpha: .18),
                borderRadius: AppRadii.lgRadius,
              ),
              child: const Icon(
                Icons.shield_outlined,
                color: AppColors.onAccent,
                size: AppSpacing.iconMd,
              ),
            ),
            const SizedBox(width: AppSpacing.x4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.statusTitle,
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: AppColors.onAccent,
                      fontSize: 22,
                      height: 1.12,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  Text(
                    snapshot.statusBody,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.onAccent.withValues(alpha: .9),
                      fontWeight: AppTextStyles.bold,
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

class _ExplainerCard extends StatelessWidget {
  const _ExplainerCard({required this.snapshot});

  final P2PAntiPhishingCodeSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PAntiPhishingCodePage.explainerKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: AppModuleAccents.p2p,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  snapshot.explainerTitle,
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            snapshot.explainerBody,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: 1.55,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          for (final benefit in snapshot.benefits) ...[
            _CheckRow(text: benefit),
            if (benefit != snapshot.benefits.last)
              const SizedBox(height: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _EmailExamples extends StatelessWidget {
  const _EmailExamples({required this.examples});

  final List<P2PAntiPhishingExampleDraft> examples;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PAntiPhishingCodePage.examplesKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < examples.length; index++) ...[
          _EmailExampleCard(example: examples[index]),
          if (index != examples.length - 1)
            const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _EmailExampleCard extends StatelessWidget {
  const _EmailExampleCard({required this.example});

  final P2PAntiPhishingExampleDraft example;

  @override
  Widget build(BuildContext context) {
    final color = example.isLegit ? AppColors.buy : AppColors.sell;

    return VitCard(
      key: P2PAntiPhishingCodePage.exampleKey(example.id),
      radius: VitCardRadius.lg,
      borderColor: color,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                example.isLegit
                    ? Icons.check_circle_outline_rounded
                    : Icons.warning_amber_rounded,
                color: color,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.mail_outline_rounded,
                          color: AppColors.text3,
                          size: 12,
                        ),
                        const SizedBox(width: AppSpacing.x1),
                        Expanded(
                          child: Text(
                            example.subject,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x3),
                    VitCard(
                      radius: VitCardRadius.sm,
                      variant: VitCardVariant.inner,
                      borderColor: AppColors.transparent,
                      padding: const EdgeInsets.all(AppSpacing.x3),
                      child: Text(
                        example.preview,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text2,
                          height: 1.55,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Align(
            alignment: Alignment.centerLeft,
            child: _SmallBadge(
              label: example.isLegit ? 'Email chính thức' : 'Email lừa đảo',
              icon: example.isLegit ? Icons.check_rounded : Icons.close_rounded,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _WarningCard extends StatelessWidget {
  const _WarningCard({required this.snapshot});

  final P2PAntiPhishingCodeSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      key: P2PAntiPhishingCodePage.warningKey,
      decoration: BoxDecoration(
        color: AppColors.sell10,
        borderRadius: AppRadii.lgRadius,
        border: Border.all(color: AppColors.sell20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.sell,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.warningTitle,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.sell,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  for (final warning in snapshot.warnings) ...[
                    _BulletRow(text: warning),
                    if (warning != snapshot.warnings.last)
                      const SizedBox(height: AppSpacing.x1),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.baseMedium.copyWith(fontWeight: AppTextStyles.bold),
    );
  }
}

class _CheckRow extends StatelessWidget {
  const _CheckRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.check_circle_outline_rounded,
          color: AppColors.buy,
          size: 13,
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}

class _BulletRow extends StatelessWidget {
  const _BulletRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 4,
          height: 4,
          margin: const EdgeInsets.only(top: 7),
          decoration: const BoxDecoration(
            color: AppColors.text3,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}
