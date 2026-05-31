part of '../pages/copy_safety_center_page.dart';

class _EnforcementTab extends StatelessWidget {
  const _EnforcementTab({required this.actions});

  final List<TradeCopyEnforcementAction> actions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Recent enforcement actions taken to protect users:',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 14),
        for (final action in actions) ...[
          _EnforcementCard(action: action),
          if (action != actions.last) const SizedBox(height: 10),
        ],
        const SizedBox(height: 14),
        _SimpleCard(
          title: 'Transparent enforcement',
          body:
              'All actions are logged. If you believe an action was unfair, contact support.',
          color: _safetyPrimary,
        ),
      ],
    );
  }
}

class _EnforcementCard extends StatelessWidget {
  const _EnforcementCard({required this.action});

  final TradeCopyEnforcementAction action;

  @override
  Widget build(BuildContext context) {
    final color = switch (action.action) {
      'suspended' => AppColors.sell,
      'warned' => AppColors.warn,
      _ => AppColors.buy,
    };
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _safetyCard,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.shield_outlined, color: color, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  action.action.toUpperCase(),
                  style: AppTextStyles.micro.copyWith(
                    color: color,
                    fontSize: 10,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  action.providerName,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 12,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${action.date} - ${action.reason}',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionPanel extends StatelessWidget {
  const _SectionPanel({
    required this.title,
    required this.color,
    required this.child,
  });

  final String title;
  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 12,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: 10),
        child,
      ],
    );
  }
}

class _IconTextRow extends StatelessWidget {
  const _IconTextRow({
    required this.icon,
    required this.color,
    required this.text,
  });

  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.smRadius,
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SimpleCard extends StatelessWidget {
  const _SimpleCard({required this.title, required this.body, this.color});

  final String title;
  final String body;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final accent = color ?? AppColors.text1;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.smRadius,
        border: color == null ? null : Border.all(color: color!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.micro.copyWith(
              color: accent,
              fontSize: 11,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            body,
            style: AppTextStyles.micro.copyWith(
              color: color ?? AppColors.text3,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmergencyPanel extends StatelessWidget {
  const _EmergencyPanel({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: const BoxDecoration(color: AppColors.modalScrim),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: AppColors.bg,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Emergency stop activated',
                  style: AppTextStyles.baseMedium.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  'All copies would be stopped and positions queued for close in the backend flow.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: onClose,
                  borderRadius: AppRadii.inputRadius,
                  child: Container(
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _safetyPrimary,
                      borderRadius: AppRadii.inputRadius,
                    ),
                    child: Text(
                      'Done',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.onAccent,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
