part of '../pages/staking_institutional_page.dart';

class _SheetFrame extends StatelessWidget {
  const _SheetFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.all(AppSpacing.contentPad),
        padding: const EdgeInsets.all(AppSpacing.x5),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.88,
        ),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadii.cardLargeRadius,
        ),
        child: child,
      ),
    );
  }
}

class _CreateBatchSheet extends StatelessWidget {
  const _CreateBatchSheet({required this.snapshot});

  final StakingInstitutionalSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: StakingInstitutionalPage.createSheetKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Create Batch Operation',
                  style: AppTextStyles.sectionTitle,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close_rounded, color: AppColors.text2),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          _FieldGroup(
            label: 'Operation Type',
            child: _StaticField(
              value: snapshot.operationTypes.first,
              trailing: Icons.expand_more_rounded,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          _FieldGroup(
            label: 'Upload CSV File',
            child: CustomPaint(
              painter: _DashedBorderPainter(),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.x4),
                child: Column(
                  children: [
                    const Icon(
                      Icons.description_outlined,
                      color: AppColors.text3,
                      size: AppSpacing.iconLg,
                    ),
                    const SizedBox(height: AppSpacing.x2),
                    Text(
                      'Drop CSV or click to upload',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      snapshot.csvFormatNote,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x5),
          VitCtaButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Submit for Approval'),
          ),
        ],
      ),
    );
  }
}

class _FieldGroup extends StatelessWidget {
  const _FieldGroup({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.x3),
        child,
      ],
    );
  }
}

class _StaticField extends StatelessWidget {
  const _StaticField({required this.value, required this.trailing});

  final String value;
  final IconData trailing;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.md,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.x4,
      ),
      child: Row(
        children: [
          Expanded(child: Text(value, style: AppTextStyles.body)),
          Icon(trailing, color: AppColors.text2, size: AppSpacing.iconSm),
        ],
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const dashWidth = 6.0;
    const dashSpace = 5.0;
    final paint = Paint()
      ..color = AppColors.borderSolid
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final rect = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(AppRadii.lg),
    );
    final path = Path()..addRRect(rect);
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

String _tabLabel(_InstitutionalBatchTab tab) {
  return switch (tab) {
    _InstitutionalBatchTab.pending => 'Pending',
    _InstitutionalBatchTab.executed => 'Executed',
  };
}

String _batchTypeLabel(StakingInstitutionalBatchType type) {
  return switch (type) {
    StakingInstitutionalBatchType.stake => 'Stake',
    StakingInstitutionalBatchType.unstake => 'Unstake',
    StakingInstitutionalBatchType.claim => 'Claim',
  };
}

String _statusLabel(StakingInstitutionalBatchStatus status) {
  return switch (status) {
    StakingInstitutionalBatchStatus.pending => 'Pending',
    StakingInstitutionalBatchStatus.approved => 'Approved',
    StakingInstitutionalBatchStatus.executed => 'Executed',
  };
}

String _formatAmount(double value) {
  if (value == value.roundToDouble()) return value.toStringAsFixed(0);
  return value.toStringAsFixed(1);
}

Color _toneColor(String tone) {
  return switch (tone) {
    'primary' => AppColors.primarySoft,
    'success' => AppColors.buy,
    _ => AppColors.text3,
  };
}

Color _toneFillColor(String tone) {
  return switch (tone) {
    'primary' => AppColors.primary15,
    'success' => AppColors.buy15,
    _ => AppColors.surface2,
  };
}

IconData _infoIcon(String icon) {
  return switch (icon) {
    'building' => Icons.apartment_rounded,
    'users' => Icons.group_rounded,
    'shield' => Icons.shield_outlined,
    'file' => Icons.description_outlined,
    _ => Icons.verified_user_rounded,
  };
}
