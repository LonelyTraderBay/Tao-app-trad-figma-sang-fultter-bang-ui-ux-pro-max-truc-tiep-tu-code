import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

const _governancePrimary = AppColors.primary;
const _governanceCard = AppColors.surface;
const _governanceTabs = AppColors.surface;
const _governanceHeroBackground = AppColors.primary15;
const _governanceWarningBackground = AppColors.warningBg;
const _governanceWarningBorder = AppColors.warningBorderStrong;
const _governanceWarning = AppColors.caution;
const _governancePill = AppColors.buy20;

class ProviderGovernancePage extends ConsumerStatefulWidget {
  const ProviderGovernancePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc081_provider_governance_content');
  static const requestActionKey = Key('sc081_request_strategy_modification');
  static Key tabKey(String id) => Key('sc081_tab_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ProviderGovernancePage> createState() =>
      _ProviderGovernancePageState();
}

class _ProviderGovernancePageState
    extends ConsumerState<ProviderGovernancePage> {
  late String _activeTabId;
  bool _showMessagePanel = false;
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(tradeProviderGovernanceProvider);
    if (!_initialized) {
      _activeTabId = snapshot.defaultTabId;
      _initialized = true;
    }

    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 128 : 28);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-081 ProviderGovernancePage',
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            Column(
              children: [
                VitHeader(
                  title: 'Provider Governance',
                  showBack: true,
                  onBack: () => context.go(AppRoutePaths.tradeCopyTrading),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    key: ProviderGovernancePage.contentKey,
                    padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _ProviderDashboard(stats: snapshot.stats),
                        const SizedBox(height: 25),
                        _GovernanceTabs(
                          tabs: snapshot.tabs,
                          activeId: _activeTabId,
                          onChanged: (id) => setState(() => _activeTabId = id),
                        ),
                        const SizedBox(height: 26),
                        if (_activeTabId == 'modifications')
                          _ModificationsTab(
                            snapshot: snapshot,
                            onRequest: () =>
                                setState(() => _showMessagePanel = true),
                          )
                        else if (_activeTabId == 'communication')
                          _CommunicationTab(
                            snapshot: snapshot,
                            onBroadcast: () =>
                                setState(() => _showMessagePanel = true),
                          )
                        else if (_activeTabId == 'fees')
                          _FeesTab(snapshot: snapshot)
                        else
                          _ComplianceTab(snapshot: snapshot),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (_showMessagePanel)
              _MessagePanel(
                onClose: () => setState(() => _showMessagePanel = false),
              ),
          ],
        ),
      ),
    );
  }
}

class _ProviderDashboard extends StatelessWidget {
  const _ProviderDashboard({required this.stats});

  final TradeProviderGovernanceStats stats;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 136,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      decoration: BoxDecoration(
        color: _governanceHeroBackground,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: _governancePrimary, width: 2),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: _governancePrimary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  color: AppColors.onAccent,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Provider Dashboard',
                      style: AppTextStyles.body.copyWith(
                        color: _governancePrimary,
                        fontSize: 15,
                        fontWeight: AppTextStyles.bold,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Managing ${stats.followers} followers',
                      style: AppTextStyles.caption.copyWith(
                        color: _governancePrimary,
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
                child: _DashboardStat(label: 'AUM', value: '\$125K'),
              ),
              Expanded(
                child: _DashboardStat(
                  label: 'This Month',
                  value: '\$${stats.monthlyFeesEarned.toStringAsFixed(0)}',
                ),
              ),
              Expanded(
                child: _DashboardStat(
                  label: 'Compliance',
                  value: '${stats.complianceScore}/100',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DashboardStat extends StatelessWidget {
  const _DashboardStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: _governancePrimary,
            fontSize: 10,
            height: 1,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: _governancePrimary,
            fontSize: 14,
            fontWeight: AppTextStyles.bold,
            height: 1,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _GovernanceTabs extends StatelessWidget {
  const _GovernanceTabs({
    required this.tabs,
    required this.activeId,
    required this.onChanged,
  });

  final List<TradeProviderGovernanceTab> tabs;
  final String activeId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 53,
      color: _governanceTabs,
      child: Row(
        children: [
          for (final tab in tabs)
            Expanded(
              child: InkWell(
                key: ProviderGovernancePage.tabKey(tab.id),
                onTap: () => onChanged(tab.id),
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          tab.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            color: tab.id == activeId
                                ? _governancePrimary
                                : AppColors.text3,
                            fontSize: 12,
                            fontWeight: AppTextStyles.bold,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: tab.id == activeId ? 67 : 0,
                      height: 2,
                      color: _governancePrimary,
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

class _ModificationsTab extends StatelessWidget {
  const _ModificationsTab({required this.snapshot, required this.onRequest});

  final TradeProviderGovernanceSnapshot snapshot;
  final VoidCallback onRequest;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Notice(text: snapshot.warning),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            'Strategy Modification Log',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontSize: 12,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
        ),
        const SizedBox(height: 12),
        for (final modification in snapshot.modifications) ...[
          _ModificationCard(modification: modification),
          if (modification != snapshot.modifications.last)
            const SizedBox(height: 10),
        ],
        const SizedBox(height: 16),
        _RequestButton(onPressed: onRequest),
      ],
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 52),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 11),
      decoration: BoxDecoration(
        color: _governanceWarningBackground,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: _governanceWarningBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: _governanceWarning,
            size: 14,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: _governanceWarning,
                fontSize: 10,
                fontWeight: AppTextStyles.bold,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModificationCard extends StatelessWidget {
  const _ModificationCard({required this.modification});

  final TradeStrategyModification modification;

  @override
  Widget build(BuildContext context) {
    final typeColor = _modificationColor(modification.type);
    return Container(
      height: 154,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      decoration: BoxDecoration(
        color: _governanceCard,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                height: 20,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: typeColor.withValues(alpha: .16),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  modification.type.replaceAll('_', ' ').toUpperCase(),
                  style: AppTextStyles.micro.copyWith(
                    color: typeColor,
                    fontSize: 11,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.check_circle_outline_rounded,
                color: AppColors.buy,
                size: 13,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Change:',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 10,
              height: 1,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Text(
                modification.oldValue,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  fontSize: 11,
                  height: 1,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.text3,
                size: 13,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  modification.newValue,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text1,
                    fontSize: 11,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                color: AppColors.text3,
                size: 11,
              ),
              const SizedBox(width: 4),
              Text(
                modification.date,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 10,
                  height: 1,
                ),
              ),
              const SizedBox(width: 17),
              const Icon(
                Icons.group_outlined,
                color: AppColors.text3,
                size: 11,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  '${modification.followerImpact} followers impacted',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 10,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            height: 28,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: _governancePill,
              borderRadius: AppRadii.inputRadius,
            ),
            child: Text(
              '✓ Notification sent 24h before implementation',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.buy,
                fontSize: 9,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RequestButton extends StatelessWidget {
  const _RequestButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: ProviderGovernancePage.requestActionKey,
      onTap: onPressed,
      borderRadius: AppRadii.inputRadius,
      child: Container(
        height: 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _governancePrimary,
          borderRadius: AppRadii.inputRadius,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.edit_outlined,
              color: AppColors.onAccent,
              size: 17,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                'Request Strategy Modification',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.onAccent,
                  fontSize: 13,
                  fontWeight: AppTextStyles.bold,
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

class _CommunicationTab extends StatelessWidget {
  const _CommunicationTab({required this.snapshot, required this.onBroadcast});

  final TradeProviderGovernanceSnapshot snapshot;
  final VoidCallback onBroadcast;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _RequestButton(onPressed: onBroadcast),
        const SizedBox(height: 14),
        for (final message in snapshot.messages) ...[
          _SimplePanel(
            title: message.subject,
            body:
                '${message.recipients} recipients · ${message.openRate}% open rate · ${message.date}',
          ),
          if (message != snapshot.messages.last) const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _FeesTab extends StatelessWidget {
  const _FeesTab({required this.snapshot});

  final TradeProviderGovernanceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SimplePanel(
          title: 'Performance Fee Waterfall',
          body:
              'This Month \$${snapshot.stats.monthlyFeesEarned.toStringAsFixed(0)} · All-Time \$${snapshot.stats.allTimeFeesEarned.toStringAsFixed(0)}',
        ),
        const SizedBox(height: 12),
        for (final contributor in snapshot.feeContributors) ...[
          _SimplePanel(
            title: contributor.name,
            body:
                'Profit \$${contributor.profit.toStringAsFixed(0)} · Fee \$${contributor.fee.toStringAsFixed(0)}',
          ),
          if (contributor != snapshot.feeContributors.last)
            const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _ComplianceTab extends StatelessWidget {
  const _ComplianceTab({required this.snapshot});

  final TradeProviderGovernanceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final item in snapshot.complianceItems) ...[
          _SimplePanel(
            title: item.item,
            body: 'Last check: ${item.lastCheck}',
            leading: Icons.check_circle_outline_rounded,
          ),
          if (item != snapshot.complianceItems.last) const SizedBox(height: 8),
        ],
        const SizedBox(height: 12),
        _SimplePanel(
          title: 'Compliance Score: ${snapshot.stats.complianceScore}/100',
          body: 'Excellent standing — All requirements met',
        ),
      ],
    );
  }
}

class _SimplePanel extends StatelessWidget {
  const _SimplePanel({required this.title, required this.body, this.leading});

  final String title;
  final String body;
  final IconData? leading;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _governanceCard,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          if (leading != null) ...[
            Icon(leading, color: AppColors.buy, size: 17),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 12,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 10,
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

class _MessagePanel extends StatelessWidget {
  const _MessagePanel({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: const BoxDecoration(color: AppColors.modalScrim),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: AppColors.bg,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Broadcast Message',
                  style: AppTextStyles.baseMedium.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  'Send announcement to all followers',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 18),
                _RequestButton(onPressed: onClose),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Color _modificationColor(String type) {
  switch (type) {
    case 'fee_structure':
      return AppColors.buy;
    case 'risk_level':
      return AppColors.sell;
    default:
      return _governanceWarning;
  }
}
