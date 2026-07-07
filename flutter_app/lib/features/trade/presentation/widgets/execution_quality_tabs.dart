import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/execution_quality_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

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
    return VitTabBar(
      variant: VitTabBarVariant.segment,
      activeKey: active.name,
      onChanged: (key) => onChanged(ExecutionQualityTab.values.byName(key)),
      tabs: [
        VitTabItem(
          key: ExecutionQualityTab.slippage.name,
          label: 'Slippage',
          widgetKey: executionQualityTabKey(ExecutionQualityTab.slippage.name),
        ),
        VitTabItem(
          key: ExecutionQualityTab.execution.name,
          label: 'Execution',
          widgetKey: executionQualityTabKey(ExecutionQualityTab.execution.name),
        ),
        VitTabItem(
          key: ExecutionQualityTab.amendment.name,
          label: 'Amendment',
          widgetKey: executionQualityTabKey(ExecutionQualityTab.amendment.name),
        ),
      ],
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
          'Current settings: ${settings.tolerancePct.toStringAsFixed(1)}% tolerance · $reject',
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
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.tradeToolCardGap),
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
