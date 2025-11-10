import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pokemu_basic_mobile/services/pack_service.dart';

import '../models/pack.dart';

class HomeVm extends ChangeNotifier {
  final PackService _packService = PackService();
  
  bool _isLoading = true;
  bool _isDropRatesLoading = false;
  String? _errorMessage;
  String? _drErrorMessage;
  List<Pack> _featuredPacks = [];
  List<DropRateResponse> _dropRates = [];

  bool get isLoading => _isLoading;
  bool get isDropRatesLoading => _isDropRatesLoading;
  String? get errorMessage => _errorMessage;
  String? get drErrorMessage => _drErrorMessage;
  List<Pack> get featuredPacks => _featuredPacks;
  List<DropRateResponse> get dropRates => _dropRates;

  HomeVm() {
    getFeaturedPacks();
  }

  void _setState({
    bool? loading,
    bool? dropRatesLoading,
    String? errorMessage,
    String? dropRatesErrorMessage,
    List<Pack>? featuredPacks,
    List<DropRateResponse>? dropRates,
  }) {
    _isLoading = loading ?? _isLoading;
    _isDropRatesLoading = dropRatesLoading ?? _isDropRatesLoading;
    _errorMessage = errorMessage;
    _drErrorMessage = dropRatesErrorMessage;

    if (featuredPacks != null) {
      _featuredPacks = featuredPacks;
    }

    if (dropRates != null) {
      _dropRates = dropRates;
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

  Future<void> getDropRates(int packId) async {
    _setState(dropRatesLoading: true, dropRatesErrorMessage: null);

    final res = await _packService.getDropRates(packId);

    if (res.statusCode == 200 && res.data != null) {
      _setState(dropRatesLoading: false, dropRates: res.data);
    } else {
      _setState(dropRatesLoading: false, dropRatesErrorMessage: res.message ?? 'Failed to fetch drop rates');
    }
  }
}