import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../data/wallet_repository.dart';

const _approvalBg = Color(0xFF080C14);
const _approvalSurface = Color(0xFF151A23);
const _approvalBorder = Color(0x14FFFFFF);
const _approvalBlue = Color(0xFF3B82F6);
const _approvalGreen = Color(0xFF10B981);
const _approvalAmber = Color(0xFFF59E0B);
const _approvalOrange = Color(0xFFF97316);
const _approvalRed = Color(0xFFEF4444);
const _approvalPurple = Color(0xFF8B5CF6);

const _tabActive = 'Ho\u1EA1t \u0111\u1ED9ng';
const _tabHistory = 'L\u1ECBch s\u1EED';
const _tabSettings = 'C\u00E0i \u0111\u1EB7t';

class WalletTokenApprovalPage extends ConsumerStatefulWidget {
  const WalletTokenApprovalPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc150_token_approval_content');
  static const revokeAllKey = Key('sc150_token_approval_revoke_all');
  static const revokeSheetCancelKey = Key('sc150_token_approval_sheet_cancel');
  static const revokeSheetConfirmKey = Key(
    'sc150_token_approval_sheet_confirm',
  );
  static Key tabKey(String label) => Key('sc150_token_approval_tab_$label');
  static Key approvalKey(String id) => Key('sc150_token_approval_$id');
  static Key revokeKey(String id) => Key('sc150_token_approval_revoke_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<WalletTokenApprovalPage> createState() =>
      _WalletTokenApprovalPageState();
}

class _WalletTokenApprovalPageState
    extends ConsumerState<WalletTokenApprovalPage> {
  String _tab = _tabActive;
  bool _autoRevokeUnused = true;
  bool _warnUnlimited = true;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(walletRepositoryProvider).getTokenApprovals();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 92
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-150 WalletTokenApprovalPage',
      child: Material(
        color: _approvalBg,
        child: Column(
          children: [
            VitHeader(
              title: 'Token Approvals',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.wallet),
            ),
            _ApprovalTabs(
              activeTab: _tab,
              onChanged: (tab) => setState(() => _tab = tab),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: WalletTokenApprovalPage.contentKey,
                padding: EdgeInsets.fromLTRB(20, 13, 20, bottomInset),
                child: _contentForTab(snapshot),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _contentForTab(WalletTokenApprovalSnapshot snapshot) {
    if (_tab == _tabHistory) return _HistoryTab(snapshot: snapshot);
    if (_tab == _tabSettings) {
      return _SettingsTab(
        autoRevokeUnused: _autoRevokeUnused,
        warnUnlimited: _warnUnlimited,
        onAutoRevoke: () =>
            setState(() => _autoRevokeUnused = !_autoRevokeUnused),
        onWarnUnlimited: () => setState(() => _warnUnlimited = !_warnUnlimited),
      );
    }
    return _ActiveApprovalsTab(
      snapshot: snapshot,
      onRevoke: _showRevokeSheet,
      onRevokeAll: () => _showRevokeSheet(null),
    );
  }

  void _showRevokeSheet(WalletTokenApproval? approval) {
    final title = approval == null
        ? 'Revoke all high-risk approvals'
        : 'Revoke ${approval.token} approval';
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: _approvalSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title,
                  style: AppTextStyles.sectionTitle.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 12),
                Text(
                  'This mock flow requires an explicit confirmation before any token approval revocation action.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 12,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _SheetButton(
                        key: WalletTokenApprovalPage.revokeSheetCancelKey,
                        label: 'Cancel',
                        background: const Color(0xFF202635),
                        color: AppColors.text2,
                        onTap: () => Navigator.of(context).pop(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _SheetButton(
                        key: WalletTokenApprovalPage.revokeSheetConfirmKey,
                        label: 'Confirm',
                        background: _approvalRed,
                        color: Colors.white,
                        onTap: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ApprovalTabs extends StatelessWidget {
  const _ApprovalTabs({required this.activeTab, required this.onChanged});

  final String activeTab;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      decoration: const BoxDecoration(
        color: _approvalSurface,
        border: Border(bottom: BorderSide(color: _approvalBorder)),
      ),
      child: Row(
        children: [
          for (final tab in const [_tabActive, _tabHistory, _tabSettings])
            Expanded(
              child: GestureDetector(
                key: WalletTokenApprovalPage.tabKey(tab),
                onTap: () => onChanged(tab),
                behavior: HitTestBehavior.opaque,
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        tab,
                        style: AppTextStyles.caption.copyWith(
                          color: activeTab == tab
                              ? _approvalBlue
                              : const Color(0xFF566175),
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          height: 1,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 7,
                      right: 7,
                      bottom: 0,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        height: 2,
                        color: activeTab == tab
                            ? _approvalBlue
                            : Colors.transparent,
                      ),
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

class _ActiveApprovalsTab extends StatelessWidget {
  const _ActiveApprovalsTab({
    required this.snapshot,
    required this.onRevoke,
    required this.onRevokeAll,
  });

  final WalletTokenApprovalSnapshot snapshot;
  final ValueChanged<WalletTokenApproval> onRevoke;
  final VoidCallback onRevokeAll;

  @override
  Widget build(BuildContext context) {
    final approvals = snapshot.riskSortedApprovals;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SecurityOverview(snapshot: snapshot),
        const SizedBox(height: 18),
        _CriticalAlert(count: snapshot.criticalCount),
        const SizedBox(height: 17),
        const _SectionLabel(label: 'Active Approvals'),
        const SizedBox(height: 11),
        for (var i = 0; i < approvals.length; i++) ...[
          _ApprovalCard(approval: approvals[i], onRevoke: onRevoke),
          if (i != approvals.length - 1) const SizedBox(height: 14),
        ],
        const SizedBox(height: 17),
        _RevokeAllButton(onTap: onRevokeAll),
        const SizedBox(height: 16),
        const _InfoNotice(),
      ],
    );
  }
}

class _SecurityOverview extends StatelessWidget {
  const _SecurityOverview({required this.snapshot});

  final WalletTokenApprovalSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 203,
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 16),
      decoration: BoxDecoration(
        color: _approvalSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _approvalBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _approvalPurple.withValues(alpha: .14),
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.shield_outlined,
                  color: _approvalPurple,
                  size: 25,
                ),
              ),
              const SizedBox(width: 13),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Token Approvals',
                    style: AppTextStyles.baseMedium.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${snapshot.approvals.length} active approvals',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                      fontSize: 12,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 23),
          Row(
            children: [
              _OverviewMetric(
                label: 'Critical Risk',
                value: '${snapshot.criticalCount}',
                color: _approvalRed,
              ),
              _OverviewMetric(
                label: 'High Risk',
                value: '${snapshot.highRiskCount}',
                color: _approvalOrange,
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              _OverviewMetric(
                label: 'Unlimited',
                value: '${snapshot.unlimitedCount}',
                color: _approvalAmber,
              ),
              _OverviewMetric(
                label: 'Unused',
                value: '${snapshot.unusedCount}',
                color: AppColors.text1,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OverviewMetric extends StatelessWidget {
  const _OverviewMetric({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              fontSize: 11,
              height: 1,
            ),
          ),
          const SizedBox(height: 13),
          Text(
            value,
            style: AppTextStyles.sectionTitle.copyWith(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.w900,
              fontFamily: 'Roboto',
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _CriticalAlert extends StatelessWidget {
  const _CriticalAlert({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      decoration: BoxDecoration(
        color: _approvalRed.withValues(alpha: .07),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _approvalRed.withValues(alpha: .23)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: _approvalRed,
            size: 17,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Critical Security Risk',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'You have $count approval(s) to unverified contracts. Revoke immediately to protect your funds.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 11,
                    height: 1.25,
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

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 14,
          decoration: BoxDecoration(
            color: _approvalBlue,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: const Color(0xFF8791A6),
            fontSize: 12,
            fontWeight: FontWeight.w900,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _ApprovalCard extends StatelessWidget {
  const _ApprovalCard({required this.approval, required this.onRevoke});

  final WalletTokenApproval approval;
  final ValueChanged<WalletTokenApproval> onRevoke;

  @override
  Widget build(BuildContext context) {
    final riskColor = _riskColor(approval.riskLevel);
    final bordered =
        approval.riskLevel == 'critical' || approval.riskLevel == 'high';
    final showUnusedWarning = approval.unlimited && approval.usageCount == 0;
    return Container(
      key: WalletTokenApprovalPage.approvalKey(approval.id),
      height: showUnusedWarning ? 240 : 200,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: _approvalSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: bordered ? riskColor : _approvalBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CategoryIcon(approval: approval),
              const SizedBox(width: 10),
              Expanded(child: _ApprovalHeaderText(approval: approval)),
              const SizedBox(width: 8),
              GestureDetector(
                key: WalletTokenApprovalPage.revokeKey(approval.id),
                onTap: () => onRevoke(approval),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: _approvalRed.withValues(alpha: .10),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    color: _approvalRed,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _ApprovalAmount(approval: approval),
          const SizedBox(height: 15),
          Row(
            children: [
              _ApprovalStat(label: 'Approved', value: approval.approvedAtLabel),
              _ApprovalStat(label: 'Last Used', value: approval.lastUsedLabel),
              _ApprovalStat(label: 'Usage', value: '${approval.usageCount}x'),
            ],
          ),
          if (showUnusedWarning) ...[
            const Spacer(),
            Container(
              height: 30,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: _approvalRed.withValues(alpha: .07),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: _approvalRed,
                    size: 12,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Unused unlimited approval - revoke to protect funds',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: _approvalRed,
                        fontSize: 10,
                        height: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CategoryIcon extends StatelessWidget {
  const _CategoryIcon({required this.approval});

  final WalletTokenApproval approval;

  @override
  Widget build(BuildContext context) {
    final color = _riskColor(approval.riskLevel);
    final icon = switch (approval.category) {
      'dex' => Icons.trending_up_rounded,
      'lending' => Icons.attach_money_rounded,
      _ => Icons.shield_outlined,
    };
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .15),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Icon(icon, color: color, size: 17),
    );
  }
}

class _ApprovalHeaderText extends StatelessWidget {
  const _ApprovalHeaderText({required this.approval});

  final WalletTokenApproval approval;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              approval.token,
              style: AppTextStyles.baseMedium.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              approval.verified
                  ? Icons.check_circle_outline_rounded
                  : Icons.cancel_outlined,
              color: approval.verified ? _approvalGreen : _approvalRed,
              size: 13,
            ),
            const SizedBox(width: 8),
            _RiskBadge(risk: approval.riskLevel),
          ],
        ),
        const SizedBox(height: 11),
        Text(
          '\u2192 ${approval.spenderName}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 12,
            height: 1,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          approval.maskedSpender,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 10,
            fontFamily: 'Roboto',
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _RiskBadge extends StatelessWidget {
  const _RiskBadge({required this.risk});

  final String risk;

  @override
  Widget build(BuildContext context) {
    final color = _riskColor(risk);
    return Container(
      height: 17,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .13),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        risk.toUpperCase(),
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w900,
          height: 1,
        ),
      ),
    );
  }
}

class _ApprovalAmount extends StatelessWidget {
  const _ApprovalAmount({required this.approval});

  final WalletTokenApproval approval;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: approval.unlimited
            ? _approvalRed.withValues(alpha: .08)
            : const Color(0xFF0C111B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Approved Amount',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontSize: 10,
                height: 1,
              ),
            ),
          ),
          Text(
            approval.unlimited
                ? '\u221E ${approval.amountLabel}'
                : approval.amountLabel,
            style: AppTextStyles.caption.copyWith(
              color: approval.unlimited ? _approvalRed : AppColors.text1,
              fontSize: 13,
              fontWeight: FontWeight.w900,
              fontFamily: 'Roboto',
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _ApprovalStat extends StatelessWidget {
  const _ApprovalStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 10,
              height: 1,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text1,
              fontSize: 11,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _RevokeAllButton extends StatelessWidget {
  const _RevokeAllButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: WalletTokenApprovalPage.revokeAllKey,
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _approvalRed.withValues(alpha: .10),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _approvalRed.withValues(alpha: .26)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.delete_outline_rounded,
              color: _approvalRed,
              size: 18,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                'Revoke All High-Risk Approvals',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: _approvalRed,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoNotice extends StatelessWidget {
  const _InfoNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 58),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: _approvalBlue.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _approvalBlue.withValues(alpha: .20)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: _approvalBlue,
            size: 14,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Token approvals allow smart contracts to spend your tokens. Revoke unused or suspicious approvals to protect your assets.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontSize: 11,
                height: 1.48,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryTab extends StatelessWidget {
  const _HistoryTab({required this.snapshot});

  final WalletTokenApprovalSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel(label: 'Revoked Approvals'),
        const SizedBox(height: 10),
        for (final revoked in snapshot.revokedApprovals) ...[
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _approvalSurface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _approvalBorder),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.check_circle_outline_rounded,
                  color: _approvalGreen,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${revoked.token} \u2192 ${revoked.spenderName}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        revoked.reason,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  revoked.revokedAtLabel,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _approvalSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _approvalBorder),
          ),
          child: Row(
            children: [
              const _HistoryMetric(label: 'Total Revoked', value: '2'),
              const _HistoryMetric(
                label: 'Funds Protected',
                value: '\$47,200',
                color: _approvalGreen,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HistoryMetric extends StatelessWidget {
  const _HistoryMetric({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.sectionTitle.copyWith(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.w900,
              fontFamily: 'Roboto',
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTab extends StatelessWidget {
  const _SettingsTab({
    required this.autoRevokeUnused,
    required this.warnUnlimited,
    required this.onAutoRevoke,
    required this.onWarnUnlimited,
  });

  final bool autoRevokeUnused;
  final bool warnUnlimited;
  final VoidCallback onAutoRevoke;
  final VoidCallback onWarnUnlimited;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel(label: 'Security Settings'),
        const SizedBox(height: 10),
        _SettingsRow(
          title: 'Auto-revoke Unused Approvals',
          description: 'Automatically revoke approvals unused for 90+ days',
          enabled: autoRevokeUnused,
          onTap: onAutoRevoke,
        ),
        const SizedBox(height: 10),
        _SettingsRow(
          title: 'Warn Unlimited Approvals',
          description: 'Show warning before approving unlimited amounts',
          enabled: warnUnlimited,
          onTap: onWarnUnlimited,
        ),
        const SizedBox(height: 16),
        Container(
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _approvalBlue,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            'Scan for Risky Approvals',
            style: AppTextStyles.caption.copyWith(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(height: 16),
        const _BestPracticesCard(),
      ],
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.title,
    required this.description,
    required this.enabled,
    required this.onTap,
  });

  final String title;
  final String description;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _approvalSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _approvalBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onTap,
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 48,
              height: 28,
              padding: const EdgeInsets.all(2),
              alignment: enabled ? Alignment.centerRight : Alignment.centerLeft,
              decoration: BoxDecoration(
                color: enabled ? _approvalBlue : const Color(0xFF566175),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BestPracticesCard extends StatelessWidget {
  const _BestPracticesCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _approvalSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _approvalBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Best Practices',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          for (final tip in const [
            'Regularly review active approvals',
            'Revoke unused or old approvals',
            'Avoid unlimited approvals when possible',
            'Only approve verified contracts',
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_outline_rounded,
                    color: _approvalGreen,
                    size: 14,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      tip,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        fontSize: 11,
                      ),
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

class _SheetButton extends StatelessWidget {
  const _SheetButton({
    super.key,
    required this.label,
    required this.background,
    required this.color,
    required this.onTap,
  });

  final String label;
  final Color background;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

Color _riskColor(String risk) {
  return switch (risk) {
    'critical' => _approvalRed,
    'high' => _approvalOrange,
    'medium' => _approvalAmber,
    'low' => _approvalGreen,
    _ => AppColors.text3,
  };
}
