import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/profile_controller_providers.dart';

part '../widgets/profile_sub_account_summary.dart';
part '../widgets/profile_sub_account_primitives.dart';
part '../widgets/profile_sub_account_create.dart';
part '../widgets/profile_sub_account_card_details.dart';
part '../widgets/profile_sub_account_cards.dart';
part '../widgets/profile_sub_account_formatters.dart';

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
    final snapshot = ref.watch(profileControllerProvider).getSubAccounts();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollClearance =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome +
                  AppSpacing.x7 +
                  AppSpacing.x6 +
                  AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x6) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-166 SubAccountPage',
      child: Material(
        color: AppColors.bg,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'T\u00E0i kho\u1EA3n ph\u1EE5',
            subtitle: 'T\u00E0i kho\u1EA3n \u00B7 Profile',
            showBack: true,
            onBack: _close,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: SubAccountPage.contentKey,
                  physics: const ClampingScrollPhysics(),
                  padding: AppSpacing.profileSubAccountScrollPadding(
                    scrollClearance,
                  ),
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    density: VitDensity.compact,
                    fullBleed: true,
                    children: [
                      _SubAccountSummaryCard(
                        snapshot: snapshot,
                        isBalanceHidden: _isBalanceHidden,
                        onToggleBalance: _toggleBalance,
                      ),
                      VitHighRiskStatePanel(
                        state: VitHighRiskUiState.riskReview,
                        title: 'Review sub-account permissions',
                        message:
                            'Ki\u1EC3m tra quy\u1EC1n chuy\u1EC3n, r\u00FAt, API key v\u00E0 gi\u1EDBi h\u1EA1n tr\u01B0\u1EDBc khi t\u1EA1o ho\u1EB7c m\u1EDF r\u1ED9ng t\u00E0i kho\u1EA3n ph\u1EE5.',
                        contractId: 'Sub accounts: ${snapshot.accounts.length}',
                        density: VitDensity.compact,
                      ),
                      _CreateSubAccountButton(
                        isOpen: _showCreate,
                        onTap: _toggleCreateForm,
                      ),
                      if (_showCreate) const _CreateSubAccountForm(),
                      VitSectionHeader(
                        title:
                            'T\u00C0I KHO\u1EA2N (${snapshot.accounts.length})',
                        density: VitDensity.compact,
                      ),
                      if (snapshot.accounts.isEmpty)
                        const VitEmptyState(
                          title:
                              'Ch\u01B0a c\u00F3 t\u00E0i kho\u1EA3n ph\u1EE5',
                          message:
                              'T\u1EA1o t\u00E0i kho\u1EA3n ph\u1EE5 \u0111\u1EC3 t\u00E1ch quy\u1EC1n, API v\u00E0 v\u00ED giao d\u1ECBch.',
                          icon: Icons.groups_outlined,
                        )
                      else ...[
                        for (final account in snapshot.accounts)
                          _SubAccountCard(
                            account: account,
                            isExpanded: _expandedId == account.id,
                            isBalanceHidden: _isBalanceHidden,
                            onTap: () => _toggleExpanded(account.id),
                          ),
                      ],
                      const _SubAccountInfoNote(),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
