import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/support/data/support_repository.dart';

/// Smoke test for [MockSupportRepository]: exercises every method on
/// [SupportRepository] and asserts each call succeeds without throwing and
/// returns a plausible, non-empty result.
void main() {
  const repository = MockSupportRepository();

  group('MockSupportRepository smoke test', () {
    test('getSupportHub returns a populated snapshot', () {
      final snapshot = repository.getSupportHub();

      expect(snapshot, isA<SupportHubSnapshot>());
      expect(snapshot.endpoint, isNotEmpty);
      expect(snapshot.helpRoute, '/support/help');
      expect(snapshot.announcementsRoute, '/support/announcements');
      expect(snapshot.email, isNotEmpty);
      expect(snapshot.hotline, isNotEmpty);
      expect(snapshot.tickets, hasLength(2));
      expect(snapshot.faqItems, isNotEmpty);
      expect(snapshot.screenState, SupportScreenState.ready);
      expect(snapshot.supportedStates, isNotEmpty);
    });

    test('getSupportHub tickets carry nested message threads', () {
      final snapshot = repository.getSupportHub();

      final ticket = snapshot.tickets.first;
      expect(ticket, isA<SupportTicketDraft>());
      expect(ticket.id, 'ticket001');
      expect(ticket.category, SupportTicketCategory.withdraw);
      expect(ticket.status, SupportTicketStatus.inProgress);
      expect(ticket.priority, SupportTicketPriority.high);
      expect(ticket.messages, isNotEmpty);
      expect(ticket.messages.first, isA<SupportMessageDraft>());
    });

    test('getHelpCenter returns a populated snapshot', () {
      final snapshot = repository.getHelpCenter();

      expect(snapshot, isA<HelpCenterSnapshot>());
      expect(snapshot.endpoint, isNotEmpty);
      expect(snapshot.backRoute, '/support');
      expect(snapshot.searchHint, isNotEmpty);
      expect(snapshot.categories, hasLength(8));
      expect(snapshot.articles, isNotEmpty);
      expect(snapshot.screenState, SupportScreenState.ready);
      expect(snapshot.supportedStates, isNotEmpty);
    });

    test('getHelpCenter categories and articles are well-typed', () {
      final snapshot = repository.getHelpCenter();

      final category = snapshot.categories.first;
      expect(category, isA<HelpCategoryDraft>());
      expect(category.id, 'getting-started');
      expect(category.count, greaterThan(0));

      final article = snapshot.articles.first;
      expect(article, isA<HelpArticleDraft>());
      expect(article.categoryId, isNotEmpty);
      expect(article.views, greaterThan(0));
    });

    test('getAnnouncements returns a populated snapshot', () {
      final snapshot = repository.getAnnouncements();

      expect(snapshot, isA<AnnouncementsSnapshot>());
      expect(snapshot.endpoint, isNotEmpty);
      expect(snapshot.backRoute, '/support');
      expect(snapshot.filters, hasLength(6));
      expect(snapshot.announcements, hasLength(5));
      expect(snapshot.screenState, SupportScreenState.ready);
      expect(snapshot.supportedStates, isNotEmpty);
    });

    test('getAnnouncements filters and entries are well-typed', () {
      final snapshot = repository.getAnnouncements();

      final filter = snapshot.filters.first;
      expect(filter, isA<AnnouncementFilterDraft>());
      expect(filter.id, 'all');
      expect(filter.type, isNull);

      final pinned = snapshot.announcements.first;
      expect(pinned, isA<AnnouncementDraft>());
      expect(pinned.type, AnnouncementType.promotion);
      expect(pinned.isPinned, isTrue);
      expect(pinned.tags, isNotEmpty);
    });
  });
}
