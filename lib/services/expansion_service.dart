import 'package:dio/dio.dart';
import 'package:pokemu_basic_mobile/common/utils/dio_exceptions.dart';
import 'package:pokemu_basic_mobile/models/expansion.dart';
import 'package:pokemu_basic_mobile/services/api_client.dart';

import '../models/common/api_response.dart';

class ExpansionService {
  final Dio _dio = ApiClient().dio;

  //// GET EXPANSION OPTIONS
  Future<ApiResponse<List<ExpansionOptions>>> getExpansionOptions(ExpansionOptionsQueryParams queryParams) async {
    try {
      final res = await _dio.get(
        '/expansion/options',
        queryParameters: queryParams.toJson(),
      );

      final jsonBody = res.data;

      final apiResponse = ApiResponse<List<ExpansionOptions>>.fromJson(jsonBody, (data) {
        final dataList = data as List<dynamic>;

        return dataList.map((expansion) => ExpansionOptions.fromJson(expansion as Map<String, dynamic>)).toList();
      });

      return apiResponse;
    } on DioException catch (e) {
      return DioExceptions().handleDioError(e);
    } catch (e) {
      return DioExceptions().handleGenericError(e);
    }
  }

  //// GET LATEST EXPANSION
  Future<ApiResponse<ExpansionOptions>> getLatestExpansion() async {
    try {
      final res = await _dio.get('/expansion/latest');

      final jsonBody = res.data;

      final apiResponse = ApiResponse<ExpansionOptions>.fromJson(jsonBody, (data) => ExpansionOptions.fromJson(data));

      return apiResponse;
    } on DioException catch (e) {
      return DioExceptions().handleDioError(e);
    } catch (e) {
      return DioExceptions().handleGenericError(e);
    }
  }
}