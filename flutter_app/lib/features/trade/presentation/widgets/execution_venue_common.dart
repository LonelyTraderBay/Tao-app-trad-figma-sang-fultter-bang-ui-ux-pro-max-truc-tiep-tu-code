part of '../pages/execution_venue_analysis_page.dart';

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitSectionHeader(
      title: text,
      variant: VitSectionHeaderVariant.accentBar,
      accentColor: _venuePrimary,
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child, required this.padding});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: padding,
      borderColor: _venueBorder.withValues(alpha: .72),
      child: child,
    );
  }
}

class _NoticePanel extends StatelessWidget {
  const _NoticePanel({required this.text, required this.onClose});

  final String text;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: AppSpacing.contentPad,
      right: AppSpacing.contentPad,
      top:
          MediaQuery.paddingOf(context).top +
          AppSpacing.executionVenueNoticeTopOffset,
      child: Material(
        color: AppColors.transparent,
        child: VitCard(
          variant: VitCardVariant.inner,
          padding: AppSpacing.executionVenueNoticePadding,
          borderColor: _venueBorder,
          child: Row(
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: _venueGreen,
                size: AppSpacing.executionVenueNoticeIcon,
              ),
              const SizedBox(width: AppSpacing.x3 + AppSpacing.x1),
              Expanded(
                child: Text(
                  text,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text1),
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: onClose,
                icon: const Icon(
                  Icons.close_rounded,
                  size: AppSpacing.executionVenueNoticeIcon,
                ),
                color: AppColors.text3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _formatSpeed(double value) {
  if (value == .3 || value == .4 || value == .5) {
    return value.toStringAsFixed(1);
  }
  return value.toStringAsFixed(2);
}

String _formatInt(num value) {
  final text = value.round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < text.length; i++) {
    final indexFromEnd = text.length - i;
    buffer.write(text[i]);
    if (indexFromEnd > 1 && indexFromEnd % 3 == 1) {
      buffer.write(',');
    }
  }
  return buffer.toString();
}

String _formatUsd(double value) {
  return '\$${_formatInt(value)}.00';
}
