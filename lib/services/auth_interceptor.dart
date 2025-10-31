import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pokemu_basic_mobile/models/auth.dart';
import 'package:pokemu_basic_mobile/models/common/api_response.dart';
import 'package:pokemu_basic_mobile/services/token_storage_service.dart';

class AuthInterceptor extends QueuedInterceptorsWrapper {
  final Dio _dio; // MAIN Dio instance
  final TokenStorageService _tokenStorageService;

  // if this is NOT null, there is đang có 1 thằng refresh
  Future<String?>? _refreshTokenFuture;

  // SUB Dio instance for refresh token only
  final Dio _refreshDio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['BASE_URL']!,
    ),
  );

  AuthInterceptor(this._dio, this._tokenStorageService);

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // get accessToken from SS
    final accessToken = await _tokenStorageService.getAccessToken();

    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    // let the request continue
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    // when 401
    if (err.response?.statusCode == 401) {
      // (prevent loop): if even /refresh api returns 401 => next 
      if (err.requestOptions.path == '/auth/refresh') {
        return handler.next(err);
      }

      //// handle race condition:
      // check if any refresh attempt, if not (_refreshTokenFuture == null) -> that means this is the FIRST refresh attempt
      // if (_refreshTokenFuture == null) {
      //   _refreshTokenFuture = _handleRefreshToken();
      // }
      // this does the same but shorter :)
      _refreshTokenFuture ??= _handleRefreshToken();


      try {
        // all requests are all "waiting for" promise
        final newAccessToken = await _refreshTokenFuture;

        if (newAccessToken != null) {
          // done refreshing, retry the ORIGINAL 401 request with new token
          err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
          final response = await _dio.fetch(err.requestOptions);
          return handler.resolve(response);
        } else {
          // if newAccessToken is null (/refresh call failed)
          return handler.next(err); // throw 401 
        }
      } catch (e) {
        return handler.next(err);
      }
    }
  }

  // function to refresh token, return new accessToken (or null)
  Future<String?> _handleRefreshToken() async {
    try {
      final refreshToken = await _tokenStorageService.getRefreshToken();

      if (refreshToken == null) {
        throw Exception('No refresh token found');
      }

      // call /refresh api
      final refreshTokenApiResponse = await _refreshDio.post(
        '/auth/refresh',
        data: refreshToken,
      );

      final apiResponse = ApiResponse.fromJson(
        refreshTokenApiResponse.data, 
        (data) => LoginResponse.fromJson(data),
      );

      // check if response has data
      if (apiResponse.data != null) {
        // save new tokens
        await _tokenStorageService.saveTokens(apiResponse.data!.accessToken, apiResponse.data!.refreshToken);

        // complete "promise", return new token
        _refreshTokenFuture = null;
        return apiResponse.data!.accessToken;
      } else {
        throw Exception('Refresh token response is null');
      }
    } catch (e) {
      // refresh fail (401, 500, network err,...)
      _tokenStorageService.deleteAllToken();
      _refreshTokenFuture = null;
      // TODO: LOGOUT
      return null;
    }
  }
}