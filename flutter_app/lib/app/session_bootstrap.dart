import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/providers/auth_controller_providers.dart';

/// Khôi phục phiên đăng nhập đã lưu khi app khởi động (GĐ4-F1).
///
/// Bọc quanh [child] và gọi
/// `ref.read(authSessionControllerProvider.notifier).restore()` đúng MỘT
/// lần trong `initState` (qua `Future.microtask` để không đụng provider
/// trong lúc cây widget đầu tiên đang build). Người gọi (composition root
/// — `vit_trade_app.dart`) chịu trách nhiệm gắn widget này vào cây ứng
/// dụng; file đó không thuộc phạm vi thay đổi của batch này.
class SessionBootstrap extends ConsumerStatefulWidget {
  const SessionBootstrap({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<SessionBootstrap> createState() => _SessionBootstrapState();
}

class _SessionBootstrapState extends ConsumerState<SessionBootstrap> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(authSessionControllerProvider.notifier).restore(),
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
