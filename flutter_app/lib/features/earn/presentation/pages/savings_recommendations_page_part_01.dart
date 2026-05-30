part of 'savings_recommendations_page.dart';

class _SavingsRecommendationsPageState
    extends ConsumerState<SavingsRecommendationsPage> {
  String _amountText = '15000';

  double get _amount => double.tryParse(_amountText) ?? 0;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(savingsRecommendationsRepositoryProvider)
        .getRecommendations();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-338 SavingsRecommendationsPage',
      child: Material(
        color: AppColors.bg,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: bottomInset),
                child: VitPageContent(
                  padding: VitContentPadding.compact,
                  gap: VitContentGap.defaultGap,
                  children: [
                    _HeroCard(snapshot: snapshot),
                    _ProfileCard(snapshot: snapshot),
                    _AmountSimulator(
                      amountText: _amountText,
                      onAmountChanged: (value) =>
                          setState(() => _amountText = value),
                      onQuickAmount: (value) {
                        HapticFeedback.selectionClick();
                        setState(() => _amountText = '$value');
                      },
                    ),
                    _CompareButton(
                      onTap: () => _openCompareSheet(snapshot.strategies),
                    ),
                    VitPageSection(
                      label: 'Chiến lược được Đề xuất',
                      accentColor: AppColors.accent,
                      children: [
                        Column(
                          key: SavingsRecommendationsPage.strategyListKey,
                          children: [
                            for (final strategy in snapshot.strategies) ...[
                              _StrategyCard(
                                key: SavingsRecommendationsPage.strategyKey(
                                  strategy.id,
                                ),
                                strategy: strategy,
                                amount: _amount,
                                onTap: () => _openStrategySheet(
                                  strategy,
                                  snapshot.savingsRoute,
                                ),
                              ),
                              if (strategy != snapshot.strategies.last)
                                const SizedBox(height: AppSpacing.x3),
                            ],
                          ],
                        ),
                      ],
                    ),
                    VitPageSection(
                      label: 'Gợi ý Cá nhân hóa',
                      accentColor: AppColors.buy,
                      children: [
                        Column(
                          children: [
                            for (final insight in snapshot.insights) ...[
                              _InsightCard(insight: insight),
                              if (insight != snapshot.insights.last)
                                const SizedBox(height: AppSpacing.x3),
                            ],
                          ],
                        ),
                      ],
                    ),
                    _QuickLinks(snapshot: snapshot),
                    _Disclaimer(text: snapshot.disclaimer),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openStrategySheet(
    SavingsStrategyDraft strategy,
    String savingsRoute,
  ) async {
    HapticFeedback.selectionClick();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.86,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppRadii.xl),
              ),
            ),
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.contentPad,
                  AppSpacing.x5,
                  AppSpacing.contentPad,
                  AppSpacing.x6,
                ),
                child: _StrategyDetailSheet(
                  strategy: strategy,
                  amount: _amount,
                  savingsRoute: savingsRoute,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _openCompareSheet(List<SavingsStrategyDraft> strategies) async {
    HapticFeedback.selectionClick();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.72,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppRadii.xl),
              ),
            ),
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.contentPad,
                  AppSpacing.x5,
                  AppSpacing.contentPad,
                  AppSpacing.x6,
                ),
                child: _CompareSheet(strategies: strategies, amount: _amount),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.snapshot});

  final SavingsRecommendationsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.accent08,
        border: Border.all(color: AppColors.accent20, width: 1.5),
        borderRadius: AppRadii.cardLargeRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.auto_awesome_rounded,
              color: AppColors.accent,
              size: AppSpacing.iconMd,
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(snapshot.heroTitle, style: AppTextStyles.baseMedium),
                  const SizedBox(height: AppSpacing.x2),
                  Text(
                    snapshot.heroSubtitle,
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
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.snapshot});

  final SavingsRecommendationsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final profile = snapshot.profile;
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Hồ sơ của bạn', style: AppTextStyles.baseMedium),
              ),
              if (profile.hasCompletedAssessment)
                _SmallPill(
                  label: 'Đã đánh giá ${profile.assessmentDate}',
                  color: AppColors.buy,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = (constraints.maxWidth - AppSpacing.x3) / 2;
              return Wrap(
                spacing: AppSpacing.x3,
                runSpacing: AppSpacing.x3,
                children: [
                  SizedBox(
                    width: itemWidth,
                    child: _ProfileMetric(
                      label: 'Mức rủi ro',
                      value: _riskToleranceLabel(profile.riskTolerance),
                    ),
                  ),
                  SizedBox(
                    width: itemWidth,
                    child: _ProfileMetric(
                      label: 'Thời gian đầu tư',
                      value: _horizonLabel(profile.investmentHorizon),
                    ),
                  ),
                  SizedBox(
                    width: itemWidth,
                    child: _ProfileMetric(
                      label: 'Nhu cầu thanh khoản',
                      value: _liquidityLabel(profile.liquidityNeed),
                    ),
                  ),
                  SizedBox(
                    width: itemWidth,
                    child: _ProfileMetric(
                      label: 'Tài sản yêu thích',
                      value: profile.preferredAssets.join(', '),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.x3),
          VitCtaButton(
            variant: VitCtaButtonVariant.secondary,
            height: AppSpacing.buttonCompact,
            onPressed: () {
              HapticFeedback.selectionClick();
              context.go(snapshot.riskAssessmentRoute);
            },
            child: Text(
              profile.hasCompletedAssessment
                  ? 'Làm lại đánh giá rủi ro'
                  : 'Đánh giá rủi ro',
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileMetric extends StatelessWidget {
  const _ProfileMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.lgRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AmountSimulator extends StatelessWidget {
  const _AmountSimulator({
    required this.amountText,
    required this.onAmountChanged,
    required this.onQuickAmount,
  });

  final String amountText;
  final ValueChanged<String> onAmountChanged;
  final ValueChanged<int> onQuickAmount;

  @override
  Widget build(BuildContext context) {
    const amounts = [1000, 5000, 10000, 50000];
    final activeAmount = int.tryParse(amountText);
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.calculate_outlined,
                color: AppColors.text2,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Mô phỏng với số tiền khác',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          TextField(
            key: SavingsRecommendationsPage.amountFieldKey,
            keyboardType: TextInputType.number,
            onChanged: onAmountChanged,
            controller: TextEditingController(text: amountText)
              ..selection = TextSelection.collapsed(offset: amountText.length),
            cursorColor: AppColors.primary,
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text1,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
            decoration: const InputDecoration(
              isDense: true,
              filled: true,
              fillColor: AppColors.surface2,
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSpacing.x4,
                vertical: AppSpacing.x3,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadii.inputRadius,
                borderSide: BorderSide(color: AppColors.borderSolid),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppRadii.inputRadius,
                borderSide: BorderSide(color: AppColors.primary30),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              for (final amount in amounts) ...[
                Expanded(
                  child: _AmountChip(
                    key: SavingsRecommendationsPage.amountChipKey(amount),
                    amount: amount,
                    selected: activeAmount == amount,
                    onTap: () => onQuickAmount(amount),
                  ),
                ),
                if (amount != amounts.last)
                  const SizedBox(width: AppSpacing.x2),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _AmountChip extends StatelessWidget {
  const _AmountChip({
    super.key,
    required this.amount,
    required this.selected,
    required this.onTap,
  });

  final int amount;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary12 : AppColors.transparent,
      borderRadius: AppRadii.mdRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.mdRadius,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
          child: Text(
            amount >= 1000 ? '\$${amount ~/ 1000}K' : '\$$amount',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: selected ? AppColors.primary : AppColors.text3,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _CompareButton extends StatelessWidget {
  const _CompareButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: SavingsRecommendationsPage.compareButtonKey,
      variant: VitCtaButtonVariant.ghost,
      height: AppSpacing.buttonCompact,
      leading: const Icon(Icons.bar_chart_rounded),
      onPressed: onTap,
      child: const Text('So sánh tất cả chiến lược'),
    );
  }
}
