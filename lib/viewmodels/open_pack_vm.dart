import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokemu_basic_mobile/services/pack_service.dart';

import '../models/card.dart' as model;

class OpenPackVm extends ChangeNotifier {
  final PackService _packService = PackService();
  
  bool _isLoading = true;
  String? _errorMessage;
  List<model.Card> _rolledCards = [];
  bool _isCachingImages = true;
  int? _currCardElementTypeId;
  int? _currRarityId;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<model.Card> get rolledCards => _rolledCards;
  bool get isCachingImages => _isCachingImages;
  int? get currCardElementTypeId => _currCardElementTypeId;
  int? get currRarityId => _currRarityId;
  

  void _setState({
    bool? loading,
    String? message,
    List<model.Card>? cards,
    bool? isCaching,
    int? elementType,
    int? rarity,
    bool updateElementType = false, // cờ này để fix lỗi hệ null
    bool updateRarity = false, // cờ này để fix lỗi hệ null
  }) {
    _isLoading = loading ?? _isLoading;
    _errorMessage = message;
    
    if (cards != null) { // chỉ update state khi nó ĐƯỢC TRUYỀN VÀO
      _rolledCards = cards;
    }

    _isCachingImages = isCaching ?? _isCachingImages;

    if (updateElementType) { // chỉ update state này khi BẬT CỜ
      _currCardElementTypeId = elementType; 
    }

    if (updateRarity) { // chỉ update state này khi BẬT CỜ
      _currRarityId = rarity;
    }

    notifyListeners();
  }

  Future<void> fetchAndPrecacheCards(int packId, BuildContext context) async {
    _setState(loading: true, isCaching: true, message: null);

    final res = await _packService.openPack(packId);
    
    if (res.statusCode == 201 && res.data != null) {
      _setState(loading: false, cards: res.data, rarity: res.data!.isNotEmpty ? res.data![0].rarityId : null, updateRarity: true); // bật cờ
      if (context.mounted) {
        await _preCacheImages(res.data!, context);
      }

      _setState(isCaching: false); // đoạn này cờ sẽ tắt vì state mặc định của cờ là false
    } else {
      _setState(loading: false, isCaching: false, message: res.message ?? 'Failed to open pack');
    }
  }

  Future<void> _preCacheImages(List<model.Card> cards, BuildContext context) async {
    if (!context.mounted) return; // check an toan

    List<Future> futures = [];

    for (var card in cards) {
      futures.add(precacheImage(CachedNetworkImageProvider(card.cardImage), context));
    }

    await Future.wait(futures); // doi tat ca images tai xong
  }

  void onCardSwiped(int? newIndex) {
    if (newIndex != null && newIndex < _rolledCards.length) {
      _setState(rarity: _rolledCards[newIndex].rarityId, updateRarity: true); // bật cờ khi swipe (cho phép update hệ)
    } 
  }
}