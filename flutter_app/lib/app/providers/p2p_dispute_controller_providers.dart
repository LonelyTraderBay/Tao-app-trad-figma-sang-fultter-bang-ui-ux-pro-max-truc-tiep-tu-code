import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/features/p2p_core/data/providers/p2p_repository_provider.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/controllers/p2p_controller.dart';

export 'package:vit_trade_flutter/features/p2p_core/presentation/controllers/p2p_controller.dart';

final p2pDisputeDetailProvider =
    FutureProvider.family<P2PDisputeDetailSnapshot, String>(
      (ref, disputeId) =>
          ref.watch(p2pTrustRepositoryProvider).getDisputeDetail(disputeId),
    );

final p2pDisputeEvidenceProvider =
    FutureProvider.family<P2PDisputeEvidenceSnapshot, String>(
      (ref, disputeId) =>
          ref.watch(p2pTrustRepositoryProvider).getDisputeEvidence(disputeId),
    );

// GD4-F5 (STATE-S25 khuôn): Provider<AsyncValue<Controller>> — .whenData()
// map dong bo tu snapshot da FutureProvider-hoa, tranh 1 tang Future/
// microtask thua so voi FutureProvider<Controller>. Trang van goi .when()
// nhu moi snapshot provider khac.
final p2pDisputeEvidenceControllerProvider =
    Provider.family<AsyncValue<P2PDisputeEvidenceController>, String>((
      ref,
      disputeId,
    ) {
      return ref
          .watch(p2pDisputeEvidenceProvider(disputeId))
          .whenData(
            (snapshot) => P2PDisputeEvidenceController(
              state: P2PDisputeEvidenceViewState(snapshot: snapshot),
            ),
          );
    });

final p2pDisputeResolutionProvider =
    FutureProvider.family<P2PDisputeResolutionSnapshot, String>(
      (ref, disputeId) =>
          ref.watch(p2pTrustRepositoryProvider).getDisputeResolution(disputeId),
    );

final p2pDisputeOpenProvider =
    FutureProvider.family<P2PDisputeOpenSnapshot, String>(
      (ref, orderId) =>
          ref.watch(p2pTrustRepositoryProvider).getDisputeOpen(orderId),
    );

final p2pDisputesProvider = FutureProvider<P2PDisputesSnapshot>(
  (ref) => ref.watch(p2pTrustRepositoryProvider).getDisputes(),
);

final p2pInsuranceFundProvider = FutureProvider<P2PInsuranceFundSnapshot>(
  (ref) => ref.watch(p2pTrustRepositoryProvider).getInsuranceFund(),
);

final p2pInsuranceCertificateProvider =
    FutureProvider<P2PInsuranceCertificateSnapshot>(
      (ref) => ref.watch(p2pTrustRepositoryProvider).getInsuranceCertificate(),
    );

final p2pInsuranceScoreProvider = FutureProvider<P2PInsuranceScoreSnapshot>(
  (ref) => ref.watch(p2pTrustRepositoryProvider).getInsuranceScore(),
);

final p2pInsurancePolicyProvider = FutureProvider<P2PInsurancePolicySnapshot>(
  (ref) => ref.watch(p2pTrustRepositoryProvider).getInsurancePolicy(),
);

final p2pClaimDetailProvider =
    FutureProvider.family<P2PClaimDetailSnapshot, String>(
      (ref, claimId) =>
          ref.watch(p2pTrustRepositoryProvider).getClaimDetail(claimId),
    );
