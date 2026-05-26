import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/features/profile/data/profile_repository.dart';

class SubAccountPage extends ConsumerStatefulWidget {
  const SubAccountPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc166_sub_accounts_content');
  static const summaryKey = Key('sc166_sub_accounts_summary');
  static const createButtonKey = Key('sc166_sub_accounts_create_button');
  static const createFormKey = Key('sc166_sub_accounts_create_form');
  static const balanceToggleKey = Key('sc166_sub_accounts_balance_toggle');

  static Key accountCardKey(String id) => Key('sc166_sub_account_card_$id');
  static Key expandKey(String id) => Key('sc166_sub_account_expand_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SubAccountPage> createState() => _SubAccountPageState();
}

class _SubAccountPageState extends ConsumerState<SubAccountPage> {
  bool _isBalanceHidden = false;
  bool _showCreate = false;
  String? _expandedId;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(profileRepositoryProvider).getSubAccounts();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 126
            : DeviceMetrics.nativeBottomChrome + 32) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-166 SubAccountPage',
      child: Material(
        color: AppColors.bg,
        child: Column(
          children: [
            VitHeader(
              title: 'T\u00E0i kho\u1EA3n ph\u1EE5',
              subtitle: 'T\u00E0i kho\u1EA3n \u00B7 Profile',
              showBack: true,
              onBack: _close,
            ),
            Expanded(
              child: SingleChildScrollView(
                key: SubAccountPage.contentKey,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _SubAccountSummaryCard(
                      snapshot: snapshot,
                      isBalanceHidden: _isBalanceHidden,
                      onToggleBalance: _toggleBalance,
                    ),
                    const SizedBox(height: 26),
                    _CreateSubAccountButton(
                      isOpen: _showCreate,
                      onTap: _toggleCreateForm,
                    ),
                    if (_showCreate) ...[
                      const SizedBox(height: 13),
                      const _CreateSubAccountForm(),
                    ],
                    const SizedBox(height: 24),
                    _SectionHeader(
                      label:
                          'T\u00C0I KHO\u1EA2N (${snapshot.accounts.length})',
                    ),
                    const SizedBox(height: 10),
                    for (final account in snapshot.accounts) ...[
                      _SubAccountCard(
                        account: account,
                        isExpanded: _expandedId == account.id,
                        isBalanceHidden: _isBalanceHidden,
                        onTap: () => _toggleExpanded(account.id),
                      ),
                      if (account != snapshot.accounts.last)
                        const SizedBox(height: 13),
                    ],
                    const SizedBox(height: 25),
                    const _SubAccountInfoNote(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleBalance() {
    HapticFeedback.selectionClick();
    setState(() => _isBalanceHidden = !_isBalanceHidden);
  }

  void _toggleCreateForm() {
    HapticFeedback.selectionClick();
    setState(() => _showCreate = !_showCreate);
  }

  void _toggleExpanded(String id) {
    HapticFeedback.selectionClick();
    setState(() => _expandedId = _expandedId == id ? null : id);
  }

  void _close() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.profile);
  }
}

class _SubAccountSummaryCard extends StatelessWidget {
  const _SubAccountSummaryCard({
    required this.snapshot,
    required this.isBalanceHidden,
    required this.onToggleBalance,
  });

  final ProfileSubAccountsSnapshot snapshot;
  final bool isBalanceHidden;
  final VoidCallback onToggleBalance;

  @override
  Widget build(BuildContext context) {
    final pnlColor = snapshot.totalPnl30d >= 0 ? AppColors.buy : AppColors.sell;

    return Container(
      key: SubAccountPage.summaryKey,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadii.cardLargeRadius,
        border: Border.all(color: AppColors.primary20),
        gradient: const RadialGradient(
          center: Alignment(.85, -.9),
          radius: 1.15,
          colors: [AppColors.primary12, AppColors.surface],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: .13),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.group_outlined,
                color: AppColors.primary,
                size: 18,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'T\u1ED5ng t\u00E0i s\u1EA3n t\u1EA5t c\u1EA3 t\u00E0i kho\u1EA3n',
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 12,
                    height: 1.2,
                  ),
                ),
              ),
              SizedBox(
                width: 34,
                height: 34,
                child: IconButton(
                  key: SubAccountPage.balanceToggleKey,
                  padding: EdgeInsets.zero,
                  onPressed: onToggleBalance,
                  icon: Icon(
                    isBalanceHidden
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.text3,
                    size: 17,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 17),
          Text(
            isBalanceHidden
                ? '\u2022\u2022\u2022\u2022\u2022\u2022'
                : _formatUsd(snapshot.totalBalance),
            style: AppTextStyles.heroNumber.copyWith(
              fontSize: 26,
              height: 1.05,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            isBalanceHidden
                ? 'PnL 30d: \u2022\u2022\u2022\u2022'
                : 'PnL 30d: ${_formatSignedUsd(snapshot.totalPnl30d)}',
            style: AppTextStyles.caption.copyWith(
              color: pnlColor,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _SummaryMetric(
                  label: 'T\u1ED5ng TK',
                  value: '${snapshot.accounts.length}',
                  valueColor: AppColors.text1,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SummaryMetric(
                  label: 'Ho\u1EA1t \u0111\u1ED9ng',
                  value: '${snapshot.activeCount}',
                  valueColor: AppColors.buy,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SummaryMetric(
                  label: 'API Keys',
                  value: '${snapshot.apiKeyCount}',
                  valueColor: AppColors.warn,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.portfolioBtnGhost,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.portfolioTextMuted,
              fontSize: 10,
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.baseMedium.copyWith(
              color: valueColor,
              fontSize: 16,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _CreateSubAccountButton extends StatelessWidget {
  const _CreateSubAccountButton({required this.isOpen, required this.onTap});

  final bool isOpen;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: SubAccountPage.createButtonKey,
        onTap: onTap,
        borderRadius: AppRadii.cardRadius,
        child: Container(
          height: AppSpacing.ctaHeight,
          decoration: BoxDecoration(
            color: AppColors.primary08,
            borderRadius: AppRadii.cardRadius,
            border: Border.all(
              color: AppColors.primary40,
              style: BorderStyle.solid,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isOpen ? Icons.close_rounded : Icons.add_rounded,
                color: AppColors.primary,
                size: 19,
              ),
              const SizedBox(width: 10),
              Text(
                isOpen
                    ? '\u0110\u00F3ng bi\u1EC3u m\u1EABu'
                    : 'T\u1EA1o t\u00E0i kho\u1EA3n ph\u1EE5 m\u1EDBi',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.primary,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CreateSubAccountForm extends StatelessWidget {
  const _CreateSubAccountForm();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: SubAccountPage.createFormKey,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'T\u1EA1o t\u00E0i kho\u1EA3n ph\u1EE5',
            style: AppTextStyles.baseMedium.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
          const SizedBox(height: 14),
          const _FormFieldPreview(
            label: 'T\u00EAn t\u00E0i kho\u1EA3n',
            value: 'VD: Grid Bot #2',
          ),
          const SizedBox(height: 12),
          const _FormPillRow(
            label: 'Lo\u1EA1i t\u00E0i kho\u1EA3n',
            values: ['Spot', 'Margin', 'Futures', 'T\u1EA5t c\u1EA3'],
          ),
          const SizedBox(height: 12),
          const _FormPillRow(
            label: 'Quy\u1EC1n h\u1EA1n',
            values: [
              'Spot',
              'Margin',
              'Futures',
              'Chuy\u1EC3n',
              'R\u00FAt',
              'Xem',
            ],
            wrap: true,
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: AppSpacing.ctaHeight,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: AppRadii.inputRadius,
              ),
              child: Center(
                child: Text(
                  'T\u1EA1o t\u00E0i kho\u1EA3n',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.portfolioBtnGhostText,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FormFieldPreview extends StatelessWidget {
  const _FormFieldPreview({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 11,
            height: 1,
          ),
        ),
        const SizedBox(height: 7),
        Container(
          height: AppSpacing.inputHeight,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: AppColors.surface2,
            borderRadius: AppRadii.inputRadius,
            border: Border.all(color: AppColors.borderSolid),
          ),
          child: Text(
            value,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text3,
              fontSize: 14,
              height: 1,
            ),
          ),
        ),
      ],
    );
  }
}

class _FormPillRow extends StatelessWidget {
  const _FormPillRow({
    required this.label,
    required this.values,
    this.wrap = false,
  });

  final String label;
  final List<String> values;
  final bool wrap;

  @override
  Widget build(BuildContext context) {
    final children = [
      for (final value in values)
        _SmallPill(
          label: value,
          foreground: AppColors.primary,
          background: AppColors.primary08,
          border: AppColors.primary20,
        ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 11,
            height: 1,
          ),
        ),
        const SizedBox(height: 8),
        if (wrap)
          Wrap(spacing: 8, runSpacing: 8, children: children)
        else
          Row(
            children: [
              for (final child in children) ...[
                Expanded(child: child),
                if (child != children.last) const SizedBox(width: 8),
              ],
            ],
          ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyles.caption.copyWith(
        color: AppColors.text2,
        fontWeight: AppTextStyles.bold,
        fontSize: 12,
        height: 1.1,
      ),
    );
  }
}

class _SubAccountCard extends StatelessWidget {
  const _SubAccountCard({
    required this.account,
    required this.isExpanded,
    required this.isBalanceHidden,
    required this.onTap,
  });

  final ProfileSubAccount account;
  final bool isExpanded;
  final bool isBalanceHidden;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final typeColor = _typeColor(account.type);
    final statusColor = _statusColor(account.status);
    final pnlColor = account.pnl30d >= 0 ? AppColors.buy : AppColors.sell;

    return Container(
      key: SubAccountPage.accountCardKey(account.id),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              key: SubAccountPage.expandKey(account.id),
              onTap: onTap,
              borderRadius: AppRadii.cardRadius,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    _AccountAvatar(
                      initial: account.name.isEmpty
                          ? '?'
                          : account.name.substring(0, 1),
                      color: typeColor,
                    ),
                    const SizedBox(width: 13),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  account.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.baseMedium.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    height: 1,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 7),
                              _SmallPill(
                                label: _typeLabel(account.type),
                                foreground: typeColor,
                                background: typeColor.withValues(alpha: .12),
                                border: typeColor.withValues(alpha: .18),
                              ),
                            ],
                          ),
                          const SizedBox(height: 9),
                          Row(
                            children: [
                              Icon(
                                _statusIcon(account.status),
                                color: statusColor,
                                size: 12,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                _statusLabel(account.status),
                                style: AppTextStyles.micro.copyWith(
                                  color: statusColor,
                                  fontWeight: AppTextStyles.bold,
                                  height: 1,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  '\u00B7 ${account.lastActive}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.micro.copyWith(
                                    color: AppColors.text3,
                                    height: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          isBalanceHidden
                              ? '\u2022\u2022\u2022\u2022'
                              : _formatUsd(account.balance),
                          style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                            height: 1,
                            fontFeatures: AppTextStyles.tabularFigures,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isBalanceHidden
                              ? '\u2022\u2022'
                              : _formatSignedUsd(account.pnl30d),
                          style: AppTextStyles.micro.copyWith(
                            color: pnlColor,
                            fontWeight: AppTextStyles.bold,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isExpanded)
            _SubAccountDetails(account: account, typeColor: typeColor),
        ],
      ),
    );
  }
}

class _SubAccountDetails extends StatelessWidget {
  const _SubAccountDetails({required this.account, required this.typeColor});

  final ProfileSubAccount account;
  final Color typeColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _DetailMetric(
                  label: 'Volume 30d',
                  value: _formatCompact(account.tradingVolume30d, prefix: r'$'),
                  color: AppColors.text1,
                ),
              ),
              Expanded(
                child: _DetailMetric(
                  label: 'API Keys',
                  value: '${account.apiKeyCount}',
                  color: AppColors.warn,
                ),
              ),
              Expanded(
                child: _DetailMetric(
                  label: 'T\u1EA1o ng\u00E0y',
                  value: account.createdAt,
                  color: AppColors.text2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Text(
            'Quy\u1EC1n h\u1EA1n:',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: [
              for (final permission in account.permissions)
                _SmallPill(
                  label: _permissionLabel(permission),
                  foreground: AppColors.text2,
                  background: AppColors.surface3.withValues(alpha: .72),
                  border: AppColors.cardBorder,
                ),
            ],
          ),
          const SizedBox(height: 13),
          Text.rich(
            TextSpan(
              text: 'Email: ',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontSize: 11,
              ),
              children: [
                TextSpan(
                  text: account.email,
                  style: const TextStyle(color: AppColors.text2),
                ),
              ],
            ),
          ),
          const SizedBox(height: 13),
          Row(
            children: [
              Expanded(
                child: _ActionChip(
                  icon: Icons.swap_horiz_rounded,
                  label: 'Chuy\u1EC3n ti\u1EC1n',
                  color: AppColors.primary,
                  background: AppColors.primary08,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ActionChip(
                  icon: Icons.key_rounded,
                  label: 'API Key',
                  color: AppColors.warn,
                  background: AppColors.warn08,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ActionChip(
                  icon: Icons.settings_outlined,
                  label: 'C\u00E0i \u0111\u1EB7t',
                  color: AppColors.sell,
                  background: AppColors.sell10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AccountAvatar extends StatelessWidget {
  const _AccountAvatar({required this.initial, required this.color});

  final String initial;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .13),
        borderRadius: AppRadii.cardRadius,
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w900,
          height: 1,
        ),
      ),
    );
  }
}

class _DetailMetric extends StatelessWidget {
  const _DetailMetric({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 9,
            height: 1,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontSize: 12,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _SmallPill extends StatelessWidget {
  const _SmallPill({
    required this.label,
    required this.foreground,
    required this.background,
    required this.border,
  });

  final String label;
  final Color foreground;
  final Color background;
  final Color border;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadii.smRadius,
        border: Border.all(color: border),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.micro.copyWith(
          color: foreground,
          fontWeight: AppTextStyles.bold,
          fontSize: 9,
          height: 1,
        ),
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.background,
  });

  final IconData icon;
  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadii.inputRadius,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
                fontSize: 11,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SubAccountInfoNote extends StatelessWidget {
  const _SubAccountInfoNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
      decoration: BoxDecoration(
        color: AppColors.primary08,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: AppColors.primary20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.primary,
            size: 16,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              'M\u1ED7i t\u00E0i kho\u1EA3n ph\u1EE5 c\u00F3 v\u00ED v\u00E0 API ri\u00EAng bi\u1EC7t. B\u1EA1n c\u00F3 th\u1EC3 t\u1EA1o t\u1ED1i \u0111a 20 t\u00E0i kho\u1EA3n ph\u1EE5. T\u00E0i kho\u1EA3n ph\u1EE5 th\u1EEBa h\u01B0\u1EDFng m\u1EE9c VIP c\u1EE7a t\u00E0i kho\u1EA3n ch\u00EDnh.',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                fontSize: 11,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Color _typeColor(String type) {
  return switch (type) {
    'spot' => AppColors.buy,
    'margin' => AppColors.warn,
    'futures' => AppColors.sell,
    _ => AppColors.primary,
  };
}

String _typeLabel(String type) {
  return switch (type) {
    'spot' => 'Spot',
    'margin' => 'Margin',
    'futures' => 'Futures',
    _ => 'T\u1EA5t c\u1EA3',
  };
}

Color _statusColor(String status) {
  return switch (status) {
    'frozen' => AppColors.warn,
    'pending' => AppColors.primary,
    _ => AppColors.buy,
  };
}

IconData _statusIcon(String status) {
  return switch (status) {
    'frozen' => Icons.ac_unit_rounded,
    'pending' => Icons.pause_circle_outline_rounded,
    _ => Icons.check_circle_outline_rounded,
  };
}

String _statusLabel(String status) {
  return switch (status) {
    'frozen' => '\u0110\u00F3ng b\u0103ng',
    'pending' => 'Ch\u1EDD duy\u1EC7t',
    _ => 'Ho\u1EA1t \u0111\u1ED9ng',
  };
}

String _permissionLabel(String permission) {
  return switch (permission) {
    'spot_trade' => 'Spot',
    'margin_trade' => 'Margin',
    'futures_trade' => 'Futures',
    'transfer' => 'Chuy\u1EC3n',
    'withdraw' => 'R\u00FAt',
    'read' => 'Xem',
    _ => permission,
  };
}

String _formatUsd(double value) {
  final fixed = value.toStringAsFixed(2);
  final parts = fixed.split('.');
  return '\$${_withCommas(parts[0])}.${parts[1]}';
}

String _formatSignedUsd(double value) {
  final sign = value >= 0 ? '+' : '-';
  return '$sign${_formatUsd(value.abs())}';
}

String _formatCompact(double value, {String prefix = ''}) {
  final abs = value.abs();
  if (abs >= 1000000) {
    return '$prefix${(value / 1000000).toStringAsFixed(2)}M';
  }
  if (abs >= 1000) {
    return '$prefix${(value / 1000).toStringAsFixed(1)}K';
  }
  return '$prefix${value.toStringAsFixed(0)}';
}

String _withCommas(String input) {
  final buffer = StringBuffer();
  for (var i = 0; i < input.length; i += 1) {
    final remaining = input.length - i;
    buffer.write(input[i]);
    if (remaining > 1 && remaining % 3 == 1) {
      buffer.write(',');
    }
  }
  return buffer.toString();
}
