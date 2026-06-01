part of '../pages/copy_trading_card_demo.dart';

class _AnalysisHeader extends StatelessWidget {
  const _AnalysisHeader({required this.snapshot});

  final TradeCopyCardDemoSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: CopyTradingCardDemo.analysisKey,
      variant: VitCardVariant.standard,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.analytics_outlined,
                color: AppColors.primary,
                size: 22,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  'Enterprise Fintech Card Analysis',
                  style: AppTextStyles.sectionTitle.copyWith(fontSize: 19),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            'Below are 3 variants designed to address enterprise-level fintech standards: visual hierarchy, trust-first principles, and regulatory compliance.',
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.medium,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          DecoratedBox(
            decoration: const BoxDecoration(
              color: AppColors.bg,
              borderRadius: AppRadii.cardRadius,
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Key Improvements:',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  for (final item in snapshot.improvements)
                    _BulletLine(text: item, compact: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ComparisonMatrix extends StatelessWidget {
  const _ComparisonMatrix({required this.issues});

  final List<TradeCopyCardIssue> issues;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: CopyTradingCardDemo.matrixKey,
      variant: VitCardVariant.standard,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Compliance Comparison Matrix',
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              _ScoreCard(
                label: 'Original',
                score: _score('original'),
                status: TradeCopyCardCompliance.fail,
              ),
              const SizedBox(width: AppSpacing.x2),
              _ScoreCard(
                label: 'Variant A',
                score: _score('variantA'),
                status: TradeCopyCardCompliance.pass,
                selected: true,
              ),
              const SizedBox(width: AppSpacing.x2),
              _ScoreCard(
                label: 'Variant B',
                score: _score('variantB'),
                status: TradeCopyCardCompliance.pass,
              ),
              const SizedBox(width: AppSpacing.x2),
              _ScoreCard(
                label: 'Variant C',
                score: _score('variantC'),
                status: TradeCopyCardCompliance.warn,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          _MatrixHeader(),
          for (final issue in issues) _IssueRow(issue: issue),
          const SizedBox(height: AppSpacing.x4),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: AppSpacing.x5,
            runSpacing: AppSpacing.x2,
            children: const [
              _Legend(status: TradeCopyCardCompliance.pass, label: 'Compliant'),
              _Legend(status: TradeCopyCardCompliance.warn, label: 'Partial'),
              _Legend(
                status: TradeCopyCardCompliance.fail,
                label: 'Non-compliant',
              ),
            ],
          ),
        ],
      ),
    );
  }

  int _score(String column) {
    var total = 0;
    for (final issue in issues) {
      final status = switch (column) {
        'original' => issue.original,
        'variantA' => issue.variantA,
        'variantB' => issue.variantB,
        _ => issue.variantC,
      };
      total += switch (status) {
        TradeCopyCardCompliance.pass => 100,
        TradeCopyCardCompliance.warn => 50,
        TradeCopyCardCompliance.fail => 0,
      };
    }
    return (total / issues.length).round();
  }
}

class _MatrixHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.x2),
      child: Row(
        children: [
          Expanded(flex: 5, child: _HeaderCell('Issue Category')),
          Expanded(child: _HeaderCell('Orig')),
          Expanded(child: _HeaderCell('A')),
          Expanded(child: _HeaderCell('B')),
          Expanded(child: _HeaderCell('C')),
        ],
      ),
    );
  }
}

class _IssueRow extends StatelessWidget {
  const _IssueRow({required this.issue});

  final TradeCopyCardIssue issue;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.x3),
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    issue.category,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  Text(
                    issue.description,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                  ),
                ],
              ),
            ),
            Expanded(child: _ComplianceIcon(status: issue.original)),
            Expanded(child: _ComplianceIcon(status: issue.variantA)),
            Expanded(child: _ComplianceIcon(status: issue.variantB)),
            Expanded(child: _ComplianceIcon(status: issue.variantC)),
          ],
        ),
      ),
    );
  }
}

class _OriginalIssues extends StatelessWidget {
  const _OriginalIssues({required this.issues});

  final List<TradeCopyCardTextBlock> issues;

  @override
  Widget build(BuildContext context) {
    return _InfoPanel(
      key: CopyTradingCardDemo.issuesKey,
      icon: Icons.error_outline_rounded,
      iconColor: AppColors.sell,
      borderColor: AppColors.sell20,
      title: 'Original Card Issues (Enterprise Standards)',
      children: [
        for (final issue in issues)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.x3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  issue.title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  issue.body,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _Recommendation extends StatelessWidget {
  const _Recommendation({required this.snapshot});

  final TradeCopyCardDemoSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return _InfoPanel(
      key: CopyTradingCardDemo.recommendationKey,
      icon: Icons.verified_rounded,
      iconColor: AppColors.buy,
      borderColor: AppColors.buy20,
      title: 'Final Recommendation',
      children: [
        Text(
          snapshot.recommendation,
          style: AppTextStyles.body.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x3),
        for (final item in snapshot.recommendationReasons)
          _IconLine(icon: Icons.check_rounded, text: item),
      ],
    );
  }
}

class _Guidelines extends StatelessWidget {
  const _Guidelines({required this.guidelines});

  final List<TradeCopyCardTextBlock> guidelines;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: CopyTradingCardDemo.guidelinesKey,
      variant: VitCardVariant.standard,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Guidelines Compliance',
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          for (var i = 0; i < guidelines.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.x3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DecoratedBox(
                    decoration: const BoxDecoration(
                      color: AppColors.primary15,
                      borderRadius: AppRadii.xsRadius,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.x2,
                        vertical: AppSpacing.x1,
                      ),
                      child: Text(
                        '§${i + 1}',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.primary,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${guidelines[i].title}: ',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                          TextSpan(
                            text: guidelines[i].body,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text2,
                            ),
                          ),
                        ],
                      ),
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
