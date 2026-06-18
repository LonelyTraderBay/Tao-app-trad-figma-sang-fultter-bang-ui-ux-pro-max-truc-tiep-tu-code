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
        const SizedBox(height: AppSpacing.tradeBotRowGap),
        for (final endpoint in endpoints) ...[
          _EndpointCard(endpoint: endpoint),
          if (endpoint != endpoints.last)
            const SizedBox(height: AppSpacing.tradeBotCardGap),
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
      padding: AppSpacing.tradeBotCardPaddingLoose,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _MethodBadge(method: endpoint.method),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  endpoint.path,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    height: AppSpacing.tradeBotLineHeightTight,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.tradeBotContentGap),
          Text(
            endpoint.description,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: AppSpacing.tradeBotLineHeightTight,
            ),
          ),
          if (endpoint.params.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.tradeBotContentGap),
            _Parameters(params: endpoint.params),
          ],
          const SizedBox(height: AppSpacing.tradeBotContentGap),
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
            height: AppSpacing.tradeBotLineHeightTight,
          ),
        ),
        const SizedBox(height: AppSpacing.x3),
        for (final param in params) ...[
          _ParameterRow(param: param),
          if (param != params.last) const SizedBox(height: AppSpacing.x3),
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
            height: AppSpacing.tradeBotLineHeightCaption,
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Text(
          '(${param.type})',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: AppSpacing.tradeBotLineHeightCaption,
          ),
        ),
        if (param.required)
          Text(
            ' *',
            style: AppTextStyles.micro.copyWith(
              color: _apiRed,
              fontWeight: AppTextStyles.bold,
              height: AppSpacing.tradeBotLineHeightCaption,
            ),
          ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Text(
            '- ${param.description}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: AppSpacing.tradeBotLineHeightBody,
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
                height: AppSpacing.tradeBotLineHeightTight,
              ),
            ),
            const Spacer(),
            VitIconButton(
              key: BotApiDocumentationPage.copyKey,
              icon: Icons.content_copy_rounded,
              tooltip: 'Copy response',
              size: VitIconButtonSize.sm,
              variant: VitIconButtonVariant.transparent,
              onPressed: () => Clipboard.setData(ClipboardData(text: response)),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x3),
        _CodeBlock(text: response),
      ],
    );
  }
}
