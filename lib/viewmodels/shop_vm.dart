import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pokemu_basic_mobile/services/pack_service.dart';

import '../models/pack.dart';

class ShopVm extends ChangeNotifier {
  final PackService _packService = PackService();
  
  bool _isLoading = true;
  bool _isDropRatesLoading = false;
  String? _errorMessage;
  String? _drErrorMessage;
  List<Pack> _allAvailablePacks = [];
  List<Pack> _filteredPacks = []; // list of searching packs
  List<DropRateResponse> _dropRates = [];

  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  bool get isLoading => _isLoading;
  bool get isDropRatesLoading => _isDropRatesLoading;
  String? get errorMessage => _errorMessage;
  String? get drErrorMessage => _drErrorMessage;
  List<Pack> get filteredPacks => _filteredPacks;
  List<DropRateResponse> get dropRates => _dropRates;

  ShopVm() {
    searchController.addListener(_onSearchChanged);
    getAllAvailablePacks();
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _setState({
    bool? loading,
    bool? dropRatesLoading,
    String? errorMessage,
    String? dropRatesErrorMessage,
    List<Pack>? allAvailablePack,
    List<DropRateResponse>? dropRates,
  }) {
    _isLoading = loading ?? _isLoading;
    _isDropRatesLoading = dropRatesLoading ?? _isDropRatesLoading;
    _errorMessage = errorMessage;
    _drErrorMessage = dropRatesErrorMessage;

    if (allAvailablePack != null) {
      _allAvailablePacks = allAvailablePack;
      // when new data fetched, reset filtered list
      _filterPacks();
    }

    if (dropRates != null) {
      _dropRates = dropRates;
    }
    notifyListeners();
  }

  Future<void> getAllAvailablePacks() async {
    _setState(loading: true, errorMessage: null);

    final res = await _packService.getAllAvailablePacks();

    if (res.statusCode == 200 && res.data != null) {
      _setState(loading: false, allAvailablePack: res.data);
    } else {
      _setState(loading: false, errorMessage: res.message ?? 'Failed to fetch packs');
    }
  }

  // (with debounce method)
  void _onSearchChanged() {
    // cancel old time if typing fast
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // create a new debounce of 300ms
    _debounce = Timer(const Duration(milliseconds: 300), () {
      // run this filter method ONLY when stop typing
      _filterPacks();
    });
  }

  // (run only after DEBOUNCE)
  void _filterPacks() {
    final query = searchController.text.toLowerCase();

    if (query.isEmpty) {
      _filteredPacks = _allAvailablePacks; // show all
    } else {
      _filteredPacks = _allAvailablePacks.where((pack) {
        return pack.packName.toLowerCase().contains(query);
      }).toList();
    }
    notifyListeners();
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