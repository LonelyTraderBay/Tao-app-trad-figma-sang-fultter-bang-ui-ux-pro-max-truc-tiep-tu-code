part of '../pages/dispute_resolution_page.dart';

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .16),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label.toUpperCase(),
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 10,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _CaseTimeline extends StatelessWidget {
  const _CaseTimeline({required this.disputeCase});

  final TradeDisputeCase disputeCase;

  @override
  Widget build(BuildContext context) {
    const steps = [
      ('submitted', 'Complaint submitted'),
      ('under_review', 'Under review by support team'),
      ('provider_response', 'Awaiting provider response'),
      ('resolved', 'Resolution'),
    ];
    return Column(
      children: [
        for (final step in steps) ...[
          _TimelineRow(
            done: _stepDone(step.$1, disputeCase.status),
            label: step.$2,
            date: step.$1 == 'submitted'
                ? disputeCase.submittedDate
                : step.$1 == disputeCase.status
                ? disputeCase.updatedDate
                : '',
          ),
          if (step != steps.last) const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.done,
    required this.label,
    required this.date,
  });

  final bool done;
  final String label;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          done ? Icons.check_circle_outline_rounded : Icons.schedule_rounded,
          color: done ? AppColors.buy : AppColors.text3,
          size: 14,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.micro.copyWith(
                  color: done ? AppColors.text1 : AppColors.text3,
                  fontSize: 10,
                  fontWeight: done ? AppTextStyles.bold : AppTextStyles.normal,
                  height: 1.2,
                ),
              ),
              if (date.isNotEmpty)
                Text(
                  date,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 9,
                    height: 1.2,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RefundPanel extends StatelessWidget {
  const _RefundPanel({required this.disputeCase});

  final TradeDisputeCase disputeCase;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.sm,
      padding: const EdgeInsets.all(10),
      child: Text(
        '\$5 refund issued to your account',
        style: AppTextStyles.micro.copyWith(
          color: AppColors.buy,
          fontSize: 10,
          height: 1.3,
        ),
      ),
    );
  }
}

class _EmptyCases extends StatelessWidget {
  const _EmptyCases({required this.history});

  final bool history;

  @override
  Widget build(BuildContext context) {
    return VitEmptyState(
      title: history ? 'No resolved cases yet' : 'No active cases',
      icon: history
          ? Icons.description_outlined
          : Icons.check_circle_outline_rounded,
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Text(
        text,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.text2,
          fontSize: 12,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.micro.copyWith(
        color: AppColors.text2,
        fontSize: 11,
        height: 1,
      ),
    );
  }
}

Color _statusColor(String status) {
  switch (status) {
    case 'under_review':
      return _disputePrimary;
    case 'provider_response':
      return AppColors.warn;
    case 'resolved':
      return AppColors.buy;
    case 'escalated':
      return AppColors.sell;
    default:
      return AppColors.text3;
  }
}

String _statusLabel(String status) {
  switch (status) {
    case 'under_review':
      return 'Under Review';
    case 'provider_response':
      return 'Provider Responded';
    case 'resolved':
      return 'Resolved';
    case 'escalated':
      return 'Escalated';
    default:
      return 'Submitted';
  }
}

String _outcomeLabel(String? outcome) {
  switch (outcome) {
    case 'refund':
      return 'Refund Issued';
    case 'warning':
      return 'Provider Warned';
    case 'suspension':
      return 'Provider Suspended';
    case 'no_action':
      return 'No Action Required';
    default:
      return 'Pending';
  }
}

bool _stepDone(String step, String status) {
  const order = ['submitted', 'under_review', 'provider_response', 'resolved'];
  return order.indexOf(step) <= order.indexOf(status);
}
