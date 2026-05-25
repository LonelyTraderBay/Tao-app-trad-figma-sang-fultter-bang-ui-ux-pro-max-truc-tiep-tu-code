import 'package:flutter_riverpod/flutter_riverpod.dart';

final enterpriseStatesRepositoryProvider = Provider<EnterpriseStatesRepository>(
  (ref) {
    return const MockEnterpriseStatesRepository();
  },
);

abstract interface class EnterpriseStatesRepository {
  EnterpriseStatesSnapshot getReference();
}

enum EnterpriseStatesScreenState { loading, empty, error, offline }

enum EnterpriseStateSection { stateKit, applied, security }

enum EnterprisePreviewState { loading, empty, error, offline, gate }

enum EnterpriseBannerKind { info, warning, error }

final class EnterpriseStatesSnapshot {
  const EnterpriseStatesSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.subtitle,
    required this.backRoute,
    required this.tabs,
    required this.previewStates,
    required this.banners,
    required this.marketRoute,
    required this.kycRoute,
    required this.securityRoute,
    required this.loginRoute,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String subtitle;
  final String backRoute;
  final List<EnterpriseTabDraft> tabs;
  final List<EnterprisePreviewStateDraft> previewStates;
  final List<EnterpriseBannerDraft> banners;
  final String marketRoute;
  final String kycRoute;
  final String securityRoute;
  final String loginRoute;
  final String contractNotes;
  final Set<EnterpriseStatesScreenState> supportedStates;
}

final class EnterpriseTabDraft {
  const EnterpriseTabDraft({required this.section, required this.label});

  final EnterpriseStateSection section;
  final String label;
}

final class EnterprisePreviewStateDraft {
  const EnterprisePreviewStateDraft({
    required this.state,
    required this.label,
    required this.description,
  });

  final EnterprisePreviewState state;
  final String label;
  final String description;
}

final class EnterpriseBannerDraft {
  const EnterpriseBannerDraft({
    required this.kind,
    required this.title,
    this.detail,
  });

  final EnterpriseBannerKind kind;
  final String title;
  final String? detail;
}

final class MockEnterpriseStatesRepository
    implements EnterpriseStatesRepository {
  const MockEnterpriseStatesRepository();

  @override
  EnterpriseStatesSnapshot getReference() {
    return const EnterpriseStatesSnapshot(
      endpoint: '/api/mobile/enterprise-states/enterprise-states',
      actionDraft: 'read-only or local navigation action',
      title: '02 – Enterprise UI States',
      subtitle: 'UI-only · Không redesign · Match 100% style hiện tại',
      backRoute: '/home',
      tabs: [
        EnterpriseTabDraft(
          section: EnterpriseStateSection.stateKit,
          label: 'A — State Kit',
        ),
        EnterpriseTabDraft(
          section: EnterpriseStateSection.applied,
          label: 'B — Applied',
        ),
        EnterpriseTabDraft(
          section: EnterpriseStateSection.security,
          label: 'C — Security',
        ),
      ],
      previewStates: [
        EnterprisePreviewStateDraft(
          state: EnterprisePreviewState.loading,
          label: 'Loading',
          description: 'Preview — loading',
        ),
        EnterprisePreviewStateDraft(
          state: EnterprisePreviewState.empty,
          label: 'Empty',
          description: 'Bạn chưa theo dõi cặp nào',
        ),
        EnterprisePreviewStateDraft(
          state: EnterprisePreviewState.error,
          label: 'Error',
          description: 'Có lỗi xảy ra',
        ),
        EnterprisePreviewStateDraft(
          state: EnterprisePreviewState.offline,
          label: 'Offline',
          description: 'Mất kết nối. Đang hiển thị dữ liệu gần nhất.',
        ),
        EnterprisePreviewStateDraft(
          state: EnterprisePreviewState.gate,
          label: 'Gate',
          description: 'Cần KYC để tiếp tục',
        ),
      ],
      banners: [
        EnterpriseBannerDraft(
          kind: EnterpriseBannerKind.info,
          title: 'Thị trường sẽ bảo trì từ 02:00 – 04:00 UTC.',
        ),
        EnterpriseBannerDraft(
          kind: EnterpriseBannerKind.warning,
          title: 'Biến động giá mạnh. Hãy cẩn thận khi giao dịch.',
          detail: 'BTC đã thay đổi >5% trong 1 giờ qua.',
        ),
        EnterpriseBannerDraft(
          kind: EnterpriseBannerKind.error,
          title: 'Hệ thống rút tiền tạm ngưng hoạt động.',
        ),
      ],
      marketRoute: '/markets',
      kycRoute: '/profile/kyc',
      securityRoute: '/profile/security',
      loginRoute: '/auth/login',
      contractNotes:
          'Enterprise states is a UI reference screen. State previews use mock reference data; resolved CTAs navigate to markets, KYC, security, and login routes.',
      supportedStates: {
        EnterpriseStatesScreenState.loading,
        EnterpriseStatesScreenState.empty,
        EnterpriseStatesScreenState.error,
        EnterpriseStatesScreenState.offline,
      },
    );
  }
}
