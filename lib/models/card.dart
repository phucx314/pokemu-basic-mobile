import 'common/query_request.dart';

class Card {
  final int id;
  final String cardName;
  final String cardImage;
  final int indexNumber;
  final int rarityId;
  final int cardSuperTypeId;
  final int? cardSubTypeId;
  final int? elementTypeId;
  final int? powerIndex;

  Card({
    required this.id,
    required this.cardName,
    required this.cardImage,
    required this.indexNumber,
    required this.rarityId,
    required this.cardSuperTypeId,
    this.cardSubTypeId,
    this.elementTypeId,
    this.powerIndex,
  });

  factory Card.fromJson(Map<String, dynamic> json) {
    return Card(
      id: json['id'], 
      cardName: json['cardName'], 
      cardImage: json['cardImage'], 
      indexNumber: json['indexNumber'], 
      rarityId: json['rarityId'],
      cardSuperTypeId: json['cardSuperTypeId'],
      cardSubTypeId: json['cardSubTypeId'],
      elementTypeId: json['elementTypeId'],
      powerIndex: json['powerIndex'],
    );
  }
}

class CardInListResponse {
  final int totalCards;
  final int acquiredCards;
  final List<CardInList> cards;

  CardInListResponse({
    required this.totalCards,
    required this.acquiredCards,
    required this.cards
  });

  factory CardInListResponse.fromJson(Map<String, dynamic> json) {
    return CardInListResponse(
      totalCards: json['totalCards'], 
      acquiredCards: json['acquiredCards'], 
      cards: (json['cards'] as List<dynamic>?)
        ?.map((e) => CardInList.fromJson(e))
        .toList() ?? [],
    );
  }
}

class OwnedCardsQueryParams extends QueryRequest {
  final String? searchKey;
  final int? expansionId;

  OwnedCardsQueryParams({
    this.searchKey,
    this.expansionId,
    super.currentPage,
    super.pageSize,
    super.sortBy,
    super.direction,
  });

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();

    if (searchKey != null && searchKey!.isNotEmpty) {
      data['searchKey'] = searchKey;
    }

    if (expansionId != null) {
      data['expansionId'] = expansionId;
    }

    return data;
  }

  OwnedCardsQueryParams copyWith({
    String? searchKey,
    int? expansionId,
    int? currentPage,
    int? pageSize,
    String? sortBy,
    String? direction,
  }) {
    return OwnedCardsQueryParams(
      searchKey: searchKey ?? this.searchKey,
      expansionId: expansionId ?? this.expansionId,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      sortBy: sortBy ?? this.sortBy,
      direction: direction ?? this.direction,
    );
  }
}

class CardInList {
  final int id;
  final String cardName;
  final String cardImage;
  final int? expansionIndex;

  CardInList({
    required this.id,
    required this.cardName,
    required this.cardImage,
    this.expansionIndex,
  });

  factory CardInList.fromJson(Map<String, dynamic> json) {
    return CardInList(id: json['id'], cardName: json['cardName'], cardImage: json['cardImage'], expansionIndex: json['expansionIndex']);
  }
}