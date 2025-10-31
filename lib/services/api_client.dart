import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pokemu_basic_mobile/services/auth_interceptor.dart';

import 'token_storage_service.dart';

class ApiClient {
  final Dio _dio;
  final TokenStorageService _tokenStorageService = TokenStorageService();

  ApiClient({Dio? dio}) : _dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['BASE_URL']!,
      headers: {
        'Content-Type': 'application.json; charset=UTF-8',
      },
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 15),
    )
  ) {
    _dio.interceptors.add(
      // auth interceptor
      AuthInterceptor(_dio, _tokenStorageService),
    );

  }
  Dio get dio => _dio;
}