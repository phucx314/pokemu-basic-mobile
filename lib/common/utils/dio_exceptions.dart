import 'package:dio/dio.dart';

import '../../models/common/api_response.dart';

class DioExceptions {
  ApiResponse<T> handleDioError<T>(DioException e) {
    if (e.response != null && e.response?.data is Map<String, dynamic>) {
      try {
        // Thử parse theo cấu trúc ApiResponse
        return ApiResponse.fromJson(
          e.response!.data,
          (_) => null, // Không có data T khi lỗi
        );
      } catch (_) {
        // Nếu parse lỗi, dùng lỗi chung bên dưới
      }
    }

    // Lỗi chung (timeout, không có mạng, 503...)
    return ApiResponse<T>(
      statusCode: e.response?.statusCode ?? 503, // 503 Service Unavailable
      message: e.message ?? 'A network or server error occurred.',
      data: null,
    );
  }

  ApiResponse<T> handleGenericError<T>(Object e) {
    return ApiResponse<T>(
      statusCode: 500,
      message: 'An unknown client error occurred: ${e.toString()}',
      data: null,
    );
  }
}