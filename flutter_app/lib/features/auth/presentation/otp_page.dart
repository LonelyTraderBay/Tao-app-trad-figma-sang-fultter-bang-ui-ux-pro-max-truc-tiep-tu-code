import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_content.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/auth_repository.dart';

const _authPrimary = Color(0xFF3B82F6);
const _authPrimary10 = Color(0x1A3B82F6);
const _authPrimary30 = Color(0x4D3B82F6);
const _otpBoxSize = 48.0;
const _otpBoxHeight = 56.0;
const _freezeAuthCountdownForQa = bool.fromEnvironment('FREEZE_AUTH_COUNTDOWN');

class OtpPageRouteArgs {
  const OtpPageRouteArgs({this.contact, this.contactType, this.purpose});

  final String? contact;
  final AuthContactType? contactType;
  final AuthOtpPurpose? purpose;
}

class OTPPage extends ConsumerStatefulWidget {
  const OTPPage({
    super.key,
    this.contact = 'your@email.com',
    this.contactType = AuthContactType.email,
    this.purpose = AuthOtpPurpose.verify,
  });

  final String contact;
  final AuthContactType contactType;
  final AuthOtpPurpose purpose;

  static const contentKey = Key('sc003_otp_content');
  static const submitKey = Key('sc003_otp_submit');
  static const resendKey = Key('sc003_otp_resend');

  static Key digitFieldKey(int index) => Key('sc003_otp_digit_$index');

  @override
  ConsumerState<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends ConsumerState<OTPPage> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;
  Timer? _timer;

  bool _submitting = false;
  bool _canResend = false;
  int _countdown = 58;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(6, (_) => TextEditingController());
    _focusNodes = List.generate(6, (_) => FocusNode());
    _startCountdown();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNodes.first.requestFocus();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  String get _code => _controllers.map((controller) => controller.text).join();

  int get _filledCount =>
      _controllers.where((controller) => controller.text.isNotEmpty).length;

  void _startCountdown() {
    _timer?.cancel();
    if (_freezeAuthCountdownForQa) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_countdown <= 0) {
        timer.cancel();
        setState(() => _canResend = true);
        return;
      }
      setState(() => _countdown -= 1);
    });
  }

  void _handleChanged(int index, String value) {
    final digit = value.replaceAll(RegExp(r'\D'), '');
    final normalized = digit.isEmpty ? '' : digit[digit.length - 1];
    if (_controllers[index].text != normalized) {
      _controllers[index].value = TextEditingValue(
        text: normalized,
        selection: TextSelection.collapsed(offset: normalized.length),
      );
    }

    if (_error.isNotEmpty) setState(() => _error = '');
    if (normalized.isNotEmpty && index < _focusNodes.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }
    if (_filledCount == 6) {
      _handleVerify();
    } else {
      setState(() {});
    }
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event, int index) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  Future<void> _handleVerify() async {
    if (_submitting || _filledCount < 6) return;
    setState(() {
      _submitting = true;
      _error = '';
    });

    try {
      final result = await ref
          .read(authRepositoryProvider)
          .verifyFactor(
            contact: widget.contact,
            code: _code,
            purpose: widget.purpose,
          );

      if (!mounted) return;
      if (!result.success) {
        _clearOtp(
          error: result.errorMessage ?? 'Mã OTP không đúng. Vui lòng thử lại.',
        );
        return;
      }

      switch (widget.purpose) {
        case AuthOtpPurpose.register:
          context.go(AppRoutePaths.auth2faSetup);
        case AuthOtpPurpose.twoFactor:
          context.go(AppRoutePaths.home);
        case AuthOtpPurpose.passwordReset:
          context.go(
            '${AppRoutePaths.authResetPassword}?email=${Uri.encodeComponent(widget.contact)}&otp=$_code',
          );
        case AuthOtpPurpose.verify:
          context.go(AppRoutePaths.authResetPassword);
      }
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  void _clearOtp({required String error}) {
    for (final controller in _controllers) {
      controller.clear();
    }
    setState(() => _error = error);
    _focusNodes.first.requestFocus();
  }

  void _handleResend() {
    if (!_canResend) return;
    for (final controller in _controllers) {
      controller.clear();
    }
    setState(() {
      _canResend = false;
      _countdown = 59;
      _error = '';
    });
    _focusNodes.first.requestFocus();
    _startCountdown();
  }

  @override
  Widget build(BuildContext context) {
    final filled = _filledCount;

    return VitPageLayout(
      semanticLabel: 'SC-003 OTPPage',
      child: Column(
        children: [
          VitHeader(
            title: 'Xác minh OTP',
            subtitle: 'Xác thực · Bảo mật',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.authLogin),
          ),
          Expanded(
            child: SingleChildScrollView(
              key: OTPPage.contentKey,
              padding: const EdgeInsets.only(bottom: AppSpacing.x6),
              child: VitPageContent(
                padding: VitContentPadding.relaxed,
                gap: VitContentGap.relaxed,
                children: [
                  const _ShieldHero(),
                  _OtpIntro(contact: widget.contact),
                  _OtpDigitRow(
                    controllers: _controllers,
                    focusNodes: _focusNodes,
                    hasError: _error.isNotEmpty,
                    onChanged: _handleChanged,
                    onKey: _handleKey,
                  ),
                  _OtpProgress(filled: filled),
                  if (_error.isNotEmpty) _OtpErrorBanner(error: _error),
                  VitCtaButton(
                    key: OTPPage.submitKey,
                    onPressed: filled < 6 || _submitting ? null : _handleVerify,
                    loading: _submitting,
                    variant: VitCtaButtonVariant.auth,
                    child: Text(_submitting ? 'Đang xác minh...' : 'Xác nhận'),
                  ),
                  _ResendControl(
                    canResend: _canResend,
                    countdown: _countdown,
                    onResend: _handleResend,
                  ),
                  Text(
                    'Không nhận được? Kiểm tra thư mục Spam hoặc\n'
                    'đảm bảo email / SĐT chính xác.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                      fontSize: 12,
                      height: 1.5,
                    ),
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

class _ShieldHero extends StatelessWidget {
  const _ShieldHero();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: _authPrimary10,
          borderRadius: AppRadii.cardLargeRadius,
          border: Border.all(color: _authPrimary30, width: 1.5),
        ),
        child: const Icon(
          Icons.gpp_good_outlined,
          color: _authPrimary,
          size: 40,
        ),
      ),
    );
  }
}

class _OtpIntro extends StatelessWidget {
  const _OtpIntro({required this.contact});

  final String contact;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Nhập mã xác minh',
          textAlign: TextAlign.center,
          style: AppTextStyles.sectionTitle.copyWith(fontSize: 24),
        ),
        const SizedBox(height: AppSpacing.x3),
        Text.rich(
          TextSpan(
            text: 'Chúng tôi đã gửi mã 6 chữ số đến ',
            children: [
              TextSpan(
                text: contact,
                style: const TextStyle(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            height: 1.6,
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text.rich(
          const TextSpan(
            text: '(Demo: nhập ',
            children: [
              TextSpan(
                text: '123456',
                style: TextStyle(color: _authPrimary),
              ),
              TextSpan(text: ')'),
            ],
          ),
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text3,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _OtpDigitRow extends StatelessWidget {
  const _OtpDigitRow({
    required this.controllers,
    required this.focusNodes,
    required this.hasError,
    required this.onChanged,
    required this.onKey,
  });

  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final bool hasError;
  final void Function(int index, String value) onChanged;
  final KeyEventResult Function(FocusNode node, KeyEvent event, int index)
  onKey;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var index = 0; index < controllers.length; index++) ...[
          if (index > 0) const SizedBox(width: 12),
          _OtpDigitField(
            index: index,
            controller: controllers[index],
            focusNode: focusNodes[index],
            hasError: hasError,
            onChanged: (value) => onChanged(index, value),
            onKey: (node, event) => onKey(node, event, index),
          ),
        ],
      ],
    );
  }
}

class _OtpDigitField extends StatelessWidget {
  const _OtpDigitField({
    required this.index,
    required this.controller,
    required this.focusNode,
    required this.hasError,
    required this.onChanged,
    required this.onKey,
  });

  final int index;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool hasError;
  final ValueChanged<String> onChanged;
  final FocusOnKeyEventCallback onKey;

  @override
  Widget build(BuildContext context) {
    final filled = controller.text.isNotEmpty;
    final borderColor = hasError
        ? AppColors.sell
        : filled
        ? _authPrimary
        : AppColors.borderSolid;
    final background = filled ? _authPrimary10 : AppColors.surface2;

    return SizedBox(
      width: _otpBoxSize,
      height: _otpBoxHeight,
      child: Focus(
        onKeyEvent: onKey,
        child: TextField(
          key: OTPPage.digitFieldKey(index),
          controller: controller,
          focusNode: focusNode,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          textInputAction: index == 5
              ? TextInputAction.done
              : TextInputAction.next,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(1),
          ],
          style: AppTextStyles.sectionTitle.copyWith(
            fontSize: 24,
            fontWeight: AppTextStyles.bold,
          ),
          cursorColor: _authPrimary,
          decoration: InputDecoration(
            counterText: '',
            filled: true,
            fillColor: background,
            contentPadding: EdgeInsets.zero,
            border: _border(borderColor),
            enabledBorder: _border(borderColor),
            focusedBorder: _border(_authPrimary, width: 2),
            errorBorder: _border(AppColors.sell),
            focusedErrorBorder: _border(AppColors.sell, width: 2),
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }

  OutlineInputBorder _border(Color color, {double width = 1.5}) {
    return OutlineInputBorder(
      borderRadius: AppRadii.inputRadius,
      borderSide: BorderSide(color: color, width: width),
    );
  }
}

class _OtpProgress extends StatelessWidget {
  const _OtpProgress({required this.filled});

  final int filled;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var index = 0; index < 6; index++) ...[
          if (index > 0) const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                color: index < filled ? _authPrimary : AppColors.borderSolid,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _OtpErrorBanner extends StatelessWidget {
  const _OtpErrorBanner({required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.sell10,
        borderRadius: AppRadii.mdRadius,
        border: Border.all(color: AppColors.sell20),
      ),
      child: Text(
        error,
        textAlign: TextAlign.center,
        style: AppTextStyles.caption.copyWith(color: AppColors.sell),
      ),
    );
  }
}

class _ResendControl extends StatelessWidget {
  const _ResendControl({
    required this.canResend,
    required this.countdown,
    required this.onResend,
  });

  final bool canResend;
  final int countdown;
  final VoidCallback onResend;

  @override
  Widget build(BuildContext context) {
    final timer = '0:${countdown.toString().padLeft(2, '0')}';

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.refresh_rounded,
          size: 14,
          color: canResend ? _authPrimary : AppColors.text3,
        ),
        const SizedBox(width: AppSpacing.x3),
        if (canResend)
          TextButton(
            key: OTPPage.resendKey,
            onPressed: onResend,
            style: TextButton.styleFrom(
              foregroundColor: _authPrimary,
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 32),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Gửi lại mã OTP',
              style: AppTextStyles.caption.copyWith(
                color: _authPrimary,
                fontWeight: AppTextStyles.medium,
              ),
            ),
          )
        else
          Text.rich(
            TextSpan(
              text: 'Gửi lại sau ',
              children: [
                TextSpan(
                  text: timer,
                  style: const TextStyle(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
      ],
    );
  }
}
