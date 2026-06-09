part of '../pages/provider_governance_page.dart';

class _MessagePanel extends StatelessWidget {
  const _MessagePanel({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: const BoxDecoration(color: AppColors.modalScrim),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: VitCard(
            radius: VitCardRadius.lg,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Broadcast Message',
                  style: AppTextStyles.baseMedium.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  'Send announcement to all followers',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 18),
                _RequestButton(onPressed: onClose),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Color _modificationColor(String type) {
  switch (type) {
    case 'fee_structure':
      return AppColors.buy;
    case 'risk_level':
      return AppColors.sell;
    default:
      return _governanceWarning;
  }
}
