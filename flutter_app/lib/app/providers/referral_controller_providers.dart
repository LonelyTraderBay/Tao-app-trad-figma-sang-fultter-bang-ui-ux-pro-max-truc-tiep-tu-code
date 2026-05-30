import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/features/referral/data/providers/referral_repository_provider.dart';
import 'package:vit_trade_flutter/features/referral/presentation/controllers/referral_controller.dart';

export 'package:vit_trade_flutter/features/referral/presentation/controllers/referral_controller.dart';

final referralControllerProvider = Provider<ReferralController>((ref) {
  return ReferralController(ref.watch(referralRepositoryProvider));
});
