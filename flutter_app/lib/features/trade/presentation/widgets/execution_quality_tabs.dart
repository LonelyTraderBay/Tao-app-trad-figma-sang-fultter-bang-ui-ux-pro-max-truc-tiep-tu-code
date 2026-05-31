import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/execution_quality_common.dart';

class ExecutionQualityTabs extends StatelessWidget {
  const ExecutionQualityTabs({
    required this.active,
    required this.onChanged,
    super.key,
  });

  final ExecutionQualityTab active;
  final ValueChanged<ExecutionQualityTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      (ExecutionQualityTab.slippage, 'Slippage'),
      (ExecutionQualityTab.execution, 'Execution'),
      (ExecutionQualityTab.amendment, 'Amendment'),
    ];
    return Container(
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: executionQualityChipBackground,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        children: [
          for (var i = 0; i < tabs.length; i++) ...[
            Expanded(
              child: _TabButton(
                key: executionQualityTabKey(tabs[i].$1.name),
                label: tabs[i].$2,
                active: active == tabs[i].$1,
                onTap: () => onChanged(tabs[i].$1),
              ),
            ),
            if (i < tabs.length - 1) const SizedBox(width: 4),
          ],
        ],
      ),
    );
  }
}

class ExecutionQualitySlippageTab extends StatelessWidget {
  const ExecutionQualitySlippageTab({
    required this.settings,
    required this.onOpen,
    super.key,
  });

  final TradeSlippageSettings settings;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final reject = settings.rejectOnExceed
        ? 'Auto-reject enabled'
        : 'Warn only';
    return _ActionTab(
      description:
          'Current settings: ${settings.tolerancePct.toStringAsFixed(1)}% tolerance Â· $reject',
      buttonKey: executionQualitySlippageButtonKey,
      label: 'Configure Slippage Protection',
      icon: Icons.shield_rounded,
      colors: const [AppColors.buy, AppColors.buyDark],
      onOpen: onOpen,
    );
  }
}

class ExecutionQualityExecutionTab extends StatelessWidget {
  const ExecutionQualityExecutionTab({required this.onOpen, super.key});

  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return _ActionTab(
      description: 'View detailed execution breakdown after order fills',
      buttonKey: executionQualityExecutionButtonKey,
      label: 'View Sample Execution Report',
      icon: Icons.bar_chart_rounded,
      colors: const [AppColors.caution, AppColors.medalBronzeMuted],
      onOpen: onOpen,
    );
  }
}

class ExecutionQualityAmendmentTab extends StatelessWidget {
  const ExecutionQualityAmendmentTab({required this.onOpen, super.key});

  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return _ActionTab(
      description: 'Modify open order price or quantity',
      buttonKey: executionQualityAmendmentButtonKey,
      label: 'Modify Open Order',
      icon: Icons.edit_rounded,
      colors: const [AppColors.accent, AppColors.accentDark],
      onOpen: onOpen,
    );
  }
}

class _ActionTab extends StatelessWidget {
  const _ActionTab({
    required this.description,
    required this.buttonKey,
    required this.label,
    required this.icon,
    required this.colors,
    required this.onOpen,
  });

  final String description;
  final Key buttonKey;
  final String label;
  final IconData icon;
  final List<Color> colors;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          description,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text3,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 12),
        ExecutionQualityGradientButton(
          key: buttonKey,
          label: label,
          icon: icon,
          colors: colors,
          onTap: onOpen,
        ),
      ],
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.active,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.smRadius,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? executionQualityPrimary : AppColors.transparent,
          borderRadius: AppRadii.smRadius,
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: active ? AppColors.onAccent : AppColors.text2,
            fontSize: 11,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}
