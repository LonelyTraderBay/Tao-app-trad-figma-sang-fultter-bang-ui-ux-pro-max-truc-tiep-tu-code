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

part '../widgets/p2p_chat_header_banners.dart';
part '../widgets/p2p_chat_messages.dart';
part '../widgets/p2p_chat_composer_actions.dart';

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
