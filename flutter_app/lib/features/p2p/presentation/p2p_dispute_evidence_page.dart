import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_module_accents.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/p2p_repository.dart';

class P2PDisputeEvidencePage extends ConsumerStatefulWidget {
  const P2PDisputeEvidencePage({
    super.key,
    required this.disputeId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc219_p2p_dispute_evidence_content');
  static const submitKey = Key('sc219_p2p_dispute_evidence_submit');

  static Key uploadKey(String id) => Key('sc219_p2p_dispute_evidence_$id');

  final String disputeId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PDisputeEvidencePage> createState() =>
      _P2PDisputeEvidencePageState();
}

class _P2PDisputeEvidencePageState
    extends ConsumerState<P2PDisputeEvidencePage> {
  final Set<String> _uploaded = {};

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(p2pRepositoryProvider)
        .getDisputeEvidence(widget.disputeId);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;
    final documents = snapshot.documents
        .map(
          (item) => _EvidenceDocumentView(
            source: item,
            uploaded: item.uploaded || _uploaded.contains(item.id),
          ),
        )
        .toList(growable: false);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-219 P2PDisputeEvidencePage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Bằng chứng tranh chấp',
              subtitle: 'Tranh chấp · P2P',
              showBack: true,
              onBack: () =>
                  context.go(AppRoutePaths.p2pDisputeDetail(widget.disputeId)),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: P2PDisputeEvidencePage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.contentPad,
                    AppSpacing.x4,
                    AppSpacing.contentPad,
                    bottomInset,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _HeroCard(
                        title: snapshot.title,
                        subtitle: snapshot.subtitle,
                      ),
                      const SizedBox(height: AppSpacing.x4),
                      for (final document in documents) ...[
                        _EvidenceRow(
                          document: document,
                          onUpload: () => _markUploaded(document.source.id),
                        ),
                        const SizedBox(height: AppSpacing.x3),
                      ],
                      const SizedBox(height: AppSpacing.x2),
                      VitCtaButton(
                        key: P2PDisputeEvidencePage.submitKey,
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          context.go(
                            AppRoutePaths.p2pDisputeDetail(widget.disputeId),
                          );
                        },
                        child: const Text('Gửi bằng chứng'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _markUploaded(String id) {
    HapticFeedback.mediumImpact();
    setState(() => _uploaded.add(id));
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppModuleAccents.p2p.withValues(alpha: .24),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.sectionTitle.copyWith(
              color: AppModuleAccents.p2p,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            subtitle,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
        ],
      ),
    );
  }
}

class _EvidenceDocumentView {
  const _EvidenceDocumentView({required this.source, required this.uploaded});

  final P2PDisputeEvidenceDocumentDraft source;
  final bool uploaded;
}

class _EvidenceRow extends StatelessWidget {
  const _EvidenceRow({required this.document, required this.onUpload});

  final _EvidenceDocumentView document;
  final VoidCallback onUpload;

  @override
  Widget build(BuildContext context) {
    final color = document.uploaded ? AppColors.buy : AppModuleAccents.p2p;
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          Container(
            width: AppSpacing.x6,
            height: AppSpacing.x6,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              document.uploaded
                  ? Icons.check_circle_outline_rounded
                  : _documentIcon(document.source.iconKey),
              color: color,
              size: AppSpacing.iconSm,
            ),
          ),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document.source.label,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                if (document.uploaded) ...[
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    'Uploaded',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.buy,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (!document.uploaded)
            _UploadButton(
              key: P2PDisputeEvidencePage.uploadKey(document.source.id),
              onPressed: onUpload,
            ),
        ],
      ),
    );
  }
}

class _UploadButton extends StatelessWidget {
  const _UploadButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppModuleAccents.p2p.withValues(alpha: .10),
      borderRadius: AppRadii.inputRadius,
      child: InkWell(
        onTap: onPressed,
        borderRadius: AppRadii.inputRadius,
        child: SizedBox(
          height: AppSpacing.buttonCompact,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x3),
            child: Center(
              child: Text(
                'Upload',
                style: AppTextStyles.caption.copyWith(
                  color: AppModuleAccents.p2p,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

IconData _documentIcon(String iconKey) {
  return switch (iconKey) {
    'image' => Icons.image_outlined,
    _ => Icons.description_outlined,
  };
}
