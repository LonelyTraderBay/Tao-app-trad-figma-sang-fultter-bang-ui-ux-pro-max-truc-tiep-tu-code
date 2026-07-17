import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/support/data/repositories/mock_support_repository.dart';
import 'package:vit_trade_flutter/features/support/presentation/controllers/support_controller.dart';

void main() {
  group('SupportController', () {
    test('exposes support snapshots through repository contract', () {
      final controller = const SupportController(MockSupportRepository());

      final hub = controller.getSupportHub();
      final help = controller.getHelpCenter();
      final announcements = controller.getAnnouncements();

      expect(hub.endpoint, '/api/mobile/support/support');
      expect(hub.tickets, isNotEmpty);
      expect(help.articles, isNotEmpty);
      expect(announcements.announcements, isNotEmpty);
      expect(hub.supportedStates, contains(SupportScreenState.offline));
    });
  });
}
