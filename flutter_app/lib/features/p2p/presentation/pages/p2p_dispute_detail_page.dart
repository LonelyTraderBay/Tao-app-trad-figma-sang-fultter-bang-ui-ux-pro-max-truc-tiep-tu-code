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
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/p2p/data/p2p_repository.dart';

class P2PDisputeDetailPage extends ConsumerStatefulWidget {
  const P2PDisputeDetailPage({
    super.key,
    required this.disputeId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc218_p2p_dispute_detail_content');
  static const escalateKey = Key('sc218_p2p_dispute_detail_escalate');
  static const addEvidenceKey = Key('sc218_p2p_dispute_detail_add_evidence');
  static const manageEvidenceKey = Key(
    'sc218_p2p_dispute_detail_manage_evidence',
  );
  static const disputesKey = Key('sc218_p2p_dispute_detail_disputes');
  static const inputKey = Key('sc218_p2p_dispute_detail_input');
  static const sendKey = Key('sc218_p2p_dispute_detail_send');

  final String disputeId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PDisputeDetailPage> createState() =>
      _P2PDisputeDetailPageState();
}

class _P2PDisputeDetailPageState extends ConsumerState<P2PDisputeDetailPage> {
  late final TextEditingController _controller;
  final List<P2PDisputeEvidenceDraft> _localEvidence = [];
  final List<P2PDisputeSupportMessageDraft> _localMessages = [];
  int? _currentLevel;

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
    final snapshot = ref
        .watch(p2pRepositoryProvider)
        .getDisputeDetail(widget.disputeId);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;
    final level = _currentLevel ?? snapshot.dispute.currentLevel;
    final currentLevel = snapshot.levelByNumber(level);
    final nextLevel = level < snapshot.levels.length
        ? snapshot.levelByNumber(level + 1)
        : null;
    final evidence = [...snapshot.evidence, ..._localEvidence];
    final messages = [...snapshot.supportMessages, ..._localMessages];

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-218 P2PDisputeDetailPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Chi tiết khiếu nại',
              subtitle: 'Tranh chấp · P2P',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2pDisputes),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: P2PDisputeDetailPage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.contentPad,
                    AppSpacing.x4,
                    AppSpacing.contentPad,
                    bottomInset,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _StatusBanner(dispute: snapshot.dispute),
                      const SizedBox(height: AppSpacing.x4),
                      _EscalationCard(
                        levels: snapshot.levels,
                        currentLevel: level,
                        currentLevelData: currentLevel,
                        nextLevelData: nextLevel,
                        onEscalate: nextLevel == null
                            ? null
                            : () => _escalate(nextLevel),
                      ),
                      const SizedBox(height: AppSpacing.x4),
                      _ReasonCard(dispute: snapshot.dispute),
                      const SizedBox(height: AppSpacing.x4),
                      _EvidenceCard(
                        evidence: evidence,
                        onAdd: () => context.go(
                          AppRoutePaths.p2pDisputeEvidence(snapshot.dispute.id),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x4),
                      _TimelineCard(timeline: snapshot.timeline),
                      const SizedBox(height: AppSpacing.x4),
                      _SupportChatCard(
                        currentLevel: level,
                        messages: messages,
                        controller: _controller,
                        onChanged: () => setState(() {}),
                        onSend: () => _sendMessage(),
                      ),
                      const SizedBox(height: AppSpacing.x4),
                      _ActionsCard(dispute: snapshot.dispute),
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

  void _escalate(P2PDisputeLevelDraft nextLevel) {
    HapticFeedback.mediumImpact();
    setState(() {
      _currentLevel = nextLevel.level;
      _localMessages.add(
        P2PDisputeSupportMessageDraft(
          id: 'local-escalate-${nextLevel.level}',
          sender: P2PDisputeMessageSender.support,
          text:
              'Khiếu nại đã được chuyển lên Cấp ${nextLevel.level} (${nextLevel.shortLabel}). Thời gian xử lý dự kiến: ${nextLevel.avgTime}.',
          time: '09:15',
        ),
      );
    });
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    HapticFeedback.selectionClick();
    setState(() {
      _localMessages.add(
        P2PDisputeSupportMessageDraft(
          id: 'local-message-${_localMessages.length}',
          sender: P2PDisputeMessageSender.user,
          text: text,
          time: '09:20',
        ),
      );
      _controller.clear();
    });
  }
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({required this.dispute});

  final P2PDisputeDraft dispute;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(dispute.status);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.x4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .08),
        border: Border.all(color: color.withValues(alpha: .22)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .12),
              borderRadius: AppRadii.inputRadius,
            ),
            child: Icon(_statusIcon(dispute.status), color: color, size: 24),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dispute.statusLabel,
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: color,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Đơn hàng #${dispute.orderNumber}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EscalationCard extends StatelessWidget {
  const _EscalationCard({
    required this.levels,
    required this.currentLevel,
    required this.currentLevelData,
    required this.nextLevelData,
    required this.onEscalate,
  });

  final List<P2PDisputeLevelDraft> levels;
  final int currentLevel;
  final P2PDisputeLevelDraft currentLevelData;
  final P2PDisputeLevelDraft? nextLevelData;
  final VoidCallback? onEscalate;

  @override
  Widget build(BuildContext context) {
    final color = _levelColor(currentLevel);
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.shield_outlined,
                color: AppColors.text1,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Cấp độ xử lý',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              _SmallPill(label: 'Cấp $currentLevel/4', color: color),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var index = 0; index < levels.length; index++) ...[
                Expanded(
                  child: _LevelNode(
                    level: levels[index],
                    isCompleted: levels[index].level < currentLevel,
                    isActive: levels[index].level == currentLevel,
                  ),
                ),
                if (index < levels.length - 1)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 17),
                      child: Container(
                        height: 2,
                        color: levels[index].level < currentLevel
                            ? _levelColor(levels[index].level)
                            : AppColors.borderSolid,
                      ),
                    ),
                  ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          VitCard(
            variant: VitCardVariant.inner,
            borderColor: color.withValues(alpha: .18),
            padding: const EdgeInsets.all(AppSpacing.x3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: AppSpacing.x6,
                  height: AppSpacing.x6,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: AppRadii.smRadius,
                  ),
                  child: Icon(
                    _levelIcon(currentLevelData.iconKey),
                    color: Colors.white,
                    size: AppSpacing.iconSm,
                  ),
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cấp $currentLevel: ${currentLevelData.shortLabel}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        currentLevelData.description,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x2),
                      Row(
                        children: [
                          const Icon(
                            Icons.schedule_rounded,
                            color: AppColors.text3,
                            size: 11,
                          ),
                          const SizedBox(width: AppSpacing.x1),
                          Text(
                            'Dự kiến: ${currentLevelData.avgTime}',
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (nextLevelData != null) ...[
            const SizedBox(height: AppSpacing.x3),
            Material(
              color: AppColors.warn10,
              borderRadius: AppRadii.inputRadius,
              child: InkWell(
                key: P2PDisputeDetailPage.escalateKey,
                onTap: onEscalate,
                borderRadius: AppRadii.inputRadius,
                child: Container(
                  constraints: const BoxConstraints(
                    minHeight: AppSpacing.inputHeight,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.x3,
                    vertical: AppSpacing.x3,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.warn15),
                    borderRadius: AppRadii.inputRadius,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.arrow_upward_rounded,
                        color: AppColors.warn,
                        size: AppSpacing.iconSm,
                      ),
                      const SizedBox(width: AppSpacing.x2),
                      Expanded(
                        child: Text(
                          'Chuyển lên Cấp ${nextLevelData!.level}: ${nextLevelData!.shortLabel}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.warn,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.warn,
                        size: AppSpacing.iconSm,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _LevelNode extends StatelessWidget {
  const _LevelNode({
    required this.level,
    required this.isCompleted,
    required this.isActive,
  });

  final P2PDisputeLevelDraft level;
  final bool isCompleted;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final color = _levelColor(level.level);
    return Opacity(
      opacity: isActive || isCompleted ? 1 : .42,
      child: Column(
        children: [
          Container(
            width: 37,
            height: 37,
            decoration: BoxDecoration(
              color: isActive
                  ? color
                  : isCompleted
                  ? color.withValues(alpha: .12)
                  : AppColors.surface2,
              borderRadius: AppRadii.inputRadius,
              border: isActive ? null : Border.all(color: color),
            ),
            child: Icon(
              isCompleted
                  ? Icons.check_circle_outline_rounded
                  : _levelIcon(level.iconKey),
              color: isActive ? Colors.white : color,
              size: AppSpacing.iconSm,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            level.shortLabel,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: isActive ? color : AppColors.text3,
              fontWeight: isActive ? AppTextStyles.bold : AppTextStyles.medium,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReasonCard extends StatelessWidget {
  const _ReasonCard({required this.dispute});

  final P2PDisputeDraft dispute;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lý do khiếu nại',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            dispute.reason,
            style: AppTextStyles.body.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x3),
          const Divider(color: AppColors.divider, height: 1),
          const SizedBox(height: AppSpacing.x3),
          Text(
            'Mô tả chi tiết',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            dispute.description,
            style: AppTextStyles.body.copyWith(color: AppColors.text2),
          ),
        ],
      ),
    );
  }
}

class _EvidenceCard extends StatelessWidget {
  const _EvidenceCard({required this.evidence, required this.onAdd});

  final List<P2PDisputeEvidenceDraft> evidence;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Bằng chứng (${evidence.length})',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              _SmallButton(
                key: P2PDisputeDetailPage.addEvidenceKey,
                icon: Icons.upload_outlined,
                label: 'Thêm',
                color: AppModuleAccents.p2p,
                onPressed: onAdd,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              for (final item in evidence)
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.surface2,
                    border: Border.all(color: AppColors.borderSolid),
                    borderRadius: AppRadii.inputRadius,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(
                        Icons.image_outlined,
                        color: AppColors.text3,
                        size: AppSpacing.iconMd,
                      ),
                      Positioned(
                        left: AppSpacing.x1,
                        right: AppSpacing.x1,
                        bottom: AppSpacing.x1,
                        child: Text(
                          item.fileName,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                            fontSize: 8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimelineCard extends StatelessWidget {
  const _TimelineCard({required this.timeline});

  final List<P2PDisputeTimelineDraft> timeline;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tiến trình',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          for (var index = 0; index < timeline.length; index++)
            _TimelineItem(
              item: timeline[index],
              isLast: index == timeline.length - 1,
            ),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({required this.item, required this.isLast});

  final P2PDisputeTimelineDraft item;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final color = item.active ? AppModuleAccents.p2p : AppColors.buy;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: color.withValues(alpha: .35)),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: AppSpacing.x6,
                color: AppColors.borderSolid,
              ),
          ],
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.x3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.event,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                if (item.detail != null) ...[
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    item.detail!,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
                const SizedBox(height: AppSpacing.x1),
                Text(
                  item.time,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SupportChatCard extends StatelessWidget {
  const _SupportChatCard({
    required this.currentLevel,
    required this.messages,
    required this.controller,
    required this.onChanged,
    required this.onSend,
  });

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
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.x4,
              vertical: AppSpacing.x3,
            ),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(bottom: BorderSide(color: AppColors.divider)),
            ),
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
                _SmallPill(
                  label: 'Cấp $currentLevel',
                  color: _levelColor(currentLevel),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.x4),
            child: Column(
              children: [
                for (final message in messages)
                  _SupportMessageBubble(message: message),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.x4,
              AppSpacing.x3,
              AppSpacing.x4,
              AppSpacing.x3,
            ),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.divider)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    key: P2PDisputeDetailPage.inputKey,
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
                  child: InkWell(
                    key: P2PDisputeDetailPage.sendKey,
                    onTap: onSend,
                    customBorder: const CircleBorder(),
                    child: const SizedBox(
                      width: 38,
                      height: 38,
                      child: Icon(
                        Icons.send_rounded,
                        color: AppColors.text1,
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
      child: Container(
        constraints: const BoxConstraints(maxWidth: 300),
        margin: const EdgeInsets.only(bottom: AppSpacing.x3),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x3,
          vertical: AppSpacing.x2,
        ),
        decoration: BoxDecoration(
          color: isUser ? AppModuleAccents.p2p : AppColors.surface2,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
        ),
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
                color: isUser ? Colors.white : AppColors.text1,
                fontWeight: AppTextStyles.medium,
              ),
            ),
            const SizedBox(height: AppSpacing.x1),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                message.time,
                style: AppTextStyles.micro.copyWith(
                  color: isUser ? Colors.white70 : AppColors.text3,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionsCard extends StatelessWidget {
  const _ActionsCard({required this.dispute});

  final P2PDisputeDraft dispute;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.description_outlined,
                color: AppColors.text1,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Hành động',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          _ActionTile(
            key: P2PDisputeDetailPage.manageEvidenceKey,
            icon: Icons.upload_outlined,
            title: 'Quản lý bằng chứng',
            subtitle: 'Upload & xem tài liệu đã gửi',
            color: AppModuleAccents.p2p,
            onTap: () =>
                context.go(AppRoutePaths.p2pDisputeEvidence(dispute.id)),
          ),
          const SizedBox(height: AppSpacing.x2),
          _ActionTile(
            key: P2PDisputeDetailPage.disputesKey,
            icon: Icons.balance_rounded,
            title: 'Danh sách tranh chấp',
            subtitle: 'Xem tất cả tranh chấp của bạn',
            color: AppColors.text2,
            onTap: () => context.go(AppRoutePaths.p2pDisputes),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: .08),
      borderRadius: AppRadii.inputRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: Container(
          constraints: const BoxConstraints(
            minHeight: AppSpacing.buttonStandard,
          ),
          padding: const EdgeInsets.all(AppSpacing.x3),
          decoration: BoxDecoration(
            border: Border.all(color: color.withValues(alpha: .18)),
            borderRadius: AppRadii.inputRadius,
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .14),
                  borderRadius: AppRadii.smRadius,
                ),
                child: Icon(icon, color: color, size: AppSpacing.iconSm),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
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
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.text3,
                size: AppSpacing.iconSm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SmallPill extends StatelessWidget {
  const _SmallPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            height: 1.2,
          ),
        ),
      ),
    );
  }
}

class _SmallButton extends StatelessWidget {
  const _SmallButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: .10),
      borderRadius: AppRadii.inputRadius,
      child: InkWell(
        onTap: onPressed,
        borderRadius: AppRadii.inputRadius,
        child: Container(
          height: AppSpacing.buttonCompact,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x3),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 13),
              const SizedBox(width: AppSpacing.x1),
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
    );
  }
}

Color _statusColor(P2PDisputeStatus status) {
  return switch (status) {
    P2PDisputeStatus.submitted => AppColors.warn,
    P2PDisputeStatus.underReview => AppModuleAccents.p2p,
    P2PDisputeStatus.resolved => AppColors.buy,
    P2PDisputeStatus.rejected => AppColors.sell,
  };
}

IconData _statusIcon(P2PDisputeStatus status) {
  return switch (status) {
    P2PDisputeStatus.submitted => Icons.schedule_rounded,
    P2PDisputeStatus.underReview => Icons.description_outlined,
    P2PDisputeStatus.resolved => Icons.check_circle_outline_rounded,
    P2PDisputeStatus.rejected => Icons.warning_amber_rounded,
  };
}

Color _levelColor(int level) {
  return switch (level) {
    1 => AppModuleAccents.p2p,
    2 => AppColors.accent,
    3 => AppColors.warn,
    _ => AppColors.sell,
  };
}

IconData _levelIcon(String iconKey) {
  return switch (iconKey) {
    'bot' => Icons.smart_toy_outlined,
    'support' => Icons.support_agent_rounded,
    'scale' => Icons.balance_rounded,
    'briefcase' => Icons.business_center_outlined,
    _ => Icons.shield_outlined,
  };
}
