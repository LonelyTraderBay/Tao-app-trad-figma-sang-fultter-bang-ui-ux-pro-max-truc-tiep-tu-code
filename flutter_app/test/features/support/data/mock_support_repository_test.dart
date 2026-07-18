import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/support/data/support_repository.dart';

/// Direct smoke test for [MockSupportRepository]: exercises every method on
/// [SupportRepository] and pins fixture literals from
/// lib/features/support/data/repositories/mock_support_repository.dart that
/// test/features/support/mock_support_repository_test.dart only asserts the
/// shape of (hasLength/isNotEmpty).
///
/// Contextual support routing (ProductSupportContext / supportRouteFor) is
/// not a method on [SupportRepository] — it lives in
/// lib/core/product_flow/contextual_support_contract.dart and is already
/// covered by test/core/product_flow/contextual_support_contract_test.dart.
void main() {
  const repository = MockSupportRepository(loadDelay: Duration.zero);

  group('MockSupportRepository smoke test', () {
    test(
      'getSupportHub pins the endpoint, routes and ticket fixture',
      () async {
        final snapshot = await repository.getSupportHub();

        expect(snapshot, isA<SupportHubSnapshot>());
        expect(snapshot.endpoint, '/api/mobile/support/support');
        expect(snapshot.helpRoute, '/support/help');
        expect(snapshot.announcementsRoute, '/support/announcements');
        expect(snapshot.email, 'support@vittrade.vn');
        expect(snapshot.tickets, hasLength(2));

        final ticket = snapshot.tickets.first;
        expect(ticket.id, 'ticket001');
        expect(ticket.category, SupportTicketCategory.withdraw);
        expect(ticket.status, SupportTicketStatus.inProgress);
        expect(ticket.priority, SupportTicketPriority.high);
        expect(ticket.messages, hasLength(2));
        expect(ticket.messages.first.id, 'msg001');

        expect(snapshot.faqItems, hasLength(4));
        expect(snapshot.screenState, SupportScreenState.ready);
      },
    );

    test(
      'getHelpCenter pins the endpoint and category/article fixture',
      () async {
        final snapshot = await repository.getHelpCenter();

        expect(snapshot, isA<HelpCenterSnapshot>());
        expect(snapshot.endpoint, '/api/mobile/support/support-help');
        expect(snapshot.backRoute, '/support');
        expect(snapshot.categories, hasLength(8));

        final category = snapshot.categories.first;
        expect(category.id, 'getting-started');
        expect(category.count, 12);

        expect(snapshot.articles, hasLength(8));
        final article = snapshot.articles.first;
        expect(article.id, 'h001');
        expect(article.categoryId, 'getting-started');
        expect(article.views, 15420);
      },
    );

    test(
      'getAnnouncements pins the endpoint and filter/announcement fixture',
      () async {
        final snapshot = await repository.getAnnouncements();

        expect(snapshot, isA<AnnouncementsSnapshot>());
        expect(snapshot.endpoint, '/api/mobile/support/support-announcements');
        expect(snapshot.backRoute, '/support');
        expect(snapshot.filters, hasLength(6));
        expect(snapshot.filters.first.id, 'all');

        expect(snapshot.announcements, hasLength(5));
        final pinned = snapshot.announcements.first;
        expect(pinned.id, 'news001');
        expect(pinned.type, AnnouncementType.promotion);
        expect(pinned.isPinned, isTrue);
        expect(pinned.tags, ['Khuyến mãi', 'BTC', 'Phí']);
      },
    );
  });
}
