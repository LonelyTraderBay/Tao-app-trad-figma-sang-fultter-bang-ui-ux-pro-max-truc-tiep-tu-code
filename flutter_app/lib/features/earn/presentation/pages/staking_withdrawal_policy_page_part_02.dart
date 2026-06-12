part of 'staking_withdrawal_policy_page.dart';

class _PenaltyExampleCard extends StatelessWidget {
  const _PenaltyExampleCard({required this.example});

  final StakingWithdrawalPenaltyExampleDraft example;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            example.title,
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: AppSpacing.x3)),
          Container(
            padding: const EdgeInsets.all(AppSpacing.x3),
            decoration: BoxDecoration(
              color: AppColors.surface2,
              borderRadius: AppRadii.lgRadius,
            ),
            child: Column(
              children: [
                for (final row in example.rows) ...[
                  if (row.label.startsWith('Phí'))
                    const Divider(color: AppColors.divider),
                  _CalculationRow(row: row),
                  if (row != example.rows.last)
                    const Padding(padding: EdgeInsets.only(top: AppSpacing.x2)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CalculationRow extends StatelessWidget {
  const _CalculationRow({required this.row});

  final StakingWithdrawalCalculationRowDraft row;

  @override
  Widget build(BuildContext context) {
    final color = row.tone == null ? AppColors.text1 : _toneColor(row.tone!);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            row.label,
            style: AppTextStyles.caption.copyWith(
              color: row.highlight ? AppColors.text1 : AppColors.text3,
              fontWeight: row.highlight
                  ? AppTextStyles.bold
                  : AppTextStyles.normal,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Text(
          row.value,
          textAlign: TextAlign.end,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontWeight: row.highlight
                ? AppTextStyles.bold
                : AppTextStyles.medium,
          ),
        ),
      ],
    );
  }
}

class _EmergencyTab extends StatelessWidget {
  const _EmergencyTab({required this.snapshot});

  final StakingWithdrawalPolicySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: StakingWithdrawalPolicyPage.emergencyKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          label: snapshot.emergencyTitle,
          children: [
            VitCard(
              radius: VitCardRadius.lg,
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: AppSpacing.earnWithdrawalEmergencyIconBox,
                        height: AppSpacing.earnWithdrawalEmergencyIconBox,
                        decoration: BoxDecoration(
                          color: AppColors.sell10,
                          border: Border.all(
                            color: AppColors.sell20,
                            width: AppSpacing.earnWithdrawalBorderWidth,
                          ),
                          borderRadius: AppRadii.cardRadius,
                        ),
                        child: const Icon(
                          Icons.emergency_rounded,
                          color: AppColors.sell,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x3),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Khi nào cần rút khẩn cấp?',
                              style: AppTextStyles.baseMedium.copyWith(
                                color: AppColors.text1,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: AppSpacing.x2),
                            ),
                            Text(
                              snapshot.emergencyBody,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text2,
                                height: AppSpacing.earnWithdrawalInfoLineHeight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.only(top: AppSpacing.x4)),
                  for (final reason in snapshot.emergencyReasons) ...[
                    _BulletLine(text: reason, color: AppColors.sell),
                    if (reason != snapshot.emergencyReasons.last)
                      const Padding(
                        padding: EdgeInsets.only(top: AppSpacing.x2),
                      ),
                  ],
                ],
              ),
            ),
          ],
        ),
        const Padding(padding: EdgeInsets.only(top: AppSpacing.x5)),
        VitPageSection(
          label: 'Quy trình Rút khẩn cấp',
          children: [
            VitCard(
              radius: VitCardRadius.lg,
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Column(
                children: [
                  for (final step in snapshot.emergencySteps) ...[
                    _EmergencyStepRow(step: step),
                    if (step != snapshot.emergencySteps.last)
                      const Padding(
                        padding: EdgeInsets.only(top: AppSpacing.x4),
                      ),
                  ],
                ],
              ),
            ),
          ],
        ),
        const Padding(padding: EdgeInsets.only(top: AppSpacing.x5)),
        VitPageSection(
          label: 'Phí Rút khẩn cấp',
          children: [
            VitCard(
              radius: VitCardRadius.lg,
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Phí rút khẩn cấp cao hơn phí rút sớm thông thường vì cần xử lý ưu tiên và bỏ qua unbonding period.',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height: AppSpacing.earnWithdrawalInfoLineHeight,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: AppSpacing.x3)),
                  Wrap(
                    spacing: AppSpacing.x3,
                    runSpacing: AppSpacing.x3,
                    children: [
                      for (final fee in snapshot.emergencyFees)
                        _EmergencyFeeTile(fee: fee),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const Padding(padding: EdgeInsets.only(top: AppSpacing.x4)),
        _WarningBox(text: snapshot.emergencyWarning),
        const Padding(padding: EdgeInsets.only(top: AppSpacing.x4)),
        _SupportCard(contacts: snapshot.supportContacts),
      ],
    );
  }
}

class _EmergencyStepRow extends StatelessWidget {
  const _EmergencyStepRow({required this.step});

  final StakingEmergencyStepDraft step;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: AppSpacing.earnWithdrawalEmergencyStepBox,
          height: AppSpacing.earnWithdrawalEmergencyStepBox,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primary12,
            border: Border.all(
              color: AppColors.primary20,
              width: AppSpacing.earnWithdrawalBorderWidth,
            ),
            shape: BoxShape.circle,
          ),
          child: Text(
            '${step.step}',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primary,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                step.text,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.medium,
                  height: AppSpacing.earnWithdrawalEmergencyStepLineHeight,
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: AppSpacing.x1)),
              Row(
                children: [
                  const Icon(
                    Icons.timer_outlined,
                    color: AppColors.text3,
                    size: AppSpacing.earnWithdrawalTimerIcon,
                  ),
                  const SizedBox(width: AppSpacing.x1),
                  Text(
                    step.time,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EmergencyFeeTile extends StatelessWidget {
  const _EmergencyFeeTile({required this.fee});

  final StakingEmergencyFeeDraft fee;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSpacing.earnWithdrawalFeeTileWidth,
      child: Container(
        constraints: const BoxConstraints(
          minHeight: AppSpacing.earnWithdrawalFeeTileMinHeight,
        ),
        padding: const EdgeInsets.all(AppSpacing.x3),
        decoration: BoxDecoration(
          color: AppColors.surface2,
          borderRadius: AppRadii.lgRadius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              fee.product,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
            const Padding(padding: EdgeInsets.only(top: AppSpacing.x2)),
            Text(
              fee.fee,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.sell,
                fontWeight: AppTextStyles.bold,
                height: AppSpacing.earnWithdrawalFeeLineHeight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SupportCard extends StatelessWidget {
  const _SupportCard({required this.contacts});

  final List<StakingSupportContactDraft> contacts;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Liên hệ Support:',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: AppSpacing.x3)),
          for (final contact in contacts) ...[
            _SupportRow(contact: contact),
            if (contact != contacts.last)
              const Padding(padding: EdgeInsets.only(top: AppSpacing.x2)),
          ],
        ],
      ),
    );
  }
}

class _SupportRow extends StatelessWidget {
  const _SupportRow({required this.contact});

  final StakingSupportContactDraft contact;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            '${contact.label}:',
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Text(
            contact.value,
            textAlign: TextAlign.end,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primary,
              fontWeight: AppTextStyles.medium,
            ),
          ),
        ),
      ],
    );
  }
}

class _PenaltyCalculatorSheet extends StatefulWidget {
  const _PenaltyCalculatorSheet({required this.snapshot});

  final StakingWithdrawalPolicySnapshot snapshot;

  @override
  State<_PenaltyCalculatorSheet> createState() =>
      _PenaltyCalculatorSheetState();
}
