import 'package:flutter_cache_manager/flutter_cache_manager.dart';

final cacheManagerConfig = CacheManager(
  Config(
    'pokemubasic_cache',
    stalePeriod: const Duration(days: 7), // cache 7 ngày
    maxNrOfCacheObjects: 1000, // chỉ lưu 1000 ảnh vào disk cache
  ),
);