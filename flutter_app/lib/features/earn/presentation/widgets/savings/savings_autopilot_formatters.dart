import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/providers/earn_controller_providers.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

TextStyle get captionBoldStyle =>
    AppTextStyles.caption.copyWith(fontWeight: AppTextStyles.bold);
TextStyle get microBoldStyle =>
    AppTextStyles.micro.copyWith(fontWeight: AppTextStyles.bold);

VitStatusPillStatus? accentSemanticStatus(Color color) {
  if (color == AppColors.buy) return VitStatusPillStatus.success;
  if (color == AppColors.warn) return VitStatusPillStatus.warning;
  if (color == AppColors.sell) return VitStatusPillStatus.error;
  if (color == AppColors.primary) return VitStatusPillStatus.info;
  if (color == AppColors.accent) return VitStatusPillStatus.purple;
  return null;
}

SavingsAutoPilotModeDraft modeById(
  SavingsAutoPilotSnapshot snapshot,
  SavingsAutoPilotMode id,
) {
  return snapshot.modes.firstWhere((mode) => mode.id == id);
}

String formatAutoPilotMoney(int value) {
  final raw = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i += 1) {
    final left = raw.length - i;
    buffer.write(raw[i]);
    if (left > 1 && left % 3 == 1) buffer.write(',');
  }
  return '\$${buffer.toString()}.00';
}

IconData iconForKey(String key) {
  return switch (key) {
    'shield' => Icons.shield_outlined,
    'target' => Icons.track_changes_rounded,
    'bolt' => Icons.bolt_rounded,
    'repeat' => Icons.repeat_rounded,
    'rebalance' => Icons.sync_rounded,
    'spark' => Icons.auto_awesome_rounded,
    'trend' => Icons.trending_up_rounded,
    _ => Icons.tune_rounded,
  };
}

Color toneColor(EarnRiskLevel tone) {
  return switch (tone) {
    EarnRiskLevel.low => AppColors.buy,
    EarnRiskLevel.medium => AppColors.primary,
    EarnRiskLevel.high => AppColors.accent,
  };
}

Color autoPilotStatusColor(SavingsAutoPilotStatus status) {
  return switch (status) {
    SavingsAutoPilotStatus.active => AppColors.buy,
    SavingsAutoPilotStatus.paused => AppColors.warn,
    SavingsAutoPilotStatus.inactive => AppColors.text3,
  };
}

VitStatusPillStatus autoPilotStatusPillStatus(SavingsAutoPilotStatus status) {
  return switch (status) {
    SavingsAutoPilotStatus.active => VitStatusPillStatus.success,
    SavingsAutoPilotStatus.paused => VitStatusPillStatus.warning,
    SavingsAutoPilotStatus.inactive => VitStatusPillStatus.neutral,
  };
}

IconData autoPilotStatusIcon(SavingsAutoPilotStatus status) {
  return switch (status) {
    SavingsAutoPilotStatus.active => Icons.play_arrow_rounded,
    SavingsAutoPilotStatus.paused => Icons.pause_rounded,
    SavingsAutoPilotStatus.inactive => Icons.power_settings_new_rounded,
  };
}

String autoPilotStatusLabel(SavingsAutoPilotStatus status) {
  return switch (status) {
    SavingsAutoPilotStatus.active => 'Đang chạy',
    SavingsAutoPilotStatus.paused => 'Tạm dừng',
    SavingsAutoPilotStatus.inactive => 'Kích hoạt',
  };
}

IconData actionTypeIcon(SavingsAutoPilotActionType type) {
  return switch (type) {
    SavingsAutoPilotActionType.dcaExecuted => Icons.repeat_rounded,
    SavingsAutoPilotActionType.rebalanced => Icons.sync_rounded,
    SavingsAutoPilotActionType.switchProduct => Icons.swap_horiz_rounded,
    SavingsAutoPilotActionType.compoundActivated => Icons.bolt_rounded,
    SavingsAutoPilotActionType.apyOptimized => Icons.trending_up_rounded,
    SavingsAutoPilotActionType.riskAdjusted => Icons.shield_outlined,
  };
}

Color actionTypeColor(SavingsAutoPilotActionType type) {
  return switch (type) {
    SavingsAutoPilotActionType.dcaExecuted => AppColors.buy,
    SavingsAutoPilotActionType.rebalanced => AppColors.primary,
    SavingsAutoPilotActionType.switchProduct => AppColors.accent,
    SavingsAutoPilotActionType.compoundActivated => AppColors.buy,
    SavingsAutoPilotActionType.apyOptimized => AppColors.warn,
    SavingsAutoPilotActionType.riskAdjusted => AppColors.sell,
  };
}

String actionTypeLabel(SavingsAutoPilotActionType type) {
  return switch (type) {
    SavingsAutoPilotActionType.dcaExecuted => 'DCA',
    SavingsAutoPilotActionType.rebalanced => 'Rebalance',
    SavingsAutoPilotActionType.switchProduct => 'Chuyển SP',
    SavingsAutoPilotActionType.compoundActivated => 'Lãi kép',
    SavingsAutoPilotActionType.apyOptimized => 'Tối ưu APY',
    SavingsAutoPilotActionType.riskAdjusted => 'Rủi ro',
  };
}

Color actionStatusColor(SavingsAutoPilotActionStatus status) {
  return switch (status) {
    SavingsAutoPilotActionStatus.executed => AppColors.buy,
    SavingsAutoPilotActionStatus.pending => AppColors.warn,
    SavingsAutoPilotActionStatus.skipped => AppColors.text3,
    SavingsAutoPilotActionStatus.needsApproval => AppColors.primary,
  };
}

String actionStatusLabel(SavingsAutoPilotActionStatus status) {
  return switch (status) {
    SavingsAutoPilotActionStatus.executed => 'Đã thực hiện',
    SavingsAutoPilotActionStatus.pending => 'Đang xử lý',
    SavingsAutoPilotActionStatus.skipped => 'Bỏ qua',
    SavingsAutoPilotActionStatus.needsApproval => 'Cần duyệt',
  };
}
