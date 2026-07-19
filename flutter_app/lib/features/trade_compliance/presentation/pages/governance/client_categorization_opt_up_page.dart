part of 'client_categorization_page.dart';

class ClientOptUpRequestPage extends ConsumerStatefulWidget {
  const ClientOptUpRequestPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc411_client_opt_up_content');
  static const criteriaKey = Key('sc411_client_opt_up_criteria');
  static const waiverKey = Key('sc411_client_opt_up_waiver');
  static const submitKey = Key('sc411_client_opt_up_submit');
  static const successKey = Key('sc411_client_opt_up_success');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ClientOptUpRequestPage> createState() =>
      _ClientOptUpRequestPageState();
}

class _ClientOptUpRequestPageState
    extends ConsumerState<ClientOptUpRequestPage> {
  bool _criteriaConfirmed = false;
  bool _waiverAcknowledged = false;
  bool _submitted = false;

  bool get _canSubmit => _criteriaConfirmed && _waiverAcknowledged;

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(tradeClientCategorizationProvider);
    return VitTradeDetailScaffold(
      title: 'Client Opt-Up Request',
      subtitle: 'MiFID II Classification',
      semanticLabel:
          'Yêu cầu nâng hạng lên khách hàng chuyên nghiệp (MiFID II)',
      semanticIdentifier: 'SC-411',
      contentKey: ClientOptUpRequestPage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.tradeCopyClientCategorization,
        mode: BackNavigationMode.historyThenFallback,
      ),
      children: async.when(
        loading: () => const [VitSkeletonList()],
        error: (error, stackTrace) => [
          VitErrorState(
            title: 'Không tải được dữ liệu',
            message: 'Vui lòng kiểm tra kết nối và thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(tradeClientCategorizationProvider),
          ),
        ],
        data: (snapshot) {
          final professional = snapshot.categories.firstWhere(
            (item) => item.id == 'professional',
          );
          return [
            if (_submitted)
              VitTradeSection(
                title: 'Status',
                child: VitCard(
                  key: ClientOptUpRequestPage.successKey,
                  density: VitDensity.tool,
                  radius: VitCardRadius.tight,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        color: _clientGreen,
                        size: 24,
                      ),
                      const SizedBox(width: AppSpacing.x3),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Review request saved',
                              style: AppTextStyles.base.copyWith(
                                color: AppColors.text1,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                            const SizedBox(
                              height: AppSpacing.pageRhythmCompactInnerGap,
                            ),
                            Text(
                              'Compliance review is required before any categorization change takes effect.',
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.text3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            VitTradeComplianceSection(
              title: 'Opt-up review',
              statusPill: const VitStatusPill(
                label: 'No instant status change',
                status: VitStatusPillStatus.warning,
                size: VitStatusPillSize.sm,
              ),
              items: [
                VitTradeComplianceItem(
                  label: 'Target',
                  value: professional.label,
                ),
                VitTradeComplianceItem(
                  label: 'Criteria',
                  value: '${professional.requirements.length} requirements',
                ),
              ],
            ),
            VitTradeSection(
              title: 'Request',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  VitCard(
                    density: VitDensity.tool,
                    radius: VitCardRadius.tight,
                    child: VitPageSection(
                      label: 'Professional Status Criteria',
                      density: VitDensity.tool,
                      children: [
                        for (final requirement in professional.requirements)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.track_changes_outlined,
                                color: _clientPrimary,
                                size: 14,
                              ),
                              const SizedBox(width: AppSpacing.x2),
                              Expanded(
                                child: Text(
                                  requirement,
                                  style: AppTextStyles.micro.copyWith(
                                    color: AppColors.text2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  VitPageSection(
                    density: VitDensity.tool,
                    children: [
                      _OptUpChecklistTile(
                        key: ClientOptUpRequestPage.criteriaKey,
                        value: _criteriaConfirmed,
                        title: 'I meet the professional client criteria',
                        subtitle:
                            'Evidence must be reviewed before status can change.',
                        onChanged: (value) =>
                            setState(() => _criteriaConfirmed = value),
                      ),
                      _OptUpChecklistTile(
                        key: ClientOptUpRequestPage.waiverKey,
                        value: _waiverAcknowledged,
                        title: 'I understand protection changes',
                        subtitle:
                            'Opting up can reduce retail investor protections.',
                        onChanged: (value) =>
                            setState(() => _waiverAcknowledged = value),
                      ),
                    ],
                  ),
                  VitCtaButton(
                    key: ClientOptUpRequestPage.submitKey,
                    onPressed: _canSubmit
                        ? () => setState(() => _submitted = true)
                        : null,
                    density: VitDensity.tool,
                    child: const Text('Submit for Review'),
                  ),
                  const VitHighRiskStatePanel(
                    state: VitHighRiskUiState.riskReview,
                    density: VitDensity.tool,
                    title: 'Opt-up request review',
                    message:
                        'Criteria acknowledgement, protection waiver, compliance receipt and delayed-effect next step are reviewed before any category change.',
                    contractId: 'client-opt-up-review',
                  ),
                ],
              ),
            ),
          ];
        },
      ),
    );
  }
}

class _OptUpChecklistTile extends StatelessWidget {
  const _OptUpChecklistTile({
    super.key,
    required this.value,
    required this.title,
    required this.subtitle,
    required this.onChanged,
  });

  final bool value;
  final String title;
  final String subtitle;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.tool,
      radius: VitCardRadius.tight,
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeThumbColor: _clientPrimary,
        title: Text(
          title,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ),
    );
  }
}
