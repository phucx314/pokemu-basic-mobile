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
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isLoadingMore = false;
  int? _currentLastOwnedCard;

  final TextEditingController cardSearchController = TextEditingController();
  final TextEditingController expansionSearchController = TextEditingController();
  // final ScrollController scrollController = ScrollController();
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
  bool get isLoadingMore => _isLoadingMore;
  int? get currentLastOwnedCard => _currentLastOwnedCard;
  int? get currentPage => _currentPage;
  int? get totalPages => _totalPages;

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
    int? currentLastOwnedCard
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
      _selectedExpansion = selectedExpansion ?? _selectedExpansion;
      _currentLastOwnedCard = currentLastOwnedCard ?? _currentLastOwnedCard;

      notifyListeners();
  }

  //// GET OWNED CARDS BY EXPANSION ID
  Future<void> getOwnedCards(int expansionId, {bool isLoadMore = false}) async {
    if (_isCardListLoading || _isLoadingMore) {
      return; // nếu đang load dở thì nghỉ
    }

    String activeSearchKey;

    if (isLoadMore) {
      if (isLoadMore && _currentPage >= _totalPages) {
        _currentLastOwnedCard = _totalCardsInExpansion;
        notifyListeners();
        return; // hoặc đã hết trang cũng nghỉ
      }

      _isLoadingMore = true;
      _currentPage++;
      notifyListeners();

      activeSearchKey = _currentOwnedCardQueryParams.searchKey ?? '';
    } else {
      // QUAN TRỌNG: Nếu là search mới/refresh
      activeSearchKey = cardSearchController.text.trim();

      _setState(isCardListLoading: true, cardListErrorMessage: null); // nếu đang load (refresh)
      _currentPage = 1; // thì reset trang về 1
      _cardList = []; // và xoá hết list cũ
    }

    _currentOwnedCardQueryParams = _currentOwnedCardQueryParams.copyWith(
      currentPage: _currentPage,
      expansionId: expansionId,
      searchKey: activeSearchKey,
    );

    final res = await _cardService.getOwnedCards(_currentOwnedCardQueryParams);

    if (res.data != null && res.statusCode == 200) {
      if (res.paginationMetadata != null) {
        _totalPages = res.paginationMetadata!.totalPages;
        notifyListeners();
      }

      if (res.data!.cards.isNotEmpty) {
         _currentLastOwnedCard = res.data!.cards.last.expansionIndex;
      } else {
         // Nếu search không ra gì, hoặc chưa có thẻ nào
         _currentLastOwnedCard = 0; 
      }

      final newCards = res.data!.cards;

      if (isLoadMore) {
        _cardList.addAll(newCards);
        _isLoadingMore = false;
        notifyListeners();
      } else {
        _setState(
          isCardListLoading: false, 
          cardList: newCards, 
          totalCardsInExpansion: res.data!.totalCards,
        );

        if (res.data!.acquiredCards > 0) {
          _setState(
            currentLastOwnedCard: res.data!.cards.last.expansionIndex,
          );
        } else {
          _setState(
            currentLastOwnedCard: _totalCardsInExpansion,
          );
        }
      }
    } else {
      if (isLoadMore) {
        _isLoadingMore = false; 
        _currentPage--;
        notifyListeners();
      } else {
        _setState(isCardListLoading: false, cardListErrorMessage: res.message);
      }
    }
  }

  void onSearchCardButtonTap(int expansionId) {
    final newText = cardSearchController.text.trim();

    if (newText == _currentOwnedCardQueryParams.searchKey) return;

    _currentOwnedCardQueryParams = _currentOwnedCardQueryParams.copyWith(
      searchKey: cardSearchController.text,
      currentPage: 1,
    );

    getOwnedCards(expansionId);
  }

  //// GET EXPANSION LIST (ONLY 16 LATEST EXPANSIONS TO BE SHOWN)
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