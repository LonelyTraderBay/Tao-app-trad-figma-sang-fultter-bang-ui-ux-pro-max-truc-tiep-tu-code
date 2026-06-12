part of '../pages/bot_api_documentation_page.dart';

class _EndpointsView extends StatelessWidget {
  const _EndpointsView({required this.endpoints});

  final List<TradeBotApiEndpoint> endpoints;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel('REST API Endpoints'),
        const SizedBox(height: 10),
        for (final endpoint in endpoints) ...[
          _EndpointCard(endpoint: endpoint),
          if (endpoint != endpoints.last) const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _EndpointCard extends StatelessWidget {
  const _EndpointCard({required this.endpoint});

  final TradeBotApiEndpoint endpoint;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: BotApiDocumentationPage.endpointKey(endpoint.method, endpoint.path),
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _MethodBadge(method: endpoint.method),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  endpoint.path,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 17),
          Text(
            endpoint.description,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: 1,
            ),
          ),
          if (endpoint.params.isNotEmpty) ...[
            const SizedBox(height: 17),
            _Parameters(params: endpoint.params),
          ],
          const SizedBox(height: 18),
          _ResponseBlock(response: endpoint.response),
        ],
      ),
    );
  }
}

class _Parameters extends StatelessWidget {
  const _Parameters({required this.params});

  final List<TradeBotApiParameter> params;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PARAMETERS:',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
        const SizedBox(height: 9),
        for (final param in params) ...[
          _ParameterRow(param: param),
          if (param != params.last) const SizedBox(height: 9),
        ],
      ],
    );
  }
}

class _ParameterRow extends StatelessWidget {
  const _ParameterRow({required this.param});

  final TradeBotApiParameter param;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          param.name,
          style: AppTextStyles.micro.copyWith(
            color: _apiPrimary,
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
        ),
        const SizedBox(width: 7),
        Text(
          '(${param.type})',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: 1.2,
          ),
        ),
        if (param.required)
          Text(
            ' *',
            style: AppTextStyles.micro.copyWith(
              color: _apiRed,
              fontWeight: AppTextStyles.bold,
              height: 1.2,
            ),
          ),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            '- ${param.description}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}

class _ResponseBlock extends StatelessWidget {
  const _ResponseBlock({required this.response});

  final String response;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'RESPONSE:',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
            const Spacer(),
            GestureDetector(
              key: BotApiDocumentationPage.copyKey,
              behavior: HitTestBehavior.opaque,
              onTap: () => Clipboard.setData(ClipboardData(text: response)),
              child: const Icon(
                Icons.content_copy_rounded,
                color: AppColors.text3,
                size: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 9),
        _CodeBlock(text: response),
      ],
    );
  }
}
