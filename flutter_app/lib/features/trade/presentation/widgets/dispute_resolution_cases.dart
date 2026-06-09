part of '../pages/dispute_resolution_page.dart';

class _DisputeTabs extends StatelessWidget {
  const _DisputeTabs({
    required this.tabs,
    required this.activeId,
    required this.onChanged,
  });

  final List<TradeDisputeTab> tabs;
  final String activeId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      height: 54,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.sm,
      child: Row(
        children: [
          for (final tab in tabs)
            Expanded(
              child: InkWell(
                key: DisputeResolutionPage.tabKey(tab.id),
                onTap: () => onChanged(tab.id),
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                tab.label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.caption.copyWith(
                                  color: tab.id == activeId
                                      ? _disputePrimary
                                      : AppColors.text3,
                                  fontSize: 12,
                                  fontWeight: AppTextStyles.bold,
                                  height: 1,
                                ),
                              ),
                            ),
                            if (tab.badgeCount != null) ...[
                              const SizedBox(width: 5),
                              _TabBadge(tab.badgeCount!),
                            ],
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: tab.id == activeId ? 70 : 0,
                      height: 2,
                      color: _disputePrimary,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TabBadge extends StatelessWidget {
  const _TabBadge(this.count);

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: _disputePrimary,
        shape: BoxShape.circle,
      ),
      child: Text(
        '$count',
        style: AppTextStyles.micro.copyWith(
          color: AppColors.onAccent,
          fontSize: 10,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _CasesTab extends StatelessWidget {
  const _CasesTab({
    required this.activeTabId,
    required this.snapshot,
    required this.lastResult,
  });

  final String activeTabId;
  final TradeDisputeResolutionSnapshot snapshot;
  final TradeDisputeSubmissionResult? lastResult;

  @override
  Widget build(BuildContext context) {
    final cases = activeTabId == 'history'
        ? snapshot.resolvedCases
        : snapshot.activeCases;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (lastResult != null && activeTabId == 'active') ...[
          _ResultBanner(result: lastResult!),
          const SizedBox(height: 12),
        ],
        if (cases.isEmpty)
          _EmptyCases(history: activeTabId == 'history')
        else
          for (final disputeCase in cases) ...[
            _DisputeCaseCard(disputeCase: disputeCase),
            if (disputeCase != cases.last) const SizedBox(height: 12),
          ],
      ],
    );
  }
}

class _ResultBanner extends StatelessWidget {
  const _ResultBanner({required this.result});

  final TradeDisputeSubmissionResult result;

  @override
  Widget build(BuildContext context) {
    return VitHighRiskStatePanel(
      state: VitHighRiskUiState.success,
      title: '${result.message}: ${result.caseId}',
      message: 'Case is now available in Active Cases.',
      contractId: result.caseId,
    );
  }
}

class _DisputeCaseCard extends StatelessWidget {
  const _DisputeCaseCard({required this.disputeCase});

  final TradeDisputeCase disputeCase;

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(disputeCase.status);
    final resolved = disputeCase.status == 'resolved';
    return VitCard(
      padding: const EdgeInsets.all(16),
      borderColor: AppColors.cardBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              if (resolved)
                const Icon(
                  Icons.check_circle_outline_rounded,
                  color: AppColors.buy,
                  size: 15,
                )
              else
                _StatusPill(
                  label: _statusLabel(disputeCase.status),
                  color: statusColor,
                ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  resolved
                      ? _outcomeLabel(disputeCase.outcome)
                      : 'Case #${disputeCase.id}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: resolved ? AppColors.buy : AppColors.text3,
                    fontSize: 11,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            disputeCase.subject,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontSize: 13,
              fontWeight: AppTextStyles.bold,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Provider: ${disputeCase.providerName}',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 11,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            disputeCase.description,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              fontSize: 10,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          if (!resolved)
            _CaseTimeline(disputeCase: disputeCase)
          else
            _RefundPanel(disputeCase: disputeCase),
          if (!resolved) ...[
            const SizedBox(height: 12),
            VitCtaButton(
              onPressed: () {},
              variant: VitCtaButtonVariant.danger,
              height: 36,
              child: const Text('Escalate to Senior Support'),
            ),
          ],
        ],
      ),
    );
  }
}
