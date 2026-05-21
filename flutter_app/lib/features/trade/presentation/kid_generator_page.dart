import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../data/trade_repository.dart';

const _kidBg = Color(0xFF080C14);
const _kidSurface = Color(0xFF151A23);
const _kidSurface2 = Color(0xFF1E2535);
const _kidBorder = Color(0xFF273142);
const _kidBlue = Color(0xFF3B82F6);
const _kidGreen = Color(0xFF10B981);

class KIDGeneratorPage extends ConsumerWidget {
  const KIDGeneratorPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc108_kid_content');
  static const previewKey = Key('sc108_kid_preview');
  static const downloadKey = Key('sc108_kid_download');
  static Key sectionKey(String title) =>
      Key('sc108_kid_section_${title.toLowerCase().replaceAll(' ', '_')}');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(tradeRepositoryProvider).getKidGenerator();
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 70
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-108 KIDGeneratorPage',
      child: Material(
        color: _kidBg,
        child: Column(
          children: [
            VitHeader(
              title: 'Key Information Document',
              subtitle: 'PRIIPs KID',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.tradeCopyExAnteCosts),
              trailing: const _DownloadAction(),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: KIDGeneratorPage.contentKey,
                padding: EdgeInsets.fromLTRB(20, 27, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _RegulatoryNotice(),
                    const SizedBox(height: 35),
                    _KidPreviewCard(document: snapshot.document),
                    const SizedBox(height: 26),
                    const _SectionLabel('Document Sections'),
                    const SizedBox(height: 9),
                    for (final section in snapshot.sections) ...[
                      _KidSectionCard(section: section),
                      if (section != snapshot.sections.last)
                        const SizedBox(height: 8),
                    ],
                    const SizedBox(height: 18),
                    const _Actions(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DownloadAction extends StatelessWidget {
  const _DownloadAction();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 36,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: _kidSurface2,
          border: Border.all(color: _kidBorder.withValues(alpha: .72)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: IconButton(
          key: KIDGeneratorPage.downloadKey,
          onPressed: () {},
          padding: EdgeInsets.zero,
          icon: const Icon(
            Icons.download_rounded,
            color: AppColors.text1,
            size: 18,
          ),
        ),
      ),
    );
  }
}

class _RegulatoryNotice extends StatelessWidget {
  const _RegulatoryNotice();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 8, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.shield_outlined, color: AppColors.text1, size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mandatory PRIIPs Document',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 11,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'This Key Information Document must be provided before you '
                  'invest. It contains essential information in a standardized '
                  'format (max 3 pages).',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text1,
                    fontSize: 10,
                    fontWeight: AppTextStyles.bold,
                    height: 1.35,
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

class _KidPreviewCard extends StatelessWidget {
  const _KidPreviewCard({required this.document});

  final TradeKidDocument document;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 16),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: _kidBlue.withValues(alpha: .11),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.description_outlined,
                  color: _kidBlue,
                  size: 28,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      document.title,
                      style: AppTextStyles.baseMedium.copyWith(
                        color: AppColors.text1,
                        fontSize: 18,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 11),
                    Text(
                      'Last updated: ${document.lastUpdated} • '
                      'Version ${document.version}',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontSize: 11,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _DocumentMetric(
                  label: 'Document Type',
                  value: document.documentType,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _DocumentMetric(
                  label: 'Pages',
                  value: '${document.pages} / ${document.maxPages}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DocumentMetric extends StatelessWidget {
  const _DocumentMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 9),
      decoration: BoxDecoration(
        color: _kidSurface2,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 9,
              height: 1,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontSize: 12,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _KidSectionCard extends StatelessWidget {
  const _KidSectionCard({required this.section});

  final TradeKidSection section;

  @override
  Widget build(BuildContext context) {
    return _Card(
      key: KIDGeneratorPage.sectionKey(section.title),
      padding: const EdgeInsets.fromLTRB(16, 12, 13, 12),
      child: SizedBox(
        height: 40,
        child: Row(
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: Icon(_iconFor(section.icon), color: _kidBlue, size: 18),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                section.title,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontSize: 13,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: Color(0x1A10B981),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_outline_rounded,
                color: _kidGreen,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            key: KIDGeneratorPage.previewKey,
            icon: Icons.remove_red_eye_outlined,
            label: 'Preview KID',
            filled: false,
            onPressed: () {},
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ActionButton(
            icon: Icons.download_rounded,
            label: 'Download PDF',
            filled: true,
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.filled,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final bool filled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: FilledButton.icon(
        style: FilledButton.styleFrom(
          backgroundColor: filled ? _kidBlue : _kidSurface2,
          foregroundColor: AppColors.text1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: filled ? Colors.transparent : _kidBorder),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
        onPressed: onPressed,
        icon: Icon(icon, size: 16),
        label: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontSize: 13,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 14,
          decoration: BoxDecoration(
            color: _kidBlue,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 7),
        Text(
          text,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontSize: 11,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({super.key, required this.child, required this.padding});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: _kidSurface,
        border: Border.all(color: _kidBorder.withValues(alpha: .72)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: child,
    );
  }
}

IconData _iconFor(TradeKidSectionIcon icon) {
  return switch (icon) {
    TradeKidSectionIcon.info => Icons.info_outline_rounded,
    TradeKidSectionIcon.target => Icons.adjust_rounded,
    TradeKidSectionIcon.warning => Icons.warning_amber_rounded,
    TradeKidSectionIcon.chart => Icons.bar_chart_rounded,
    TradeKidSectionIcon.costs => Icons.attach_money_rounded,
    TradeKidSectionIcon.clock => Icons.schedule_rounded,
    TradeKidSectionIcon.help => Icons.help_outline_rounded,
  };
}
