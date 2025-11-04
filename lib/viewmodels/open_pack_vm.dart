import 'package:flutter/foundation.dart';
import 'package:pokemu_basic_mobile/services/pack_service.dart';

import '../models/card.dart';

class OpenPackVm extends ChangeNotifier {
  final PackService _packService = PackService();
  
  bool _isLoading = true;
  String? _errorMessage;
  List<Card> _rolledCards = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Card> get rolledCards => _rolledCards;

  void _setState({
    bool? loading,
    String? message,
    List<Card>? cards,
  }) {
    _isLoading = loading ?? _isLoading;
    _errorMessage = message;
    
    if (cards != null) {
      _rolledCards = cards;
    }

    notifyListeners();
  }

  Future<bool> fetchRolledCards(int packId) async {
    _setState(loading: true, message: null);

    final res = await _packService.openPack(packId);
    
    if (res.statusCode == 201 && res.data != null) {
      _setState(loading: false, cards: res.data);
      
      return true;
    } else {
      _setState(loading: false, message: res.message ?? 'Failed to open pack');
      
      return false;
    }
  }
}