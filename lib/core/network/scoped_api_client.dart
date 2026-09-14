import 'package:dio/dio.dart';

import '../auth/access_token_provider.dart';
import 'api_client.dart';
import 'api_scope.dart';

final class ScopedApiClient implements ApiClient {
  const ScopedApiClient({
    required this._dio,
    required this.scope,
    this.accessTokenProvider,
  });

  final Dio _dio;
  final ApiScope scope;
  final AccessTokenProvider? accessTokenProvider;

  @override
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final token = await accessTokenProvider?.getAccessToken();
    final response = await _dio.get<dynamic>(
      path,
      queryParameters: queryParameters,
      options: Options(
        headers: token == null
            ? null
            : <String, String>{'Authorization': 'Bearer $token'},
      ),
    );
    return response.data;
  }
}
