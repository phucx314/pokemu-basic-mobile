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

    // Không có response → xử lý theo type lỗi
    String message;
    int code = 500;

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        code = 408;
        message = 'Connection timed out. Please check your internet connection';
        break;
      case DioExceptionType.receiveTimeout:
        code = 504;
        message = 'Server took too long to respond. Please try again later';
        break;
      case DioExceptionType.badCertificate:
        code = 495;
        message = 'SSL certificate error. Please verify your network';
        break;
      case DioExceptionType.connectionError:
        code = 503;
        message = 'Unable to reach the server. Please check your connection';
        break;
      case DioExceptionType.cancel:
        code = 499;
        message = 'Request was cancelled';
        break;
      default:
        code = 500;
        message = e.message ?? 'Unexpected network error occurred';
        break;
    }

    return ApiResponse<T>(
      statusCode: code,
      message: message,
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