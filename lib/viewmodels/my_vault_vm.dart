import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pokemu_basic_mobile/services/expansion_service.dart';

import '../models/card.dart';
import '../models/expansion.dart';
import '../services/card_service.dart';

class MyVaultVm extends ChangeNotifier {
  final ExpansionService _expansionService = ExpansionService();
  final CardService _cardService = CardService();

  bool _isLoading = true;
  bool _isExpansionListLoading = false;
  bool _isCardListLoading = false;
  String? _errorMessage;
  String? _expansionListErrorMessage;
  String? _cardListErrorMessage;
  List<ExpansionOptions> _expansionList = [];
  List<CardInList> _cardList = [];
  int? _totalCardsInExpansion;
  ExpansionOptions? _selectedExpansion;

  final TextEditingController cardSearchController = TextEditingController();
  final TextEditingController expansionSearchController = TextEditingController();
  Timer? _expansionSearchDebounce;

  ExpansionOptionsQueryParams _currentExpansionQueryParams = ExpansionOptionsQueryParams(searchKey: '');
  OwnedCardsQueryParams _currentOwnedCardQueryParams = OwnedCardsQueryParams(searchKey: '', expansionId: null);

  bool get isLoading => _isLoading;
  bool get isExpansionListLoading => _isExpansionListLoading;
  bool get isCardListLoading => _isCardListLoading;
  String? get errorMessage => _errorMessage;
  String? get expansionListErrorMessage => _expansionListErrorMessage;
  String? get cardListErrorMessage => _cardListErrorMessage;
  List<ExpansionOptions> get expansionList => _expansionList;
  List<CardInList> get cardList => _cardList;
  int? get totalCardsInExpansion => _totalCardsInExpansion;
  ExpansionOptions? get selectedExpansion => _selectedExpansion;

  MyVaultVm() {
    expansionSearchController.addListener(_onExpansionSearchChanged);
    getLatestExpansion().then((_) {
      if (selectedExpansion != null) {
        getOwnedCards(selectedExpansion!.id);
      }
    });
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
    List<CardInList>? cardList,
    int? totalCardsInExpansion,
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

      if (cardList != null) {
        _cardList = cardList;
      }

      _totalCardsInExpansion = totalCardsInExpansion ?? _totalCardsInExpansion;

      // Nếu selectedExpansion là null (không truyền) thì giữ nguyên giá trị cũ (_selectedExpansion)
      _selectedExpansion = selectedExpansion ?? _selectedExpansion;

      notifyListeners();
  }

  //// GET OWNED CARDS BY EXPANSION ID
  Future<void> getOwnedCards(int expansionId) async {
    _setState(isCardListLoading: true, cardListErrorMessage: null);

    final queryParams = _currentOwnedCardQueryParams.copyWith(expansionId: expansionId);

    final res = await _cardService.getOwnedCards(queryParams);

    if (res.data != null && res.statusCode == 200) {
      _setState(
        isCardListLoading: false,
        totalCardsInExpansion: res.data!.totalCards,
        cardList: res.data!.cards,
      );
    } else {
      _setState(isCardListLoading: false, cardListErrorMessage: res.message ?? 'Failed to fetch owned cards');
    }
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
      // _setState(selectedExpansion: null);
      _selectedExpansion = null;
      notifyListeners();
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