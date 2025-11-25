import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pokemu_basic_mobile/services/expansion_service.dart';

import '../models/card.dart';
import '../models/expansion.dart';

class MyVaultVm extends ChangeNotifier {
  final ExpansionService _expansionService = ExpansionService();
  // final CardService _cardService = CardService();

  bool _isLoading = true;
  bool _isExpansionListLoading = false;
  bool _isCardListLoading = false;
  String? _errorMessage;
  String? _expansionListErrorMessage;
  String? _cardListErrorMessage;
  List<ExpansionOptions> _expansionList = [];
  List<CardInListResponse> _cardList = [];
  ExpansionOptions? _selectedExpansion;

  final TextEditingController cardSearchController = TextEditingController();
  final TextEditingController expansionSearchController = TextEditingController();
  Timer? _expansionSearchDebounce;

  ExpansionOptionsQueryParams _currentExpansionQueryParams = ExpansionOptionsQueryParams(
    searchKey: '', // Ban đầu rỗng
  );

  bool get isLoading => _isLoading;
  bool get isExpansionListLoading => _isExpansionListLoading;
  bool get isCardListLoading => _isCardListLoading;
  String? get errorMessage => _errorMessage;
  String? get expansionListErrorMessage => _expansionListErrorMessage;
  String? get cardListErrorMessage => _cardListErrorMessage;
  List<ExpansionOptions> get expansionList => _expansionList;
  List<CardInListResponse> get cardList => _cardList;
  ExpansionOptions? get selectedExpansion => _selectedExpansion;

  MyVaultVm() {
    expansionSearchController.addListener(_onExpansionSearchChanged);
    getLatestExpansion();
  }

  @override
  void dispose() {
    expansionSearchController.dispose();
    cardSearchController.dispose();
    _expansionSearchDebounce?.cancel();
    super.dispose();
  }

  void _setState({
    bool? isLoading,
    bool? isExpansionListLoading,
    bool? isCardListLoading,
    String? errorMessage,
    String? expansionListErrorMessage,
    String? cardListErrorMessage,
    List<ExpansionOptions>? expansionList,
    List<CardInListResponse>? cardList,
    ExpansionOptions? selectedExpansion,
  }) {
      _isLoading = isLoading ?? _isLoading;
      _isExpansionListLoading = isExpansionListLoading ?? _isExpansionListLoading;
      _isCardListLoading = isCardListLoading ?? _isCardListLoading;
      _errorMessage = errorMessage ?? _errorMessage;
      _expansionListErrorMessage = expansionListErrorMessage ?? _expansionListErrorMessage;
      _cardListErrorMessage = cardListErrorMessage ?? _cardListErrorMessage;

      if (expansionList != null) _expansionList = expansionList;
      if (cardList != null) _cardList = cardList;

      _selectedExpansion = selectedExpansion;

      notifyListeners();
  }

  //// GET EXPANSION LIST
  Future<void> getExpansionList() async {
    _setState(isExpansionListLoading: true, expansionListErrorMessage: null);

    final queryParams = _currentExpansionQueryParams.copyWith();

    final res = await _expansionService.getExpansionOptions(queryParams);

    if (res.data != null && res.statusCode == 200) {
      _setState(
        isExpansionListLoading: false,
        expansionList: res.data,
        selectedExpansion: _selectedExpansion,
      );
    } else {
      _setState(isExpansionListLoading: false, expansionListErrorMessage: res.message ?? 'Failed to fetch expansion list');
    }
  }

  void _onExpansionSearchChanged() {
    final newText = expansionSearchController.text.trim();

    if (newText == _currentExpansionQueryParams.searchKey) return;

    if (_expansionSearchDebounce?.isActive ?? false) _expansionSearchDebounce!.cancel();

    _expansionSearchDebounce = Timer(const Duration(milliseconds: 500), () {
      _currentExpansionQueryParams = _currentExpansionQueryParams.copyWith(
        searchKey: expansionSearchController.text,
        currentPage: 1,
      );
      // notifyListeners();
      getExpansionList();
    });
  }

  void resetSearchTextfields() {
    expansionSearchController.text = '';
    cardSearchController.text = '';
    notifyListeners();
  }

  void selectExpansion(ExpansionOptions expansion) { // sau này nên đổi qua model đầy đủ hơn
    if (selectedExpansion != null && selectedExpansion?.id == expansion.id) {
      _setState(selectedExpansion: null);
      // _selectedExpansion = null;
      return;
    }
    _setState(selectedExpansion: expansion);
  }

  //// GET LATEST EXPANSION
  Future<void> getLatestExpansion() async {
    _setState(isLoading: true, errorMessage: null);

    final res = await _expansionService.getLatestExpansion();

    if (res.data != null && res.statusCode == 200) {
      _setState(isLoading: false, selectedExpansion: res.data);
    } else {
      _setState(isLoading: false, errorMessage: res.message ?? 'Failed to get latest expansion');
    }
  }
}