import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/enterprise_states/data/enterprise_states_repository.dart';

/// Fixture-pinning test for [MockEnterpriseStatesRepository]: the sole
/// method on [EnterpriseStatesRepository] is already exercised for shape
/// (non-empty lists, populated strings) in
/// `test/features/enterprise_states/mock_enterprise_states_repository_test.dart`.
/// This file pins the exact literal values in the reference fixture — tab
/// order/labels, preview-state copy, banner copy, and resolved CTA routes —
/// so a silent content regression in the mock data fails a test instead of
/// only a visual diff.
void main() {
  const repository = MockEnterpriseStatesRepository();

  group('MockEnterpriseStatesRepository fixture pins', () {
    test('tabs pin section order and labels', () {
      final tabs = repository.getReference().tabs;

      expect(tabs, hasLength(3));
      expect(tabs[0].section, EnterpriseStateSection.stateKit);
      expect(tabs[0].label, 'A — State Kit');
      expect(tabs[1].section, EnterpriseStateSection.applied);
      expect(tabs[1].label, 'B — Applied');
      expect(tabs[2].section, EnterpriseStateSection.security);
      expect(tabs[2].label, 'C — Security');
    });

    test('previewStates pin every state, label, and description', () {
      final previewStates = repository.getReference().previewStates;

      expect(previewStates, hasLength(5));
      expect(previewStates[0].state, EnterprisePreviewState.loading);
      expect(previewStates[0].label, 'Loading');
      expect(previewStates[0].description, 'Preview — loading');
      expect(previewStates[1].state, EnterprisePreviewState.empty);
      expect(previewStates[1].label, 'Empty');
      expect(previewStates[1].description, 'Bạn chưa theo dõi cặp nào');
      expect(previewStates[2].state, EnterprisePreviewState.error);
      expect(previewStates[2].label, 'Error');
      expect(previewStates[2].description, 'Có lỗi xảy ra');
      expect(previewStates[3].state, EnterprisePreviewState.offline);
      expect(previewStates[3].label, 'Offline');
      expect(
        previewStates[3].description,
        'Mất kết nối. Đang hiển thị dữ liệu gần nhất.',
      );
      expect(previewStates[4].state, EnterprisePreviewState.gate);
      expect(previewStates[4].label, 'Gate');
      expect(previewStates[4].description, 'Cần KYC để tiếp tục');
    });

    test('banners pin kind, title, and optional detail', () {
      final banners = repository.getReference().banners;

      expect(banners, hasLength(3));
      expect(banners[0].kind, EnterpriseBannerKind.info);
      expect(banners[0].title, 'Thị trường sẽ bảo trì từ 02:00 – 04:00 UTC.');
      expect(banners[0].detail, isNull);
      expect(banners[1].kind, EnterpriseBannerKind.warning);
      expect(
        banners[1].title,
        'Biến động giá mạnh. Hãy cẩn thận khi giao dịch.',
      );
      expect(banners[1].detail, 'BTC đã thay đổi >5% trong 1 giờ qua.');
      expect(banners[2].kind, EnterpriseBannerKind.error);
      expect(banners[2].title, 'Hệ thống rút tiền tạm ngưng hoạt động.');
      expect(banners[2].detail, isNull);
    });

    test('resolved CTA routes pin the exact handoff destinations', () {
      final snapshot = repository.getReference();

      expect(snapshot.marketRoute, '/markets');
      expect(snapshot.kycRoute, '/profile/kyc');
      expect(snapshot.securityRoute, '/profile/security');
      expect(snapshot.loginRoute, '/auth/login');
      expect(snapshot.backRoute, '/home');
    });
  });
}
