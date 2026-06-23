import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/p2p/domain/entities/p2p_entities.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/widgets/p2p_dispute_detail_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class P2PDisputeSupportChatCard extends StatelessWidget {
  const P2PDisputeSupportChatCard({
    super.key,
    required this.inputKey,
    required this.sendKey,
    required this.currentLevel,
    required this.messages,
    required this.controller,
    required this.onChanged,
    required this.onSend,
  });

  final Key inputKey;
  final Key sendKey;
  final int currentLevel;
  final List<P2PDisputeSupportMessageDraft> messages;
  final TextEditingController controller;
  final VoidCallback onChanged;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      clip: true,
      child: Column(
        children: [
          Material(
            color: AppColors.surface,
            child: Column(
              children: [
                Padding(
                  padding: AppSpacing.p2pDisputeChatHeaderPadding,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.chat_bubble_outline_rounded,
                        color: AppModuleAccents.p2p,
                        size: AppSpacing.iconSm,
                      ),
                      const SizedBox(width: AppSpacing.x2),
                      Expanded(
                        child: Text(
                          'Chat với hỗ trợ',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                      P2PDisputeSmallPill(
                        label: 'Cấp $currentLevel',
                        color: p2pDisputeLevelColor(currentLevel),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: AppColors.divider,
                  height: AppSpacing.dividerHairline,
                ),
              ],
            ),
          ),
          Padding(
            padding: AppSpacing.p2pDisputeChatBodyPadding,
            child: Column(
              children: [
                for (final message in messages)
                  _SupportMessageBubble(message: message),
              ],
            ),
          ),
          Material(
            color: AppColors.surface,
            child: Column(
              children: [
                const Divider(
                  color: AppColors.divider,
                  height: AppSpacing.dividerHairline,
                ),
                Padding(
                  padding: AppSpacing.p2pDisputeChatInputPadding,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          key: inputKey,
                          controller: controller,
                          onChanged: (_) => onChanged(),
                          minLines: 1,
                          maxLines: 2,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            hintText: 'Nhập tin nhắn cho hỗ trợ...',
                            hintStyle: AppTextStyles.caption.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x2),
                      Material(
                        color: controller.text.trim().isEmpty
                            ? AppColors.surface2
                            : AppModuleAccents.p2p,
                        shape: const CircleBorder(),
                        child: SizedBox.square(
                          key: sendKey,
                          dimension: AppSpacing.p2pDisputeSendButtonSize,
                          child: Center(
                            child: VitInlineIconAction(
                              icon: Icons.send_rounded,
                              tooltip: 'Gửi tin nhắn hỗ trợ',
                              onPressed: onSend,
                              color: AppColors.text1,
                              borderRadius: AppRadii.pillRadius,
                              padding: AppSpacing.x2,
                              size: AppSpacing.iconSm,
                            ),
                          ),
                        ),
                      ),
                    ],
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

class _SupportMessageBubble extends StatelessWidget {
  const _SupportMessageBubble({required this.message});

  final P2PDisputeSupportMessageDraft message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == P2PDisputeMessageSender.user;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: AppSpacing.p2pDisputeBubbleMargin,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSpacing.p2pDisputeBubbleMaxWidth,
          ),
          child: Material(
            color: isUser ? AppModuleAccents.p2p : AppColors.surface2,
            shape: RoundedRectangleBorder(
              borderRadius: AppRadii.disputeMessageBubbleRadius(isUser: isUser),
            ),
            child: Padding(
              padding: AppSpacing.p2pDisputeBubblePadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isUser) ...[
                    Text(
                      'Hỗ trợ VitTrade',
                      style: AppTextStyles.micro.copyWith(
                        color: AppModuleAccents.p2p,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                  ],
                  Text(
                    message.text,
                    style: AppTextStyles.caption.copyWith(
                      color: isUser ? AppColors.onAccent : AppColors.text1,
                      fontWeight: AppTextStyles.medium,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      message.time,
                      style: AppTextStyles.micro.copyWith(
                        color: isUser
                            ? AppColors.onAccent.withValues(alpha: .70)
                            : AppColors.text3,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
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
}
