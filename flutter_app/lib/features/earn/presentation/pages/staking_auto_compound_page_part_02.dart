part of 'staking_auto_compound_page.dart';

class _FrequencyTile extends StatelessWidget {
  const _FrequencyTile({
    required this.frequency,
    required this.selected,
    required this.onTap,
  });

  final StakingAutoCompoundFrequencyDraft frequency;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      borderRadius: AppRadii.inputRadius,
      child: InkWell(
        key: StakingAutoCompoundPage.frequencyKey(frequency.id),
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.all(AppSpacing.x4),
          decoration: BoxDecoration(
            color: selected ? AppColors.buy10 : AppColors.surface2,
            borderRadius: AppRadii.inputRadius,
            border: Border.all(
              color: selected ? AppColors.buy : AppColors.borderSolid,
              width: AppSpacing.stakingAutoCompoundPlanBorderWidth,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  frequency.label,
                  style: AppTextStyles.caption.copyWith(
                    color: selected ? AppColors.buy : AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: AppSpacing.x1)),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  frequency.description,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GasOptimizationTile extends StatelessWidget {
  const _GasOptimizationTile({required this.enabled, required this.onTap});

  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      borderRadius: AppRadii.inputRadius,
      child: InkWell(
        key: StakingAutoCompoundPage.gasOptimizationKey,
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: VitCard(
          variant: VitCardVariant.inner,
          radius: VitCardRadius.md,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Row(
            children: [
              _CheckBoxIndicator(checked: enabled),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tối ưu Gas Fee', style: AppTextStyles.baseMedium),
                    Text(
                      'Chỉ compound khi gas fee thấp (tiết kiệm ~30-50%)',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
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

class _PositionCard extends StatelessWidget {
  const _PositionCard({
    required this.position,
    required this.frequency,
    required this.onToggle,
  });

  final StakingAutoCompoundPositionDraft position;
  final String frequency;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingAutoCompoundPage.positionKey(position.id),
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(position.product, style: AppTextStyles.baseMedium),
                    const Padding(padding: EdgeInsets.only(top: AppSpacing.x1)),
                    Text(
                      '${_formatAmount(position.amount)} ${position.asset}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              _ToggleSwitch(
                key: StakingAutoCompoundPage.toggleKey(position.id),
                enabled: position.autoCompound,
                onTap: onToggle,
              ),
            ],
          ),
          if (position.autoCompound) ...[
            const Padding(padding: EdgeInsets.only(top: AppSpacing.x3)),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.x3,
                vertical: AppSpacing.x3,
              ),
              decoration: const BoxDecoration(
                color: AppColors.buy10,
                borderRadius: AppRadii.inputRadius,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.bolt_rounded,
                    color: AppColors.buy,
                    size: AppSpacing.iconSm,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: Text(
                      'Auto-compound đang bật • ${_frequencyLabel(frequency)}',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.buy,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SimulationCard extends StatelessWidget {
  const _SimulationCard({
    required this.controllerPrincipal,
    required this.controllerApy,
    required this.controllerMonths,
    required this.simulation,
    required this.onChanged,
  });

  final TextEditingController controllerPrincipal;
  final TextEditingController controllerApy;
  final TextEditingController controllerMonths;
  final _CompoundSimulation simulation;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingAutoCompoundPage.simulationKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: _MiniInput(
                  fieldKey: StakingAutoCompoundPage.principalKey,
                  label: 'Số lượng gốc',
                  controller: controllerPrincipal,
                  onChanged: onChanged,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _MiniInput(
                  fieldKey: StakingAutoCompoundPage.apyKey,
                  label: 'APY (%)',
                  controller: controllerApy,
                  onChanged: onChanged,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _MiniInput(
                  fieldKey: StakingAutoCompoundPage.monthsKey,
                  label: 'Tháng',
                  controller: controllerMonths,
                  onChanged: onChanged,
                ),
              ),
            ],
          ),
          const Padding(padding: EdgeInsets.only(top: AppSpacing.x5)),
          SizedBox(
            height: AppSpacing.stakingAutoCompoundChartHeight,
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _CompoundChartPainter(points: simulation.points),
                  ),
                ),
                const Positioned(
                  left: AppSpacing.x6,
                  right: AppSpacing.x4,
                  bottom: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _AxisLabel('0'),
                      _AxisLabel('1'),
                      _AxisLabel('2'),
                      _AxisLabel('3'),
                      _AxisLabel('4'),
                      _AxisLabel('5'),
                      _AxisLabel('6'),
                      _AxisLabel('7'),
                      _AxisLabel('8'),
                      _AxisLabel('9'),
                      _AxisLabel('10'),
                      _AxisLabel('11'),
                      _AxisLabel('12'),
                    ],
                  ),
                ),
                Positioned(
                  left: AppSpacing.x6,
                  right: AppSpacing.x4,
                  bottom: AppSpacing.x5,
                  child: Center(
                    child: Text(
                      'Tháng',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: AppSpacing.x4)),
          Row(
            children: [
              Expanded(
                child: _ResultCard(
                  label: 'Có compound',
                  value: _formatCurrency(simulation.withCompound),
                  color: AppColors.buy,
                  tone: AppColors.buy10,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _ResultCard(
                  label: 'Không compound',
                  value: _formatCurrency(simulation.withoutCompound),
                  color: AppColors.sell,
                  tone: AppColors.sell10,
                ),
              ),
            ],
          ),
          const Padding(padding: EdgeInsets.only(top: AppSpacing.x4)),
          VitCard(
            variant: VitCardVariant.inner,
            radius: VitCardRadius.md,
            padding: const EdgeInsets.all(AppSpacing.x4),
            child: Column(
              children: [
                Text(
                  'Lợi thế compound',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const Padding(padding: EdgeInsets.only(top: AppSpacing.x2)),
                Text(
                  '+${_formatCurrency(simulation.difference)}',
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: AppColors.buy,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: AppSpacing.x1)),
                Text(
                  '(+${simulation.percentageGain.toStringAsFixed(2)}% cao hơn)',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniInput extends StatelessWidget {
  const _MiniInput({
    required this.fieldKey,
    required this.label,
    required this.controller,
    required this.onChanged,
  });

  final Key fieldKey;
  final String label;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontWeight: AppTextStyles.medium,
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: AppSpacing.x2)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x3),
          decoration: BoxDecoration(
            color: AppColors.surface2,
            borderRadius: AppRadii.inputRadius,
            border: Border.all(color: AppColors.borderSolid),
          ),
          child: TextField(
            key: fieldKey,
            controller: controller,
            textAlign: TextAlign.center,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            cursorColor: AppColors.primary,
            onChanged: onChanged,
            style: AppTextStyles.caption.copyWith(
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: AppSpacing.x3),
            ),
          ),
        ),
      ],
    );
  }
}

class _AxisLabel extends StatelessWidget {
  const _AxisLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyles.micro.copyWith(
        color: AppColors.text3,
        fontSize: AppSpacing.stakingAutoCompoundAxisFontSize,
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({
    required this.label,
    required this.value,
    required this.color,
    required this.tone,
  });

  final String label;
  final String value;
  final Color color;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.x4),
      decoration: BoxDecoration(color: tone, borderRadius: AppRadii.cardRadius),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: AppSpacing.x4,
                height: AppSpacing.stakingAutoCompoundResultMarkerHeight,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: AppRadii.xsRadius,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
            ],
          ),
          const Padding(padding: EdgeInsets.only(top: AppSpacing.x2)),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: AppTextStyles.baseMedium.copyWith(
                color: color,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterNote extends StatelessWidget {
  const _FooterNote({required this.snapshot});

  final StakingAutoCompoundSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingAutoCompoundPage.footerKey,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Text(
        snapshot.footerNote,
        textAlign: TextAlign.center,
        style: AppTextStyles.micro.copyWith(color: AppColors.text3),
      ),
    );
  }
}
