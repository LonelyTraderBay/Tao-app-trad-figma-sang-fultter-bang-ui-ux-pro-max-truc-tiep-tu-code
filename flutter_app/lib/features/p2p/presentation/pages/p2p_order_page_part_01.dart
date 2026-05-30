part of 'p2p_order_page.dart';

class _P2POrderPageState extends ConsumerState<P2POrderPage> {
  _P2POrderUiStep _step = _P2POrderUiStep.payment;
  String? _copiedField;
  bool _showQr = true;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(p2pOrderProvider(widget.orderId));
    final controller = P2POrderController(
      state: P2POrderViewState(snapshot: snapshot),
    );
    final paidPreview = controller.paidPreview();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;
    final order = snapshot.order;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-216 P2POrderPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Chi tiết đơn hàng',
              subtitle: 'Đơn hàng - P2P',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2p),
            ),
            _StatusBanner(
              label: _step == _P2POrderUiStep.payment
                  ? order.statusLabel
                  : paidPreview.statusLabel,
              countdown: _step == _P2POrderUiStep.payment
                  ? order.countdownLabel
                  : paidPreview.countdownLabel,
              color: _step == _P2POrderUiStep.payment
                  ? AppColors.warn
                  : AppColors.primary,
            ),
            _OrderStepper(step: _step),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: P2POrderPage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(
                    left: AppSpacing.contentPad,
                    right: AppSpacing.contentPad,
                    bottom: bottomInset,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _SafetyBanner(
                        title: snapshot.safetyTitle,
                        bullets: snapshot.safetyBullets,
                      ),
                      const SizedBox(height: AppSpacing.x4),
                      _EscrowBanner(
                        order: order,
                        onTap: () =>
                            context.go(AppRoutePaths.p2pEscrow(order.id)),
                      ),
                      const SizedBox(height: AppSpacing.x4),
                      _OrderInfoCard(order: order),
                      if (_step == _P2POrderUiStep.payment) ...[
                        const SizedBox(height: AppSpacing.x4),
                        _PaymentInfoCard(
                          order: order,
                          fields: snapshot.paymentFields,
                          showQr: _showQr,
                          copiedField: _copiedField,
                          warningTitle: snapshot.transferWarningTitle,
                          warning: snapshot.transferWarning,
                          onToggleQr: () {
                            HapticFeedback.selectionClick();
                            setState(() => _showQr = !_showQr);
                          },
                          onCopyAll: () => _markCopied('all'),
                          onCopy: _markCopied,
                        ),
                      ],
                      const SizedBox(height: AppSpacing.x4),
                      _ProofCard(
                        step: _step,
                        onUpload: () =>
                            context.go(AppRoutePaths.p2pOrderProof(order.id)),
                      ),
                      const SizedBox(height: AppSpacing.x4),
                      _TimelineCard(timeline: snapshot.timeline),
                      const SizedBox(height: AppSpacing.x4),
                      _PaymentWarning(message: snapshot.paymentWarning),
                      const SizedBox(height: AppSpacing.x4),
                      _PrimaryActions(
                        step: _step,
                        onChat: () =>
                            context.go(AppRoutePaths.p2pChat(order.id)),
                        onPaid: _markPaid,
                      ),
                      if (_step == _P2POrderUiStep.payment) ...[
                        const SizedBox(height: AppSpacing.x3),
                        _TextActionButton(
                          key: P2POrderPage.cancelKey,
                          onPressed: () => context.go(
                            AppRoutePaths.p2pOrderCancel(order.id),
                          ),
                          icon: const Icon(Icons.close_rounded, size: 16),
                          label: 'Hủy đơn hàng',
                          color: AppColors.sell,
                        ),
                      ],
                      const SizedBox(height: AppSpacing.x4),
                      _QuickActions(actions: snapshot.quickActions),
                      const SizedBox(height: AppSpacing.x5),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _markCopied(String field) {
    HapticFeedback.selectionClick();
    setState(() => _copiedField = field);
    Future<void>.delayed(const Duration(milliseconds: 900), () {
      if (!mounted || _copiedField != field) return;
      setState(() => _copiedField = null);
    });
  }

  void _markPaid() {
    HapticFeedback.mediumImpact();
    setState(() => _step = _P2POrderUiStep.confirm);
  }
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({
    required this.label,
    required this.countdown,
    required this.color,
  });

  final String label;
  final String countdown;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.contentPad,
        vertical: AppSpacing.x4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .08),
        border: Border(bottom: BorderSide(color: color.withValues(alpha: .15))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          Text(
            countdown,
            style: AppTextStyles.baseMedium.copyWith(
              color: color,
              fontFeatures: AppTextStyles.tabularFigures,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderStepper extends StatelessWidget {
  const _OrderStepper({required this.step});

  final _P2POrderUiStep step;

  @override
  Widget build(BuildContext context) {
    final activeIndex = step == _P2POrderUiStep.payment ? 1 : 2;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.contentPad,
        vertical: AppSpacing.x4,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var index = 0; index < 3; index++) ...[
            Expanded(
              child: _StepperNode(
                index: index,
                label: const ['Đặt lệnh', 'Thanh toán', 'Nhận tiền'][index],
                activeIndex: activeIndex,
              ),
            ),
            if (index < 2)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.x3 + 2),
                  child: Container(
                    height: 2,
                    color: index < activeIndex - 1
                        ? AppModuleAccents.p2p
                        : AppColors.borderSolid,
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _StepperNode extends StatelessWidget {
  const _StepperNode({
    required this.index,
    required this.label,
    required this.activeIndex,
  });

  final int index;
  final String label;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    final isCompleted = index < activeIndex;
    return Column(
      children: [
        Container(
          width: AppSpacing.x6,
          height: AppSpacing.x6,
          decoration: BoxDecoration(
            color: isCompleted ? AppModuleAccents.p2p : AppColors.surface2,
            shape: BoxShape.circle,
            border: Border.all(
              color: isCompleted ? AppModuleAccents.p2p : AppColors.borderSolid,
            ),
          ),
          child: Center(
            child: isCompleted
                ? const Icon(
                    Icons.check_rounded,
                    color: AppColors.onAccent,
                    size: AppSpacing.iconSm,
                  )
                : Text(
                    '${index + 1}',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.micro.copyWith(
            color: isCompleted ? AppModuleAccents.p2p : AppColors.text3,
          ),
        ),
      ],
    );
  }
}

class _SafetyBanner extends StatelessWidget {
  const _SafetyBanner({required this.title, required this.bullets});

  final String title;
  final List<String> bullets;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.sell20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppSpacing.x6,
            height: AppSpacing.x6,
            decoration: const BoxDecoration(
              color: AppColors.sell10,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: AppColors.sell,
              size: AppSpacing.iconSm,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.sell,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                for (final item in bullets)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.x1),
                    child: Text(
                      item,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.sell,
                        height: 1.35,
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

class _EscrowBanner extends StatelessWidget {
  const _EscrowBanner({required this.order, required this.onTap});

  final P2POrderDetailDraft order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.buy10,
      borderRadius: AppRadii.cardRadius,
      child: InkWell(
        key: P2POrderPage.escrowKey,
        onTap: onTap,
        borderRadius: AppRadii.cardRadius,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.x4),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.buy20),
            borderRadius: AppRadii.cardRadius,
          ),
          child: Row(
            children: [
              const Icon(
                Icons.lock_outline_rounded,
                color: AppColors.buy,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Escrow: ${_formatCrypto(order.escrowAmount)} ${order.asset} đã khóa',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.buy,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      'Tài sản được bảo vệ cho đến khi xác nhận thanh toán',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.buy10,
                  borderRadius: AppRadii.inputRadius,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.x3,
                    vertical: AppSpacing.x2,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Chi tiết',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.buy,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x1),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.buy,
                        size: AppSpacing.iconSm,
                      ),
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
}

class _OrderInfoCard extends StatelessWidget {
  const _OrderInfoCard({required this.order});

  final P2POrderDetailDraft order;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Đơn hàng',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              _SmallPill(
                icon: Icons.copy_rounded,
                label: order.orderNumber,
                color: AppColors.text2,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          _InfoLine(
            label: 'Giao dịch',
            value:
                '${order.typeLabel} ${_formatCrypto(order.amount)} ${order.asset}',
            emphasis: true,
          ),
          _InfoLine(
            label: 'Giá',
            value: '${_formatVnd(order.priceVnd)} VND/${order.asset}',
          ),
          _InfoLine(
            label: 'Cần thanh toán',
            value: '${_formatVnd(order.totalVnd)} ${order.currency}',
            emphasis: true,
          ),
          _InfoLine(label: 'Thanh toán qua', value: order.paymentMethod),
          _InfoLine(label: 'Người bán', value: order.merchant),
          _InfoLine(label: 'Phí', value: order.feeLabel, isLast: true),
        ],
      ),
    );
  }
}
