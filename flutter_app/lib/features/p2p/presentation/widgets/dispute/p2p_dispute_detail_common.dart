part of 'p2p_dispute_widgets.dart';

class P2PDisputeSmallPill extends StatelessWidget {
  const P2PDisputeSmallPill({
    super.key,
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitAccentPill(label: label, accentColor: color);
  }
}

class P2PDisputeSmallButton extends StatelessWidget {
  const P2PDisputeSmallButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      label: label,
      selected: true,
      onTap: onPressed,
      padding: P2PSpacingTokens.p2pDisputeEvidenceButtonPadding,
      accentColor: color,
      leading: Icon(icon),
      semanticLabel: 'Thao tác khiếu nại P2P $label',
    );
  }
}

Color p2pDisputeStatusColor(P2PDisputeStatus status) {
  return switch (status) {
    P2PDisputeStatus.submitted => AppColors.warn,
    P2PDisputeStatus.underReview => AppModuleAccents.p2p,
    P2PDisputeStatus.resolved => AppColors.buy,
    P2PDisputeStatus.rejected => AppColors.sell,
  };
}

IconData p2pDisputeStatusIcon(P2PDisputeStatus status) {
  return switch (status) {
    P2PDisputeStatus.submitted => Icons.schedule_rounded,
    P2PDisputeStatus.underReview => Icons.description_outlined,
    P2PDisputeStatus.resolved => Icons.check_circle_outline_rounded,
    P2PDisputeStatus.rejected => Icons.warning_amber_rounded,
  };
}

Color p2pDisputeLevelColor(int level) {
  return switch (level) {
    1 => AppModuleAccents.p2p,
    2 => AppColors.accent,
    3 => AppColors.warn,
    _ => AppColors.sell,
  };
}

IconData p2pDisputeLevelIcon(String iconKey) {
  return switch (iconKey) {
    'bot' => Icons.smart_toy_outlined,
    'support' => Icons.support_agent_rounded,
    'scale' => Icons.balance_rounded,
    'briefcase' => Icons.business_center_outlined,
    _ => Icons.shield_outlined,
  };
}
