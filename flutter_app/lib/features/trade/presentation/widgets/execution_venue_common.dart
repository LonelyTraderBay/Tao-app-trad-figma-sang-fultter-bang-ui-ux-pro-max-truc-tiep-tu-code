part of '../pages/execution_venue_analysis_page.dart';

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
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
          TradeSpacingTokens.executionVenueNoticeTopOffset,
      child: Material(
        color: AppColors.transparent,
        child: VitCard(
          variant: VitCardVariant.inner,
          padding: TradeSpacingTokens.executionVenueNoticePadding,
          borderColor: _venueBorder,
          child: Row(
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: _venueGreen,
                size: TradeSpacingTokens.executionVenueNoticeIcon,
              ),
              const SizedBox(width: AppSpacing.pageRhythmStandardInnerGap),
              Expanded(
                child: Text(
                  text,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text1),
                ),
              ),
              VitInlineIconAction(
                icon: Icons.close_rounded,
                tooltip: 'Dismiss notice',
                onPressed: onClose,
                color: AppColors.text3,
                size: TradeSpacingTokens.executionVenueNoticeIcon,
                padding: AppSpacing.x1,
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
