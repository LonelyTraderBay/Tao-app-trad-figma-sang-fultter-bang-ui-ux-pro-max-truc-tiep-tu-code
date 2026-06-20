part of 'staking_proof_of_reserves_page.dart';

class _AssetReserveCard extends StatelessWidget {
  const _AssetReserveCard({required this.asset});

  final StakingAssetReserveDraft asset;

  @override
  Widget build(BuildContext context) {
    final progress = math.min(asset.reserveRatio / 150, 1.0);
    return VitCard(
      radius: VitCardRadius.lg,
      padding: AppSpacing.earnPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(asset.asset, style: AppTextStyles.baseMedium),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      'Updated: ${asset.lastUpdated}',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${asset.reserveRatio.toStringAsFixed(1)}%',
                style: AppTextStyles.sectionTitle.copyWith(
                  color: AppColors.buy,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          ClipRRect(
            borderRadius: AppRadii.xsRadius,
            child: LinearProgressIndicator(
              minHeight: AppSpacing.x2,
              value: progress,
              backgroundColor: AppColors.surface3,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.buy),
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: _InnerMetric(
                  label: 'On-Chain Balance',
                  value:
                      '${_formatAmount(asset.onChainBalance)} ${asset.asset}',
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _InnerMetric(
                  label: 'User Liabilities',
                  value:
                      '${_formatAmount(asset.userLiabilities)} ${asset.asset}',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          VitCard(
            variant: VitCardVariant.inner,
            padding: AppSpacing.earnPaddingX3,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Wallet Address',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                      const Padding(padding: AppSpacing.earnTopPaddingX1),
                      Text(
                        asset.walletAddress,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text2,
                          fontWeight: AppTextStyles.medium,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.x3),
                _StatusPill(label: 'Verify', color: AppColors.primarySoft),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AuditReportCard extends StatelessWidget {
  const _AuditReportCard({required this.report});

  final StakingReserveAuditReportDraft report;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: AppSpacing.earnPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(report.auditor, style: AppTextStyles.baseMedium),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      report.dateLabel,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusPill(label: report.status, color: AppColors.buy),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            report.findings,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: AppSpacing.stakingProofReportLineHeight,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          VitCtaButton(
            variant: VitCtaButtonVariant.secondary,
            height: AppSpacing.buttonCompact,
            onPressed: () {},
            leading: const Icon(Icons.open_in_new_rounded),
            child: const Text('Download Report (PDF)'),
          ),
        ],
      ),
    );
  }
}

class _VerificationStepCard extends StatelessWidget {
  const _VerificationStepCard({required this.step});

  final StakingReserveVerifyStepDraft step;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: AppSpacing.earnPaddingX4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: AppSpacing.x6,
            height: AppSpacing.x6,
            child: Material(
              color: AppColors.primary,
              shape: const CircleBorder(),
              child: Center(
                child: Text(
                  step.step.toString(),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.onAccent,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(step.title, style: AppTextStyles.caption),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  step.description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    height: AppSpacing.stakingProofReportLineHeight,
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

class _VerifySheet extends StatefulWidget {
  const _VerifySheet({required this.snapshot});

  final StakingProofOfReservesSnapshot snapshot;

  @override
  State<_VerifySheet> createState() => _VerifySheetState();
}

class _VerifySheetState extends State<_VerifySheet> {
  final _userId = TextEditingController();
  final _balance = TextEditingController();
  StakingMerkleProofDraft? _proof;

  @override
  void dispose() {
    _userId.dispose();
    _balance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        key: StakingProofOfReservesPage.verifySheetKey,
        padding: AppSpacing.earnContentMargin,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.86,
          ),
          child: VitSheetSurface(
            color: AppColors.surface,
            borderRadius: AppRadii.cardLargeRadius,
            padding: AppSpacing.earnPaddingX5,
            child: SingleChildScrollView(
              child: _proof == null ? _form(context) : _proofView(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _form(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _SheetTitle(title: 'Verify Your Balance'),
        const SizedBox(height: AppSpacing.x4),
        VitCard(
          variant: VitCardVariant.inner,
          borderColor: AppColors.primary20,
          padding: AppSpacing.earnPaddingX4,
          child: Text(
            widget.snapshot.verifyInfo,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: AppSpacing.stakingProofInfoLineHeight,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        _TextInput(
          fieldKey: StakingProofOfReservesPage.userIdFieldKey,
          label: 'User ID',
          controller: _userId,
          hint: 'e.g., user_12345',
        ),
        const SizedBox(height: AppSpacing.x3),
        _TextInput(
          fieldKey: StakingProofOfReservesPage.balanceFieldKey,
          label: 'Staked Balance (ETH)',
          controller: _balance,
          hint: 'e.g., 10.5',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        const SizedBox(height: AppSpacing.x4),
        VitCtaButton(
          key: StakingProofOfReservesPage.verifySubmitKey,
          onPressed: _verify,
          leading: const Icon(Icons.verified_outlined),
          child: const Text('Verify Inclusion'),
        ),
      ],
    );
  }

  Widget _proofView(BuildContext context) {
    final proof = _proof!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _SheetTitle(title: 'Verify Your Balance'),
        const SizedBox(height: AppSpacing.x4),
        VitCard(
          key: StakingProofOfReservesPage.proofResultKey,
          variant: VitCardVariant.inner,
          borderColor: AppColors.buy20,
          padding: AppSpacing.earnPaddingX4,
          child: Column(
            children: [
              const Icon(
                Icons.check_circle_outline_rounded,
                color: AppColors.buy,
                size: AppSpacing.x7,
              ),
              const SizedBox(height: AppSpacing.x3),
              Text('Verification Successful', style: AppTextStyles.baseMedium),
              const SizedBox(height: AppSpacing.x2),
              Text(
                'Your balance of ${proof.balance.toStringAsFixed(2)} ETH is included in the Proof of Reserves Merkle tree.',
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: AppSpacing.stakingProofInfoLineHeight,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        Text('Merkle Proof', style: AppTextStyles.caption),
        const SizedBox(height: AppSpacing.x2),
        _HashCard(label: 'Leaf Hash', value: proof.leaf),
        const SizedBox(height: AppSpacing.x2),
        _HashCard(label: 'Merkle Root', value: proof.root),
        const SizedBox(height: AppSpacing.x2),
        VitCard(
          variant: VitCardVariant.inner,
          padding: AppSpacing.earnPaddingX3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sibling Hashes (${proof.siblings.length})',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const SizedBox(height: AppSpacing.x2),
              for (var i = 0; i < proof.siblings.length; i++)
                Text(
                  '${i + 1}. ${_shortHash(proof.siblings[i])}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        VitCtaButton(
          variant: VitCtaButtonVariant.ghost,
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }

  void _verify() {
    if (_userId.text.trim().isEmpty || _balance.text.trim().isEmpty) return;
    final balance = double.tryParse(_balance.text.trim()) ?? 0;
    setState(() {
      _proof = StakingMerkleProofDraft(
        userId: _userId.text.trim(),
        balance: balance,
        leaf: '0x7a9c35cc6634c0532925a3b844bc9e7595f0beb4129dfad7890abc123',
        root:
            '0xabc123def456789012345678901234567890123456789012345678901234567890',
        siblings: const [
          '0x4df1741e6cdd9012cba8419900aa4455129dfad7890abc123',
          '0x62ab993d3d79012cba8419900aa4455129dfad7890abc123',
          '0x91cc0a18e52f012cba8419900aa4455129dfad7890abc123',
        ],
        verified: true,
      );
    });
  }
}

class _TextInput extends StatelessWidget {
  const _TextInput({
    required this.fieldKey,
    required this.label,
    required this.controller,
    required this.hint,
    this.keyboardType,
  });

  final Key fieldKey;
  final String label;
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.x2),
        VitInput(
          fieldKey: fieldKey,
          controller: controller,
          semanticLabel: label,
          hintText: hint,
          keyboardType: keyboardType,
        ),
      ],
    );
  }
}

class _HashCard extends StatelessWidget {
  const _HashCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: AppSpacing.earnPaddingX3,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  _shortHash(value),
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.content_copy_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconSm,
          ),
        ],
      ),
    );
  }
}

class _SheetTitle extends StatelessWidget {
  const _SheetTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(title, style: AppTextStyles.sectionTitle)),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close_rounded, color: AppColors.text2),
        ),
      ],
    );
  }
}
