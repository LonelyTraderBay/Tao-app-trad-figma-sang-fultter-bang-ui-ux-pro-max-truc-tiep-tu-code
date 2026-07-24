part of 'p2p_dispute_widgets.dart';

class P2PDisputeEvidenceCard extends StatelessWidget {
  const P2PDisputeEvidenceCard({
    super.key,
    required this.addEvidenceKey,
    required this.evidence,
    required this.onAdd,
  });

  final Key addEvidenceKey;
  final List<P2PDisputeEvidenceDraft> evidence;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: P2PSpacingTokens.p2pDisputeCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Bằng chứng (${evidence.length})',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              P2PDisputeSmallButton(
                key: addEvidenceKey,
                icon: Icons.upload_outlined,
                label: 'Thêm',
                color: AppModuleAccents.p2p,
                onPressed: onAdd,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              for (final item in evidence)
                Material(
                  color: AppColors.surface2,
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadii.inputRadius,
                    side: BorderSide(color: AppColors.borderSolid),
                  ),
                  child: SizedBox(
                    width: P2PSpacingTokens.p2pDisputeEvidenceThumb,
                    height: P2PSpacingTokens.p2pDisputeEvidenceThumb,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Icon(
                          Icons.image_outlined,
                          color: AppColors.text3,
                          size: AppSpacing.iconMd,
                        ),
                        Positioned(
                          left: AppSpacing.x1,
                          right: AppSpacing.x1,
                          bottom: AppSpacing.x1,
                          child: Text(
                            item.fileName,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
