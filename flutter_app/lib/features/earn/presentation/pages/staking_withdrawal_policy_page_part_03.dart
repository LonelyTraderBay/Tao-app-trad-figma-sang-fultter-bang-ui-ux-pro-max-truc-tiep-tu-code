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
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.earnWithdrawalSheetRadius),
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.x5,
            AppSpacing.x4,
            AppSpacing.x5,
            bottomPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: AppSpacing.earnWithdrawalSheetHandleWidth,
                  height: AppSpacing.earnWithdrawalSheetHandleHeight,
                  decoration: BoxDecoration(
                    color: AppColors.borderSolid,
                    borderRadius: BorderRadius.circular(
                      AppSpacing.earnWithdrawalSheetHandleRadius,
                    ),
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: AppSpacing.x4)),
              Text(
                'Tính phí rút sớm',
                style: AppTextStyles.sectionTitle.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: AppSpacing.x4)),
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
              const Padding(padding: EdgeInsets.only(top: AppSpacing.x3)),
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
              const Padding(padding: EdgeInsets.only(top: AppSpacing.x3)),
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
                const Padding(padding: EdgeInsets.only(top: AppSpacing.x4)),
                _CalculatorResult(
                  result: result,
                  previewRequested: _previewRequested,
                ),
              ],
              const Padding(padding: EdgeInsets.only(top: AppSpacing.x4)),
              _WarningBox(text: widget.snapshot.calculatorDisclaimer),
              const Padding(padding: EdgeInsets.only(top: AppSpacing.x4)),
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
    return Container(
      key: StakingWithdrawalPolicyPage.calculatorResultKey,
      padding: const EdgeInsets.all(AppSpacing.x4),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.cardLargeRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kết quả:',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const Padding(padding: EdgeInsets.only(top: AppSpacing.x3)),
          _CalculationRow(
            row: StakingWithdrawalCalculationRowDraft(
              label: 'Phí rút sớm',
              value: '-${result.penalty.toStringAsFixed(2)} (${result.rate}%)',
              tone: result.rate == 100
                  ? StakingDisclosureRiskLevel.high
                  : StakingDisclosureRiskLevel.medium,
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: AppSpacing.x2)),
          _CalculationRow(
            row: StakingWithdrawalCalculationRowDraft(
              label: 'Phần thưởng còn lại',
              value: '+${result.remaining.toStringAsFixed(2)}',
              tone: StakingDisclosureRiskLevel.low,
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: AppSpacing.x2)),
          _CalculationRow(
            row: StakingWithdrawalCalculationRowDraft(
              label: 'Số lượng nhận về',
              value: result.receive.toStringAsFixed(2),
              highlight: true,
            ),
          ),
          if (previewRequested) ...[
            const Padding(padding: EdgeInsets.only(top: AppSpacing.x3)),
            _SmallBadge(
              label: 'Preview mock đã sẵn sàng - cần xác nhận trước khi rút',
              color: AppColors.primary,
            ),
          ],
        ],
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
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.text3,
            size: AppSpacing.earnWithdrawalNoticeIcon,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                height: AppSpacing.earnWithdrawalNoticeLineHeight,
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
    return Container(
      padding: const EdgeInsets.all(AppSpacing.x3),
      decoration: BoxDecoration(
        color: AppColors.warningBg,
        border: Border.all(color: AppColors.warningBorder),
        borderRadius: AppRadii.lgRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warn,
            size: AppSpacing.earnWithdrawalNoticeIcon,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                height: AppSpacing.earnWithdrawalNoticeLineHeight,
              ),
            ),
          ),
        ],
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
          padding: const EdgeInsets.only(
            top: AppSpacing.earnWithdrawalBulletTopPadding,
          ),
          child: SizedBox(
            width: AppSpacing.earnWithdrawalBulletSize,
            height: AppSpacing.earnWithdrawalBulletSize,
            child: DecoratedBox(
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: AppSpacing.earnWithdrawalBulletLineHeight,
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
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.earnWithdrawalBadgePadV,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.smRadius,
      ),
      child: Text(
        label,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
          height: AppSpacing.earnWithdrawalBadgeLineHeight,
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
