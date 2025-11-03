import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pokemu_basic_mobile/services/pack_service.dart';

import '../models/pack.dart';

class ShopVm extends ChangeNotifier {
  final PackService _packService = PackService();
  
  bool _isLoading = true;
  String? _errorMessage;
  List<Pack> _allAvailablePacks = [];
  List<Pack> _filteredPacks = []; // list of searching packs

  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Pack> get filteredPacks => _filteredPacks;

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
    String? errorMessage,
    List<Pack>? allAvailablePack,
  }) {
    _isLoading = loading ?? _isLoading;
    _errorMessage = errorMessage;

    if (allAvailablePack != null) {
      _allAvailablePacks = allAvailablePack;
      // when new data fetched, reset filtered list
      _filterPacks();
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
}