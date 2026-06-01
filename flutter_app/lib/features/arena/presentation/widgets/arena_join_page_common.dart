part of '../pages/arena_join_page.dart';

class _AcknowledgementStack extends StatelessWidget {
  const _AcknowledgementStack({
    required this.readRules,
    required this.understandPoints,
    required this.onRules,
    required this.onPoints,
  });

  final bool readRules;
  final bool understandPoints;
  final VoidCallback onRules;
  final VoidCallback onPoints;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _AcknowledgementRow(
          key: ArenaJoinPage.rulesCheckboxKey,
          checked: readRules,
          label: 'Tôi đã đọc luật chơi và hiểu các điều kiện của challenge này',
          onTap: onRules,
        ),
        const SizedBox(height: AppSpacing.x3),
        _AcknowledgementRow(
          key: ArenaJoinPage.pointsCheckboxKey,
          checked: understandPoints,
          label:
              'Tôi hiểu đây là Arena Points — không phải tài sản tài chính và không thể rút ra ngoài',
          onTap: onPoints,
        ),
      ],
    );
  }
}

class _AcknowledgementRow extends StatelessWidget {
  const _AcknowledgementRow({
    super.key,
    required this.checked,
    required this.label,
    required this.onTap,
  });

  final bool checked;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.mdRadius,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 44),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: checked ? AppColors.primary : AppColors.transparent,
                  borderRadius: AppRadii.smRadius,
                  border: Border.all(
                    color: checked ? AppColors.primary : AppColors.borderSolid,
                    width: 1.5,
                  ),
                ),
                child: checked
                    ? const Icon(
                        Icons.check_rounded,
                        size: 18,
                        color: AppColors.onAccent,
                      )
                    : null,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.55,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionStack extends StatelessWidget {
  const _ActionStack({
    required this.entryPoints,
    required this.canJoin,
    required this.onConfirm,
    required this.onDecline,
  });

  final int entryPoints;
  final bool canJoin;
  final VoidCallback onConfirm;
  final VoidCallback onDecline;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VitCtaButton(
          key: ArenaJoinPage.confirmKey,
          onPressed: canJoin ? onConfirm : null,
          child: Text('Xác nhận tham gia · ${_formatPoints(entryPoints)} pts'),
        ),
        const SizedBox(height: AppSpacing.x3),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            key: ArenaJoinPage.declineKey,
            onPressed: onDecline,
            child: Text(
              'Từ chối',
              style: AppTextStyles.body.copyWith(
                color: AppColors.text2,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

String _formatPoints(int value) {
  if (value.abs() >= 1000) {
    final compact = value / 1000;
    return '${compact.toStringAsFixed(1)}K';
  }
  return value.toString();
}
