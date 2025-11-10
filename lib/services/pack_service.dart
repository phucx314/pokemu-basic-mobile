import 'package:dio/dio.dart';
import 'package:pokemu_basic_mobile/common/utils/dio_exceptions.dart';
import 'package:pokemu_basic_mobile/models/pack.dart';
import 'package:pokemu_basic_mobile/services/api_client.dart';

import '../models/card.dart';
import '../models/common/api_response.dart';

class PackService {
  final Dio _dio = ApiClient().dio;
  
  //// GET ALL AVAILABLE PACKS
  Future<ApiResponse<List<Pack>>> getAllAvailablePacks() async {
    try {
      final res = await _dio.get('/pack/list-available');

      final jsonBody = res.data;

      final apiResponse = ApiResponse<List<Pack>>.fromJson(jsonBody, (data) {
        final listData = data as List<dynamic>;
        
        return listData.map((pack) => Pack.fromJson(pack as Map<String, dynamic>)).toList(); // 
      });

      return apiResponse;
    } on DioException catch (e) {
      return DioExceptions().handleDioError(e);
    } catch (e) {
      return DioExceptions().handleGenericError(e);
    }
  }

  //// GET FEATURED PACKS
  Future<ApiResponse<List<Pack>>> getFeaturedPacks() async {
    try {
      final res = await _dio.get('/pack/list-featured');

      final jsonBody = res.data;

      final apiResponse = ApiResponse<List<Pack>>.fromJson(jsonBody, (data) {
        final listData = data as List<dynamic>;
        
        return listData.map((pack) => Pack.fromJson(pack as Map<String, dynamic>)).toList(); // 
      });

      return apiResponse;
    } on DioException catch (e) {
      return DioExceptions().handleDioError(e);
    } catch (e) {
      return DioExceptions().handleGenericError(e);
    }
  }

  //// OPEN PACK
  Future<ApiResponse<List<Card>>> openPack(int packId) async {
    try {
      final res = await _dio.post('/pack/$packId/open');

      final jsonBody = res.data;

      final apiResponse = ApiResponse<List<Card>>.fromJson(jsonBody, (data) {
        final listData = data as List<dynamic>;

        return listData.map((card) => Card.fromJson(card as Map<String, dynamic>)).toList();
      });

      return apiResponse;
    } on DioException catch (e) {
      return DioExceptions().handleDioError(e);
    } catch (e) {
      return DioExceptions().handleGenericError(e);
    }
  }

  //// GET PACK RARITY DROP RATES
  Future<ApiResponse<List<DropRateResponse>>> getDropRates(int packId) async {
    try {
      final res = await _dio.get('/pack/$packId/get-drop-rates');

      final jsonBody = res.data;

      final apiResponse = ApiResponse<List<DropRateResponse>>.fromJson(jsonBody, (data) {
        final listData = data as List<dynamic>;

        return listData.map((dropRate) => DropRateResponse.fromJson(dropRate as Map<String, dynamic>)).toList();
      });

      return apiResponse;
    } on DioException catch (e) {
      return DioExceptions().handleDioError(e);
    } catch (e) {
      return DioExceptions().handleGenericError(e);
    }
  }
}