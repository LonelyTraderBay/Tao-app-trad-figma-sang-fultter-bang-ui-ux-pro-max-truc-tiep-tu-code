part of '../pages/sub_account_page.dart';

Color _typeColor(String type) {
  return switch (type) {
    'spot' => AppColors.buy,
    'margin' => AppColors.warn,
    'futures' => AppColors.sell,
    _ => AppColors.primary,
  };
}

String _typeLabel(String type) {
  return switch (type) {
    'spot' => 'Spot',
    'margin' => 'Margin',
    'futures' => 'Futures',
    _ => 'T\u1EA5t c\u1EA3',
  };
}

Color _statusColor(String status) {
  return switch (status) {
    'frozen' => AppColors.warn,
    'pending' => AppColors.primary,
    _ => AppColors.buy,
  };
}

IconData _statusIcon(String status) {
  return switch (status) {
    'frozen' => Icons.ac_unit_rounded,
    'pending' => Icons.pause_circle_outline_rounded,
    _ => Icons.check_circle_outline_rounded,
  };
}

String _statusLabel(String status) {
  return switch (status) {
    'frozen' => '\u0110\u00F3ng b\u0103ng',
    'pending' => 'Ch\u1EDD duy\u1EC7t',
    _ => 'Ho\u1EA1t \u0111\u1ED9ng',
  };
}

String _permissionLabel(String permission) {
  return switch (permission) {
    'spot_trade' => 'Spot',
    'margin_trade' => 'Margin',
    'futures_trade' => 'Futures',
    'transfer' => 'Chuy\u1EC3n',
    'withdraw' => 'R\u00FAt',
    'read' => 'Xem',
    _ => permission,
  };
}

String _formatUsd(double value) {
  final fixed = value.toStringAsFixed(2);
  final parts = fixed.split('.');
  return '\$${_withCommas(parts[0])}.${parts[1]}';
}

String _formatSignedUsd(double value) {
  final sign = value >= 0 ? '+' : '-';
  return '$sign${_formatUsd(value.abs())}';
}

String _formatCompact(double value, {String prefix = ''}) {
  final abs = value.abs();
  if (abs >= 1000000) {
    return '$prefix${(value / 1000000).toStringAsFixed(2)}M';
  }
  if (abs >= 1000) {
    return '$prefix${(value / 1000).toStringAsFixed(1)}K';
  }
  return '$prefix${value.toStringAsFixed(0)}';
}

String _withCommas(String input) {
  final buffer = StringBuffer();
  for (var i = 0; i < input.length; i += 1) {
    final remaining = input.length - i;
    buffer.write(input[i]);
    if (remaining > 1 && remaining % 3 == 1) {
      buffer.write(',');
    }
  }
  return buffer.toString();
}
