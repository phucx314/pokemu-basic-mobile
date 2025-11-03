import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pokemu_basic_mobile/services/pack_service.dart';

import '../models/pack.dart';

class HomeVm extends ChangeNotifier {
  final PackService _packService = PackService();
  
  bool _isLoading = true;
  String? _errorMessage;
  List<Pack> _featuredPacks = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Pack> get featuredPacks => _featuredPacks;

  HomeVm() {
    getFeaturedPacks();
  }

  void _setState({
    bool? loading,
    String? errorMessage,
    List<Pack>? featuredPacks,
  }) {
    _isLoading = loading ?? _isLoading;
    _errorMessage = errorMessage;

    if (featuredPacks != null) {
      _featuredPacks = featuredPacks;
    }
    notifyListeners();
  }

  Future<void> getFeaturedPacks() async {
    _setState(loading: true, errorMessage: null);

    final res = await _packService.getFeaturedPacks();

    if (res.statusCode == 200 && res.data != null) {
      _setState(loading: false, featuredPacks: res.data);
    } else {
      _setState(loading: false, errorMessage: res.message ?? 'Failed to fetch packs');
    }
  }
}