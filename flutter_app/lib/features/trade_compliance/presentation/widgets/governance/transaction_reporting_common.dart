import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/features/trade_compliance/domain/entities/trade_compliance_entities.dart';

const transactionReportBackground = AppColors.bg;
const transactionReportPanel = AppColors.surface;
const transactionReportPanel2 = AppColors.surface2;
const transactionReportBorder = AppColors.borderSolid;
const transactionReportPrimary = AppColors.primary;
const transactionReportGreen = AppColors.buy;
const transactionReportRed = AppColors.sell;
const transactionReportAmber = AppColors.caution;
const transactionReportMuted = AppColors.medalSilverBlue;

const transactionReportingContentKey = Key(
  'sc093_transaction_reporting_content',
);
const transactionReportingSearchKey = Key('sc093_transaction_reporting_search');

Key transactionReportingTabKey(String id) => Key('sc093_transaction_tab_$id');
Key transactionReportingActionKey(String id) =>
    Key('sc093_transaction_action_$id');

List<TradeTransactionReport> filterTransactionReports({
  required TradeTransactionReportingSnapshot snapshot,
  required String tab,
  required String query,
}) {
  final reports = snapshot.reportsForTab(tab);
  if (query.trim().isEmpty) return reports;
  final normalizedQuery = query.toLowerCase();
  return reports
      .where(
        (report) =>
            report.transactionId.toLowerCase().contains(normalizedQuery) ||
            report.instrument.toLowerCase().contains(normalizedQuery),
      )
      .toList();
}

({Color color, String label, IconData icon}) transactionReportStatusConfig(
  String status,
) {
  return switch (status) {
    'pending' => (
      color: transactionReportMuted,
      label: 'Pending',
      icon: Icons.schedule_rounded,
    ),
    'submitting' => (
      color: transactionReportPrimary,
      label: 'Submitting',
      icon: Icons.send_rounded,
    ),
    'submitted' => (
      color: transactionReportAmber,
      label: 'Submitted',
      icon: Icons.waves_rounded,
    ),
    'confirmed' => (
      color: transactionReportGreen,
      label: 'Confirmed',
      icon: Icons.check_circle_outline,
    ),
    'failed' => (
      color: transactionReportRed,
      label: 'Failed',
      icon: Icons.cancel_outlined,
    ),
    _ => (
      color: transactionReportAmber,
      label: 'Retrying',
      icon: Icons.refresh_rounded,
    ),
  };
}

({Color color, String label}) transactionReportSlaConfig(String status) {
  return switch (status) {
    'warning' => (color: transactionReportAmber, label: 'Warning'),
    'breach' => (color: transactionReportRed, label: 'SLA Breach'),
    _ => (color: transactionReportGreen, label: 'On-time'),
  };
}

String formatTransactionReportUsd(double value) {
  final raw = value.toStringAsFixed(0);
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final remaining = raw.length - i;
    buffer.write(raw[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
  }
  return '\$${buffer.toString()}';
}

String formatTransactionReportAmount(double value) {
  if (value == value.roundToDouble()) return value.toStringAsFixed(0);
  return value.toStringAsFixed(value < 1 ? 2 : 1);
}
