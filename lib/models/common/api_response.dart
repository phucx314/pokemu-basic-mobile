import 'pagination.dart';

class ApiResponse<T> {
  final int statusCode;
  final String? message;
  final T? data;
  final Map<String, List<String>>? errors;
  final PaginationMetadata? pagination;

  ApiResponse({
    required this.statusCode,
    required this.message,
    required this.data,
    this.errors,
    this.pagination,
  });

  factory ApiResponse.fromJson(
      Map<String, dynamic> json, Function(Map<String, dynamic>) fromJsonT) {
    Map<String, List<String>>? parseErrors;

    if (json['errors'] != null) {
      parseErrors = (json['errors'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, List<String>.from(value)),
      );
    }

    return ApiResponse(
      statusCode: json['statusCode'] ?? 500,
      message: json['message'] ?? 'An unknown server error occurred',
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      errors: parseErrors,
      pagination: json['pagination'] != null
          ? PaginationMetadata.fromJson(json['pagination'])
          : null,
    );
  }
}
