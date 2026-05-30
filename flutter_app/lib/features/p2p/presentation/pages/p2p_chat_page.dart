import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';

class P2PChatPage extends ConsumerStatefulWidget {
  const P2PChatPage({super.key, required this.orderId, this.shellRenderMode});

  static const contentKey = Key('sc217_p2p_chat_content');
  static const inputKey = Key('sc217_p2p_chat_input');
  static const sendKey = Key('sc217_p2p_chat_send');
  static const detailKey = Key('sc217_p2p_chat_detail');
  static const e2eKey = Key('sc217_p2p_chat_e2e');
  static const shareProofKey = Key('sc217_p2p_chat_share_proof');

  static Key quickReplyKey(String label) => Key('sc217_p2p_chat_quick_$label');

  final String orderId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PChatPage> createState() => _P2PChatPageState();
}

class _P2PChatPageState extends ConsumerState<P2PChatPage> {
  late final TextEditingController _controller;
  final List<P2PChatMessageDraft> _extraMessages = [];
  bool _showE2EBanner = true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(p2pChatProvider(widget.orderId));
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome
            : DeviceMetrics.nativeBottomChrome) +
        MediaQuery.paddingOf(context).bottom;
    final messages = [...snapshot.messages, ..._extraMessages];

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-217 P2PChatPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            _ChatHeader(snapshot: snapshot),
            _RiskBanner(message: snapshot.warning),
            if (_showE2EBanner)
              _E2EBanner(
                title: snapshot.e2eTitle,
                subtitle: snapshot.e2eSubtitle,
                onOpen: () => context.go(AppRoutePaths.p2pE2EInfo),
                onClose: () {
                  HapticFeedback.selectionClick();
                  setState(() => _showE2EBanner = false);
                },
              ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: P2PChatPage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.contentPad,
                    AppSpacing.x4,
                    AppSpacing.contentPad,
                    AppSpacing.x4,
                  ),
                  child: Column(
                    children: [
                      _EncryptionPill(
                        label: snapshot.encryptionPill,
                        onTap: () => context.go(AppRoutePaths.p2pE2EInfo),
                      ),
                      const SizedBox(height: AppSpacing.x5),
                      const _DateSeparator(),
                      const SizedBox(height: AppSpacing.x4),
                      for (final message in messages)
                        _MessageBubble(
                          message: message,
                          merchantInitial: snapshot.merchantInitial,
                        ),
                    ],
                  ),
                ),
              ),
            ),
            _ChatComposer(
              bottomInset: bottomInset,
              quickReplies: snapshot.quickReplies,
              controller: _controller,
              onShareProof: () => _sendText(
                'Tôi đã chuyển khoản 5.070.000 VND qua Vietcombank. Nội dung: VITTA P2P001',
              ),
              onQuickReply: (reply) {
                HapticFeedback.selectionClick();
                _controller.text = reply;
                _controller.selection = TextSelection.fromPosition(
                  TextPosition(offset: reply.length),
                );
                setState(() {});
              },
              onChanged: () => setState(() {}),
              onSend: () => _sendText(_controller.text),
            ),
          ],
        ),
      ),
    );
  }

  void _sendText(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return;
    HapticFeedback.selectionClick();
    setState(() {
      _extraMessages.add(
        P2PChatMessageDraft(
          id: 'local-${_extraMessages.length}',
          sender: P2PChatSender.me,
          text: text,
          time: '11:08',
          isRead: false,
        ),
      );
      _controller.clear();
    });
  }
}

class _ChatHeader extends StatelessWidget {
  const _ChatHeader({required this.snapshot});

  final P2PChatSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        MediaQuery.paddingOf(context).top + AppSpacing.x3,
        AppSpacing.contentPad,
        AppSpacing.x3,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          _RoundIconButton(
            icon: Icons.arrow_back_rounded,
            onPressed: () =>
                context.go(AppRoutePaths.p2pOrder(snapshot.orderId)),
          ),
          const SizedBox(width: AppSpacing.x3),
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.accent,
                child: Text(
                  snapshot.merchantInitial,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.onAccent,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Positioned(
                right: -1,
                bottom: -1,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    color: AppColors.buy,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.surface, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.merchant,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  snapshot.activeLabel,
                  style: AppTextStyles.micro.copyWith(color: AppColors.buy),
                ),
              ],
            ),
          ),
          _SmallHeaderButton(
            key: P2PChatPage.detailKey,
            label: 'Chi tiết',
            onPressed: () =>
                context.go(AppRoutePaths.p2pOrder(snapshot.orderId)),
          ),
          const SizedBox(width: AppSpacing.x2),
          _RoundIconButton(
            key: P2PChatPage.e2eKey,
            icon: Icons.lock_outline_rounded,
            color: AppColors.buy,
            onPressed: () => context.go(AppRoutePaths.p2pE2EInfo),
          ),
        ],
      ),
    );
  }
}

class _RiskBanner extends StatelessWidget {
  const _RiskBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.contentPad,
        vertical: AppSpacing.x3,
      ),
      color: AppColors.sell10,
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.sell,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.micro.copyWith(color: AppColors.sell),
            ),
          ),
        ],
      ),
    );
  }
}

class _E2EBanner extends StatelessWidget {
  const _E2EBanner({
    required this.title,
    required this.subtitle,
    required this.onOpen,
    required this.onClose,
  });

  final String title;
  final String subtitle;
  final VoidCallback onOpen;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.buy10,
      child: InkWell(
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.contentPad,
            vertical: AppSpacing.x3,
          ),
          child: Row(
            children: [
              const Icon(
                Icons.verified_user_outlined,
                color: AppColors.buy,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.buy,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.lock_outline_rounded,
                    color: AppColors.buy,
                    size: 10,
                  ),
                  const SizedBox(width: AppSpacing.x1),
                  Text(
                    'AES-256',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.buy,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: onClose,
                icon: const Icon(Icons.close_rounded),
                color: AppColors.buy,
                iconSize: 13,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EncryptionPill extends StatelessWidget {
  const _EncryptionPill({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Material(
        color: AppColors.buy10,
        borderRadius: AppRadii.inputRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.inputRadius,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.x4,
              vertical: AppSpacing.x2,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.lock_outline_rounded,
                  color: AppColors.buy,
                  size: 10,
                ),
                const SizedBox(width: AppSpacing.x2),
                Text(
                  label,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.buy,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DateSeparator extends StatelessWidget {
  const _DateSeparator();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.divider)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
          child: Text(
            'Hôm nay',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.divider)),
      ],
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message, required this.merchantInitial});

  final P2PChatMessageDraft message;
  final String merchantInitial;

  @override
  Widget build(BuildContext context) {
    if (message.sender == P2PChatSender.system) {
      return Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.x4),
        child: Align(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 340),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.primary08,
                border: Border.all(color: AppColors.primary20),
                borderRadius: AppRadii.cardRadius,
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.x3),
                child: Column(
                  children: [
                    Text(
                      message.text,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.caption.copyWith(
                        color: AppModuleAccents.p2p,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      message.time,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    final isMe = message.sender == P2PChatSender.me;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.x4),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 14,
              backgroundColor: AppModuleAccents.p2p,
              child: Text(
                merchantInitial,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.onAccent,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.x2),
          ],
          Flexible(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300),
              child: Column(
                crossAxisAlignment: isMe
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: isMe ? AppModuleAccents.p2p : AppColors.surface2,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(AppRadii.lg),
                        topRight: const Radius.circular(AppRadii.lg),
                        bottomLeft: Radius.circular(isMe ? AppRadii.lg : 4),
                        bottomRight: Radius.circular(isMe ? 4 : AppRadii.lg),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.x4,
                        vertical: AppSpacing.x3,
                      ),
                      child: Text(
                        message.text,
                        style: AppTextStyles.body.copyWith(
                          color: isMe ? AppColors.onAccent : AppColors.text1,
                          fontWeight: AppTextStyles.medium,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        message.time,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                      if (isMe) ...[
                        const SizedBox(width: AppSpacing.x1),
                        Icon(
                          Icons.done_all_rounded,
                          size: 12,
                          color: message.isRead
                              ? AppModuleAccents.p2p
                              : AppColors.text3,
                        ),
                      ],
                    ],
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

class _ChatComposer extends StatelessWidget {
  const _ChatComposer({
    required this.bottomInset,
    required this.quickReplies,
    required this.controller,
    required this.onShareProof,
    required this.onQuickReply,
    required this.onChanged,
    required this.onSend,
  });

  final double bottomInset;
  final List<String> quickReplies;
  final TextEditingController controller;
  final VoidCallback onShareProof;
  final ValueChanged<String> onQuickReply;
  final VoidCallback onChanged;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final canSend = controller.text.trim().isNotEmpty;
    return Container(
      padding: EdgeInsets.only(bottom: bottomInset),
      decoration: const BoxDecoration(
        color: AppColors.bg,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Column(
        children: [
          SizedBox(
            height: AppSpacing.buttonStandard,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.contentPad,
                vertical: AppSpacing.x3,
              ),
              children: [
                _ReplyChip(
                  key: P2PChatPage.shareProofKey,
                  label: 'Chia sẻ bằng chứng',
                  icon: Icons.shield_outlined,
                  color: AppColors.buy,
                  onTap: onShareProof,
                ),
                for (final reply in quickReplies)
                  _ReplyChip(
                    key: P2PChatPage.quickReplyKey(reply),
                    label: reply,
                    icon: null,
                    color: AppColors.text2,
                    onTap: () => onQuickReply(reply),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.contentPad,
              AppSpacing.x2,
              AppSpacing.contentPad,
              AppSpacing.x3,
            ),
            child: Row(
              children: [
                _RoundIconButton(icon: Icons.image_outlined, onPressed: () {}),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: AppSpacing.x3),
                        child: Text(
                          'E2E Encrypted',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.buy,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      TextField(
                        key: P2PChatPage.inputKey,
                        controller: controller,
                        onChanged: (_) => onChanged(),
                        minLines: 1,
                        maxLines: 3,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.text1,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Nhập tin nhắn...',
                          hintStyle: AppTextStyles.body.copyWith(
                            color: AppColors.text3,
                          ),
                          filled: true,
                          fillColor: AppColors.surface2,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.x4,
                            vertical: AppSpacing.x3,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: AppRadii.inputRadius,
                            borderSide: const BorderSide(
                              color: AppColors.borderSolid,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: AppRadii.inputRadius,
                            borderSide: const BorderSide(
                              color: AppModuleAccents.p2p,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.x3),
                _RoundIconButton(
                  key: P2PChatPage.sendKey,
                  icon: Icons.send_rounded,
                  color: canSend ? AppModuleAccents.p2p : AppColors.text3,
                  onPressed: canSend ? onSend : () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReplyChip extends StatelessWidget {
  const _ReplyChip({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData? icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.x2),
      child: Material(
        color: color.withValues(alpha: .10),
        borderRadius: AppRadii.inputRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.inputRadius,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
            decoration: BoxDecoration(
              border: Border.all(color: color.withValues(alpha: .22)),
              borderRadius: AppRadii.inputRadius,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: color, size: 12),
                  const SizedBox(width: AppSpacing.x2),
                ],
                Text(
                  label,
                  style: AppTextStyles.micro.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.color = AppColors.text2,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.hoverBg,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, color: color, size: AppSpacing.iconMd),
        ),
      ),
    );
  }
}

class _SmallHeaderButton extends StatelessWidget {
  const _SmallHeaderButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary12,
      borderRadius: AppRadii.inputRadius,
      child: InkWell(
        onTap: onPressed,
        borderRadius: AppRadii.inputRadius,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x3,
            vertical: AppSpacing.x2,
          ),
          child: Row(
            children: [
              Text(
                label,
                style: AppTextStyles.micro.copyWith(
                  color: AppModuleAccents.p2p,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(width: AppSpacing.x1),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppModuleAccents.p2p,
                size: AppSpacing.iconSm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
