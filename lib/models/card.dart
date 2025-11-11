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