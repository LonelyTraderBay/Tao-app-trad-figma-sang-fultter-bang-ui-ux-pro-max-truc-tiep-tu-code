import 'package:dio/dio.dart';

import 'package:vit_trade_flutter/core/data/offline_failure.dart';

/// Lỗi API đã map về tầng domain (SEC-S46 / P0.3): controller hiển thị
/// [userMessage] tiếng Việt, không rò rỉ message tiếng Anh hay stack HTTP.
///
/// [code] / [traceId] / [details] giữ nguyên từ body BE (khi có) để remote
/// repository hoặc support flow dùng — không đưa raw [details] ra UI.
final class ApiFailure implements Exception {
  const ApiFailure({
    required this.statusCode,
    required this.userMessage,
    this.code,
    this.traceId,
    this.details,
  });

  final int? statusCode;
  final String userMessage;
  final String? code;
  final String? traceId;
  final Map<String, Object?>? details;

  @override
  String toString() => 'ApiFailure($statusCode, code: $code): $userMessage';
}

/// Map [DioException] → [OfflineFailure] hoặc [ApiFailure].
///
/// Dùng bởi [errorMappingInterceptor]; remote repository unwrap
/// `DioException.error` và ném tiếp cho controller (ADR-001).
Object mapDioExceptionToDomain(DioException exception) {
  switch (exception.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.connectionError:
      return const OfflineFailure();
    case DioExceptionType.badResponse:
      return mapBadResponseToApiFailure(
        statusCode: exception.response?.statusCode,
        data: exception.response?.data,
      );
    case DioExceptionType.badCertificate:
      return const ApiFailure(
        statusCode: null,
        userMessage: 'Kết nối không an toàn bị chặn. Kiểm tra mạng đang dùng.',
      );
    case DioExceptionType.cancel:
    case DioExceptionType.unknown:
      return const ApiFailure(
        statusCode: null,
        userMessage: 'Không thể hoàn tất yêu cầu. Vui lòng thử lại.',
      );
    // Dio thêm case enum mới theo minor version — nhánh chặn mọi case tương lai.
    // ignore: unreachable_switch_default
    default:
      return const ApiFailure(
        statusCode: null,
        userMessage: 'Không thể hoàn tất yêu cầu. Vui lòng thử lại.',
      );
  }
}

/// Parse HTTP bad-response → domain failure.
///
/// Ưu tiên business [code] trong body; `NETWORK_UNAVAILABLE` → [OfflineFailure].
/// Không bao giờ dùng field `message` tiếng Anh của BE làm copy UI.
Object mapBadResponseToApiFailure({
  required int? statusCode,
  required Object? data,
}) {
  final parsed = _parseErrorBody(data);
  final code = parsed.code;
  final details = parsed.details;
  final traceId = parsed.traceId;

  if (code == 'NETWORK_UNAVAILABLE') {
    return const OfflineFailure();
  }

  final fromCode = code == null
      ? null
      : apiUserMessageForBusinessCode(code, details);
  final fromStatus = apiUserMessageForStatus(statusCode, traceId: traceId);
  final userMessage = fromCode ?? fromStatus;

  return ApiFailure(
    statusCode: statusCode,
    userMessage: userMessage,
    code: code,
    traceId: traceId,
    details: details,
  );
}

/// Copy tiếng Việt theo HTTP status (bảng P0.3 production readiness).
String apiUserMessageForStatus(int? statusCode, {String? traceId}) {
  final base = switch (statusCode) {
    400 => 'Yêu cầu không hợp lệ. Kiểm tra lại thông tin đã nhập.',
    401 => 'Phiên đã hết hạn. Đăng nhập lại để tiếp tục.',
    403 =>
      'Bạn không có quyền thực hiện thao tác này hoặc tài khoản bị hạn chế.',
    404 => 'Dữ liệu không còn tồn tại hoặc đã bị xóa.',
    409 => 'Trạng thái đã thay đổi. Tải lại thông tin trước khi tiếp tục.',
    422 => 'Thông tin chưa hợp lệ. Kiểm tra từng trường và thử lại.',
    429 => 'Bạn thao tác quá nhanh. Vui lòng chờ rồi thử lại.',
    final code when code != null && code >= 500 =>
      'Hệ thống đang gián đoạn. Vui lòng thử lại sau.',
    final code when code != null && code >= 400 =>
      'Yêu cầu không hợp lệ hoặc phiên đã hết hạn. Thử lại sau.',
    _ => 'Không thể hoàn tất yêu cầu. Vui lòng thử lại.',
  };

  if (statusCode != null &&
      statusCode >= 500 &&
      traceId != null &&
      traceId.isNotEmpty) {
    return '$base Mã hỗ trợ: $traceId.';
  }
  return base;
}

/// Copy tiếng Việt theo business code ổn định với BE.
///
/// Trả `null` khi code chưa biết — caller fallback sang map theo HTTP status.
String? apiUserMessageForBusinessCode(
  String code,
  Map<String, Object?>? details,
) {
  switch (code) {
    case 'INSUFFICIENT_BALANCE':
      final available = _detailAsDisplayString(details, 'available');
      final required = _detailAsDisplayString(details, 'required');
      if (available != null && required != null) {
        return 'Số dư không đủ (khả dụng: $available, cần: $required).';
      }
      return 'Số dư không đủ để thực hiện giao dịch.';
    case 'LIMIT_EXCEEDED':
      return 'Vượt hạn mức giao dịch. Kiểm tra hạn mức ngày/tháng và thử lại.';
    default:
      return null;
  }
}

({String? code, String? traceId, Map<String, Object?>? details})
_parseErrorBody(Object? data) {
  final map = _asStringKeyedMap(data);
  if (map == null) {
    return (code: null, traceId: null, details: null);
  }

  final code = map['code'];
  final traceId = map['traceId'] ?? map['trace_id'];
  final detailsRaw = map['details'];

  return (
    code: code is String && code.isNotEmpty ? code : null,
    traceId: traceId is String && traceId.isNotEmpty ? traceId : null,
    details: _asStringKeyedMap(detailsRaw),
  );
}

Map<String, Object?>? _asStringKeyedMap(Object? value) {
  if (value is Map<String, Object?>) {
    return value;
  }
  if (value is Map) {
    return <String, Object?>{
      for (final entry in value.entries)
        if (entry.key is String) entry.key as String: entry.value,
    };
  }
  return null;
}

String? _detailAsDisplayString(Map<String, Object?>? details, String key) {
  if (details == null) {
    return null;
  }
  final value = details[key];
  if (value is String && value.isNotEmpty) {
    return value;
  }
  if (value is num) {
    return value.toString();
  }
  return null;
}
