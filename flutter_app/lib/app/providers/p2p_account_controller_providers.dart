import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/features/p2p_core/data/providers/p2p_repository_provider.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/controllers/p2p_controller.dart';

export 'package:vit_trade_flutter/features/p2p_core/presentation/controllers/p2p_controller.dart';

final p2pMerchantApplyProvider = FutureProvider<P2PMerchantApplySnapshot>(
  (ref) => ref.watch(p2pAccountRepositoryProvider).getMerchantApply(),
);

final p2pMerchantProfileProvider =
    FutureProvider.family<P2PMerchantProfileSnapshot, String>(
      (ref, merchantId) => ref
          .watch(p2pAccountRepositoryProvider)
          .getMerchantProfile(merchantId),
    );

final p2pPaymentMethodAddProvider = FutureProvider<P2PPaymentMethodAddSnapshot>(
  (ref) => ref.watch(p2pAccountRepositoryProvider).getPaymentMethodAdd(),
);

final p2pPaymentMethodVerificationProvider =
    FutureProvider.family<P2PPaymentMethodVerificationSnapshot, String>(
      (ref, methodId) => ref
          .watch(p2pAccountRepositoryProvider)
          .getPaymentMethodVerification(methodId),
    );

final p2pPaymentMethodOwnershipProvider =
    FutureProvider.family<P2PPaymentMethodOwnershipSnapshot, String>(
      (ref, methodId) => ref
          .watch(p2pAccountRepositoryProvider)
          .getPaymentMethodOwnership(methodId),
    );

// GD4-F5 (STATE-S25 khuôn): Provider<AsyncValue<Controller>>.
final p2pPaymentMethodOwnershipControllerProvider =
    Provider.family<AsyncValue<P2PPaymentMethodOwnershipController>, String>((
      ref,
      methodId,
    ) {
      return ref
          .watch(p2pPaymentMethodOwnershipProvider(methodId))
          .whenData(
            (snapshot) => P2PPaymentMethodOwnershipController(
              state: P2PPaymentMethodOwnershipViewState(snapshot: snapshot),
            ),
          );
    });

final p2pPaymentMethodCoolingPeriodProvider =
    FutureProvider<P2PPaymentMethodCoolingPeriodSnapshot>(
      (ref) => ref
          .watch(p2pAccountRepositoryProvider)
          .getPaymentMethodCoolingPeriod(),
    );

// GD4-F5 (STATE-S25 khuôn): Provider<AsyncValue<Controller>>.
final p2pPaymentMethodCoolingPeriodControllerProvider =
    Provider<AsyncValue<P2PPaymentMethodCoolingPeriodController>>((ref) {
      return ref
          .watch(p2pPaymentMethodCoolingPeriodProvider)
          .whenData(
            (snapshot) => P2PPaymentMethodCoolingPeriodController(
              state: P2PPaymentMethodCoolingPeriodViewState(snapshot: snapshot),
            ),
          );
    });

final p2pPaymentMethodHistoryProvider =
    FutureProvider<P2PPaymentMethodHistorySnapshot>(
      (ref) =>
          ref.watch(p2pAccountRepositoryProvider).getPaymentMethodHistory(),
    );

final p2pPaymentMethodsProvider = FutureProvider<P2PPaymentMethodsSnapshot>(
  (ref) => ref.watch(p2pAccountRepositoryProvider).getPaymentMethods(),
);

final p2pKycRequirementsProvider = FutureProvider<P2PKycRequirementsSnapshot>(
  (ref) => ref.watch(p2pAccountRepositoryProvider).getKycRequirements(),
);

final p2pKycStatusProvider = FutureProvider<P2PKycStatusSnapshot>(
  (ref) => ref.watch(p2pAccountRepositoryProvider).getKycStatus(),
);

final p2pIdentityVerificationProvider =
    FutureProvider<P2PIdentityVerificationSnapshot>(
      (ref) =>
          ref.watch(p2pAccountRepositoryProvider).getIdentityVerification(),
    );

final p2pAddressProofProvider = FutureProvider<P2PAddressProofSnapshot>(
  (ref) => ref.watch(p2pAccountRepositoryProvider).getAddressProof(),
);

final p2pSelfieVerificationProvider =
    FutureProvider<P2PSelfieVerificationSnapshot>(
      (ref) => ref.watch(p2pAccountRepositoryProvider).getSelfieVerification(),
    );

final p2pVideoVerificationProvider =
    FutureProvider<P2PVideoVerificationSnapshot>(
      (ref) => ref.watch(p2pAccountRepositoryProvider).getVideoVerification(),
    );
