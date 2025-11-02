import 'package:dio/dio.dart';
import 'package:pokemu_basic_mobile/common/utils/dio_exceptions.dart';
import 'package:pokemu_basic_mobile/models/auth.dart';
import 'package:pokemu_basic_mobile/services/api_client.dart';
import 'package:pokemu_basic_mobile/services/token_storage_service.dart';

import '../models/common/api_response.dart';

class AuthService {
  final Dio _dio = ApiClient().dio;
  final TokenStorageService _tokenStorageService = TokenStorageService();

  //// LOGIN
  Future<ApiResponse<LoginResponse>> login(LoginRequest loginRequest) async {
    try {
      final res = await _dio.post('/auth/login', data: loginRequest.toJson());

      final jsonBody = res.data; // response is a whole ApiResponse

      final apiResponse = ApiResponse<LoginResponse>.fromJson(jsonBody, (data) => LoginResponse.fromJson(data));

      // login successfully -> save tokens
      if (apiResponse.statusCode == 200 && apiResponse.data != null) {
        await _tokenStorageService.saveTokens(apiResponse.data!.accessToken, apiResponse.data!.refreshToken);
      }

      return apiResponse;
    } on DioException catch (e) {
      // handle error from Dio (400, 404, 500,...)
      // 401 will be auto-handled by interceptor
      return DioExceptions().handleDioError(e);
    } catch (e) {
      // handle other errors (parse, logic,...)
      return DioExceptions().handleGenericError(e);
    }
  }

  //// CREATE ACCOUNT
  Future<ApiResponse<void>> createAccount(RegisterRequest registerRequest) async {
    try {
      final res = await _dio.post('/auth/register', data: registerRequest.toJson());

      final jsonBody = res.data;

      // reg successfully not returns any data
      return ApiResponse.fromJson(jsonBody, (_) => null);
    } on DioException catch (e) {
      return DioExceptions().handleDioError(e);
    } catch (e) {
      return DioExceptions().handleGenericError(e);
    }
  }

  //// LOG OUT
  Future<void> logout() async {
    await _tokenStorageService.deleteAllToken();

    try {
      await _dio.post('/auth/logout');
    } catch (e) {
      // skip err when logging out (eg: net err, expired token,...)
    }
  }

  //// GET ME
  Future<ApiResponse<AuthInfo>> getMe() async {
    try {
      final res = await _dio.get('/auth/me');

      final jsonBody = res.data;

      final apiResponse = ApiResponse<AuthInfo>.fromJson(jsonBody, (data) => AuthInfo.fromJson(data));

      return apiResponse;
    } on DioException catch (e) {
      return DioExceptions().handleDioError(e);
    } catch (e) {
      return DioExceptions().handleGenericError(e);
    }
  }
}