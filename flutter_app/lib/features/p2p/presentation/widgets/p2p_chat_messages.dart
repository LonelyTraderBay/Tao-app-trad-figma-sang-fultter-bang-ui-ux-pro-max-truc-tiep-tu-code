part of '../pages/p2p_chat_page.dart';

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
