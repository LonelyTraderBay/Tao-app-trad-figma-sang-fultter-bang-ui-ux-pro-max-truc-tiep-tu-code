part of '../pages/p2p_chat_page.dart';

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
    return Material(
      color: AppColors.bg,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: AppSpacing.dividerHairline,
            child: ColoredBox(color: AppColors.divider),
          ),
          Padding(
            padding: AppSpacing.p2pChatComposerBottomPadding(bottomInset),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
          SizedBox(
            height: AppSpacing.buttonStandard,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: AppSpacing.p2pChatQuickReplyRailPadding,
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
            padding: AppSpacing.p2pChatComposerInputPadding,
            child: Row(
              children: [
                _RoundIconButton(icon: Icons.image_outlined, onPressed: () {}),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: AppSpacing.p2pChatComposerLabelPadding,
                        child: Text(
                          'E2E Encrypted',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.buy,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      VitInput(
                        fieldKey: P2PChatPage.inputKey,
                        controller: controller,
                        onChanged: (_) => onChanged(),
                        semanticLabel: 'P2P encrypted chat message',
                        hintText: 'Nhap tin nhan...',
                        textStyle: AppTextStyles.body.copyWith(
                          color: AppColors.text1,
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
      padding: AppSpacing.p2pChatReplyChipOuterPadding,
      child: Material(
        color: color.withValues(alpha: .10),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.inputRadius,
          side: BorderSide(color: color.withValues(alpha: .22)),
        ),
        child: InkWell(
          onTap: onTap,
          customBorder: RoundedRectangleBorder(
            borderRadius: AppRadii.inputRadius,
          ),
          child: Padding(
            padding: AppSpacing.p2pChatReplyChipPadding,
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
          width: AppSpacing.p2pChatRoundIconButtonSize,
          height: AppSpacing.p2pChatRoundIconButtonSize,
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
          padding: AppSpacing.p2pChatSmallHeaderButtonPadding,
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
