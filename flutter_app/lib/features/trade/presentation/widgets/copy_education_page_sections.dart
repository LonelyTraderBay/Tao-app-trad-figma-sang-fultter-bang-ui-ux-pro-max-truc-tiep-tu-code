part of '../pages/copy_education_page.dart';

class _IntroBanner extends StatelessWidget {
  const _IntroBanner({required this.snapshot});

  final TradeCopyEducationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 96),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 15),
      decoration: BoxDecoration(
        color: _copyPrimary.withValues(alpha: .08),
        border: Border.all(color: _copyPrimary),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.menu_book_outlined, color: _copyPrimary, size: 25),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.introTitle,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: _copyPrimary,
                    fontSize: 16,
                    fontWeight: AppTextStyles.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  snapshot.introDescription,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 12,
                    height: 1.42,
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

class _EducationTabs extends StatelessWidget {
  const _EducationTabs({
    required this.tabs,
    required this.active,
    required this.onChanged,
  });

  final List<TradeCopyEducationTab> tabs;
  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      color: AppColors.surface,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final tab in tabs)
            Expanded(
              child: InkWell(
                key: CopyEducationPage.tabKey(tab.id),
                onTap: () => onChanged(tab.id),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        _tabLabel(tab),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.caption.copyWith(
                          color: active == tab.id
                              ? _copyPrimary
                              : AppColors.text3,
                          fontSize: 12,
                          fontWeight: active == tab.id
                              ? AppTextStyles.bold
                              : AppTextStyles.medium,
                          height: 1.25,
                        ),
                      ),
                    ),
                    if (active == tab.id)
                      const Positioned(
                        left: 28,
                        right: 28,
                        bottom: 0,
                        child: SizedBox(
                          height: 2,
                          child: DecoratedBox(
                            decoration: BoxDecoration(color: _copyPrimary),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _HowItWorksContent extends StatelessWidget {
  const _HowItWorksContent({required this.snapshot});

  final TradeCopyEducationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _StepsCard(steps: snapshot.steps),
        const SizedBox(height: 22),
        _CopyModesCard(modes: snapshot.copyModes),
        const SizedBox(height: 22),
        _ConceptsCard(concepts: snapshot.concepts),
      ],
    );
  }
}

class _StepsCard extends StatelessWidget {
  const _StepsCard({required this.steps});

  final List<TradeCopyEducationStep> steps;

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Copy Trading hoạt động như thế nào?',
            style: AppTextStyles.baseMedium.copyWith(
              fontSize: 16,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: 17),
          for (final step in steps) ...[
            _StepRow(step: step),
            if (step != steps.last) const SizedBox(height: 17),
          ],
        ],
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({required this.step});

  final TradeCopyEducationStep step;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 34,
          child: Padding(
            padding: const EdgeInsets.only(top: 11),
            child: Text(
              '${step.number}',
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(
                color: _copyPrimary,
                fontSize: 14,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _iconFor(step.iconName),
                    color: AppColors.text1,
                    size: 15,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      step.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontSize: 14,
                        fontWeight: AppTextStyles.bold,
                        height: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 7),
              Text(
                step.description,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 11,
                  height: 1.38,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CopyModesCard extends StatelessWidget {
  const _CopyModesCard({required this.modes});

  final List<TradeCopyModeGuide> modes;

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Các chế độ sao chép',
            style: AppTextStyles.baseMedium.copyWith(
              fontSize: 16,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: 14),
          for (final mode in modes) ...[
            _CopyModeTile(mode: mode),
            if (mode != modes.last) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _CopyModeTile extends StatelessWidget {
  const _CopyModeTile({required this.mode});

  final TradeCopyModeGuide mode;

  @override
  Widget build(BuildContext context) {
    final color = Color(mode.colorHex);
    return Container(
      constraints: const BoxConstraints(minHeight: 116),
      padding: const EdgeInsets.fromLTRB(14, 13, 14, 12),
      decoration: BoxDecoration(
        color: _educationPanel,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Text(
                mode.title,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontSize: 14,
                  fontWeight: AppTextStyles.bold,
                  height: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Text(
            mode.description,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              fontSize: 11,
              height: 1.42,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _SmallGuideLine(
                  icon: Icons.check_circle_outline_rounded,
                  color: AppColors.buy,
                  text: mode.pro,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SmallGuideLine(
                  icon: Icons.cancel_outlined,
                  color: AppColors.sell,
                  text: mode.con,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ConceptsCard extends StatelessWidget {
  const _ConceptsCard({required this.concepts});

  final List<TradeCopyConceptGuide> concepts;

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Khái niệm quan trọng',
            style: AppTextStyles.baseMedium.copyWith(
              fontSize: 16,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: 14),
          for (final concept in concepts) ...[
            _ConceptRow(concept: concept),
            if (concept != concepts.last) const SizedBox(height: 11),
          ],
        ],
      ),
    );
  }
}
