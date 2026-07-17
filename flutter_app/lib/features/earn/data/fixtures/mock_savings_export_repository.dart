part of '../repositories/mock_earn_repository.dart';

final class MockSavingsExportRepository implements SavingsExportRepository {
  const MockSavingsExportRepository();

  @override
  SavingsExportSnapshot getExport() {
    return const SavingsExportSnapshot(
      endpoint: '/api/mobile/earn/earn-savings-export',
      actionDraft:
          'GET /earn/savings/export | POST /exports | POST /earn/subscribe|redeem|claim|vote where applicable',
      title: 'Xuất báo cáo',
      backRoute: '/earn/savings',
      tabs: [
        SavingsPreferenceTabDraft(id: 'create', label: 'Tạo báo cáo'),
        SavingsPreferenceTabDraft(id: 'history', label: 'Lịch sử (4)'),
      ],
      defaultTab: 'create',
      heroLabel: 'Export & Báo cáo',
      createdReports: 4,
      reportTypeCountLabel: '4 loại',
      formatSummary: 'CSV · PDF · Excel',
      retentionLabel: '7 ngày',
      reportTypes: [
        SavingsExportReportDraft(
          id: SavingsExportReportType.transaction,
          title: 'Lịch sử giao dịch',
          description:
              'Xuất tất cả giao dịch tiết kiệm: gửi, rút, nhận lãi, lãi kép',
          iconKey: 'download',
          rowsLabel: '~47 dòng · 8 cột',
        ),
        SavingsExportReportDraft(
          id: SavingsExportReportType.tax,
          title: 'Báo cáo thuế',
          description:
              'Tóm tắt thu nhập lãi tiết kiệm theo năm, phù hợp nộp thuế cá nhân',
          iconKey: 'shield',
          rowsLabel: '~12 dòng · 6 cột',
        ),
        SavingsExportReportDraft(
          id: SavingsExportReportType.portfolio,
          title: 'Ảnh chụp danh mục',
          description:
              'Trạng thái hiện tại của tất cả vị thế tiết kiệm đang hoạt động',
          iconKey: 'portfolio',
          rowsLabel: '~8 dòng · 8 cột',
        ),
        SavingsExportReportDraft(
          id: SavingsExportReportType.performance,
          title: 'Hiệu suất đầu tư',
          description:
              'Phân tích hiệu suất: lãi hằng ngày, APY trung bình, tăng trưởng',
          iconKey: 'trend',
          rowsLabel: '~30 dòng · 6 cột',
        ),
      ],
      formats: [
        SavingsExportFormatDraft(
          id: SavingsExportFormat.csv,
          label: 'CSV',
          description: 'Tương thích Excel, Google Sheets',
        ),
        SavingsExportFormatDraft(
          id: SavingsExportFormat.pdf,
          label: 'PDF',
          description: 'Báo cáo định dạng in ấn',
        ),
        SavingsExportFormatDraft(
          id: SavingsExportFormat.xlsx,
          label: 'Excel',
          description: 'Microsoft Excel với định dạng',
        ),
      ],
      periods: [
        SavingsExportPeriodDraft(
          id: SavingsExportPeriod.sevenDays,
          label: '7 ngày',
        ),
        SavingsExportPeriodDraft(
          id: SavingsExportPeriod.thirtyDays,
          label: '30 ngày',
        ),
        SavingsExportPeriodDraft(
          id: SavingsExportPeriod.ninetyDays,
          label: '90 ngày',
        ),
        SavingsExportPeriodDraft(
          id: SavingsExportPeriod.sixMonths,
          label: '6 tháng',
        ),
        SavingsExportPeriodDraft(
          id: SavingsExportPeriod.oneYear,
          label: '1 năm',
        ),
        SavingsExportPeriodDraft(id: SavingsExportPeriod.all, label: 'Tất cả'),
      ],
      scopes: [
        SavingsExportScopeDraft(
          id: SavingsExportScope.all,
          label: 'Tất cả',
          iconKey: 'filter',
        ),
        SavingsExportScopeDraft(
          id: SavingsExportScope.subscribe,
          label: 'Gửi tiết kiệm',
          iconKey: 'download',
        ),
        SavingsExportScopeDraft(
          id: SavingsExportScope.redeem,
          label: 'Rút tiết kiệm',
          iconKey: 'upload',
        ),
        SavingsExportScopeDraft(
          id: SavingsExportScope.interest,
          label: 'Nhận lãi',
          iconKey: 'trend',
        ),
        SavingsExportScopeDraft(
          id: SavingsExportScope.compound,
          label: 'Lãi kép',
          iconKey: 'bolt',
        ),
      ],
      options: [
        SavingsExportOptionDraft(
          id: 'interest',
          title: 'Bao gồm lãi tích lũy',
          subtitle: 'Thêm cột lãi hằng ngày/tháng',
          iconKey: 'trend',
        ),
        SavingsExportOptionDraft(
          id: 'fees',
          title: 'Bao gồm phí',
          subtitle: 'Thêm cột phí giao dịch (nếu có)',
          iconKey: 'info',
        ),
        SavingsExportOptionDraft(
          id: 'apy-history',
          title: 'Lịch sử APY',
          subtitle: 'Thêm dữ liệu APY theo ngày',
          iconKey: 'chart',
        ),
        SavingsExportOptionDraft(
          id: 'product-details',
          title: 'Chi tiết sản phẩm',
          subtitle: 'Thêm loại, thời hạn, rủi ro',
          iconKey: 'settings',
        ),
        SavingsExportOptionDraft(
          id: 'email-copy',
          title: 'Gửi bản sao qua email',
          subtitle: 'Gửi file tới email đã đăng ký',
          iconKey: 'mail',
        ),
      ],
      defaultReportType: SavingsExportReportType.transaction,
      defaultFormat: SavingsExportFormat.csv,
      defaultPeriod: SavingsExportPeriod.thirtyDays,
      defaultScope: SavingsExportScope.all,
      defaultEnabledOptions: {'interest', 'fees', 'product-details'},
      summaryRows: '~47',
      summaryFileSize: '14.1 KB',
      sensitiveNotice:
          'Báo cáo có thể chứa thông tin tài chính nhạy cảm. Không chia sẻ file với người khác. File tự động xóa sau 7 ngày.',
      ctaLabel: 'Xem trước & Xuất CSV',
      history: [
        SavingsExportHistoryDraft(
          id: 'rep-q1',
          fileName: 'savings_transactions_2026Q1.csv',
          format: SavingsExportFormat.csv,
          reportType: SavingsExportReportType.transaction,
          period: '01/01/2026 - 31/03/2026',
          rowsLabel: '47 dòng',
          fileSize: '14.1 KB',
          status: SavingsExportStatus.completed,
          createdAt: '09/03/2026 12:20',
          expiresAt: '16/03/2026',
        ),
        SavingsExportHistoryDraft(
          id: 'rep-tax',
          fileName: 'savings_tax_report_2025.pdf',
          format: SavingsExportFormat.pdf,
          reportType: SavingsExportReportType.tax,
          period: 'Năm 2025',
          rowsLabel: '12 dòng',
          fileSize: '226 KB',
          status: SavingsExportStatus.completed,
          createdAt: '02/03/2026 09:45',
          expiresAt: '09/03/2026',
        ),
        SavingsExportHistoryDraft(
          id: 'rep-portfolio',
          fileName: 'savings_portfolio_snapshot.xlsx',
          format: SavingsExportFormat.xlsx,
          reportType: SavingsExportReportType.portfolio,
          period: 'Ảnh chụp 28/02/2026',
          rowsLabel: '8 dòng',
          fileSize: '38 KB',
          status: SavingsExportStatus.completed,
          createdAt: '28/02/2026 17:30',
          expiresAt: '06/03/2026',
        ),
        SavingsExportHistoryDraft(
          id: 'rep-performance',
          fileName: 'savings_performance_30d.csv',
          format: SavingsExportFormat.csv,
          reportType: SavingsExportReportType.performance,
          period: '30 ngày',
          rowsLabel: '30 dòng',
          fileSize: '18.4 KB',
          status: SavingsExportStatus.ready,
          createdAt: '20/02/2026 08:10',
          expiresAt: '27/02/2026',
        ),
      ],
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, export configuration, preview rows, history, and POST /exports action state.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
        EarnScreenState.submitting,
        EarnScreenState.success,
      },
    );
  }
}
