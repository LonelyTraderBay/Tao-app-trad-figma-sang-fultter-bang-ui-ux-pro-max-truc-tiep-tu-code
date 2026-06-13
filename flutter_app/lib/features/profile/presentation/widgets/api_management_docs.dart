part of '../pages/api_management_page.dart';

class _ApiDocsCard extends StatelessWidget {
  const _ApiDocsCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      height: 96,
      padding: const EdgeInsets.fromLTRB(16, 16, 14, 16),
      borderColor: _apiBorder,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _apiPrimary.withValues(alpha: .1),
              borderRadius: AppRadii.cardRadius,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.info_outline_rounded,
              color: _apiPrimary,
              size: 21,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'T\u00E0i li\u1EC7u API',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: AppTextStyles.extraBold,
                    height: 1.1,
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 5)),
                Text(
                  'Xem h\u01B0\u1EDBng d\u1EABn t\u00EDch h\u1EE3p v\u00E0 endpoint',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: _apiMuted,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: _apiMuted, size: 18),
        ],
      ),
    );
  }
}

String _maskedKey(String value) {
  if (value.length <= 18) return value;
  return '${value.substring(0, 12)}\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022${value.substring(value.length - 6)}';
}

String _permissionLabel(String id) {
  return switch (id) {
    'trade' => 'Giao d\u1ECBch',
    'withdraw' => 'R\u00FAt ti\u1EC1n',
    _ => '\u0110\u1ECDc',
  };
}

Color _permissionColor(String id) {
  return switch (id) {
    'trade' => _apiAmber,
    'withdraw' => _apiRed,
    _ => _apiPrimary,
  };
}

String _formatInt(int value) {
  final text = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < text.length; i++) {
    final remaining = text.length - i;
    buffer.write(text[i]);
    if (remaining > 1 && remaining % 3 == 1) {
      buffer.write(',');
    }
  }
  return buffer.toString();
}
