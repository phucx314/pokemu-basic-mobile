import 'package:dio/dio.dart';
import 'package:pokemu_basic_mobile/common/utils/dio_exceptions.dart';
import 'package:pokemu_basic_mobile/models/common/api_response.dart';
import 'package:pokemu_basic_mobile/services/api_client.dart';

import '../models/card.dart';

class CardService {
  final Dio _dio = ApiClient().dio;

  //// GET OWNED CARDS BY EXPANSION ID
  Future<ApiResponse<CardInListResponse>> getOwnedCards(OwnedCardsQueryParams queryParams) async {
    try {
      final res = await _dio.get(
        '/card/owned/list',
        queryParameters: queryParams.toJson(),
      );

      final jsonBody = res.data;

      final apiResponse = ApiResponse<CardInListResponse>.fromJson(jsonBody, (data) => CardInListResponse.fromJson(data));

      return apiResponse;
    } on DioException catch (e) {
      return DioExceptions().handleDioError(e);
    } catch (e) {
      return DioExceptions().handleGenericError(e);
    }
  }
}