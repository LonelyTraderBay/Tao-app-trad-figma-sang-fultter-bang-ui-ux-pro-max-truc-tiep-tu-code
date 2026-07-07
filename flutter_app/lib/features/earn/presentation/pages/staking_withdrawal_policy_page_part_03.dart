part of 'staking_withdrawal_policy_page.dart';

class _PenaltyCalculatorSheetState extends State<_PenaltyCalculatorSheet> {
  final _principalController = TextEditingController();
  final _earnedController = TextEditingController();
  final _daysController = TextEditingController();
  bool _previewRequested = false;

  @override
  void dispose() {
    _principalController.dispose();
    _earnedController.dispose();
    _daysController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final result = _calculate();
    final bottomPadding =
        MediaQuery.viewInsetsOf(context).bottom +
        MediaQuery.paddingOf(context).bottom +
        AppSpacing.x5;

    return SafeArea(
      top: false,
      child: Material(
        color: AppColors.surface,
        borderRadius: AppRadii.sheetTopLargeRadius,
        child: SingleChildScrollView(
          padding: AppSpacing.earnSheetPadding(bottomPadding - AppSpacing.x5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: SizedBox(
                  width: _stakingWithdrawalSheetHandleWidth,
                  height: _stakingWithdrawalSheetHandleHeight,
                  child: const Material(
                    color: AppColors.borderSolid,
                    borderRadius: AppRadii.hairlineRadius,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              Text(
                'Tính phí rút sớm',
                style: AppTextStyles.sectionTitle.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              VitInput(
                controller: _principalController,
                fieldKey: const Key('sc355_calculator_principal'),
                label: 'Số lượng gốc (Principal)',
                hintText: '1000',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                prefix: const Icon(Icons.account_balance_wallet_rounded),
                onChanged: (_) => setState(() => _previewRequested = false),
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              VitInput(
                controller: _earnedController,
                fieldKey: const Key('sc355_calculator_earned'),
                label: 'Phần thưởng đã tích lũy',
                hintText: '50',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                prefix: const Icon(Icons.savings_rounded),
                onChanged: (_) => setState(() => _previewRequested = false),
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              VitInput(
                controller: _daysController,
                fieldKey: const Key('sc355_calculator_days'),
                label: 'Số ngày đã stake',
                hintText: '45',
                keyboardType: TextInputType.number,
                prefix: const Icon(Icons.calendar_month_rounded),
                onChanged: (_) => setState(() => _previewRequested = false),
              ),
              if (result != null) ...[
                const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                _CalculatorResult(
                  result: result,
                  previewRequested: _previewRequested,
                ),
              ],
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              _WarningBox(text: widget.snapshot.calculatorDisclaimer),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              VitCtaButton(
                onPressed: result == null
                    ? null
                    : () {
                        HapticFeedback.mediumImpact();
                        setState(() => _previewRequested = true);
                      },
                leading: const Icon(Icons.fact_check_rounded),
                child: const Text('Xem preview rút'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _PenaltyCalculation? _calculate() {
    final principal = double.tryParse(_principalController.text);
    final earned = double.tryParse(_earnedController.text);
    final days = int.tryParse(_daysController.text);
    if (principal == null || earned == null || days == null) return null;
    if (principal <= 0 || earned < 0 || days < 0) return null;

    final rate = days < 30 ? 100 : 50;
    final penalty = rate == 100 ? earned : earned * .5;
    final remaining = earned - penalty;
    return _PenaltyCalculation(
      principal: principal,
      penalty: penalty,
      remaining: remaining,
      receive: principal + remaining,
      rate: rate,
    );
  }
}

class _PenaltyCalculation {
  const _PenaltyCalculation({
    required this.principal,
    required this.penalty,
    required this.remaining,
    required this.receive,
    required this.rate,
  });

  final double principal;
  final double penalty;
  final double remaining;
  final double receive;
  final int rate;
}

class _CalculatorResult extends StatelessWidget {
  const _CalculatorResult({
    required this.result,
    required this.previewRequested,
  });

  final _PenaltyCalculation result;
  final bool previewRequested;

  @override
  Widget build(BuildContext context) {
    return Material(
      key: StakingWithdrawalPolicyPage.calculatorResultKey,
      color: AppColors.surface2,
      borderRadius: AppRadii.cardLargeRadius,
      child: Padding(
        padding: _stakingWithdrawalCardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kết quả:',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
            _CalculationRow(
              row: StakingWithdrawalCalculationRowDraft(
                label: 'Phí rút sớm',
                value:
                    '-${result.penalty.toStringAsFixed(2)} (${result.rate}%)',
                tone: result.rate == 100
                    ? StakingDisclosureRiskLevel.high
                    : StakingDisclosureRiskLevel.medium,
              ),
            ),
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            _CalculationRow(
              row: StakingWithdrawalCalculationRowDraft(
                label: 'Phần thưởng còn lại',
                value: '+${result.remaining.toStringAsFixed(2)}',
                tone: StakingDisclosureRiskLevel.low,
              ),
            ),
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            _CalculationRow(
              row: StakingWithdrawalCalculationRowDraft(
                label: 'Số lượng nhận về',
                value: result.receive.toStringAsFixed(2),
                highlight: true,
              ),
            ),
            if (previewRequested) ...[
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              _SmallBadge(
                label: 'Preview mock đã sẵn sàng - cần xác nhận trước khi rút',
                color: AppColors.primary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  const _NoteCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: _stakingWithdrawalCardPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.text3,
            size: _stakingWithdrawalNoticeIcon,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                height: _stakingWithdrawalNoticeLineHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WarningBox extends StatelessWidget {
  const _WarningBox({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.warningBg,
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadii.lgRadius,
        side: BorderSide(color: AppColors.warningBorder),
      ),
      child: Padding(
        padding: AppSpacing.earnPaddingX3,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.warn,
              size: _stakingWithdrawalNoticeIcon,
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Text(
                text,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  height: _stakingWithdrawalNoticeLineHeight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BulletLine extends StatelessWidget {
  const _BulletLine({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: _stakingWithdrawalBulletPadding,
          child: SizedBox(
            width: _stakingWithdrawalBulletSize,
            height: _stakingWithdrawalBulletSize,
            child: Material(color: color, shape: const CircleBorder()),
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: _stakingWithdrawalBulletLineHeight,
            ),
          ),
        ),
      ],
    );
  }
}

class _SmallBadge extends StatelessWidget {
  const _SmallBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: .12),
      borderRadius: AppRadii.smRadius,
      child: Padding(
        padding: _stakingWithdrawalBadgePadding,
        child: Text(
          label,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            height: _stakingWithdrawalBadgeLineHeight,
          ),
        ),
      ),
    );
  }
}

IconData _stepIcon(int step) {
  switch (step) {
    case 1:
      return Icons.account_balance_wallet_rounded;
    case 2:
      return Icons.verified_user_rounded;
    case 3:
      return Icons.schedule_rounded;
    default:
      return Icons.check_circle_rounded;
  }
}

Color _toneColor(StakingDisclosureRiskLevel level) {
  return switch (level) {
    StakingDisclosureRiskLevel.low => AppColors.buy,
    StakingDisclosureRiskLevel.medium => AppColors.warn,
    StakingDisclosureRiskLevel.high => AppColors.sell,
  };
}

Color _toneTint(StakingDisclosureRiskLevel level) {
  return switch (level) {
    StakingDisclosureRiskLevel.low => AppColors.buy10,
    StakingDisclosureRiskLevel.medium => AppColors.warn10,
    StakingDisclosureRiskLevel.high => AppColors.sell10,
  };
}
